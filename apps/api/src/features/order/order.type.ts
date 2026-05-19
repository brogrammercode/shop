type ProductVariant = {
    readonly name: string;
    readonly price: number;
}

type Product = {
    readonly id: string;
    readonly branch_id: string;
    readonly name: string;
    readonly description?: string;
    readonly price: number;
    readonly stock: number;
    readonly category?: string;
    readonly images?: readonly string[];
    readonly is_veg: boolean; 
    readonly preparation_time: number;
    readonly variants: readonly ProductVariant[];
    readonly is_available: boolean;
    readonly created_at: Date;
    readonly updated_at: Date;
}

type OrderType = 'DINE_IN' | 'TAKEAWAY' | 'DELIVERY';
type OrderStatus = 'PENDING' | 'CONFIRMED' | 'PREPARING' | 'READY' | 'DISPATCHED' | 'DELIVERED' | 'CANCELLED';

type Order = {
    readonly id: string;
    readonly branch_id: string;
    readonly employee_id?: string;
    readonly customer_id?: string;
    readonly type: OrderType;
    readonly table_number?: string;
    readonly status: OrderStatus;
    readonly total_amount: number;
    readonly notes?: string;
    readonly created_at: Date;
    readonly updated_at: Date;
}

type OrderItem = {
    readonly id: string;
    readonly order_id: string;
    readonly product_id: string;
    readonly quantity: number;
    readonly price: number;
    readonly variants: readonly ProductVariant[];
    readonly notes?: string;
    readonly created_at: Date;
    readonly updated_at: Date;
}

type PaymentStatus = 'PENDING' | 'PAID' | 'FAILED' | 'REFUNDED';
type PaymentMethod = 'CASH' | 'CARD' | 'UPI' | 'ONLINE';

type Bill = {
    readonly id: string;
    readonly order_id: string;
    readonly bill_number: string;
    readonly sub_total: number;
    readonly tax: number;
    readonly discount: number;
    readonly order_amount: number;
    readonly delivery_amount: number;
    readonly total_amount: number;
    readonly payment_status: PaymentStatus;
    readonly payment_method: PaymentMethod;
    readonly created_at: Date;
    readonly updated_at: Date;
}

type DeliveryStatus = 'PENDING' | 'ASSIGNED' | 'OUT_FOR_DELIVERY' | 'DELIVERED' | 'FAILED';

type Delivery = {
    readonly id: string;
    readonly order_id: string;
    readonly rider_id?: string;
    readonly status: DeliveryStatus;
    readonly tracking_number?: string;
    readonly address: string;
    readonly delivery_fee: number;
    readonly estimated_time?: Date;
    readonly actual_time?: Date;
    readonly created_at: Date;
    readonly updated_at: Date;
}

type Rider = {
    readonly id: string;
    readonly employee_id: string;
    readonly vehicle_number?: string;
    readonly vehicle_type?: string;
    readonly is_available: boolean;
    readonly current_location?: string;
    readonly created_at: Date;
    readonly updated_at: Date;
}

export {
    Product,
    ProductVariant,
    OrderType,
    OrderStatus,
    Order,
    OrderItem,
    PaymentStatus,
    PaymentMethod,
    Bill,
    DeliveryStatus,
    Delivery,
    Rider
};
