import { BusinessRepo } from './business.repo';
import { 
    Business, Branch, Department, Post, 
    Shift, Role, Employee 
} from './business.type';
import { User } from '../auth/user.type';
import prisma from '../../infra/database/client';

export class BusinessService {
    private businessRepo: BusinessRepo;

    constructor() {
        this.businessRepo = new BusinessRepo();
    }

    // Business
    async getBusinessById(id: string): Promise<Business | null> {
        return this.businessRepo.findBusinessById(id);
    }

    async createBusiness(data: Omit<Business, 'id' | 'created_at' | 'updated_at'>): Promise<Business> {
        return this.businessRepo.createBusiness(data);
    }

    async updateBusiness(id: string, data: Partial<Omit<Business, 'id' | 'created_at' | 'updated_at'>>): Promise<Business> {
        return this.businessRepo.updateBusiness(id, data);
    }

    async deleteBusiness(id: string): Promise<Business> {
        return this.businessRepo.deleteBusiness(id);
    }

    // Branch
    async getBranchById(id: string): Promise<Branch | null> {
        return this.businessRepo.findBranchById(id);
    }

    async getBranchesByBusinessId(businessId: string): Promise<Branch[]> {
        return this.businessRepo.findBranchesByBusinessId(businessId);
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

    // Department
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

    // Post
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

    // Shift
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

    // Role
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

    // Employee
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

    async initializeBusiness(user: User, businessData: Omit<Business, 'id' | 'created_at' | 'updated_at'>, branchData: Omit<Branch, 'id' | 'business_id' | 'created_at' | 'updated_at'>): Promise<{ business: Business, branch: Branch, employee: Employee }> {
        const business = await this.createBusiness(businessData);
        const branch = await this.createBranch({ ...branchData, business_id: business.id });
        
        const ownerRole = await this.createRole({
            name: 'Owner',
            branch_id: branch.id,
            permissions: ['ALL']
        });

        const employee = await this.createEmployee({
            user_id: user.id,
            name: user.name,
            email: user.email,
            branch_id: branch.id,
            role_id: ownerRole.id,
            shift_id: '',
            post_id: '',
            bank_details: { account_name: '', account_number: '', bank_name: '', ifsc_code: '' },
            address: { street: '', city: '', state: '', zip: '', country: '' }
        });

        return { business, branch, employee };
    }

    async searchBusinesses(query: string): Promise<Business[]> {
        return prisma.business.findMany({
            where: {
                name: {
                    contains: query,
                    mode: 'insensitive'
                }
            }
        }) as any;
    }

    async getUserContext(userId: string): Promise<{ business: Business, branch: Branch, employee: Employee, permissions: string[] } | null> {
        const employee = await prisma.employee.findUnique({
            where: { user_id: userId },
            include: {
                branch: {
                    include: {
                        business: true
                    }
                },
                role: true
            }
        }) as any;

        if (!employee) return null;

        return {
            business: employee.branch.business,
            branch: employee.branch,
            employee,
            permissions: employee.role.permissions
        };
    }
}
