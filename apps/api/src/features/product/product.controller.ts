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
        const category = typeof req.query.category === 'string' ? req.query.category : undefined;
        const available = req.query.available === undefined ? undefined : req.query.available === 'true';
        const result = await this.productService.getList(user, {
            branch_id: branchId,
            search,
            category,
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
}
