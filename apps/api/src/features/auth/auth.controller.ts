import { Request, Response } from 'express';
import { AuthService } from './auth.service';
import { sendSuccess } from '../../utils/error';
import { asyncHandler } from '../../utils/async';
import { AUTH_MESSAGES } from './auth.constant';

export class AuthController {
    private authService: AuthService;

    constructor() {
        this.authService = new AuthService();
    }

    login = asyncHandler(async (req: Request, res: Response) => {
        const { idToken } = req.body;
        const result = await this.authService.loginWithFirebase(idToken);
        return sendSuccess(res, result, AUTH_MESSAGES.LOGIN_SUCCESS);
    });

    refresh = asyncHandler(async (req: Request, res: Response) => {
        const { refreshToken } = req.body;
        const result = await this.authService.refreshAccessToken(refreshToken);
        return sendSuccess(res, result, AUTH_MESSAGES.REFRESH_SUCCESS);
    });
}
