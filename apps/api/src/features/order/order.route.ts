import { Router } from 'express';
import { OrderController } from './order.controller';
import { protect } from '../auth/auth.middleware';
import { ORDER_ROUTES } from './order.constant';

const router = Router();
const controller = new OrderController();

router.get(ORDER_ROUTES.MENU, controller.getMenu);
router.get(ORDER_ROUTES.TABLE_MENU, controller.getMenu);
router.get(ORDER_ROUTES.TABLE_SESSION, controller.getTableSession);
router.post(ORDER_ROUTES.TABLE_ORDER, controller.placeTableOrder);
router.get(ORDER_ROUTES.PUBLIC_ORDER_DETAIL, controller.getPublicOrder);
router.get(ORDER_ROUTES.PUBLIC_RECEIPT, controller.getPublicReceipt);
router.get(ORDER_ROUTES.DELIVERY_TRACKING, controller.getDeliveryTracking);

router.get(ORDER_ROUTES.PRODUCT_LIST, protect, controller.getProducts);
router.get(ORDER_ROUTES.PRODUCT_DETAIL, protect, controller.getProduct);
router.post(ORDER_ROUTES.PRODUCT_LIST, protect, controller.createProduct);
router.patch(ORDER_ROUTES.PRODUCT_DETAIL, protect, controller.updateProduct);
router.delete(ORDER_ROUTES.PRODUCT_DETAIL, protect, controller.deleteProduct);

router.get(ORDER_ROUTES.MY_ORDER_LIST, protect, controller.getMyOrders);
router.get(ORDER_ROUTES.MY_ORDER_DETAIL, protect, controller.getMyOrder);
router.post(ORDER_ROUTES.MY_ORDER_LIST, protect, controller.placeMyOrder);
router.post(ORDER_ROUTES.DELIVERY_ORDER, protect, controller.placeDeliveryOrder);

router.get(ORDER_ROUTES.ORDER_LIST, protect, controller.getOrders);
router.get(ORDER_ROUTES.ORDER_DETAIL, protect, controller.getOrder);
router.post(ORDER_ROUTES.ORDER_LIST, protect, controller.placeOrder);
router.post(ORDER_ROUTES.COUNTER_ORDER, protect, controller.placeOrder);
router.patch(ORDER_ROUTES.ORDER_STATUS, protect, controller.updateOrderStatus);

router.get(ORDER_ROUTES.BILL_BY_ORDER, protect, controller.getBillByOrder);
router.post(ORDER_ROUTES.BILL_BY_ORDER, protect, controller.generateBill);
router.patch(ORDER_ROUTES.BILL_STATUS, protect, controller.updateBillStatus);
router.get(ORDER_ROUTES.RECEIPT, protect, controller.getReceipt);

router.get(ORDER_ROUTES.RIDER_BY_EMPLOYEE, protect, controller.getRiderByEmployee);
router.get(ORDER_ROUTES.RIDER_DETAIL, protect, controller.getRider);
router.post(ORDER_ROUTES.RIDER_LIST, protect, controller.createRider);
router.patch(ORDER_ROUTES.RIDER_DETAIL, protect, controller.updateRider);

router.get(ORDER_ROUTES.DELIVERY_BY_ORDER, protect, controller.getDeliveryByOrder);
router.get(ORDER_ROUTES.DELIVERY_DETAIL, protect, controller.getDelivery);
router.patch(ORDER_ROUTES.DELIVERY_ASSIGN_RIDER, protect, controller.assignRider);
router.patch(ORDER_ROUTES.DELIVERY_STATUS, protect, controller.updateDeliveryStatus);

export default router;
