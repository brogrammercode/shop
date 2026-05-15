import { Request, Response, NextFunction } from 'express';
import logger from '../utils/logger';
import { HttpStatus } from '../constants/status';
import { AppError } from '../utils/error';

export const errorHandler = (
    err: Error | AppError,
    req: Request,
    res: Response,
    _next: NextFunction
) => {
    if (err instanceof AppError) {
        logger.error(`${err.statusCode} - ${err.message} - ${req.originalUrl} - ${req.method} - ${req.ip}`);

        return res.status(err.statusCode).json({
            status: 'error',
            message: err.message,
            ...(err.details ? { data: err.details } : {}),
        });
    }

    logger.error(`500 - ${err.message} - ${req.originalUrl} - ${req.method} - ${req.ip}`, {
        stack: err.stack,
    });

    return res.status(HttpStatus.INTERNAL_SERVER_ERROR).json({
        status: 'error',
        message: 'Something went wrong',
    });
};

export default errorHandler;
