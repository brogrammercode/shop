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
        const { idToken, picture } = req.body;
        const result = await this.authService.loginWithFirebase(idToken, picture);
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
        const user = (req as any).user as User | undefined;
        const uid = req.body.uid || req.body.user_id || user?.id;
        const result = await this.userService.logActivity({
            ...req.body,
            uid,
        });
        return sendSuccess(res, result, AUTH_MESSAGES.ACTIVITY_LOGGED);
    });

    getActivities = asyncHandler(async (req: Request, res: Response) => {
        const { user_id } = req.params;
        const result = await this.userService.getActivities(user_id as string);
        return sendSuccess(res, result, AUTH_MESSAGES.ACTIVITIES_FETCHED);
    });

    sendOtp = asyncHandler(async (req: Request, res: Response) => {
        const { phone_number } = req.body;
        await this.authService.sendOtp(phone_number);
        return sendSuccess(res, null, AUTH_MESSAGES.OTP_SENT);
    });

    verifyOtp = asyncHandler(async (req: Request, res: Response) => {
        const { phone_number, otp } = req.body;
        const result = await this.authService.verifyOtp(phone_number, otp);
        return sendSuccess(res, result, AUTH_MESSAGES.LOGIN_SUCCESS);
    });

    getAdBanners = asyncHandler(async (req: Request, res: Response) => {
        const result = await this.authService.getAdBanners();
        return sendSuccess(res, result, AUTH_MESSAGES.BANNERS_FETCHED);
    });

    getSessions = asyncHandler(async (req: Request, res: Response) => {
        const user = (req as any).user as User;
        const result = await this.userService.getSessions(user.id);
        return sendSuccess(res, result, AUTH_MESSAGES.SESSIONS_FETCHED);
    });

    createSession = asyncHandler(async (req: Request, res: Response) => {
        const user = (req as any).user as User;
        const result = await this.userService.createSession({
            ...req.body,
            uid: user.id,
        });
        return sendSuccess(res, result, AUTH_MESSAGES.SESSION_CREATED);
    });

    terminateSession = asyncHandler(async (req: Request, res: Response) => {
        const { id } = req.params;
        const result = await this.userService.terminateSession(id as string);
        return sendSuccess(res, result, AUTH_MESSAGES.SESSION_TERMINATED);
    });

    createAddress = asyncHandler(async (req: Request, res: Response) => {
        const user = (req as any).user as User;
        const result = await this.userService.createAddress({
            ...req.body,
            uid: user.id,
        });
        return sendSuccess(res, result, AUTH_MESSAGES.ADDRESS_CREATED);
    });

    getAddresses = asyncHandler(async (req: Request, res: Response) => {
        const user = (req as any).user as User;
        const result = await this.userService.getAddresses(user.id);
        return sendSuccess(res, result, AUTH_MESSAGES.ADDRESSES_FETCHED);
    });

    updateAddress = asyncHandler(async (req: Request, res: Response) => {
        const { id } = req.params;
        const result = await this.userService.updateAddress(id as string, req.body);
        return sendSuccess(res, result, AUTH_MESSAGES.ADDRESS_UPDATED);
    });

    deleteAddress = asyncHandler(async (req: Request, res: Response) => {
        const { id } = req.params;
        const result = await this.userService.deleteAddress(id as string);
        return sendSuccess(res, result, AUTH_MESSAGES.ADDRESS_DELETED);
    });
}
