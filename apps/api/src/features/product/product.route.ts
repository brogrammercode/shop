import { Router } from 'express';
import { protect } from '../auth/auth.middleware';
import { PRODUCT_ROUTES } from './product.constant';
import { ProductController } from './product.controller';

const router = Router();
const controller = new ProductController();

router.get(PRODUCT_ROUTES.LIST, protect, controller.getList);
router.get(PRODUCT_ROUTES.DETAIL, protect, controller.getById);
router.post(PRODUCT_ROUTES.LIST, protect, controller.create);
router.put(PRODUCT_ROUTES.DETAIL, protect, controller.update);
router.delete(PRODUCT_ROUTES.DETAIL, protect, controller.delete);

export default router;
