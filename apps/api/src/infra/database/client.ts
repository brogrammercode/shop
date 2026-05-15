import { PrismaClient } from '@prisma/client';
import { PrismaPg } from '@prisma/adapter-pg';
import pg from 'pg';
import config from '../../core/config';

const pool = new pg.Pool({ connectionString: config.DB_STRING });
const adapter = new PrismaPg(pool);
const prisma = new PrismaClient({ adapter });

export { pool };
export default prisma;
