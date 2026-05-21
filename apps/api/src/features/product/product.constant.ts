export const PRODUCT_MESSAGES = {
    PRODUCT_FETCHED: 'Product fetched successfully',
    PRODUCTS_FETCHED: 'Products fetched successfully',
    PRODUCT_CREATED: 'Product created successfully',
    PRODUCT_UPDATED: 'Product updated successfully',
    PRODUCT_DELETED: 'Product deleted successfully',
    NOT_FOUND: 'Product not found',
    BRANCH_ID_REQUIRED: 'branch_id is required',
    NAME_REQUIRED: 'Product name is required',
    PRICE_INVALID: 'Product price must be zero or greater',
    STOCK_INVALID: 'Product stock must be zero or greater',
    FORBIDDEN: 'You do not have permission to manage products for this branch'
};

export const PRODUCT_ROUTES = {
    LIST: '/',
    DETAIL: '/:id'
};

export const PRODUCT_FIELDS = {
    ID: 'id',
    BRANCH_ID: 'branch_id'
};

export const PRODUCT_DEFAULTS = {
    UNIT: 'pcs',
    LOW_STOCK_ALERT: 0,
    PREPARATION_TIME: 0,
    PRODUCT_READ_PERMISSION: 'product:read',
    PRODUCT_WRITE_PERMISSION: 'product:write',
    ORDER_WRITE_PERMISSION: 'order:write',
    ALL_PERMISSION: 'ALL'
} as const;
