import { Router } from 'express';
import { protect } from '../auth/auth.middleware';
import { PRODUCT_ROUTES } from './product.constant';
import { ProductController } from './product.controller';

const router = Router();
const controller = new ProductController();

router.get(PRODUCT_ROUTES.LIST, protect, controller.getList);
router.post(PRODUCT_ROUTES.LIST, protect, controller.create);

router.get(PRODUCT_ROUTES.CATEGORIES, protect, controller.getCategories);
router.post(PRODUCT_ROUTES.CATEGORIES, protect, controller.createCategory);

router.get(PRODUCT_ROUTES.SUB_CATEGORIES, protect, controller.getSubCategories);
router.post(PRODUCT_ROUTES.SUB_CATEGORIES, protect, controller.createSubCategory);

router.get(PRODUCT_ROUTES.DETAIL, protect, controller.getById);
router.put(PRODUCT_ROUTES.DETAIL, protect, controller.update);
router.delete(PRODUCT_ROUTES.DETAIL, protect, controller.delete);

router.get(PRODUCT_ROUTES.CATEGORY_DETAIL, protect, controller.getCategoryById);
router.put(PRODUCT_ROUTES.CATEGORY_DETAIL, protect, controller.updateCategory);
router.delete(PRODUCT_ROUTES.CATEGORY_DETAIL, protect, controller.deleteCategory);

router.get(PRODUCT_ROUTES.SUB_CATEGORY_DETAIL, protect, controller.getSubCategoryById);
router.put(PRODUCT_ROUTES.SUB_CATEGORY_DETAIL, protect, controller.updateSubCategory);
router.delete(PRODUCT_ROUTES.SUB_CATEGORY_DETAIL, protect, controller.deleteSubCategory);

router.get(PRODUCT_ROUTES.SUB_PRODUCTS, protect, controller.getSubProducts);
router.post(PRODUCT_ROUTES.SUB_PRODUCTS, protect, controller.createSubProduct);
router.get(PRODUCT_ROUTES.SUB_PRODUCT_DETAIL, protect, controller.getSubProductById);
router.put(PRODUCT_ROUTES.SUB_PRODUCT_DETAIL, protect, controller.updateSubProduct);
router.delete(PRODUCT_ROUTES.SUB_PRODUCT_DETAIL, protect, controller.deleteSubProduct);

export default router;
