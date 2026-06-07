import prisma from '../../infra/database/client';
import { 
    Product, Order, OrderItem, 
    Bill, Rider, Delivery
} from './order.type';
import { ORDER_DEFAULTS } from './order.constant';

export class OrderRepo {
    async findProductById(id: string): Promise<Product | null> {
        return prisma.product.findUnique({ where: { id } }) as any;
    }

    async findProductsByBranchId(branch_id: string): Promise<Product[]> {
        return prisma.product.findMany({ where: { branch_id } }) as any;
    }

    async createProduct(data: Omit<Product, 'id' | 'created_at' | 'updated_at'>): Promise<Product> {
        return prisma.product.create({ data: data as any }) as any;
    }

    async updateProduct(id: string, data: Partial<Omit<Product, 'id' | 'created_at' | 'updated_at'>>): Promise<Product> {
        return prisma.product.update({ where: { id }, data: data as any }) as any;
    }

    async deleteProduct(id: string): Promise<Product> {
        return prisma.product.delete({ where: { id } }) as any;
    }

    async findOrderById(id: string): Promise<Order | null> {
        return prisma.order.findUnique({ where: { id } }) as any;
    }

    async findOrderDetailsById(id: string): Promise<unknown | null> {
        return prisma.order.findUnique({
            where: { id },
            include: {
                items: {
                    include: {
                        product: true
                    }
                },
                bill: true,
                branch: true,
                delivery: {
                    include: {
                        rider: {
                            include: {
                                employee: true
                            }
                        }
                    }
                },
                customer: true,
                employee: true
            }
        });
    }

    async findOrdersByBranchId(branch_id: string): Promise<Order[]> {
        return prisma.order.findMany({ where: { branch_id }, orderBy: { created_at: 'desc' } }) as any;
    }

    async findOrdersByCustomerId(customer_id: string): Promise<Order[]> {
        return prisma.order.findMany({ where: { customer_id }, orderBy: { created_at: 'desc' } }) as any;
    }

    async findActiveTableOrder(branch_id: string, table_number: string): Promise<Order | null> {
        return prisma.order.findFirst({
            where: {
                branch_id,
                table_number,
                status: {
                    notIn: [...ORDER_DEFAULTS.CLOSED_TABLE_STATUSES]
                }
            },
            orderBy: { created_at: 'desc' }
        }) as any;
    }

    async createOrder(data: Omit<Order, 'id' | 'created_at' | 'updated_at'>): Promise<Order> {
        return prisma.order.create({ data: data as any }) as any;
    }

    async updateOrder(id: string, data: Partial<Omit<Order, 'id' | 'created_at' | 'updated_at'>>): Promise<Order> {
        return prisma.order.update({ where: { id }, data: data as any }) as any;
    }

    async deleteOrder(id: string): Promise<Order> {
        return prisma.order.delete({ where: { id } }) as any;
    }

    async findOrderItemsByOrderId(order_id: string): Promise<OrderItem[]> {
        return prisma.orderItem.findMany({ where: { order_id } }) as any;
    }

    async createOrderItem(data: Omit<OrderItem, 'id' | 'created_at' | 'updated_at'>): Promise<OrderItem> {
        return prisma.orderItem.create({ data: data as any }) as any;
    }

    async findBillById(id: string): Promise<Bill | null> {
        return prisma.bill.findUnique({ where: { id } }) as any;
    }

    async findBillByOrderId(order_id: string): Promise<Bill | null> {
        return prisma.bill.findUnique({ where: { order_id } }) as any;
    }

    async createBill(data: Omit<Bill, 'id' | 'created_at' | 'updated_at'>): Promise<Bill> {
        return prisma.bill.create({ data: data as any }) as any;
    }

    async updateBill(id: string, data: Partial<Omit<Bill, 'id' | 'created_at' | 'updated_at'>>): Promise<Bill> {
        return prisma.bill.update({ where: { id }, data: data as any }) as any;
    }

    async findRiderById(id: string): Promise<Rider | null> {
        return prisma.rider.findUnique({ where: { id } }) as any;
    }

    async findRiderByEmployeeId(employee_id: string): Promise<Rider | null> {
        return prisma.rider.findUnique({ where: { employee_id } }) as any;
    }

    async createRider(data: Omit<Rider, 'id' | 'created_at' | 'updated_at'>): Promise<Rider> {
        return prisma.rider.create({ data: data as any }) as any;
    }

    async updateRider(id: string, data: Partial<Omit<Rider, 'id' | 'created_at' | 'updated_at'>>): Promise<Rider> {
        return prisma.rider.update({ where: { id }, data: data as any }) as any;
    }

    async findDeliveryById(id: string): Promise<Delivery | null> {
        return prisma.delivery.findUnique({ where: { id } }) as any;
    }

    async findDeliveryByOrderId(order_id: string): Promise<Delivery | null> {
        return prisma.delivery.findUnique({ where: { order_id } }) as any;
    }

    async findDeliveryByTrackingNumber(tracking_number: string): Promise<unknown | null> {
        return prisma.delivery.findFirst({
            where: { tracking_number },
            include: {
                order: {
                    include: {
                        bill: true,
                        items: {
                            include: {
                                product: true
                            }
                        }
                    }
                },
                rider: {
                    include: {
                        employee: true
                    }
                }
            }
        });
    }

    async createDelivery(data: Omit<Delivery, 'id' | 'created_at' | 'updated_at'>): Promise<Delivery> {
        return prisma.delivery.create({ data: data as any }) as any;
    }

    async updateDelivery(id: string, data: Partial<Omit<Delivery, 'id' | 'created_at' | 'updated_at'>>): Promise<Delivery> {
        return prisma.delivery.update({ where: { id }, data: data as any }) as any;
    }
}
