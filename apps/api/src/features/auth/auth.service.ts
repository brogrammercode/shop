import admin from '../../infra/firebase/config';
import config from '../../core/config';
import { UserService } from './user.service';
import { User } from './user.type';
import { AUTH_DEFAULTS, AUTH_MESSAGES } from './auth.constant';

export class AuthService {
    private userService: UserService;

    constructor() {
        this.userService = new UserService();
    }

    async loginWithFirebase(idToken: string): Promise<{ user: User, tokens: { accessToken: string, refreshToken: string } }> {
        let email: string | undefined;
        let name: string | undefined;
        let picture: string | undefined;
        let uid: string | undefined;

        try {
            const payloadSegment = idToken.split('.')[1];
            if (!payloadSegment) throw new Error("Invalid token format");
            
            const payload = JSON.parse(Buffer.from(payloadSegment, 'base64').toString('utf-8'));
            const isGoogleIssuer = payload.iss === 'https://accounts.google.com' || payload.iss === 'accounts.google.com';

            if (isGoogleIssuer) {
                const response = await fetch(`https://oauth2.googleapis.com/tokeninfo?id_token=${idToken}`);
                if (!response.ok) {
                    throw new Error("Failed to verify Google ID token");
                }
                const decodedToken = await response.json() as any;
                email = decodedToken.email;
                name = decodedToken.name;
                picture = decodedToken.picture;
                uid = decodedToken.sub;
            } else {
                const decodedToken = await admin.auth().verifyIdToken(idToken);
                email = decodedToken.email;
                name = decodedToken.name;
                picture = decodedToken.picture;
                uid = decodedToken.uid;
            }
        } catch (error: any) {
            throw new Error(`Token verification failed: ${error.message}`);
        }

        if (!email) {
            throw new Error(AUTH_MESSAGES.EMAIL_REQUIRED);
        }

        let user = await this.userService.getByEmail(email);

        if (!user) {
            user = await this.userService.create({
                email,
                name: name || email.split('@')[0],
                username: this.createUsername(email, uid || ''),
                image: picture || '',
                cover: AUTH_DEFAULTS.EMPTY_COVER,
                bio: AUTH_DEFAULTS.EMPTY_BIO,
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

    private createUsername(email: string, uid: string): string {
        const emailName = email.split('@')[0] || AUTH_DEFAULTS.USERNAME_FALLBACK;
        const normalizedName = emailName.toLowerCase().replace(/[^a-z0-9_]/g, '');
        const normalizedUid = uid.toLowerCase().replace(/[^a-z0-9_]/g, '').slice(0, 8);
        return `${normalizedName || AUTH_DEFAULTS.USERNAME_FALLBACK}_${normalizedUid}`;
    }
}
