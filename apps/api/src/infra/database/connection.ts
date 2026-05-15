import prisma, { pool } from './client';
import logger from '../../utils/logger';

export const database = {
    connect: async () => {
        try {
            await prisma.$connect();
            logger.info('Database connected successfully');
        } catch (error) {
            logger.error('Database connection failed:', error);
            process.exit(1);
        }
    },
    disconnect: async () => {
        try {
            await prisma.$disconnect();
            await pool.end();
            logger.info('Database disconnected successfully');
        } catch (error) {
            logger.error('Database disconnection failed:', error);
        }
    }
};

export default database;
