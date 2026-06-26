import { Request, Response } from 'express';
import { asyncHandler } from '../../utils/async';
import { requireSingleValue, sendSuccess } from '../../utils/error';
import { User } from '../auth/user.type';
import { PRODUCT_FIELDS, PRODUCT_MESSAGES } from './product.constant';
import { ProductService } from './product.service';

export class ProductController {
    private productService: ProductService;

    constructor() {
        this.productService = new ProductService();
    }

    getList = asyncHandler(async (req: Request, res: Response) => {
        const user = (req as any).user as User;
        const branchId = requireSingleValue(req.query.branch_id ?? req.query.branchId, PRODUCT_FIELDS.BRANCH_ID);
        const search = typeof req.query.search === 'string' ? req.query.search : undefined;
        const category_id = typeof req.query.category_id === 'string' ? req.query.category_id : undefined;
        const available = req.query.available === undefined ? undefined : req.query.available === 'true';
        const result = await this.productService.getList(user, {
            branch_id: branchId,
            search,
            category_id,
            available
        });
        return sendSuccess(res, result, PRODUCT_MESSAGES.PRODUCTS_FETCHED);
    });

    getById = asyncHandler(async (req: Request, res: Response) => {
        const user = (req as any).user as User;
        const id = requireSingleValue(req.params.id, PRODUCT_FIELDS.ID);
        const result = await this.productService.getById(user, id);
        return sendSuccess(res, result, PRODUCT_MESSAGES.PRODUCT_FETCHED);
    });

    create = asyncHandler(async (req: Request, res: Response) => {
        const user = (req as any).user as User;
        const result = await this.productService.create(user, req.body);
        return sendSuccess(res, result, PRODUCT_MESSAGES.PRODUCT_CREATED);
    });

    update = asyncHandler(async (req: Request, res: Response) => {
        const user = (req as any).user as User;
        const id = requireSingleValue(req.params.id, PRODUCT_FIELDS.ID);
        const result = await this.productService.update(user, id, req.body);
        return sendSuccess(res, result, PRODUCT_MESSAGES.PRODUCT_UPDATED);
    });

    delete = asyncHandler(async (req: Request, res: Response) => {
        const user = (req as any).user as User;
        const id = requireSingleValue(req.params.id, PRODUCT_FIELDS.ID);
        const result = await this.productService.delete(user, id);
        return sendSuccess(res, result, PRODUCT_MESSAGES.PRODUCT_DELETED);
    });

    // ---- CATEGORIES ----
    getCategories = asyncHandler(async (req: Request, res: Response) => {
        const user = (req as any).user as User;
        const branchId = requireSingleValue(req.query.branch_id ?? req.query.branchId, PRODUCT_FIELDS.BRANCH_ID);
        const result = await this.productService.getCategoriesByBranch(user, branchId);
        return sendSuccess(res, result, PRODUCT_MESSAGES.CATEGORIES_FETCHED);
    });

    getCategoryById = asyncHandler(async (req: Request, res: Response) => {
        const user = (req as any).user as User;
        const id = requireSingleValue(req.params.id, PRODUCT_FIELDS.ID);
        const result = await this.productService.getCategoryById(user, id);
        return sendSuccess(res, result, PRODUCT_MESSAGES.CATEGORY_FETCHED);
    });

    createCategory = asyncHandler(async (req: Request, res: Response) => {
        const user = (req as any).user as User;
        const result = await this.productService.createCategory(user, req.body);
        return sendSuccess(res, result, PRODUCT_MESSAGES.CATEGORY_CREATED);
    });

    updateCategory = asyncHandler(async (req: Request, res: Response) => {
        const user = (req as any).user as User;
        const id = requireSingleValue(req.params.id, PRODUCT_FIELDS.ID);
        const result = await this.productService.updateCategory(user, id, req.body);
        return sendSuccess(res, result, PRODUCT_MESSAGES.CATEGORY_UPDATED);
    });

    deleteCategory = asyncHandler(async (req: Request, res: Response) => {
        const user = (req as any).user as User;
        const id = requireSingleValue(req.params.id, PRODUCT_FIELDS.ID);
        const result = await this.productService.deleteCategory(user, id);
        return sendSuccess(res, result, PRODUCT_MESSAGES.CATEGORY_DELETED);
    });

    // ---- SUB-CATEGORIES ----
    getSubCategories = asyncHandler(async (req: Request, res: Response) => {
        const user = (req as any).user as User;
        const categoryId = requireSingleValue(req.query.category_id ?? req.query.categoryId, PRODUCT_FIELDS.CATEGORY_ID);
        const result = await this.productService.getSubCategoriesByCategory(user, categoryId);
        return sendSuccess(res, result, PRODUCT_MESSAGES.SUB_CATEGORIES_FETCHED);
    });

    getSubCategoryById = asyncHandler(async (req: Request, res: Response) => {
        const user = (req as any).user as User;
        const id = requireSingleValue(req.params.id, PRODUCT_FIELDS.ID);
        const result = await this.productService.getSubCategoryById(user, id);
        return sendSuccess(res, result, PRODUCT_MESSAGES.SUB_CATEGORY_FETCHED);
    });

    createSubCategory = asyncHandler(async (req: Request, res: Response) => {
        const user = (req as any).user as User;
        const result = await this.productService.createSubCategory(user, req.body);
        return sendSuccess(res, result, PRODUCT_MESSAGES.SUB_CATEGORY_CREATED);
    });

    updateSubCategory = asyncHandler(async (req: Request, res: Response) => {
        const user = (req as any).user as User;
        const id = requireSingleValue(req.params.id, PRODUCT_FIELDS.ID);
        const result = await this.productService.updateSubCategory(user, id, req.body);
        return sendSuccess(res, result, PRODUCT_MESSAGES.SUB_CATEGORY_UPDATED);
    });

    deleteSubCategory = asyncHandler(async (req: Request, res: Response) => {
        const user = (req as any).user as User;
        const id = requireSingleValue(req.params.id, PRODUCT_FIELDS.ID);
        const result = await this.productService.deleteSubCategory(user, id);
        return sendSuccess(res, result, PRODUCT_MESSAGES.SUB_CATEGORY_DELETED);
    });

    // ---- SUB-PRODUCTS ----
    getSubProducts = asyncHandler(async (req: Request, res: Response) => {
        const user = (req as any).user as User;
        const branchId = requireSingleValue(req.query.branch_id ?? req.query.branchId, PRODUCT_FIELDS.BRANCH_ID);
        const result = await this.productService.getSubProductsByBranch(user, branchId);
        return sendSuccess(res, result, PRODUCT_MESSAGES.SUB_PRODUCTS_FETCHED);
    });

    getSubProductById = asyncHandler(async (req: Request, res: Response) => {
        const user = (req as any).user as User;
        const id = requireSingleValue(req.params.id, PRODUCT_FIELDS.ID);
        const result = await this.productService.getSubProductById(user, id);
        return sendSuccess(res, result, PRODUCT_MESSAGES.SUB_PRODUCT_FETCHED);
    });

    createSubProduct = asyncHandler(async (req: Request, res: Response) => {
        const user = (req as any).user as User;
        const result = await this.productService.createSubProduct(user, req.body);
        return sendSuccess(res, result, PRODUCT_MESSAGES.SUB_PRODUCT_CREATED);
    });

    updateSubProduct = asyncHandler(async (req: Request, res: Response) => {
        const user = (req as any).user as User;
        const id = requireSingleValue(req.params.id, PRODUCT_FIELDS.ID);
        const result = await this.productService.updateSubProduct(user, id, req.body);
        return sendSuccess(res, result, PRODUCT_MESSAGES.SUB_PRODUCT_UPDATED);
    });

    deleteSubProduct = asyncHandler(async (req: Request, res: Response) => {
        const user = (req as any).user as User;
        const id = requireSingleValue(req.params.id, PRODUCT_FIELDS.ID);
        const result = await this.productService.deleteSubProduct(user, id);
        return sendSuccess(res, result, PRODUCT_MESSAGES.SUB_PRODUCT_DELETED);
    });
}
