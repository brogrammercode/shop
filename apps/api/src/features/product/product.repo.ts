import prisma from '../../infra/database/client';
import { Product, ProductInput, ProductQuery, ProductUpdateInput } from './product.type';

export class ProductRepo {
    async findById(id: string): Promise<Product | null> {
        return prisma.product.findUnique({ where: { id } }) as any;
    }

    async findByQuery(query: ProductQuery): Promise<Product[]> {
        return prisma.product.findMany({
            where: {
                branch_id: query.branch_id,
                category: query.category,
                is_available: query.available,
                OR: query.search
                    ? [
                        { name: { contains: query.search, mode: 'insensitive' } },
                        { category: { contains: query.search, mode: 'insensitive' } },
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
}
