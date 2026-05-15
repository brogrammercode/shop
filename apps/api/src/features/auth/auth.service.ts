import admin from '../../infra/firebase/config';
import config from '../../core/config';
import { UserService } from './user.service';
import { User } from './user.type';
import { AUTH_MESSAGES } from './auth.constant';

export class AuthService {
    private userService: UserService;

    constructor() {
        this.userService = new UserService();
    }

    async loginWithFirebase(idToken: string): Promise<{ user: User, tokens: { accessToken: string, refreshToken: string } }> {
        const decodedToken = await admin.auth().verifyIdToken(idToken);
        const { email, name, picture } = decodedToken;

        if (!email) {
            throw new Error(AUTH_MESSAGES.EMAIL_REQUIRED);
        }

        let user = await this.userService.getByEmail(email);

        if (!user) {
            user = await this.userService.create({
                email,
                name: name || email.split('@')[0],
                image: picture || '',
            });
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
}
