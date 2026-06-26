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
    FORBIDDEN: 'You do not have permission to manage products for this branch',
    
    CATEGORY_FETCHED: 'Category fetched successfully',
    CATEGORIES_FETCHED: 'Categories fetched successfully',
    CATEGORY_CREATED: 'Category created successfully',
    CATEGORY_UPDATED: 'Category updated successfully',
    CATEGORY_DELETED: 'Category deleted successfully',
    CATEGORY_NOT_FOUND: 'Category not found',
    
    SUB_CATEGORY_FETCHED: 'Sub-category fetched successfully',
    SUB_CATEGORIES_FETCHED: 'Sub-categories fetched successfully',
    SUB_CATEGORY_CREATED: 'Sub-category created successfully',
    SUB_CATEGORY_UPDATED: 'Sub-category updated successfully',
    SUB_CATEGORY_DELETED: 'Sub-category deleted successfully',
    SUB_CATEGORY_NOT_FOUND: 'Sub-category not found',
    CATEGORY_ID_REQUIRED: 'category_id is required',
    
    SUB_PRODUCT_FETCHED: 'Sub-product fetched successfully',
    SUB_PRODUCTS_FETCHED: 'Sub-products fetched successfully',
    SUB_PRODUCT_CREATED: 'Sub-product created successfully',
    SUB_PRODUCT_UPDATED: 'Sub-product updated successfully',
    SUB_PRODUCT_DELETED: 'Sub-product deleted successfully',
    SUB_PRODUCT_NOT_FOUND: 'Sub-product not found',
};

export const PRODUCT_ROUTES = {
    LIST: '/',
    DETAIL: '/:id',
    CATEGORIES: '/categories',
    CATEGORY_DETAIL: '/categories/:id',
    SUB_CATEGORIES: '/sub-categories',
    SUB_CATEGORY_DETAIL: '/sub-categories/:id',
    SUB_PRODUCTS: '/sub-products',
    SUB_PRODUCT_DETAIL: '/sub-products/:id'
};

export const PRODUCT_FIELDS = {
    ID: 'id',
    BRANCH_ID: 'branch_id',
    CATEGORY_ID: 'category_id'
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
