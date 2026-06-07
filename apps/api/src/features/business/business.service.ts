import { BusinessRepo } from './business.repo';
import { Branch, Department, Post, Shift, Role, Employee, BusinessJoinRequest } from './business.type';
import { User } from '../auth/user.type';
import prisma from '../../infra/database/client';
import { BUSINESS_DEFAULTS, BUSINESS_MESSAGES } from './business.constant';
import { BadRequestError, ConflictError, ForbiddenError, NotFoundError } from '../../utils/error';

export class BusinessService {
    private businessRepo: BusinessRepo;

    constructor() {
        this.businessRepo = new BusinessRepo();
    }

    async getBranchById(id: string): Promise<Branch | null> {
        return this.businessRepo.findBranchById(id);
    }

    async getAllBranches(): Promise<Branch[]> {
        return this.businessRepo.findAllBranches();
    }

    async createBranch(data: Omit<Branch, 'id' | 'created_at' | 'updated_at'>): Promise<Branch> {
        return this.businessRepo.createBranch(data);
    }

    async updateBranch(id: string, data: Partial<Omit<Branch, 'id' | 'created_at' | 'updated_at'>>): Promise<Branch> {
        return this.businessRepo.updateBranch(id, data);
    }

    async deleteBranch(id: string): Promise<Branch> {
        return this.businessRepo.deleteBranch(id);
    }

    async getDepartmentById(id: string): Promise<Department | null> {
        return this.businessRepo.findDepartmentById(id);
    }

    async getDepartmentsByBranchId(branchId: string): Promise<Department[]> {
        return this.businessRepo.findDepartmentsByBranchId(branchId);
    }

    async createDepartment(data: Omit<Department, 'id' | 'created_at' | 'updated_at'>): Promise<Department> {
        return this.businessRepo.createDepartment(data);
    }

    async updateDepartment(id: string, data: Partial<Omit<Department, 'id' | 'created_at' | 'updated_at'>>): Promise<Department> {
        return this.businessRepo.updateDepartment(id, data);
    }

    async deleteDepartment(id: string): Promise<Department> {
        return this.businessRepo.deleteDepartment(id);
    }

    async getPostById(id: string): Promise<Post | null> {
        return this.businessRepo.findPostById(id);
    }

    async getPostsByDepartmentId(departmentId: string): Promise<Post[]> {
        return this.businessRepo.findPostsByDepartmentId(departmentId);
    }

    async createPost(data: Omit<Post, 'id' | 'created_at' | 'updated_at'>): Promise<Post> {
        return this.businessRepo.createPost(data);
    }

    async updatePost(id: string, data: Partial<Omit<Post, 'id' | 'created_at' | 'updated_at'>>): Promise<Post> {
        return this.businessRepo.updatePost(id, data);
    }

    async deletePost(id: string): Promise<Post> {
        return this.businessRepo.deletePost(id);
    }

    async getShiftById(id: string): Promise<Shift | null> {
        return this.businessRepo.findShiftById(id);
    }

    async getShiftsByBranchId(branchId: string): Promise<Shift[]> {
        return this.businessRepo.findShiftsByBranchId(branchId);
    }

    async createShift(data: Omit<Shift, 'id' | 'created_at' | 'updated_at'>): Promise<Shift> {
        return this.businessRepo.createShift(data);
    }

    async updateShift(id: string, data: Partial<Omit<Shift, 'id' | 'created_at' | 'updated_at'>>): Promise<Shift> {
        return this.businessRepo.updateShift(id, data);
    }

    async deleteShift(id: string): Promise<Shift> {
        return this.businessRepo.deleteShift(id);
    }

    async getRoleById(id: string): Promise<Role | null> {
        return this.businessRepo.findRoleById(id);
    }

    async getRolesByBranchId(branchId: string): Promise<Role[]> {
        return this.businessRepo.findRolesByBranchId(branchId);
    }

    async createRole(data: Omit<Role, 'id' | 'created_at' | 'updated_at'>): Promise<Role> {
        return this.businessRepo.createRole(data);
    }

    async updateRole(id: string, data: Partial<Omit<Role, 'id' | 'created_at' | 'updated_at'>>): Promise<Role> {
        return this.businessRepo.updateRole(id, data);
    }

    async deleteRole(id: string): Promise<Role> {
        return this.businessRepo.deleteRole(id);
    }

    async getEmployeeById(id: string): Promise<Employee | null> {
        return this.businessRepo.findEmployeeById(id);
    }

    async getEmployeeByUserId(userId: string): Promise<Employee | null> {
        return this.businessRepo.findEmployeeByUserId(userId);
    }

    async getEmployeesByBranchId(branchId: string): Promise<Employee[]> {
        return this.businessRepo.findEmployeesByBranchId(branchId);
    }

    async createEmployee(data: Omit<Employee, 'id' | 'created_at' | 'updated_at'>): Promise<Employee> {
        return this.businessRepo.createEmployee(data);
    }

    async updateEmployee(id: string, data: Partial<Omit<Employee, 'id' | 'created_at' | 'updated_at'>>): Promise<Employee> {
        return this.businessRepo.updateEmployee(id, data);
    }

    async deleteEmployee(id: string): Promise<Employee> {
        return this.businessRepo.deleteEmployee(id);
    }

    async createJoinRequest(user: User, branchId: string, requestedRoleId?: string): Promise<BusinessJoinRequest> {
        const existingEmployee = await this.businessRepo.findEmployeeByUserId(user.id);
        if (existingEmployee) {
            throw new ConflictError(BUSINESS_MESSAGES.ALREADY_JOINED);
        }

        const branch = await prisma.branch.findUnique({
            where: { id: branchId },
        });

        if (!branch) {
            throw new NotFoundError(BUSINESS_MESSAGES.BRANCH_NOT_FOUND);
        }

        if (requestedRoleId) {
            const role = await prisma.role.findFirst({
                where: {
                    id: requestedRoleId,
                    branch_id: branch.id,
                },
            });

            if (!role) {
                throw new NotFoundError(BUSINESS_MESSAGES.ROLE_NOT_FOUND);
            }
        }

        const pendingRequest = await this.businessRepo.findPendingJoinRequestByUserAndBranch(user.id, branch.id);
        if (pendingRequest) {
            throw new ConflictError(BUSINESS_MESSAGES.JOIN_REQUEST_ALREADY_EXISTS);
        }

        return this.businessRepo.createJoinRequest({
            uid: user.id,
            branch_id: branch.id,
            requested_role_id: requestedRoleId,
        });
    }

    async getJoinRequestsForBranch(user: User, branchId: string): Promise<BusinessJoinRequest[]> {
        await this.ensureJoinRequestReviewer(user.id, branchId);
        return this.businessRepo.findJoinRequestsByBranchId(branchId);
    }

    async getMyJoinRequests(userId: string): Promise<BusinessJoinRequest[]> {
        return this.businessRepo.findJoinRequestsByUserId(userId);
    }

    async approveJoinRequest(user: User, requestId: string, roleId?: string): Promise<{ request: BusinessJoinRequest, employee: Employee }> {
        const request = await this.businessRepo.findJoinRequestById(requestId);
        if (!request) {
            throw new NotFoundError(BUSINESS_MESSAGES.JOIN_REQUEST_NOT_FOUND);
        }

        if (request.status !== 'PENDING') {
            throw new BadRequestError(BUSINESS_MESSAGES.JOIN_REQUEST_NOT_PENDING);
        }

        const reviewer = await this.ensureJoinRequestReviewer(user.id, request.branch_id);
        const existingEmployee = await this.businessRepo.findEmployeeByUserId(request.uid);
        if (existingEmployee) {
            throw new ConflictError(BUSINESS_MESSAGES.ALREADY_JOINED);
        }

        return prisma.$transaction(async (tx) => {
            const assignedRole = roleId
                ? await tx.role.findFirst({
                    where: {
                        id: roleId,
                        branch_id: request.branch_id,
                    },
                })
                : request.requested_role_id
                    ? await tx.role.findFirst({
                        where: {
                            id: request.requested_role_id,
                            branch_id: request.branch_id,
                        },
                    })
                    : await this.ensureEmployeeRole(tx, request.branch_id);

            if (!assignedRole) {
                throw new NotFoundError(BUSINESS_MESSAGES.ROLE_NOT_FOUND);
            }

            const joiningUser = await tx.user.findUnique({ where: { id: request.uid } });
            if (!joiningUser) {
                throw new NotFoundError(BUSINESS_MESSAGES.NOT_FOUND);
            }

            const department = await this.ensureEmployeeDepartment(tx, request.branch_id);
            const post = await this.ensureEmployeePost(tx, department.id);
            const shift = await this.ensureGeneralShift(tx, request.branch_id);
            const employee = await tx.employee.create({
                data: {
                    uid: joiningUser.id,
                    name: joiningUser.name,
                    email: joiningUser.email,
                    branch_id: request.branch_id,
                    role_id: assignedRole.id,
                    shift_id: shift.id,
                    post_id: post.id,
                    bank_details: BUSINESS_DEFAULTS.EMPTY_BANK_DETAILS,
                    address: BUSINESS_DEFAULTS.EMPTY_ADDRESS,
                },
            });
            const updatedRequest = await tx.businessJoinRequest.update({
                where: { id: request.id },
                data: {
                    status: 'APPROVED',
                    requested_role_id: assignedRole.id,
                    reviewed_by_id: reviewer.id,
                },
                include: {
                    user: {
                        select: {
                            id: true,
                            name: true,
                            email: true,
                            avatar_url: true,
                        },
                    },
                    branch: true,
                    requested_role: true,
                },
            });

            return {
                request: updatedRequest,
                employee,
            };
        }) as any;
    }

    async rejectJoinRequest(user: User, requestId: string): Promise<BusinessJoinRequest> {
        const request = await this.businessRepo.findJoinRequestById(requestId);
        if (!request) {
            throw new NotFoundError(BUSINESS_MESSAGES.JOIN_REQUEST_NOT_FOUND);
        }

        if (request.status !== 'PENDING') {
            throw new BadRequestError(BUSINESS_MESSAGES.JOIN_REQUEST_NOT_PENDING);
        }

        const reviewer = await this.ensureJoinRequestReviewer(user.id, request.branch_id);
        return this.businessRepo.updateJoinRequest(request.id, {
            status: 'REJECTED',
            reviewed_by_id: reviewer.id,
        });
    }

    async initializeBranch(user: User, branchData: Omit<Branch, 'id' | 'created_at' | 'updated_at'>): Promise<{ branch: Branch, employee: Employee }> {
        return prisma.$transaction(async (tx) => {
            const branch = await tx.branch.create({ data: branchData as any });
            const department = await tx.department.create({
                data: {
                    name: BUSINESS_DEFAULTS.OWNER_DEPARTMENT,
                    branch_id: branch.id,
                },
            });
            const post = await tx.post.create({
                data: {
                    name: BUSINESS_DEFAULTS.OWNER_POST,
                    department_id: department.id,
                },
            });
            const shift = await tx.shift.create({
                data: {
                    name: BUSINESS_DEFAULTS.GENERAL_SHIFT,
                    branch_id: branch.id,
                    start_time: BUSINESS_DEFAULTS.GENERAL_SHIFT_START,
                    end_time: BUSINESS_DEFAULTS.GENERAL_SHIFT_END,
                    basis: 'DAY',
                    type: 'GENERAL',
                },
            });
            const ownerRole = await tx.role.create({
                data: {
                    name: BUSINESS_DEFAULTS.OWNER_ROLE,
                    branch_id: branch.id,
                    permissions: [BUSINESS_DEFAULTS.ALL_PERMISSION],
                },
            });
            const employee = await tx.employee.create({
                data: {
                    uid: user.id,
                    name: user.name,
                    email: user.email,
                    branch_id: branch.id,
                    role_id: ownerRole.id,
                    shift_id: shift.id,
                    post_id: post.id,
                    bank_details: BUSINESS_DEFAULTS.EMPTY_BANK_DETAILS,
                    address: BUSINESS_DEFAULTS.EMPTY_ADDRESS,
                },
            });

            return { branch, employee };
        }) as any;
    }

    async searchBranches(query: string): Promise<Branch[]> {
        return prisma.branch.findMany({
            where: {
                name: {
                    contains: query,
                    mode: 'insensitive'
                }
            }
        }) as any;
    }

    async getUserContext(userId: string): Promise<{ branch: Branch, employee: Employee, permissions: string[] } | null> {
        const employee = await prisma.employee.findUnique({
            where: { uid: userId },
            include: {
                branch: true,
                role: true
            }
        }) as any;

        if (!employee) return null;

        return {
            branch: employee.branch,
            employee,
            permissions: employee.role.permissions
        };
    }

    private async ensureJoinRequestReviewer(userId: string, branchId: string): Promise<Employee> {
        const employee = await prisma.employee.findUnique({
            where: { uid: userId },
            include: { role: true },
        }) as any;

        if (!employee || employee.branch_id !== branchId) {
            throw new ForbiddenError(BUSINESS_MESSAGES.FORBIDDEN);
        }

        const permissions = employee.role.permissions as string[];
        const canReview = permissions.includes(BUSINESS_DEFAULTS.ALL_PERMISSION) || permissions.includes('employee:write');
        if (!canReview) {
            throw new ForbiddenError(BUSINESS_MESSAGES.FORBIDDEN);
        }

        return employee;
    }

    private async ensureEmployeeRole(tx: any, branchId: string): Promise<Role> {
        const existingRole = await tx.role.findFirst({
            where: {
                branch_id: branchId,
                name: BUSINESS_DEFAULTS.EMPLOYEE_ROLE,
            },
        });

        if (existingRole) {
            return existingRole;
        }

        return tx.role.create({
            data: {
                branch_id: branchId,
                name: BUSINESS_DEFAULTS.EMPLOYEE_ROLE,
                permissions: [...BUSINESS_DEFAULTS.EMPLOYEE_PERMISSIONS],
            },
        });
    }

    private async ensureEmployeeDepartment(tx: any, branchId: string): Promise<Department> {
        const existingDepartment = await tx.department.findFirst({
            where: {
                branch_id: branchId,
                name: BUSINESS_DEFAULTS.EMPLOYEE_DEPARTMENT,
            },
        });

        if (existingDepartment) {
            return existingDepartment;
        }

        return tx.department.create({
            data: {
                branch_id: branchId,
                name: BUSINESS_DEFAULTS.EMPLOYEE_DEPARTMENT,
            },
        });
    }

    private async ensureEmployeePost(tx: any, departmentId: string): Promise<Post> {
        const existingPost = await tx.post.findFirst({
            where: {
                department_id: departmentId,
                name: BUSINESS_DEFAULTS.EMPLOYEE_POST,
            },
        });

        if (existingPost) {
            return existingPost;
        }

        return tx.post.create({
            data: {
                department_id: departmentId,
                name: BUSINESS_DEFAULTS.EMPLOYEE_POST,
            },
        });
    }

    private async ensureGeneralShift(tx: any, branchId: string): Promise<Shift> {
        const existingShift = await tx.shift.findFirst({
            where: {
                branch_id: branchId,
                name: BUSINESS_DEFAULTS.GENERAL_SHIFT,
            },
        });

        if (existingShift) {
            return existingShift;
        }

        return tx.shift.create({
            data: {
                name: BUSINESS_DEFAULTS.GENERAL_SHIFT,
                branch_id: branchId,
                start_time: BUSINESS_DEFAULTS.GENERAL_SHIFT_START,
                end_time: BUSINESS_DEFAULTS.GENERAL_SHIFT_END,
                basis: 'DAY',
                type: 'GENERAL',
            },
        });
    }
}
