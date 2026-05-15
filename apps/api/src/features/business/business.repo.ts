import prisma from '../../infra/database/client';
import { 
    Business, Branch, Department, Post, 
    Shift, Role, Employee, ShiftBasis, ShiftType 
} from './business.type';

export class BusinessRepo {
    // Business
    async findBusinessById(id: string): Promise<Business | null> {
        return prisma.business.findUnique({ where: { id } }) as any;
    }

    async createBusiness(data: Omit<Business, 'id' | 'created_at' | 'updated_at'>): Promise<Business> {
        return prisma.business.create({ data }) as any;
    }

    async updateBusiness(id: string, data: Partial<Omit<Business, 'id' | 'created_at' | 'updated_at'>>): Promise<Business> {
        return prisma.business.update({ where: { id }, data }) as any;
    }

    async deleteBusiness(id: string): Promise<Business> {
        return prisma.business.delete({ where: { id } }) as any;
    }

    // Branch
    async findBranchById(id: string): Promise<Branch | null> {
        return prisma.branch.findUnique({ where: { id } }) as any;
    }

    async findBranchesByBusinessId(business_id: string): Promise<Branch[]> {
        return prisma.branch.findMany({ where: { business_id } }) as any;
    }

    async createBranch(data: Omit<Branch, 'id' | 'created_at' | 'updated_at'>): Promise<Branch> {
        return prisma.branch.create({ data }) as any;
    }

    async updateBranch(id: string, data: Partial<Omit<Branch, 'id' | 'created_at' | 'updated_at'>>): Promise<Branch> {
        return prisma.branch.update({ where: { id }, data }) as any;
    }

    async deleteBranch(id: string): Promise<Branch> {
        return prisma.branch.delete({ where: { id } }) as any;
    }

    // Department
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

    // Post
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

    // Shift
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

    // Role
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

    // Employee
    async findEmployeeById(id: string): Promise<Employee | null> {
        return prisma.employee.findUnique({ where: { id } }) as any;
    }

    async findEmployeeByUserId(user_id: string): Promise<Employee | null> {
        return prisma.employee.findUnique({ where: { user_id } }) as any;
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
}
