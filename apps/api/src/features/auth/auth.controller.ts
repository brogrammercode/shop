import { Request, Response } from 'express';
import { AuthService } from './auth.service';
import { UserService } from './user.service';
import { sendSuccess } from '../../utils/error';
import { asyncHandler } from '../../utils/async';
import { AUTH_MESSAGES } from './auth.constant';
import { User } from './user.type';

export class AuthController {
    private authService: AuthService;
    private userService: UserService;

    constructor() {
        this.authService = new AuthService();
        this.userService = new UserService();
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

    me = asyncHandler(async (req: Request, res: Response) => {
        const user = (req as any).user as User;
        return sendSuccess(res, user, AUTH_MESSAGES.SESSION_SUCCESS);
    });

    logActivity = asyncHandler(async (req: Request, res: Response) => {
        const result = await this.userService.logActivity(req.body);
        return sendSuccess(res, result, 'Activity logged successfully');
    });

    getActivities = asyncHandler(async (req: Request, res: Response) => {
        const { user_id } = req.params;
        const result = await this.userService.getActivities(user_id as string);
        return sendSuccess(res, result, 'Activities fetched successfully');
    });
}
