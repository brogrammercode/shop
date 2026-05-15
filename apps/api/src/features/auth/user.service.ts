import { UserRepo } from './user.repo';
import { User } from './user.type';
import { Jwt } from '../../infra/security/jwt';
import config from '../../core/config';

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
}
