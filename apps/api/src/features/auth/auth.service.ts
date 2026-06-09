import admin from '../../infra/firebase/config';
import config from '../../core/config';
import { UserService } from './user.service';
import { User } from './user.type';
import { AUTH_MESSAGES, AUTH_CONFIG } from './auth.constant';
import { BadRequestError } from '../../utils/error';
import { SmsService } from '../../infra/messaging/sms.service';
import { UserRepo } from './user.repo';

export class AuthService {
    private userService: UserService;
    private smsService: SmsService;
    private userRepo: UserRepo;

    constructor() {
        this.userService = new UserService();
        this.smsService = new SmsService();
        this.userRepo = new UserRepo();
    }

    async loginWithFirebase(idToken: string, fallbackPicture?: string): Promise<{ user: User, tokens: { accessToken: string, refreshToken: string } }> {
        let email: string | undefined;
        let name: string | undefined;
        let picture: string | undefined;

        try {
            const payloadSegment = idToken.split(AUTH_CONFIG.TOKEN_SPLITTER)[1];
            if (!payloadSegment) throw new Error(AUTH_MESSAGES.INVALID_TOKEN_FORMAT);

            const payload = JSON.parse(Buffer.from(payloadSegment, 'base64').toString('utf-8'));
            const isGoogleIssuer = AUTH_CONFIG.GOOGLE_ISSUERS.includes(payload.iss);

            if (isGoogleIssuer) {
                const response = await fetch(`${AUTH_CONFIG.GOOGLE_TOKEN_INFO_URL}${idToken}`);
                if (!response.ok) {
                    throw new Error(AUTH_MESSAGES.GOOGLE_VERIFICATION_FAILED);
                }
                const decodedToken = await response.json() as any;
                email = decodedToken.email;
                name = decodedToken.name;
                picture = decodedToken.picture || fallbackPicture;
            } else {
                const decodedToken = await admin.auth().verifyIdToken(idToken);
                email = decodedToken.email;
                name = decodedToken.name;
                picture = decodedToken.picture || fallbackPicture;
            }
        } catch (error: any) {
            throw new Error(`${AUTH_MESSAGES.TOKEN_VERIFICATION_FAILED}: ${error.message}`);
        }

        if (!email) {
            throw new Error(AUTH_MESSAGES.EMAIL_REQUIRED);
        }

        let user = await this.userService.getByEmail(email);

        if (!user) {
            user = await this.userService.create({
                email,
                name: name || email.split(AUTH_CONFIG.EMAIL_SPLITTER)[0],
                phone_number: AUTH_CONFIG.EMPTY_FALLBACK,
                avatar_url: picture || AUTH_CONFIG.EMPTY_FALLBACK,
            });
        } else if (picture && (!user.avatar_url || user.avatar_url === AUTH_CONFIG.EMPTY_FALLBACK)) {
            user = await this.userService.update(user.id, { avatar_url: picture });
        }

        const tokens = this.userService.generateTokens(user);

        return { user, tokens };
    }

    async refreshAccessToken(refreshToken: string): Promise<{ accessToken: string }> {
        const decoded = this.userService.verifyToken<{ id: string }>(refreshToken, config.JWT_REFRESH_SECRET);
        const user = await this.userService.getById(decoded.id);

        if (!user) {
            throw new Error(AUTH_MESSAGES.USER_NOT_FOUND);
        }

        const tokens = this.userService.generateTokens(user);
        return { accessToken: tokens.accessToken };
    }

    async sendOtp(phoneNumber: string): Promise<void> {
        if (!phoneNumber) {
            throw new BadRequestError(AUTH_MESSAGES.PHONE_REQUIRED);
        }

        let user = await this.userService.getByPhoneNumber(phoneNumber);

        if (!user) {
            user = await this.userService.create({
                email: `${phoneNumber}${AUTH_CONFIG.DEFAULT_EMAIL_DOMAIN}`,
                name: `${AUTH_CONFIG.DEFAULT_USER_NAME_PREFIX}${phoneNumber}`,
                phone_number: phoneNumber,
                avatar_url: AUTH_CONFIG.EMPTY_FALLBACK,
            });
        }

        const latestOtp = await this.userRepo.findLatestOtpByActor(user.id, AUTH_CONFIG.OTP_TYPE_LOGIN);
        if (latestOtp && latestOtp.created_at) {
            const timeSinceLastOtp = Date.now() - new Date(latestOtp.created_at).getTime();
            if (timeSinceLastOtp < 30 * 1000) {
                throw new BadRequestError(AUTH_MESSAGES.RATE_LIMIT_WAIT);
            }
        }

        await this.userRepo.deleteOtpsByActor(user.id, AUTH_CONFIG.OTP_TYPE_LOGIN);

        const otp = Math.floor(100000 + Math.random() * 900000).toString();
        const valid_till = new Date(Date.now() + AUTH_CONFIG.OTP_EXPIRY_MS);

        await this.userRepo.createOtp({
            actor: user.id,
            otp,
            type: AUTH_CONFIG.OTP_TYPE_LOGIN,
            valid_till,
        });

        const body = AUTH_CONFIG.OTP_MESSAGE_TEMPLATE.replace('{otp}', otp);
        await this.smsService.sendSms(phoneNumber, body);
    }

    async verifyOtp(phoneNumber: string, otp: string): Promise<{ user: User, tokens: { accessToken: string, refreshToken: string } }> {
        if (!phoneNumber || !otp) {
            throw new BadRequestError(AUTH_MESSAGES.PHONE_AND_OTP_REQUIRED);
        }

        const user = await this.userService.getByPhoneNumber(phoneNumber);

        if (!user) {
            throw new BadRequestError(AUTH_MESSAGES.USER_NOT_FOUND_FOR_OTP);
        }

        const isMockOtp = otp === AUTH_CONFIG.MOCK_OTP;

        if (!isMockOtp) {
            const record = await this.userRepo.findValidOtp(user.id, otp, AUTH_CONFIG.OTP_TYPE_LOGIN);

            if (!record) {
                throw new BadRequestError(AUTH_MESSAGES.INVALID_OTP);
            }

            if (record.valid_till < new Date()) {
                await this.userRepo.deleteOtpsByActor(user.id, AUTH_CONFIG.OTP_TYPE_LOGIN);
                throw new BadRequestError(AUTH_MESSAGES.OTP_EXPIRED);
            }

            await this.userRepo.deleteOtpsByActor(user.id, AUTH_CONFIG.OTP_TYPE_LOGIN);
        }

        const tokens = this.userService.generateTokens(user);
        return { user, tokens };
    }

    async getAdBanners() {
        return await this.userRepo.getAdBanners();
    }
}
