import { ApiResponse } from "./response";
import { HttpStatus, HttpStatusCode } from "../constants/status";
import { Response } from "express";

export class AppError extends Error {
    constructor(
        message: string,
        public code?: string | number,
        public statusCode: HttpStatusCode = HttpStatus.BAD_REQUEST,
        public isOperational: boolean = true,
        public details?: Record<string, unknown>
    ) {
        super(message);
        Object.setPrototypeOf(this, new.target.prototype);
        Error.captureStackTrace(this);
    }
}

export class NotFoundError extends AppError {
    constructor(message: string = "Resource not found") {
        super(message, undefined, HttpStatus.NOT_FOUND);
    }
}

export class BadRequestError extends AppError {
    constructor(message: string = "Bad request", code?: string | number, details?: Record<string, unknown>) {
        super(message, code, HttpStatus.BAD_REQUEST, true, details);
    }
}

export class ValidationError extends AppError {
    constructor(message: string = "Validation failed") {
        super(message, undefined, HttpStatus.UNPROCESSABLE_ENTITY);
    }
}

export class UnauthorizedError extends AppError {
    constructor(message: string = "Unauthorized access", code?: string | number, details?: Record<string, unknown>) {
        super(message, code, HttpStatus.UNAUTHORIZED, true, details);
    }
}

export class ForbiddenError extends AppError {
    constructor(message: string = "Access forbidden", code?: string | number, details?: Record<string, unknown>) {
        super(message, code, HttpStatus.FORBIDDEN, true, details);
    }
}

export class PaymentRequiredError extends AppError {
    constructor(message: string = "Payment required", code?: string | number, details?: Record<string, unknown>) {
        super(message, code, HttpStatus.PAYMENT_REQUIRED, true, details);
    }
}

export class ConflictError extends AppError {
    constructor(message: string = "Resource already exists") {
        super(message, undefined, HttpStatus.CONFLICT);
    }
}

export class InternalError extends AppError {
    constructor(message: string = "Internal server error") {
        super(message, undefined, HttpStatus.INTERNAL_SERVER_ERROR, false);
    }
}

export const sendSuccess = <T>(
    res: Response,
    data: T,
    message: string = "Success",
    statusCode: number = HttpStatus.OK
): Response => {
    const response: ApiResponse<T> = {
        status: "success",
        message,
        data,
    };
    return res.status(statusCode).json(response);
};

export const sendError = (
    res: Response,
    message: string = "Error occurred",
    statusCode: number = HttpStatus.INTERNAL_SERVER_ERROR
): Response => {
    const response: ApiResponse = {
        status: "error",
        message,
    };
    return res.status(statusCode).json(response);
};

export const resolveSingleValue = (value: unknown): string => {
    if (Array.isArray(value)) {
        return value[0] === undefined || value[0] === null ? "" : String(value[0]);
    }

    return value === undefined || value === null ? "" : String(value);
};

export const requireSingleValue = (value: unknown, name: string): string => {
    const resolved = resolveSingleValue(value).trim();
    if (!resolved) {
        throw new BadRequestError(`${name} is required`);
    }
    return resolved;
};

export const ensureDocument = <T>(value: T | null | undefined, name: string): T => {
    if (value === undefined || value === null) {
        throw new InternalError(`Failed to create ${name}`);
    }
    return value;
};

type ErrorRecord = Record<string, unknown>;

export interface ParsedApiError {
    message: string;
    code?: number;
    subcode?: number;
    type?: string;
}

const DEFAULT_ERROR_MESSAGE = "Something went wrong";

const isRecord = (value: unknown): value is ErrorRecord =>
    typeof value === "object" && value !== null && !Array.isArray(value);

const parseJsonString = (value: string): unknown => {
    const trimmed = value.trim();
    if (!trimmed) {
        return "";
    }

    if ((trimmed.startsWith("{") && trimmed.endsWith("}")) || (trimmed.startsWith("[") && trimmed.endsWith("]"))) {
        try {
            return JSON.parse(trimmed);
        } catch {
            return trimmed;
        }
    }

    return trimmed;
};

const normalizeInput = (value: unknown): unknown => {
    if (typeof value === "string") {
        return parseJsonString(value);
    }

    return value;
};

const pickString = (value: unknown): string | undefined => {
    if (typeof value !== "string") {
        return undefined;
    }

    const trimmed = value.trim();
    return trimmed || undefined;
};

const pickNumber = (value: unknown): number | undefined => {
    if (typeof value === "number" && Number.isFinite(value)) {
        return value;
    }

    if (typeof value === "string") {
        const trimmed = value.trim();
        if (/^-?\d+$/.test(trimmed)) {
            return Number(trimmed);
        }
    }

    return undefined;
};

const getNestedRecord = (value: unknown, key: string): ErrorRecord | undefined => {
    if (!isRecord(value) || !isRecord(value[key])) {
        return undefined;
    }

    return value[key];
};

const getNestedValue = (value: unknown, path: string[]): unknown => {
    let current: unknown = value;

    for (const segment of path) {
        if (!isRecord(current)) {
            return undefined;
        }
        current = current[segment];
    }

    return current;
};

export const sanitizeApiErrorMessage = (value: unknown): string => {
    const normalized = normalizeInput(value);

    if (isRecord(normalized)) {
        return "";
    }

    if (typeof normalized !== "string") {
        return "";
    }

    let message = normalized
        .replace(/\r/g, "\n")
        .split("\n")
        .map((line) => line.trim())
        .filter((line) => Boolean(line) && !/^at\s+/i.test(line) && !/^[A-Za-z]:\\/.test(line))
        .join(" ")
        .trim();

    if (!message) {
        return "";
    }

    message = message
        .replace(/^(error|exception)\s*:\s*/i, "")
        .replace(/^request failed with status code \d+\s*:?\s*/i, "")
        .replace(/^\(#?\d+\)\s*/i, "")
        .replace(/^\[\d+\]\s*/i, "")
        .replace(/\s+/g, " ")
        .trim();

    if (!message || /^(object object|null|undefined)$/i.test(message)) {
        return "";
    }

    if ((message.startsWith("{") && message.endsWith("}")) || (message.startsWith("[") && message.endsWith("]"))) {
        return "";
    }

    return message.length > 500 ? `${message.slice(0, 497).trimEnd()}...` : message;
};

export const parseApiError = (input: unknown, fallbackMessage: string = DEFAULT_ERROR_MESSAGE): ParsedApiError => {
    const normalizedInput = normalizeInput(input);
    const root = isRecord(normalizedInput) ? normalizedInput : undefined;
    const response = getNestedRecord(root, "response");
    const responseData = normalizeInput(response?.data);
    const responseRecord = isRecord(responseData) ? responseData : undefined;
    const errorRecord =
        getNestedRecord(root, "error")
        ?? getNestedRecord(responseRecord, "error")
        ?? root
        ?? responseRecord;

    const message =
        sanitizeApiErrorMessage(errorRecord?.error_user_msg)
        || sanitizeApiErrorMessage(errorRecord?.message)
        || sanitizeApiErrorMessage(getNestedValue(errorRecord, ["error_data", "details"]))
        || sanitizeApiErrorMessage(root?.error)
        || sanitizeApiErrorMessage(responseRecord?.error)
        || sanitizeApiErrorMessage(root?.message)
        || sanitizeApiErrorMessage(input instanceof Error ? input.message : undefined)
        || fallbackMessage;

    return {
        message,
        code: pickNumber(errorRecord?.code ?? root?.code),
        subcode: pickNumber(errorRecord?.error_subcode ?? errorRecord?.subcode),
        type: pickString(errorRecord?.type),
    };
};

export const toAppError = (
    input: unknown,
    fallbackMessage: string = DEFAULT_ERROR_MESSAGE,
    statusCode: HttpStatusCode = HttpStatus.BAD_REQUEST
): AppError => {
    if (input instanceof AppError) {
        return input;
    }

    const parsed = parseApiError(input, fallbackMessage);
    return new AppError(parsed.message, parsed.code, statusCode);
};

export const readApiResponseBody = async <T = unknown>(response: globalThis.Response): Promise<T | string | null> => {
    const body = await response.text().catch(() => "");
    if (!body.trim()) {
        return null;
    }

    const parsed = normalizeInput(body);
    return parsed as T | string;
};

export const parseApiResponse = async <T = unknown>(
    response: globalThis.Response,
    fallbackMessage: string = DEFAULT_ERROR_MESSAGE,
    statusCode: HttpStatusCode = HttpStatus.BAD_REQUEST
): Promise<T> => {
    const body = await response.text().catch(() => "");
    const data = body.trim() ? normalizeInput(body) as T | string : null;
    const hasEmbeddedError = isRecord(data) && Object.prototype.hasOwnProperty.call(data, "error") && (data as ErrorRecord).error !== undefined;

    if (!response.ok || hasEmbeddedError) {
        throw toAppError(data ?? fallbackMessage, fallbackMessage, statusCode);
    }

    return (data ?? {}) as T;
};
