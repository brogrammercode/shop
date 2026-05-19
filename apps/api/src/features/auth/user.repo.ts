import prisma from '../../infra/database/client';
import { User } from './user.type';

export class UserRepo {
    async findById(id: string): Promise<User | null> {
        return prisma.user.findUnique({
            where: { id }
        });
    }

    async findByEmail(email: string): Promise<User | null> {
        return prisma.user.findUnique({
            where: { email }
        });
    }

    async create(data: Omit<User, 'id' | 'created_at' | 'updated_at'>): Promise<User> {
        return prisma.user.create({
            data
        });
    }

    async update(id: string, data: Partial<Omit<User, 'id' | 'created_at' | 'updated_at'>>): Promise<User> {
        return prisma.user.update({
            where: { id },
            data
        });
    }

    async delete(id: string): Promise<User> {
        return prisma.user.delete({
            where: { id }
        });
    }

    async createUserActivity(data: Omit<import('./user.type').UserActivity, 'id' | 'created_at' | 'updated_at'>) {
        return prisma.userActivity.create({
            data
        });
    }

    async getUserActivities(username: string) {
        return prisma.userActivity.findMany({
            where: { username },
            orderBy: { created_at: 'desc' },
            include: { user: true }
        });
    }
}