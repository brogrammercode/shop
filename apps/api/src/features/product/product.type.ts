type ProductVariant = {
    readonly name: string;
    readonly price: number;
}

type Product = {
    readonly id: string;
    readonly branch_id: string;
    readonly sku?: string;
    readonly barcode?: string;
    readonly name: string;
    readonly description?: string;
    readonly price: number;
    readonly stock: number;
    readonly category?: string;
    readonly unit: string;
    readonly low_stock_alert: number;
    readonly images: readonly string[];
    readonly is_veg: boolean;
    readonly preparation_time: number;
    readonly variants: readonly ProductVariant[];
    readonly is_available: boolean;
    readonly created_at: Date;
    readonly updated_at: Date;
}

type ProductInput = Omit<Product, 'id' | 'created_at' | 'updated_at'>;

type ProductUpdateInput = Partial<Omit<Product, 'id' | 'branch_id' | 'created_at' | 'updated_at'>>;

type ProductQuery = {
    readonly branch_id: string;
    readonly search?: string;
    readonly category?: string;
    readonly available?: boolean;
}

export {
    Product,
    ProductInput,
    ProductQuery,
    ProductUpdateInput,
    ProductVariant
};
