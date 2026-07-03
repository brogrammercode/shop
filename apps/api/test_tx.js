const { PrismaClient } = require('@prisma/client');
const { PrismaPg } = require('@prisma/adapter-pg');
const pg = require('pg');
require('dotenv').config();

const pool = new pg.Pool({ connectionString: process.env.DB_STRING });
const adapter = new PrismaPg(pool);
const prismaClient = new PrismaClient({ adapter });

const prisma = prismaClient.$extends({
  query: {
    $allModels: {
      async create({ model, operation, args, query }) {
        args.data = args.data || {};
        if (!args.data.id) {
          args.data.id = Date.now().toString();
        }
        return query(args);
      }
    }
  }
});

async function main() {
  try {
    await prisma.$transaction(async (tx) => {
      const user = await tx.user.create({
        data: { uid: 'test_1234', name: 'Test', phone: '1234' }
      });
      console.log('Created user:', user);
      
      const log = await tx.userLog.create({
        data: {
          uid: user.id,
          action: 'CREATE',
          type: 'TEST',
          module: 'TEST',
          title: 'Test',
          description: 'Test',
          meta: {},
          ref_link: ''
        }
      });
      console.log('Created log:', log);
    });
  } catch (e) {
    console.error(e);
  } finally {
    pool.end();
  }
}

main();
