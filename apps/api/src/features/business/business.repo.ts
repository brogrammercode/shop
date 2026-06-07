import prisma from '../../infra/database/client';
import { 
    Branch, Department, Post, 
    Shift, Role, Employee, BusinessJoinRequest 
} from './business.type';

export class BusinessRepo {
    async findBranchById(id: string): Promise<Branch | null> {
        return prisma.branch.findUnique({ where: { id } }) as any;
    }

    async findAllBranches(): Promise<Branch[]> {
        return prisma.branch.findMany() as any;
    }

    async createBranch(data: Omit<Branch, 'id' | 'created_at' | 'updated_at'>): Promise<Branch> {
        return prisma.branch.create({ data: data as any }) as any;
    }

    async updateBranch(id: string, data: Partial<Omit<Branch, 'id' | 'created_at' | 'updated_at'>>): Promise<Branch> {
        return prisma.branch.update({ where: { id }, data: data as any }) as any;
    }

    async deleteBranch(id: string): Promise<Branch> {
        return prisma.branch.delete({ where: { id } }) as any;
    }

    async findDepartmentById(id: string): Promise<Department | null> {
        return prisma.department.findUnique({ where: { id } }) as any;
    }

    async findDepartmentsByBranchId(branch_id: string): Promise<Department[]> {
        return prisma.department.findMany({ where: { branch_id } }) as any;
    }

    async createDepartment(data: Omit<Department, 'id' | 'created_at' | 'updated_at'>): Promise<Department> {
        return prisma.department.create({ data }) as any;
    }

    async updateDepartment(id: string, data: Partial<Omit<Department, 'id' | 'created_at' | 'updated_at'>>): Promise<Department> {
        return prisma.department.update({ where: { id }, data }) as any;
    }

    async deleteDepartment(id: string): Promise<Department> {
        return prisma.department.delete({ where: { id } }) as any;
    }

    async findPostById(id: string): Promise<Post | null> {
        return prisma.post.findUnique({ where: { id } }) as any;
    }

    async findPostsByDepartmentId(department_id: string): Promise<Post[]> {
        return prisma.post.findMany({ where: { department_id } }) as any;
    }

    async createPost(data: Omit<Post, 'id' | 'created_at' | 'updated_at'>): Promise<Post> {
        return prisma.post.create({ data }) as any;
    }

    async updatePost(id: string, data: Partial<Omit<Post, 'id' | 'created_at' | 'updated_at'>>): Promise<Post> {
        return prisma.post.update({ where: { id }, data }) as any;
    }

    async deletePost(id: string): Promise<Post> {
        return prisma.post.delete({ where: { id } }) as any;
    }

    async findShiftById(id: string): Promise<Shift | null> {
        return prisma.shift.findUnique({ where: { id } }) as any;
    }

    async findShiftsByBranchId(branch_id: string): Promise<Shift[]> {
        return prisma.shift.findMany({ where: { branch_id } }) as any;
    }

    async createShift(data: Omit<Shift, 'id' | 'created_at' | 'updated_at'>): Promise<Shift> {
        return prisma.shift.create({ data: data as any }) as any;
    }

    async updateShift(id: string, data: Partial<Omit<Shift, 'id' | 'created_at' | 'updated_at'>>): Promise<Shift> {
        return prisma.shift.update({ where: { id }, data: data as any }) as any;
    }

    async deleteShift(id: string): Promise<Shift> {
        return prisma.shift.delete({ where: { id } }) as any;
    }

    async findRoleById(id: string): Promise<Role | null> {
        return prisma.role.findUnique({ where: { id } }) as any;
    }

    async findRolesByBranchId(branch_id: string): Promise<Role[]> {
        return prisma.role.findMany({ where: { branch_id } }) as any;
    }

    async createRole(data: Omit<Role, 'id' | 'created_at' | 'updated_at'>): Promise<Role> {
        return prisma.role.create({ data: data as any }) as any;
    }

    async updateRole(id: string, data: Partial<Omit<Role, 'id' | 'created_at' | 'updated_at'>>): Promise<Role> {
        return prisma.role.update({ where: { id }, data: data as any }) as any;
    }

    async deleteRole(id: string): Promise<Role> {
        return prisma.role.delete({ where: { id } }) as any;
    }

    async findEmployeeById(id: string): Promise<Employee | null> {
        return prisma.employee.findUnique({ where: { id } }) as any;
    }

    async findEmployeeByUserId(user_id: string): Promise<Employee | null> {
        return prisma.employee.findUnique({ where: { uid: user_id } }) as any;
    }

    async findEmployeesByBranchId(branch_id: string): Promise<Employee[]> {
        return prisma.employee.findMany({ where: { branch_id } }) as any;
    }

    async createEmployee(data: Omit<Employee, 'id' | 'created_at' | 'updated_at'>): Promise<Employee> {
        return prisma.employee.create({ data: data as any }) as any;
    }

    async updateEmployee(id: string, data: Partial<Omit<Employee, 'id' | 'created_at' | 'updated_at'>>): Promise<Employee> {
        return prisma.employee.update({ where: { id }, data: data as any }) as any;
    }

    async deleteEmployee(id: string): Promise<Employee> {
        return prisma.employee.delete({ where: { id } }) as any;
    }

    async findJoinRequestById(id: string): Promise<BusinessJoinRequest | null> {
        return prisma.businessJoinRequest.findUnique({
            where: { id },
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
        }) as any;
    }

    async findPendingJoinRequestByUserAndBranch(user_id: string, branch_id: string): Promise<BusinessJoinRequest | null> {
        return prisma.businessJoinRequest.findFirst({
            where: {
                uid: user_id,
                branch_id,
                status: 'PENDING',
            },
        }) as any;
    }

    async findJoinRequestsByBranchId(branch_id: string): Promise<BusinessJoinRequest[]> {
        return prisma.businessJoinRequest.findMany({
            where: {
                branch_id,
                status: 'PENDING',
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
            orderBy: { created_at: 'desc' },
        }) as any;
    }

    async findJoinRequestsByUserId(user_id: string): Promise<BusinessJoinRequest[]> {
        return prisma.businessJoinRequest.findMany({
            where: { uid: user_id },
            include: {
                branch: true,
                requested_role: true,
            },
            orderBy: { created_at: 'desc' },
        }) as any;
    }

    async createJoinRequest(data: Pick<BusinessJoinRequest, 'uid' | 'branch_id' | 'requested_role_id'>): Promise<BusinessJoinRequest> {
        return prisma.businessJoinRequest.create({
            data: {
                uid: data.uid,
                branch_id: data.branch_id,
                requested_role_id: data.requested_role_id,
            },
            include: {
                branch: true,
                requested_role: true,
            },
        }) as any;
    }

    async updateJoinRequest(id: string, data: Partial<Pick<BusinessJoinRequest, 'status' | 'requested_role_id' | 'reviewed_by_id'>>): Promise<BusinessJoinRequest> {
        return prisma.businessJoinRequest.update({
            where: { id },
            data: data as any,
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
        }) as any;
    }
}
