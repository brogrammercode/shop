type ProductVariant = {
    readonly name: string;
    readonly price: number;
}

type ProductCategory = {
    readonly id: string;
    readonly branch_id: string;
    readonly name: string;
    readonly description?: string;
    readonly images: readonly string[];
    readonly videos: readonly string[];
    readonly created_at: Date;
    readonly updated_at: Date;
}

type ProductCategoryInput = Omit<ProductCategory, 'id' | 'created_at' | 'updated_at'>;
type ProductCategoryUpdateInput = Partial<Omit<ProductCategory, 'id' | 'branch_id' | 'created_at' | 'updated_at'>>;

type ProductSubCategory = {
    readonly id: string;
    readonly category_id: string;
    readonly name: string;
    readonly description?: string;
    readonly images: readonly string[];
    readonly videos: readonly string[];
    readonly created_at: Date;
    readonly updated_at: Date;
}

type ProductSubCategoryInput = Omit<ProductSubCategory, 'id' | 'created_at' | 'updated_at'>;
type ProductSubCategoryUpdateInput = Partial<Omit<ProductSubCategory, 'id' | 'category_id' | 'created_at' | 'updated_at'>>;

type SubProduct = {
    readonly id: string;
    readonly branch_id: string;
    readonly sku?: string;
    readonly barcode?: string;
    readonly name: string;
    readonly description?: string;
    readonly price: number;
    readonly stock: number;
    readonly category_id?: string;
    readonly sub_category_id?: string;
    readonly unit: string;
    readonly low_stock_alert: number;
    readonly images: readonly string[];
    readonly videos: readonly string[];
    readonly is_veg: boolean;
    readonly preparation_time: number;
    readonly variants: readonly ProductVariant[];
    readonly is_available: boolean;
    readonly created_at: Date;
    readonly updated_at: Date;
}

type SubProductInput = Omit<SubProduct, 'id' | 'created_at' | 'updated_at'>;
type SubProductUpdateInput = Partial<Omit<SubProduct, 'id' | 'branch_id' | 'created_at' | 'updated_at'>>;

type Product = {
    readonly id: string;
    readonly branch_id: string;
    readonly sku?: string;
    readonly barcode?: string;
    readonly name: string;
    readonly description?: string;
    readonly price: number;
    readonly stock: number;
    readonly category_id?: string;
    readonly sub_category_id?: string;
    readonly unit: string;
    readonly low_stock_alert: number;
    readonly images: readonly string[];
    readonly videos: readonly string[];
    readonly is_veg: boolean;
    readonly preparation_time: number;
    readonly variants: readonly ProductVariant[];
    readonly is_available: boolean;
    readonly supported_sub_products?: readonly SubProduct[];
    readonly created_at: Date;
    readonly updated_at: Date;
}

type ProductInput = Omit<Product, 'id' | 'created_at' | 'updated_at' | 'supported_sub_products'> & {
    readonly supported_sub_products?: readonly string[]; // array of IDs to link
};

type ProductUpdateInput = Partial<Omit<Product, 'id' | 'branch_id' | 'created_at' | 'updated_at' | 'supported_sub_products'>> & {
    readonly supported_sub_products?: readonly string[];
};

type ProductQuery = {
    readonly branch_id: string;
    readonly search?: string;
    readonly category_id?: string;
    readonly sub_category_id?: string;
    readonly available?: boolean;
}

export {
    Product,
    ProductInput,
    ProductQuery,
    ProductUpdateInput,
    ProductVariant,
    ProductCategory,
    ProductCategoryInput,
    ProductCategoryUpdateInput,
    ProductSubCategory,
    ProductSubCategoryInput,
    ProductSubCategoryUpdateInput,
    SubProduct,
    SubProductInput,
    SubProductUpdateInput
};
