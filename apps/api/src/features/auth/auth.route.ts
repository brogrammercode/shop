import { Router } from 'express';
import { AuthController } from './auth.controller';
import { protect } from './auth.middleware';

const router = Router();
const controller = new AuthController();

router.post('/login', controller.login);
router.post('/refresh', controller.refresh);
router.get('/me', protect, controller.me);
router.post('/activity', controller.logActivity);
router.get('/activity/:user_id', controller.getActivities);

export default router;
