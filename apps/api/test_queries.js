const { PrismaClient } = require('@prisma/client');
const { PrismaPg } = require('@prisma/adapter-pg');
const pg = require('pg');
require('dotenv').config();

const pool = new pg.Pool({ connectionString: process.env.DB_STRING });
const adapter = new PrismaPg(pool);
const prisma = new PrismaClient({ adapter, log: ['query'] });

async function run() {
  try {
    await prisma.$transaction(async (tx) => {
      const user = await tx.user.create({
        data: { uid: 'test_cuid', name: 'Test', phone: '123' }
      });
      console.log(user);
      await tx.userLog.create({
        data: {
          uid: user.id,
          action: 'T', type: 'T', module: 'T', title: 'T', description: 'T', meta: {}, ref_link: ''
        }
      });
      console.log('success');
    });
  } catch (e) {
    console.error(e);
  } finally {
    pool.end();
  }
}
run();
