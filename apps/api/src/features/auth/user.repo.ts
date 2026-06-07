import prisma from '../../infra/database/client';
import { User, UserLog, UserSession, UserAddress, UserOtp, OtpType } from './user.type';

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

    async findByPhoneNumber(phone_number: string): Promise<User | null> {
        return prisma.user.findFirst({
            where: { phone_number }
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

    async createUserLog(data: Omit<UserLog, 'id' | 'created_at' | 'updated_at'>): Promise<UserLog> {
        return prisma.userLog.create({
            data
        });
    }

    async getUserLogs(uid: string): Promise<UserLog[]> {
        return prisma.userLog.findMany({
            where: { uid },
            orderBy: { created_at: 'desc' }
        });
    }

    async createSession(data: Omit<UserSession, 'id' | 'created_at' | 'updated_at'>): Promise<UserSession> {
        return prisma.userSession.create({
            data
        });
    }

    async findSessionsByUserId(uid: string): Promise<UserSession[]> {
        return prisma.userSession.findMany({
            where: { uid },
            orderBy: { created_at: 'desc' }
        });
    }

    async deleteSession(id: string): Promise<UserSession> {
        return prisma.userSession.delete({
            where: { id }
        });
    }

    async createAddress(data: Omit<UserAddress, 'id' | 'created_at' | 'updated_at'>): Promise<UserAddress> {
        return prisma.userAddress.create({
            data
        });
    }

    async findAddressesByUserId(uid: string): Promise<UserAddress[]> {
        return prisma.userAddress.findMany({
            where: { uid },
            orderBy: { created_at: 'desc' }
        });
    }

    async updateAddress(id: string, data: Partial<Omit<UserAddress, 'id' | 'created_at' | 'updated_at'>>): Promise<UserAddress> {
        return prisma.userAddress.update({
            where: { id },
            data
        });
    }

    async deleteAddress(id: string): Promise<UserAddress> {
        return prisma.userAddress.delete({
            where: { id }
        });
    }

    async createOtp(data: { actor: string; otp: string; type: OtpType; valid_till: Date }): Promise<UserOtp> {
        return prisma.userOtp.create({ data }) as unknown as UserOtp;
    }

    async findValidOtp(actor: string, otp: string, type: OtpType): Promise<UserOtp | null> {
        return prisma.userOtp.findFirst({
            where: {
                actor,
                otp,
                type,
                valid_till: { gt: new Date() },
            },
        }) as unknown as UserOtp | null;
    }

    async deleteOtpsByActor(actor: string, type: OtpType): Promise<void> {
        await prisma.userOtp.deleteMany({ where: { actor, type } });
    }

    async getAdBanners() {
        return await prisma.adBanner.findMany({
            where: {
                status: 'ACTIVE'
            },
            orderBy: {
                created_at: 'desc'
            }
        });
    }
}

