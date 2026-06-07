import { Router } from 'express';
import { AuthController } from './auth.controller';
import { protect } from './auth.middleware';

const router = Router();
const controller = new AuthController();

router.post('/login', controller.login);
router.post('/refresh', controller.refresh);
router.get('/me', protect, controller.me);
router.post('/activity', protect, controller.logActivity);
router.get('/activity/:user_id', controller.getActivities);

router.post('/send-otp', controller.sendOtp);
router.post('/verify-otp', controller.verifyOtp);

router.get('/sessions', protect, controller.getSessions);
router.post('/sessions', protect, controller.createSession);
router.delete('/sessions/:id', protect, controller.terminateSession);

router.get('/addresses', protect, controller.getAddresses);
router.post('/addresses', protect, controller.createAddress);
router.put('/addresses/:id', protect, controller.updateAddress);
router.delete('/addresses/:id', protect, controller.deleteAddress);

export default router;
