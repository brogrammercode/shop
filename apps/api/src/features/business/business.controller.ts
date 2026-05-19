import { Request, Response } from 'express';
import { BusinessService } from './business.service';
import { sendSuccess, NotFoundError, requireSingleValue } from '../../utils/error';
import { asyncHandler } from '../../utils/async';
import { BUSINESS_MESSAGES } from './business.constant';
import { User } from '../auth/user.type';

export class BusinessController {
    private businessService: BusinessService;

    constructor() {
        this.businessService = new BusinessService();
    }

    initialize = asyncHandler(async (req: Request, res: Response) => {
        const user = (req as any).user as User;
        const { business, branch } = req.body;
        
        const result = await this.businessService.initializeBusiness(user, business, branch);
        return sendSuccess(res, result, BUSINESS_MESSAGES.INITIALIZE_SUCCESS);
    });

    search = asyncHandler(async (req: Request, res: Response) => {
        const q = req.query.q as string;
        const result = await this.businessService.searchBusinesses(q || '');
        return sendSuccess(res, result);
    });

    requestJoin = asyncHandler(async (req: Request, res: Response) => {
        const user = (req as any).user as User;
        const { branch_id, branchId, requested_role_id, requestedRoleId } = req.body;
        const branchValue = requireSingleValue(branch_id || branchId, 'branch_id');
        const result = await this.businessService.createJoinRequest(
            user,
            branchValue,
            requested_role_id || requestedRoleId,
        );
        return sendSuccess(res, result, BUSINESS_MESSAGES.JOIN_REQUEST_CREATED);
    });

    getMyJoinRequests = asyncHandler(async (req: Request, res: Response) => {
        const user = (req as any).user as User;
        const result = await this.businessService.getMyJoinRequests(user.id);
        return sendSuccess(res, result, BUSINESS_MESSAGES.JOIN_REQUESTS_FETCHED);
    });

    getJoinRequests = asyncHandler(async (req: Request, res: Response) => {
        const user = (req as any).user as User;
        const branchId = requireSingleValue(req.query.branchId || req.query.branch_id, 'branch_id');
        const result = await this.businessService.getJoinRequestsForBranch(user, branchId);
        return sendSuccess(res, result, BUSINESS_MESSAGES.JOIN_REQUESTS_FETCHED);
    });

    approveJoinRequest = asyncHandler(async (req: Request, res: Response) => {
        const user = (req as any).user as User;
        const id = req.params.id as string;
        const { role_id, roleId } = req.body;
        const result = await this.businessService.approveJoinRequest(user, id, role_id || roleId);
        return sendSuccess(res, result, BUSINESS_MESSAGES.JOIN_REQUEST_APPROVED);
    });

    rejectJoinRequest = asyncHandler(async (req: Request, res: Response) => {
        const user = (req as any).user as User;
        const id = req.params.id as string;
        const result = await this.businessService.rejectJoinRequest(user, id);
        return sendSuccess(res, result, BUSINESS_MESSAGES.JOIN_REQUEST_REJECTED);
    });

    getContext = asyncHandler(async (req: Request, res: Response) => {
        const user = (req as any).user as User;
        const result = await this.businessService.getUserContext(user.id);

        if (!result) {
            throw new NotFoundError(BUSINESS_MESSAGES.NOT_FOUND);
        }

        return sendSuccess(res, result, BUSINESS_MESSAGES.CONTEXT_FETCHED);
    });

    getBranch = asyncHandler(async (req: Request, res: Response) => {
        const id = req.params.id as string;
        const result = await this.businessService.getBranchById(id);
        return sendSuccess(res, result);
    });

    getBranches = asyncHandler(async (req: Request, res: Response) => {
        const businessId = requireSingleValue(req.query.business_id || req.query.businessId, 'business_id');
        const result = await this.businessService.getBranchesByBusinessId(businessId);
        return sendSuccess(res, result);
    });

    createBranch = asyncHandler(async (req: Request, res: Response) => {
        const result = await this.businessService.createBranch(req.body);
        return sendSuccess(res, result, BUSINESS_MESSAGES.BRANCH_CREATED);
    });

    updateBranch = asyncHandler(async (req: Request, res: Response) => {
        const id = req.params.id as string;
        const result = await this.businessService.updateBranch(id, req.body);
        return sendSuccess(res, result, BUSINESS_MESSAGES.BRANCH_UPDATED);
    });

    deleteBranch = asyncHandler(async (req: Request, res: Response) => {
        const id = req.params.id as string;
        const result = await this.businessService.deleteBranch(id);
        return sendSuccess(res, result, BUSINESS_MESSAGES.BRANCH_DELETED);
    });

    getDepartment = asyncHandler(async (req: Request, res: Response) => {
        const id = req.params.id as string;
        const result = await this.businessService.getDepartmentById(id);
        return sendSuccess(res, result);
    });

    getDepartments = asyncHandler(async (req: Request, res: Response) => {
        const branchId = req.query.branchId as string;
        const result = await this.businessService.getDepartmentsByBranchId(branchId);
        return sendSuccess(res, result);
    });

    createDepartment = asyncHandler(async (req: Request, res: Response) => {
        const result = await this.businessService.createDepartment(req.body);
        return sendSuccess(res, result, BUSINESS_MESSAGES.DEPARTMENT_CREATED);
    });

    updateDepartment = asyncHandler(async (req: Request, res: Response) => {
        const id = req.params.id as string;
        const result = await this.businessService.updateDepartment(id, req.body);
        return sendSuccess(res, result, BUSINESS_MESSAGES.DEPARTMENT_UPDATED);
    });

    deleteDepartment = asyncHandler(async (req: Request, res: Response) => {
        const id = req.params.id as string;
        const result = await this.businessService.deleteDepartment(id);
        return sendSuccess(res, result, BUSINESS_MESSAGES.DEPARTMENT_DELETED);
    });

    getPost = asyncHandler(async (req: Request, res: Response) => {
        const id = req.params.id as string;
        const result = await this.businessService.getPostById(id);
        return sendSuccess(res, result);
    });

    getPosts = asyncHandler(async (req: Request, res: Response) => {
        const departmentId = req.query.departmentId as string;
        const result = await this.businessService.getPostsByDepartmentId(departmentId);
        return sendSuccess(res, result);
    });

    createPost = asyncHandler(async (req: Request, res: Response) => {
        const result = await this.businessService.createPost(req.body);
        return sendSuccess(res, result, BUSINESS_MESSAGES.POST_CREATED);
    });

    updatePost = asyncHandler(async (req: Request, res: Response) => {
        const id = req.params.id as string;
        const result = await this.businessService.updatePost(id, req.body);
        return sendSuccess(res, result, BUSINESS_MESSAGES.POST_UPDATED);
    });

    deletePost = asyncHandler(async (req: Request, res: Response) => {
        const id = req.params.id as string;
        const result = await this.businessService.deletePost(id);
        return sendSuccess(res, result, BUSINESS_MESSAGES.POST_DELETED);
    });

    getShift = asyncHandler(async (req: Request, res: Response) => {
        const id = req.params.id as string;
        const result = await this.businessService.getShiftById(id);
        return sendSuccess(res, result);
    });

    getShifts = asyncHandler(async (req: Request, res: Response) => {
        const branchId = req.query.branchId as string;
        const result = await this.businessService.getShiftsByBranchId(branchId);
        return sendSuccess(res, result);
    });

    createShift = asyncHandler(async (req: Request, res: Response) => {
        const result = await this.businessService.createShift(req.body);
        return sendSuccess(res, result, BUSINESS_MESSAGES.SHIFT_CREATED);
    });

    updateShift = asyncHandler(async (req: Request, res: Response) => {
        const id = req.params.id as string;
        const result = await this.businessService.updateShift(id, req.body);
        return sendSuccess(res, result, BUSINESS_MESSAGES.SHIFT_UPDATED);
    });

    deleteShift = asyncHandler(async (req: Request, res: Response) => {
        const id = req.params.id as string;
        const result = await this.businessService.deleteShift(id);
        return sendSuccess(res, result, BUSINESS_MESSAGES.SHIFT_DELETED);
    });

    getRole = asyncHandler(async (req: Request, res: Response) => {
        const id = req.params.id as string;
        const result = await this.businessService.getRoleById(id);
        return sendSuccess(res, result);
    });

    getRoles = asyncHandler(async (req: Request, res: Response) => {
        const branchId = req.query.branchId as string;
        const result = await this.businessService.getRolesByBranchId(branchId);
        return sendSuccess(res, result);
    });

    createRole = asyncHandler(async (req: Request, res: Response) => {
        const result = await this.businessService.createRole(req.body);
        return sendSuccess(res, result, BUSINESS_MESSAGES.ROLE_CREATED);
    });

    updateRole = asyncHandler(async (req: Request, res: Response) => {
        const id = req.params.id as string;
        const result = await this.businessService.updateRole(id, req.body);
        return sendSuccess(res, result, BUSINESS_MESSAGES.ROLE_UPDATED);
    });

    deleteRole = asyncHandler(async (req: Request, res: Response) => {
        const id = req.params.id as string;
        const result = await this.businessService.deleteRole(id);
        return sendSuccess(res, result, BUSINESS_MESSAGES.ROLE_DELETED);
    });

    getEmployee = asyncHandler(async (req: Request, res: Response) => {
        const id = req.params.id as string;
        const result = await this.businessService.getEmployeeById(id);
        return sendSuccess(res, result);
    });

    getEmployees = asyncHandler(async (req: Request, res: Response) => {
        const branchId = req.query.branchId as string;
        const result = await this.businessService.getEmployeesByBranchId(branchId);
        return sendSuccess(res, result);
    });

    createEmployee = asyncHandler(async (req: Request, res: Response) => {
        const result = await this.businessService.createEmployee(req.body);
        return sendSuccess(res, result, BUSINESS_MESSAGES.EMPLOYEE_CREATED);
    });

    updateEmployee = asyncHandler(async (req: Request, res: Response) => {
        const id = req.params.id as string;
        const result = await this.businessService.updateEmployee(id, req.body);
        return sendSuccess(res, result, BUSINESS_MESSAGES.EMPLOYEE_UPDATED);
    });

    deleteEmployee = asyncHandler(async (req: Request, res: Response) => {
        const id = req.params.id as string;
        const result = await this.businessService.deleteEmployee(id);
        return sendSuccess(res, result, BUSINESS_MESSAGES.EMPLOYEE_DELETED);
    });
}
