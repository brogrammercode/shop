import { Router } from 'express';
import { AuthController } from './auth.controller';

const router = Router();
const controller = new AuthController();

router.post('/login', controller.login);
router.post('/refresh', controller.refresh);
router.post('/activity', controller.logActivity);
router.get('/activity/:username', controller.getActivities);

export default router;
