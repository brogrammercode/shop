import { UserRepo } from './user.repo';
import { User, UserActivity } from './user.type';
import { Jwt } from '../../infra/security/jwt';
import config from '../../core/config';
import { BadRequestError } from '../../utils/error';

export class UserService {
    private userRepo: UserRepo;

    constructor() {
        this.userRepo = new UserRepo();
    }

    async getById(id: string): Promise<User | null> {
        return this.userRepo.findById(id);
    }

    async getByEmail(email: string): Promise<User | null> {
        return this.userRepo.findByEmail(email);
    }

    async create(data: Omit<User, 'id' | 'created_at' | 'updated_at'>): Promise<User> {
        return this.userRepo.create(data);
    }

    async update(id: string, data: Partial<Omit<User, 'id' | 'created_at' | 'updated_at'>>): Promise<User> {
        return this.userRepo.update(id, data);
    }

    async delete(id: string): Promise<User> {
        return this.userRepo.delete(id);
    }

    generateTokens(user: User): { accessToken: string, refreshToken: string } {
        const accessToken = Jwt.sign(
            { id: user.id, email: user.email },
            config.JWT_SECRET,
            { expiresIn: config.JWT_EXPIRES_IN as any }
        );

        const refreshToken = Jwt.sign(
            { id: user.id },
            config.JWT_REFRESH_SECRET,
            { expiresIn: config.JWT_REFRESH_EXPIRES_IN as any }
        );

        return { accessToken, refreshToken };
    }

    verifyToken<T>(token: string, secret: string): T {
        return Jwt.verify<T>(token, secret);
    }

    async logActivity(data: Omit<UserActivity, 'id' | 'created_at' | 'updated_at'> & { username?: string, userId?: string }) {
        const userId = data.user_id || data.userId || await this.resolveUserId(data.username);
        if (!userId) {
            throw new BadRequestError('user_id is required');
        }

        const { username, userId: _userId, ...activity } = data;
        return this.userRepo.createUserActivity({
            ...activity,
            user_id: userId,
        });
    }

    async getActivities(user_id: string) {
        return this.userRepo.getUserActivities(user_id);
    }

    private async resolveUserId(username?: string): Promise<string> {
        if (!username) {
            return '';
        }

        const user = await this.userRepo.findByUsername(username);
        return user?.id || '';
    }
}
