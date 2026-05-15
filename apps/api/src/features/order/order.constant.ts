export const ORDER_MESSAGES = {
    MENU_FETCHED: 'Menu fetched successfully',
    PRODUCT_FETCHED: 'Product fetched successfully',
    PRODUCTS_FETCHED: 'Products fetched successfully',
    PRODUCT_CREATED: 'Product created successfully',
    PRODUCT_UPDATED: 'Product updated successfully',
    PRODUCT_DELETED: 'Product deleted successfully',
    ORDER_FETCHED: 'Order fetched successfully',
    ORDERS_FETCHED: 'Orders fetched successfully',
    ORDER_CREATED: 'Order placed successfully',
    ORDER_UPDATED: 'Order updated successfully',
    ORDER_CANCELLED: 'Order cancelled successfully',
    TABLE_SESSION_FETCHED: 'Table session fetched successfully',
    BILL_GENERATED: 'Bill generated successfully',
    BILL_FETCHED: 'Bill fetched successfully',
    BILL_PAID: 'Payment received successfully',
    RECEIPT_FETCHED: 'Receipt fetched successfully',
    RIDER_CREATED: 'Rider created successfully',
    RIDER_FETCHED: 'Rider fetched successfully',
    RIDER_UPDATED: 'Rider updated successfully',
    RIDER_ASSIGNED: 'Rider assigned to delivery',
    DELIVERY_FETCHED: 'Delivery fetched successfully',
    DELIVERY_UPDATED: 'Delivery status updated',
    NOT_FOUND: 'Resource not found in order module',
    INSUFFICIENT_STOCK: 'Insufficient stock for one or more products',
};

export const ORDER_ROUTES = {
    MENU: '/menu/:branchId',
    TABLE_MENU: '/menu/:branchId/tables/:tableNumber',
    TABLE_SESSION: '/tables/:branchId/:tableNumber/session',
    PRODUCT_LIST: '/products',
    PRODUCT_DETAIL: '/products/:id',
    ORDER_LIST: '/orders',
    ORDER_DETAIL: '/orders/:id',
    ORDER_STATUS: '/orders/:id/status',
    MY_ORDER_LIST: '/my/orders',
    MY_ORDER_DETAIL: '/my/orders/:id',
    PUBLIC_ORDER_DETAIL: '/public/orders/:id',
    PUBLIC_RECEIPT: '/public/orders/:id/receipt',
    COUNTER_ORDER: '/counter/orders',
    TABLE_ORDER: '/tables/:branchId/:tableNumber/orders',
    DELIVERY_ORDER: '/delivery/orders',
    BILL_BY_ORDER: '/orders/:orderId/bill',
    BILL_DETAIL: '/bills/:id',
    BILL_STATUS: '/bills/:id/status',
    RECEIPT: '/orders/:id/receipt',
    RIDER_LIST: '/riders',
    RIDER_DETAIL: '/riders/:id',
    RIDER_BY_EMPLOYEE: '/employees/:employeeId/rider',
    DELIVERY_DETAIL: '/deliveries/:id',
    DELIVERY_BY_ORDER: '/orders/:orderId/delivery',
    DELIVERY_ASSIGN_RIDER: '/deliveries/:id/rider',
    DELIVERY_STATUS: '/deliveries/:id/status',
    DELIVERY_TRACKING: '/tracking/:trackingNumber'
};

export const ORDER_FIELDS = {
    BRANCH_ID: 'branchId',
    TABLE_NUMBER: 'tableNumber',
    ORDER_ID: 'orderId',
    ID: 'id',
    EMPLOYEE_ID: 'employeeId',
    TRACKING_NUMBER: 'trackingNumber'
};

export const ORDER_DEFAULTS = {
    DINE_IN_TYPE: 'DINE_IN',
    DELIVERY_TYPE: 'DELIVERY',
    PENDING_ORDER_STATUS: 'PENDING',
    ASSIGNED_DELIVERY_STATUS: 'ASSIGNED',
    CLOSED_TABLE_STATUSES: ['DELIVERED', 'CANCELLED']
} as const;
