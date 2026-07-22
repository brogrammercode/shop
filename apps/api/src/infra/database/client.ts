import { PrismaClient, Prisma } from '@prisma/client';
import { PrismaPg } from '@prisma/adapter-pg';
import pg from 'pg';
import config from '../../core/config';
import { requestContext } from '../../core/request_context';

const modelsWithCreatedBy = new Set(Prisma.dmmf.datamodel.models.filter(m => m.fields.some(f => f.name === 'created_by')).map(m => m.name));
const modelsWithUpdatedBy = new Set(Prisma.dmmf.datamodel.models.filter(m => m.fields.some(f => f.name === 'updated_by')).map(m => m.name));

const databaseConnection = buildDatabaseConnection(config.DB_STRING);

const pool = new pg.Pool({
  connectionString: databaseConnection.connectionString,
  ssl: databaseConnection.ssl,
  connectionTimeoutMillis: 30000,
  idleTimeoutMillis: 15000,
  keepAlive: true,
  max: 5,
  min: 0,
  maxUses: 250,
});
pool.on('error', () => undefined);
const adapter = new PrismaPg(pool);
const prismaClient = new PrismaClient({ adapter });

const prisma = prismaClient.$extends({
  query: {
    $allModels: {
      async create({ model, operation, args, query }) {
        args.data = args.data || {};
        if (!(args.data as any).id) {
          (args.data as any).id = Date.now().toString();
        }
        if (model === 'Branch' && !(args.data as any).code) {
          const data = args.data as any;
          const prefix = data.name ? data.name.substring(0, 3).toUpperCase() : 'BRN';
          const randomSuffix = Math.floor(1000 + Math.random() * 9000);
          data.code = `${prefix}-${randomSuffix}`;
        }
        
        const uid = requestContext.getStore()?.uid;
        if (uid) {
          if (modelsWithCreatedBy.has(model) && (args.data as any).created_by === undefined) {
            (args.data as any).created_by = uid;
          }
          if (modelsWithUpdatedBy.has(model) && (args.data as any).updated_by === undefined) {
            (args.data as any).updated_by = uid;
          }
        }
        return query(args);
      },
      async update({ model, operation, args, query }) {
        args.data = args.data || {};
        const uid = requestContext.getStore()?.uid;
        if (uid) {
          if (modelsWithUpdatedBy.has(model) && (args.data as any).updated_by === undefined) {
            (args.data as any).updated_by = uid;
          }
        }
        return query(args);
      },
    },
  },
}) as unknown as PrismaClient;

export { pool };
export default prisma;

function buildDatabaseConnection(connectionString: string): { connectionString: string; ssl?: pg.ConnectionConfig['ssl'] } {
  const parsedUrl = new URL(connectionString);
  const sslMode = parsedUrl.searchParams.get('sslmode');
  parsedUrl.searchParams.delete('sslmode');

  if (!sslMode || sslMode === 'disable') {
    return { connectionString: parsedUrl.toString() };
  }

  return {
    connectionString: parsedUrl.toString(),
    ssl: {
      rejectUnauthorized: sslMode === 'verify-full',
    },
  };
}
