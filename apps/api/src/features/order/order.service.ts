import { OrderRepo } from './order.repo';
import { 
    Product, Order, OrderItem, Bill, 
    Rider, Delivery,
    OrderStatus, DeliveryStatus, PaymentStatus 
} from './order.type';
import { User } from '../auth/user.type';
import { ORDER_DEFAULTS } from './order.constant';

type PlaceOrderData = {
    user?: User;
    order: Omit<Order, 'id' | 'created_at' | 'updated_at' | 'status'> & Partial<Pick<Order, 'status'>>;
    items: Omit<OrderItem, 'id' | 'order_id' | 'created_at' | 'updated_at'>[];
    delivery?: Omit<Delivery, 'id' | 'order_id' | 'created_at' | 'updated_at' | 'rider_id'>;
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
