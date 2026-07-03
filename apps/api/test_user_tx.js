const prisma = require('./src/infra/database/client').default;

async function test() {
  const phone = '9999999999';
  const firebaseUid = `phone_${phone}`;
  try {
    await prisma.$transaction(async (tx) => {
      const user = await tx.user.create({
        data: {
          uid: firebaseUid,
          name: 'Unknown',
          phone,
        },
      });
      console.log('User created:', user);

      const log = await tx.userLog.create({
        data: {
          uid: user.id,
          action: 'CREATE_USER',
          type: 'MUTATION',
          module: 'CORE_HR',
          title: 'User Signup',
          description: `Created user account for ${phone}`,
          meta: { user_id: user.id },
          ref_link: `/user/${user.id}`,
        }
      });
      console.log('Log created:', log);
    });
  } catch (err) {
    console.error('Error:', err);
  } finally {
    process.exit(0);
  }
}
test();
