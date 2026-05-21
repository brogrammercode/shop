import { Request, Response } from 'express';
import { OrderService } from './order.service';
import { sendSuccess, NotFoundError, requireSingleValue } from '../../utils/error';
import { asyncHandler } from '../../utils/async';
import { ORDER_DEFAULTS, ORDER_FIELDS, ORDER_MESSAGES } from './order.constant';
import { User } from '../auth/user.type';
import { DeliveryStatus, Order, OrderStatus, PaymentStatus } from './order.type';

type OrderPayload = Omit<Order, 'id' | 'created_at' | 'updated_at' | 'status'> & Partial<Pick<Order, 'status'>>;

export class OrderController {
    private orderService: OrderService;

    constructor() {
        this.orderService = new OrderService();
    }

    private getOrderPayload(req: Request): OrderPayload {
        const { items: _items, delivery: _delivery, bill: _bill, ...order } = req.body;
        return (req.body.order ?? order) as OrderPayload;
    }

    getMenu = asyncHandler(async (req: Request, res: Response) => {
        const branchId = requireSingleValue(req.params.branchId, ORDER_FIELDS.BRANCH_ID);
        const result = await this.orderService.getProductsByBranch(branchId);
        return sendSuccess(res, result, ORDER_MESSAGES.MENU_FETCHED);
    });

    getProducts = asyncHandler(async (req: Request, res: Response) => {
        const branchId = requireSingleValue(req.query.branchId, ORDER_FIELDS.BRANCH_ID);
        const result = await this.orderService.getProductsByBranch(branchId);
        return sendSuccess(res, result, ORDER_MESSAGES.PRODUCTS_FETCHED);
    });

    getProduct = asyncHandler(async (req: Request, res: Response) => {
        const id = requireSingleValue(req.params.id, ORDER_FIELDS.ID);
        const result = await this.orderService.getProductById(id);

        if (!result) {
            throw new NotFoundError(ORDER_MESSAGES.NOT_FOUND);
        }

        return sendSuccess(res, result, ORDER_MESSAGES.PRODUCT_FETCHED);
    });

    createProduct = asyncHandler(async (req: Request, res: Response) => {
        const result = await this.orderService.createProduct(req.body);
        return sendSuccess(res, result, ORDER_MESSAGES.PRODUCT_CREATED);
    });

    updateProduct = asyncHandler(async (req: Request, res: Response) => {
        const id = requireSingleValue(req.params.id, ORDER_FIELDS.ID);
        const result = await this.orderService.updateProduct(id, req.body);
        return sendSuccess(res, result, ORDER_MESSAGES.PRODUCT_UPDATED);
    });

    deleteProduct = asyncHandler(async (req: Request, res: Response) => {
        const id = requireSingleValue(req.params.id, ORDER_FIELDS.ID);
        const result = await this.orderService.deleteProduct(id);
        return sendSuccess(res, result, ORDER_MESSAGES.PRODUCT_DELETED);
    });

    getOrders = asyncHandler(async (req: Request, res: Response) => {
        const branchId = requireSingleValue(req.query.branchId, ORDER_FIELDS.BRANCH_ID);
        const result = await this.orderService.getOrdersByBranch(branchId);
        return sendSuccess(res, result, ORDER_MESSAGES.ORDERS_FETCHED);
    });

    getMyOrders = asyncHandler(async (req: Request, res: Response) => {
        const user = (req as any).user as User;
        const result = await this.orderService.getOrdersByCustomer(user.id);
        return sendSuccess(res, result, ORDER_MESSAGES.ORDERS_FETCHED);
    });

    getOrder = asyncHandler(async (req: Request, res: Response) => {
        const id = requireSingleValue(req.params.id, ORDER_FIELDS.ID);
        const result = await this.orderService.getOrderDetailsById(id);

        if (!result) {
            throw new NotFoundError(ORDER_MESSAGES.NOT_FOUND);
        }

        return sendSuccess(res, result, ORDER_MESSAGES.ORDER_FETCHED);
    });

    getMyOrder = asyncHandler(async (req: Request, res: Response) => {
        const user = (req as any).user as User;
        const id = requireSingleValue(req.params.id, ORDER_FIELDS.ID);
        const order = await this.orderService.getOrderById(id);

        if (!order || order.customer_id !== user.id) {
            throw new NotFoundError(ORDER_MESSAGES.NOT_FOUND);
        }

        const result = await this.orderService.getOrderDetailsById(id);
        return sendSuccess(res, result, ORDER_MESSAGES.ORDER_FETCHED);
    });

    placeOrder = asyncHandler(async (req: Request, res: Response) => {
        const result = await this.orderService.placeOrder({
            order: this.getOrderPayload(req),
            items: req.body.items ?? [],
            delivery: req.body.delivery
        });
        return sendSuccess(res, result, ORDER_MESSAGES.ORDER_CREATED);
    });

    placeCounterOrder = asyncHandler(async (req: Request, res: Response) => {
        const user = (req as any).user as User;
        const result = await this.orderService.placeCounterOrder(user, {
            branch_id: req.body.branch_id,
            employee_id: req.body.employee_id,
            items: req.body.items ?? [],
            notes: req.body.notes,
            tax: req.body.tax,
            discount: req.body.discount,
            payment_method: req.body.payment_method
        });
        return sendSuccess(res, result, ORDER_MESSAGES.COUNTER_ORDER_CREATED);
    });

    placeMyOrder = asyncHandler(async (req: Request, res: Response) => {
        const user = (req as any).user as User;
        const result = await this.orderService.placeOrder({
            user,
            order: this.getOrderPayload(req),
            items: req.body.items ?? [],
            delivery: req.body.delivery
        });
        return sendSuccess(res, result, ORDER_MESSAGES.ORDER_CREATED);
    });

    placeTableOrder = asyncHandler(async (req: Request, res: Response) => {
        const branchId = requireSingleValue(req.params.branchId, ORDER_FIELDS.BRANCH_ID);
        const tableNumber = requireSingleValue(req.params.tableNumber, ORDER_FIELDS.TABLE_NUMBER);
        const result = await this.orderService.placeOrder({
            order: {
                ...this.getOrderPayload(req),
                branch_id: branchId,
                table_number: tableNumber,
                type: ORDER_DEFAULTS.DINE_IN_TYPE,
                status: ORDER_DEFAULTS.PENDING_ORDER_STATUS
            },
            items: req.body.items ?? [],
            delivery: req.body.delivery
        });
        return sendSuccess(res, result, ORDER_MESSAGES.ORDER_CREATED);
    });

    placeDeliveryOrder = asyncHandler(async (req: Request, res: Response) => {
        const user = (req as any).user as User;
        const result = await this.orderService.placeOrder({
            user,
            order: {
                ...this.getOrderPayload(req),
                type: ORDER_DEFAULTS.DELIVERY_TYPE,
                status: ORDER_DEFAULTS.PENDING_ORDER_STATUS
            },
            items: req.body.items ?? [],
            delivery: req.body.delivery
        });
        return sendSuccess(res, result, ORDER_MESSAGES.ORDER_CREATED);
    });

    getTableSession = asyncHandler(async (req: Request, res: Response) => {
        const branchId = requireSingleValue(req.params.branchId, ORDER_FIELDS.BRANCH_ID);
        const tableNumber = requireSingleValue(req.params.tableNumber, ORDER_FIELDS.TABLE_NUMBER);
        const result = await this.orderService.getActiveTableOrder(branchId, tableNumber);
        return sendSuccess(res, result, ORDER_MESSAGES.TABLE_SESSION_FETCHED);
    });

    updateOrderStatus = asyncHandler(async (req: Request, res: Response) => {
        const id = requireSingleValue(req.params.id, ORDER_FIELDS.ID);
        const result = await this.orderService.updateOrderStatus(id, req.body.status as OrderStatus);
        return sendSuccess(res, result, ORDER_MESSAGES.ORDER_UPDATED);
    });

    getBillByOrder = asyncHandler(async (req: Request, res: Response) => {
        const orderId = requireSingleValue(req.params.orderId, ORDER_FIELDS.ORDER_ID);
        const result = await this.orderService.getBillByOrderId(orderId);

        if (!result) {
            throw new NotFoundError(ORDER_MESSAGES.NOT_FOUND);
        }

        return sendSuccess(res, result, ORDER_MESSAGES.BILL_FETCHED);
    });

    generateBill = asyncHandler(async (req: Request, res: Response) => {
        const orderId = requireSingleValue(req.params.orderId, ORDER_FIELDS.ORDER_ID);
        const result = await this.orderService.generateBill({
            ...req.body,
            order_id: orderId
        });
        return sendSuccess(res, result, ORDER_MESSAGES.BILL_GENERATED);
    });

    updateBillStatus = asyncHandler(async (req: Request, res: Response) => {
        const id = requireSingleValue(req.params.id, ORDER_FIELDS.ID);
        const result = await this.orderService.updateBillStatus(id, req.body.payment_status as PaymentStatus);
        return sendSuccess(res, result, ORDER_MESSAGES.BILL_PAID);
    });

    getReceipt = asyncHandler(async (req: Request, res: Response) => {
        const id = requireSingleValue(req.params.id, ORDER_FIELDS.ID);
        const result = await this.orderService.getOrderDetailsById(id);

        if (!result) {
            throw new NotFoundError(ORDER_MESSAGES.NOT_FOUND);
        }

        return sendSuccess(res, result, ORDER_MESSAGES.RECEIPT_FETCHED);
    });

    getPublicOrder = asyncHandler(async (req: Request, res: Response) => {
        const id = requireSingleValue(req.params.id, ORDER_FIELDS.ID);
        const result = await this.orderService.getOrderDetailsById(id);

        if (!result) {
            throw new NotFoundError(ORDER_MESSAGES.NOT_FOUND);
        }

        return sendSuccess(res, result, ORDER_MESSAGES.ORDER_FETCHED);
    });

    getPublicReceipt = asyncHandler(async (req: Request, res: Response) => {
        const id = requireSingleValue(req.params.id, ORDER_FIELDS.ID);
        const result = await this.orderService.getOrderDetailsById(id);

        if (!result) {
            throw new NotFoundError(ORDER_MESSAGES.NOT_FOUND);
        }

        return sendSuccess(res, result, ORDER_MESSAGES.RECEIPT_FETCHED);
    });

    getRiderByEmployee = asyncHandler(async (req: Request, res: Response) => {
        const employeeId = requireSingleValue(req.params.employeeId, ORDER_FIELDS.EMPLOYEE_ID);
        const result = await this.orderService.getRiderByEmployeeId(employeeId);

        if (!result) {
            throw new NotFoundError(ORDER_MESSAGES.NOT_FOUND);
        }

        return sendSuccess(res, result, ORDER_MESSAGES.RIDER_FETCHED);
    });

    getRider = asyncHandler(async (req: Request, res: Response) => {
        const id = requireSingleValue(req.params.id, ORDER_FIELDS.ID);
        const result = await this.orderService.getRiderById(id);

        if (!result) {
            throw new NotFoundError(ORDER_MESSAGES.NOT_FOUND);
        }

        return sendSuccess(res, result, ORDER_MESSAGES.RIDER_FETCHED);
    });

    createRider = asyncHandler(async (req: Request, res: Response) => {
        const result = await this.orderService.createRider(req.body);
        return sendSuccess(res, result, ORDER_MESSAGES.RIDER_CREATED);
    });

    updateRider = asyncHandler(async (req: Request, res: Response) => {
        const id = requireSingleValue(req.params.id, ORDER_FIELDS.ID);
        const result = await this.orderService.updateRider(id, req.body);
        return sendSuccess(res, result, ORDER_MESSAGES.RIDER_UPDATED);
    });

    getDelivery = asyncHandler(async (req: Request, res: Response) => {
        const id = requireSingleValue(req.params.id, ORDER_FIELDS.ID);
        const result = await this.orderService.getDeliveryById(id);

        if (!result) {
            throw new NotFoundError(ORDER_MESSAGES.NOT_FOUND);
        }

        return sendSuccess(res, result, ORDER_MESSAGES.DELIVERY_FETCHED);
    });

    getDeliveryByOrder = asyncHandler(async (req: Request, res: Response) => {
        const orderId = requireSingleValue(req.params.orderId, ORDER_FIELDS.ORDER_ID);
        const result = await this.orderService.getDeliveryByOrderId(orderId);

        if (!result) {
            throw new NotFoundError(ORDER_MESSAGES.NOT_FOUND);
        }

        return sendSuccess(res, result, ORDER_MESSAGES.DELIVERY_FETCHED);
    });

    getDeliveryTracking = asyncHandler(async (req: Request, res: Response) => {
        const trackingNumber = requireSingleValue(req.params.trackingNumber, ORDER_FIELDS.TRACKING_NUMBER);
        const result = await this.orderService.getDeliveryTracking(trackingNumber);

        if (!result) {
            throw new NotFoundError(ORDER_MESSAGES.NOT_FOUND);
        }

        return sendSuccess(res, result, ORDER_MESSAGES.DELIVERY_FETCHED);
    });

    assignRider = asyncHandler(async (req: Request, res: Response) => {
        const id = requireSingleValue(req.params.id, ORDER_FIELDS.ID);
        const result = await this.orderService.assignRider(id, req.body.rider_id);
        return sendSuccess(res, result, ORDER_MESSAGES.RIDER_ASSIGNED);
    });

    updateDeliveryStatus = asyncHandler(async (req: Request, res: Response) => {
        const id = requireSingleValue(req.params.id, ORDER_FIELDS.ID);
        const result = await this.orderService.updateDeliveryStatus(id, req.body.status as DeliveryStatus);
        return sendSuccess(res, result, ORDER_MESSAGES.DELIVERY_UPDATED);
    });
}
