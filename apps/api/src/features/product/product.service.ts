import prisma from '../../infra/database/client';
import { BadRequestError, ForbiddenError, NotFoundError } from '../../utils/error';
import { User } from '../auth/user.type';
import { PRODUCT_DEFAULTS, PRODUCT_MESSAGES } from './product.constant';
import { ProductRepo } from './product.repo';
import { Product, ProductInput, ProductQuery, ProductUpdateInput, ProductCategory, ProductCategoryInput, ProductCategoryUpdateInput, ProductSubCategory, ProductSubCategoryInput, ProductSubCategoryUpdateInput, SubProduct, SubProductInput, SubProductUpdateInput } from './product.type';

export class ProductService {
    private productRepo: ProductRepo;

    constructor() {
        this.productRepo = new ProductRepo();
    }

    async getList(user: User, query: ProductQuery): Promise<Product[]> {
        await this.ensureBranchAccess(user.id, query.branch_id, [
            PRODUCT_DEFAULTS.PRODUCT_READ_PERMISSION,
            PRODUCT_DEFAULTS.PRODUCT_WRITE_PERMISSION,
            PRODUCT_DEFAULTS.ORDER_WRITE_PERMISSION
        ]);
        return this.productRepo.findByQuery(query);
    }

    async getById(user: User, id: string): Promise<Product> {
        const product = await this.productRepo.findById(id);
        if (!product) {
            throw new NotFoundError(PRODUCT_MESSAGES.NOT_FOUND);
        }

        await this.ensureBranchAccess(user.id, product.branch_id, [
            PRODUCT_DEFAULTS.PRODUCT_READ_PERMISSION,
            PRODUCT_DEFAULTS.PRODUCT_WRITE_PERMISSION,
            PRODUCT_DEFAULTS.ORDER_WRITE_PERMISSION
        ]);

        return product;
    }

    async create(user: User, data: ProductInput): Promise<Product> {
        this.validateProduct(data);
        await this.ensureBranchAccess(user.id, data.branch_id, [
            PRODUCT_DEFAULTS.PRODUCT_WRITE_PERMISSION
        ]);

        return this.productRepo.create({
            ...data,
            unit: data.unit || PRODUCT_DEFAULTS.UNIT,
            low_stock_alert: data.low_stock_alert ?? PRODUCT_DEFAULTS.LOW_STOCK_ALERT,
            images: data.images ?? [],
            is_veg: data.is_veg ?? false,
            preparation_time: data.preparation_time ?? PRODUCT_DEFAULTS.PREPARATION_TIME,
            variants: data.variants ?? [],
            is_available: data.is_available ?? true
        });
    }

    async update(user: User, id: string, data: ProductUpdateInput): Promise<Product> {
        const product = await this.getById(user, id);
        await this.ensureBranchAccess(user.id, product.branch_id, [
            PRODUCT_DEFAULTS.PRODUCT_WRITE_PERMISSION
        ]);
        this.validateProductUpdate(data);
        return this.productRepo.update(id, data);
    }

    async delete(user: User, id: string): Promise<Product> {
        const product = await this.getById(user, id);
        await this.ensureBranchAccess(user.id, product.branch_id, [
            PRODUCT_DEFAULTS.PRODUCT_WRITE_PERMISSION
        ]);
        return this.productRepo.delete(id);
    }

    // ---- PRODUCT CATEGORIES ----
    async getCategoriesByBranch(user: User, branch_id: string): Promise<ProductCategory[]> {
        await this.ensureBranchAccess(user.id, branch_id, [
            PRODUCT_DEFAULTS.PRODUCT_READ_PERMISSION,
            PRODUCT_DEFAULTS.PRODUCT_WRITE_PERMISSION
        ]);
        return this.productRepo.findCategoriesByBranch(branch_id);
    }

    async getCategoryById(user: User, id: string): Promise<ProductCategory> {
        const category = await this.productRepo.findCategoryById(id);
        if (!category) {
            throw new NotFoundError(PRODUCT_MESSAGES.CATEGORY_NOT_FOUND);
        }
        await this.ensureBranchAccess(user.id, category.branch_id, [
            PRODUCT_DEFAULTS.PRODUCT_READ_PERMISSION,
            PRODUCT_DEFAULTS.PRODUCT_WRITE_PERMISSION
        ]);
        return category;
    }

    async createCategory(user: User, data: ProductCategoryInput): Promise<ProductCategory> {
        if (!data.branch_id) throw new BadRequestError(PRODUCT_MESSAGES.BRANCH_ID_REQUIRED);
        if (!data.name?.trim()) throw new BadRequestError(PRODUCT_MESSAGES.NAME_REQUIRED);
        
        await this.ensureBranchAccess(user.id, data.branch_id, [
            PRODUCT_DEFAULTS.PRODUCT_WRITE_PERMISSION
        ]);

        return this.productRepo.createCategory({
            ...data,
            images: data.images ?? [],
            videos: data.videos ?? []
        });
    }

    async updateCategory(user: User, id: string, data: ProductCategoryUpdateInput): Promise<ProductCategory> {
        const category = await this.getCategoryById(user, id);
        await this.ensureBranchAccess(user.id, category.branch_id, [
            PRODUCT_DEFAULTS.PRODUCT_WRITE_PERMISSION
        ]);
        return this.productRepo.updateCategory(id, data);
    }

    async deleteCategory(user: User, id: string): Promise<ProductCategory> {
        const category = await this.getCategoryById(user, id);
        await this.ensureBranchAccess(user.id, category.branch_id, [
            PRODUCT_DEFAULTS.PRODUCT_WRITE_PERMISSION
        ]);
        return this.productRepo.deleteCategory(id);
    }

    // ---- PRODUCT SUB-CATEGORIES ----
    async getSubCategoriesByCategory(user: User, category_id: string): Promise<ProductSubCategory[]> {
        const category = await this.getCategoryById(user, category_id);
        return this.productRepo.findSubCategoriesByCategory(category_id);
    }

    async getSubCategoryById(user: User, id: string): Promise<ProductSubCategory> {
        const subCategory = await this.productRepo.findSubCategoryById(id);
        if (!subCategory) {
            throw new NotFoundError(PRODUCT_MESSAGES.SUB_CATEGORY_NOT_FOUND);
        }
        await this.getCategoryById(user, subCategory.category_id); // ensure access
        return subCategory;
    }

    async createSubCategory(user: User, data: ProductSubCategoryInput): Promise<ProductSubCategory> {
        if (!data.category_id) throw new BadRequestError(PRODUCT_MESSAGES.CATEGORY_ID_REQUIRED);
        if (!data.name?.trim()) throw new BadRequestError(PRODUCT_MESSAGES.NAME_REQUIRED);
        
        await this.getCategoryById(user, data.category_id); // ensure access

        return this.productRepo.createSubCategory({
            ...data,
            images: data.images ?? [],
            videos: data.videos ?? []
        });
    }

    async updateSubCategory(user: User, id: string, data: ProductSubCategoryUpdateInput): Promise<ProductSubCategory> {
        const subCategory = await this.getSubCategoryById(user, id);
        return this.productRepo.updateSubCategory(id, data);
    }

    async deleteSubCategory(user: User, id: string): Promise<ProductSubCategory> {
        const subCategory = await this.getSubCategoryById(user, id);
        return this.productRepo.deleteSubCategory(id);
    }

    // ---- SUB-PRODUCTS ----
    async getSubProductsByBranch(user: User, branch_id: string): Promise<SubProduct[]> {
        await this.ensureBranchAccess(user.id, branch_id, [
            PRODUCT_DEFAULTS.PRODUCT_READ_PERMISSION,
            PRODUCT_DEFAULTS.PRODUCT_WRITE_PERMISSION
        ]);
        return this.productRepo.findSubProductsByBranch(branch_id);
    }

    async getSubProductById(user: User, id: string): Promise<SubProduct> {
        const subProduct = await this.productRepo.findSubProductById(id);
        if (!subProduct) {
            throw new NotFoundError(PRODUCT_MESSAGES.SUB_PRODUCT_NOT_FOUND);
        }
        await this.ensureBranchAccess(user.id, subProduct.branch_id, [
            PRODUCT_DEFAULTS.PRODUCT_READ_PERMISSION,
            PRODUCT_DEFAULTS.PRODUCT_WRITE_PERMISSION
        ]);
        return subProduct;
    }

    async createSubProduct(user: User, data: SubProductInput): Promise<SubProduct> {
        if (!data.branch_id) throw new BadRequestError(PRODUCT_MESSAGES.BRANCH_ID_REQUIRED);
        if (!data.name?.trim()) throw new BadRequestError(PRODUCT_MESSAGES.NAME_REQUIRED);

        await this.ensureBranchAccess(user.id, data.branch_id, [
            PRODUCT_DEFAULTS.PRODUCT_WRITE_PERMISSION
        ]);

        return this.productRepo.createSubProduct({
            ...data,
            unit: data.unit || PRODUCT_DEFAULTS.UNIT,
            low_stock_alert: data.low_stock_alert ?? PRODUCT_DEFAULTS.LOW_STOCK_ALERT,
            images: data.images ?? [],
            is_veg: data.is_veg ?? false,
            preparation_time: data.preparation_time ?? PRODUCT_DEFAULTS.PREPARATION_TIME,
            variants: data.variants ?? [],
            is_available: data.is_available ?? true
        });
    }

    async updateSubProduct(user: User, id: string, data: SubProductUpdateInput): Promise<SubProduct> {
        const subProduct = await this.getSubProductById(user, id);
        await this.ensureBranchAccess(user.id, subProduct.branch_id, [
            PRODUCT_DEFAULTS.PRODUCT_WRITE_PERMISSION
        ]);
        return this.productRepo.updateSubProduct(id, data);
    }

    async deleteSubProduct(user: User, id: string): Promise<SubProduct> {
        const subProduct = await this.getSubProductById(user, id);
        await this.ensureBranchAccess(user.id, subProduct.branch_id, [
            PRODUCT_DEFAULTS.PRODUCT_WRITE_PERMISSION
        ]);
        return this.productRepo.deleteSubProduct(id);
    }

    private validateProduct(data: ProductInput): void {
        if (!data.branch_id) {
            throw new BadRequestError(PRODUCT_MESSAGES.BRANCH_ID_REQUIRED);
        }

        if (!data.name?.trim()) {
            throw new BadRequestError(PRODUCT_MESSAGES.NAME_REQUIRED);
        }

        this.validateProductUpdate(data);
    }

    private validateProductUpdate(data: ProductUpdateInput): void {
        if (data.price !== undefined && data.price < 0) {
            throw new BadRequestError(PRODUCT_MESSAGES.PRICE_INVALID);
        }

        if (data.stock !== undefined && data.stock < 0) {
            throw new BadRequestError(PRODUCT_MESSAGES.STOCK_INVALID);
        }
    }

    private async ensureBranchAccess(userId: string, branchId: string, requiredPermissions: readonly string[]): Promise<void> {
        const employee = await prisma.employee.findUnique({
            where: { uid: userId },
            include: { role: true }
        });

        if (!employee || employee.branch_id !== branchId) {
            throw new ForbiddenError(PRODUCT_MESSAGES.FORBIDDEN);
        }

        const permissions = employee.role.permissions as string[];
        const hasPermission = permissions.includes(PRODUCT_DEFAULTS.ALL_PERMISSION) || requiredPermissions.some((permission) => permissions.includes(permission));
        if (!hasPermission) {
            throw new ForbiddenError(PRODUCT_MESSAGES.FORBIDDEN);
        }
    }
}
