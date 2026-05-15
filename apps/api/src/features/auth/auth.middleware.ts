import { Request, Response, NextFunction } from 'express';
import { UserService } from './user.service';
import config from '../../core/config';
import { UnauthorizedError } from '../../utils/error';
import { asyncHandler } from '../../utils/async';
import { AUTH_MESSAGES } from './auth.constant';

const userService = new UserService();

export const protect = asyncHandler(async (req: Request, _res: Response, next: NextFunction) => {
    let token: string | undefined;

    if (req.headers.authorization?.startsWith('Bearer')) {
        token = req.headers.authorization.split(' ')[1];
    }

    if (!token) {
        throw new UnauthorizedError(AUTH_MESSAGES.LOGIN_REQUIRED);
    }

    const decoded = userService.verifyToken<{ id: string }>(token, config.JWT_SECRET);
    const user = await userService.getById(decoded.id);

    if (!user) {
        throw new UnauthorizedError(AUTH_MESSAGES.USER_DELETED);
    }

    (req as any).user = user;
    next();
});
