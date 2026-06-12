import prisma from '../../infra/database/client';
import { Product, ProductInput, ProductQuery, ProductUpdateInput, ProductCategory, ProductCategoryInput, ProductCategoryUpdateInput, ProductSubCategory, ProductSubCategoryInput, ProductSubCategoryUpdateInput } from './product.type';

export class ProductRepo {
    // ---- PRODUCTS ----
    async findById(id: string): Promise<Product | null> {
        return prisma.product.findUnique({ where: { id } }) as any;
    }

    async findByQuery(query: ProductQuery): Promise<Product[]> {
        return prisma.product.findMany({
            where: {
                branch_id: query.branch_id,
                category_id: query.category_id,
                sub_category_id: query.sub_category_id,
                is_available: query.available,
                OR: query.search
                    ? [
                        { name: { contains: query.search, mode: 'insensitive' } },
                        { sku: { contains: query.search, mode: 'insensitive' } },
                        { barcode: { contains: query.search, mode: 'insensitive' } }
                    ]
                    : undefined
            },
            orderBy: { name: 'asc' }
        }) as any;
    }

    async create(data: ProductInput): Promise<Product> {
        return prisma.product.create({ data: data as any }) as any;
    }

    async update(id: string, data: ProductUpdateInput): Promise<Product> {
        return prisma.product.update({ where: { id }, data: data as any }) as any;
    }

    async delete(id: string): Promise<Product> {
        return prisma.product.delete({ where: { id } }) as any;
    }

    // ---- PRODUCT CATEGORIES ----
    async findCategoryById(id: string): Promise<ProductCategory | null> {
        return prisma.productCategory.findUnique({ where: { id } }) as any;
    }

    async findCategoriesByBranch(branch_id: string): Promise<ProductCategory[]> {
        return prisma.productCategory.findMany({
            where: { branch_id },
            orderBy: { name: 'asc' }
        }) as any;
    }

    async createCategory(data: ProductCategoryInput): Promise<ProductCategory> {
        return prisma.productCategory.create({ data: data as any }) as any;
    }

    async updateCategory(id: string, data: ProductCategoryUpdateInput): Promise<ProductCategory> {
        return prisma.productCategory.update({ where: { id }, data: data as any }) as any;
    }

    async deleteCategory(id: string): Promise<ProductCategory> {
        return prisma.productCategory.delete({ where: { id } }) as any;
    }

    // ---- PRODUCT SUB-CATEGORIES ----
    async findSubCategoryById(id: string): Promise<ProductSubCategory | null> {
        return prisma.productSubCategory.findUnique({ where: { id } }) as any;
    }

    async findSubCategoriesByCategory(category_id: string): Promise<ProductSubCategory[]> {
        return prisma.productSubCategory.findMany({
            where: { category_id },
            orderBy: { name: 'asc' }
        }) as any;
    }

    async createSubCategory(data: ProductSubCategoryInput): Promise<ProductSubCategory> {
        return prisma.productSubCategory.create({ data: data as any }) as any;
    }

    async updateSubCategory(id: string, data: ProductSubCategoryUpdateInput): Promise<ProductSubCategory> {
        return prisma.productSubCategory.update({ where: { id }, data: data as any }) as any;
    }

    async deleteSubCategory(id: string): Promise<ProductSubCategory> {
        return prisma.productSubCategory.delete({ where: { id } }) as any;
    }
}
