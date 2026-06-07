import { OrderRepo } from './order.repo';
import { 
    Product, ProductVariant, Order, OrderItem, Bill, 
    Rider, Delivery,
    OrderStatus, DeliveryStatus, PaymentStatus, PaymentMethod 
} from './order.type';
import { User } from '../auth/user.type';
import { ORDER_DEFAULTS, ORDER_MESSAGES } from './order.constant';
import prisma from '../../infra/database/client';
import { BadRequestError, ForbiddenError, NotFoundError } from '../../utils/error';

type PlaceOrderData = {
    user?: User;
    order: Omit<Order, 'id' | 'created_at' | 'updated_at' | 'status'> & Partial<Pick<Order, 'status'>>;
    items: Omit<OrderItem, 'id' | 'order_id' | 'created_at' | 'updated_at'>[];
    delivery?: Omit<Delivery, 'id' | 'order_id' | 'created_at' | 'updated_at' | 'rider_id'>;
}

type CounterOrderItemData = {
    readonly product_id: string;
    readonly quantity: number;
    readonly variants?: readonly ProductVariant[];
    readonly notes?: string;
}

type CounterOrderData = {
    readonly branch_id: string;
    readonly employee_id?: string;
    readonly items: readonly CounterOrderItemData[];
    readonly notes?: string;
    readonly tax?: number;
    readonly discount?: number;
    readonly payment_method?: PaymentMethod;
}

export class OrderService {
    private orderRepo: OrderRepo;

    constructor() {
        this.orderRepo = new OrderRepo();
    }

    async getProductById(id: string): Promise<Product | null> {
        return this.orderRepo.findProductById(id);
    }

    async getProductsByBranch(branchId: string): Promise<Product[]> {
        return this.orderRepo.findProductsByBranchId(branchId);
    }

    async createProduct(data: Omit<Product, 'id' | 'created_at' | 'updated_at'>): Promise<Product> {
        return this.orderRepo.createProduct(data);
    }

    async updateProduct(id: string, data: Partial<Omit<Product, 'id' | 'created_at' | 'updated_at'>>): Promise<Product> {
        return this.orderRepo.updateProduct(id, data);
    }

    async deleteProduct(id: string): Promise<Product> {
        return this.orderRepo.deleteProduct(id);
    }

    async getOrderById(id: string): Promise<Order | null> {
        return this.orderRepo.findOrderById(id);
    }

    async getOrderDetailsById(id: string): Promise<unknown | null> {
        return this.orderRepo.findOrderDetailsById(id);
    }

    async getOrdersByBranch(branchId: string): Promise<Order[]> {
        return this.orderRepo.findOrdersByBranchId(branchId);
    }

    async getOrdersByCustomer(customerId: string): Promise<Order[]> {
        return this.orderRepo.findOrdersByCustomerId(customerId);
    }

    async getActiveTableOrder(branchId: string, tableNumber: string): Promise<Order | null> {
        return this.orderRepo.findActiveTableOrder(branchId, tableNumber);
    }

    async getOrderItemsByOrderId(orderId: string): Promise<OrderItem[]> {
        return this.orderRepo.findOrderItemsByOrderId(orderId);
    }

    async placeOrder(data: PlaceOrderData): Promise<Order> {
        const order = await this.orderRepo.createOrder({ 
            ...data.order, 
            customer_id: data.user?.id ?? data.order.customer_id,
            status: data.order.status ?? ORDER_DEFAULTS.PENDING_ORDER_STATUS
        });
        
        for (const item of data.items) {
            await this.orderRepo.createOrderItem({ ...item, order_id: order.id });
        }

        if (data.delivery) {
            await this.orderRepo.createDelivery({ ...data.delivery, order_id: order.id });
        }

        return order;
    }

    async placeCounterOrder(user: User, data: CounterOrderData): Promise<unknown> {
        if (!data.items.length) {
            throw new BadRequestError(ORDER_MESSAGES.EMPTY_ORDER);
        }

        const employee = await prisma.employee.findUnique({
            where: { uid: user.id },
            include: { role: true }
        });

        if (!employee || employee.branch_id !== data.branch_id) {
            throw new ForbiddenError(ORDER_MESSAGES.EMPLOYEE_CONTEXT_REQUIRED);
        }

        return prisma.$transaction(async (tx) => {
            let subTotal = 0;
            const resolvedItems = [];

            for (const item of data.items) {
                if (item.quantity <= 0) {
                    throw new BadRequestError(ORDER_MESSAGES.INVALID_QUANTITY);
                }

                const product = await tx.product.findFirst({
                    where: {
                        id: item.product_id,
                        branch_id: data.branch_id
                    }
                });

                if (!product) {
                    throw new NotFoundError(ORDER_MESSAGES.PRODUCT_UNAVAILABLE);
                }

                if (!product.is_available) {
                    throw new BadRequestError(ORDER_MESSAGES.PRODUCT_UNAVAILABLE);
                }

                if (product.stock < item.quantity) {
                    throw new BadRequestError(ORDER_MESSAGES.INSUFFICIENT_STOCK);
                }

                const productVariants = Array.isArray(product.variants) ? product.variants as ProductVariant[] : [];
                const selectedVariants = (item.variants ?? []).map((variant) => {
                    const matchedVariant = productVariants.find((productVariant) => productVariant.name === variant.name);
                    return matchedVariant ?? { name: variant.name, price: 0 };
                });
                const variantTotal = selectedVariants.reduce((total, variant) => total + Number(variant.price), 0);
                const price = Number(product.price) + variantTotal;
                subTotal += price * item.quantity;

                resolvedItems.push({
                    product_id: product.id,
                    quantity: item.quantity,
                    price,
                    variants: selectedVariants,
                    notes: item.notes
                });

                const stockUpdate = await tx.product.updateMany({
                    where: {
                        id: product.id,
                        stock: {
                            gte: item.quantity
                        }
                    },
                    data: {
                        stock: {
                            decrement: item.quantity
                        }
                    }
                });

                if (stockUpdate.count === 0) {
                    throw new BadRequestError(ORDER_MESSAGES.INSUFFICIENT_STOCK);
                }

                if (product.stock - item.quantity <= 0) {
                    await tx.product.update({
                        where: { id: product.id },
                        data: { is_available: false }
                    });
                }
            }

            const tax = data.tax ?? ORDER_DEFAULTS.DEFAULT_TAX;
            const discount = data.discount ?? ORDER_DEFAULTS.DEFAULT_DISCOUNT;
            const deliveryAmount = ORDER_DEFAULTS.DEFAULT_DELIVERY_AMOUNT;
            const orderAmount = Math.max(subTotal - discount, 0);
            const totalAmount = orderAmount + tax + deliveryAmount;
            const order = await tx.order.create({
                data: {
                    branch_id: data.branch_id,
                    employee_id: employee.id,
                    type: ORDER_DEFAULTS.TAKEAWAY_TYPE,
                    status: ORDER_DEFAULTS.CONFIRMED_ORDER_STATUS,
                    total_amount: totalAmount,
                    notes: data.notes,
                    items: {
                        create: resolvedItems
                    }
                }
            });

            await tx.bill.create({
                data: {
                    order_id: order.id,
                    bill_number: `${ORDER_DEFAULTS.BILL_PREFIX}-${Date.now()}`,
                    sub_total: subTotal,
                    tax,
                    discount,
                    order_amount: orderAmount,
                    delivery_amount: deliveryAmount,
                    total_amount: totalAmount,
                    payment_status: ORDER_DEFAULTS.PAID_PAYMENT_STATUS,
                    payment_method: data.payment_method ?? ORDER_DEFAULTS.UPI_PAYMENT_METHOD
                }
            });

            return tx.order.findUnique({
                where: { id: order.id },
                include: {
                    items: {
                        include: {
                            product: true
                        }
                    },
                    bill: true,
                    branch: true,
                    employee: true
                }
            });
        });
    }

    async updateOrderStatus(id: string, status: OrderStatus): Promise<Order> {
        return this.orderRepo.updateOrder(id, { status });
    }

    async getBillByOrderId(orderId: string): Promise<Bill | null> {
        return this.orderRepo.findBillByOrderId(orderId);
    }

    async generateBill(data: Omit<Bill, 'id' | 'created_at' | 'updated_at'>): Promise<Bill> {
        return this.orderRepo.createBill(data);
    }

    async updateBillStatus(id: string, payment_status: PaymentStatus): Promise<Bill> {
        return this.orderRepo.updateBill(id, { payment_status });
    }

    async getRiderByEmployeeId(employeeId: string): Promise<Rider | null> {
        return this.orderRepo.findRiderByEmployeeId(employeeId);
    }

    async getRiderById(id: string): Promise<Rider | null> {
        return this.orderRepo.findRiderById(id);
    }

    async createRider(data: Omit<Rider, 'id' | 'created_at' | 'updated_at'>): Promise<Rider> {
        return this.orderRepo.createRider(data);
    }

    async updateRider(id: string, data: Partial<Omit<Rider, 'id' | 'created_at' | 'updated_at'>>): Promise<Rider> {
        return this.orderRepo.updateRider(id, data);
    }

    async getDeliveryById(id: string): Promise<Delivery | null> {
        return this.orderRepo.findDeliveryById(id);
    }

    async getDeliveryByOrderId(orderId: string): Promise<Delivery | null> {
        return this.orderRepo.findDeliveryByOrderId(orderId);
    }

    async getDeliveryTracking(trackingNumber: string): Promise<unknown | null> {
        return this.orderRepo.findDeliveryByTrackingNumber(trackingNumber);
    }

    async assignRider(deliveryId: string, riderId: string): Promise<Delivery> {
        return this.orderRepo.updateDelivery(deliveryId, { 
            rider_id: riderId, 
            status: ORDER_DEFAULTS.ASSIGNED_DELIVERY_STATUS as DeliveryStatus 
        });
    }

    async updateDeliveryStatus(id: string, status: DeliveryStatus): Promise<Delivery> {
        return this.orderRepo.updateDelivery(id, { status });
    }
}
