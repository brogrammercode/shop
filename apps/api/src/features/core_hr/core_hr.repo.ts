import { JoinRequestStatus } from '@prisma/client';
import prisma from '../../infra/database/client';

export class CoreHrRepo {
  async findOrCreateUser(
    firebaseUid: string,
    name: string,
    phone: string,
    email: string | null,
    avatar: string | null,
  ) {
    const existing = await prisma.user.findUnique({ where: { id: firebaseUid } });
    if (existing) return existing;
    return prisma.user.create({
      data: {
        id: firebaseUid,
        name,
        phone,
        email: email ?? undefined,
        avatar: avatar ?? undefined,
      },
    });
  }

  async findUserByPhone(phone: string) {
    return prisma.user.findUnique({ where: { phone } });
  }

  async findUserById(id: string) {
    return prisma.user.findUnique({ where: { id } });
  }

  async findEmployeeByUid(uid: string) {
    return prisma.employee.findUnique({
      where: { uid },
      include: {
        branch: true,
        role_rel: true,
        department_rel: true,
        post_rel: true,
        shift_rel: true,
      },
    });
  }

  async createBranch(data: { name: string; code: string; is_hq: boolean }) {
    return prisma.branch.create({ data });
  }

  async findBranchById(id: string) {
    return prisma.branch.findUnique({ where: { id } });
  }

  async searchBranches(query: string) {
    return prisma.branch.findMany({
      where: {
        OR: [
          { name: { contains: query, mode: 'insensitive' } },
          { code: { contains: query, mode: 'insensitive' } },
        ],
        is_deleted: false,
      },
    });
  }

  async createRole(branchId: string, name: string, permissions: string[]) {
    return prisma.role.create({
      data: { branch_id: branchId, name, permissions },
    });
  }

  async findRolesByBranch(branchId: string) {
    return prisma.role.findMany({
      where: { branch_id: branchId, is_deleted: false },
    });
  }

  async findRoleById(id: string) {
    return prisma.role.findUnique({ where: { id } });
  }

  async createEmployee(branchId: string, uid: string, roleId: string) {
    return prisma.employee.create({
      data: { branch_id: branchId, uid, role: roleId },
    });
  }

  async findEmployeesByBranch(branchId: string) {
    return prisma.employee.findMany({
      where: { branch_id: branchId, is_deleted: false },
      include: {
        user: true,
        role_rel: true,
        department_rel: true,
        post_rel: true,
        shift_rel: true,
      },
    });
  }

  async findEmployeeById(id: string) {
    return prisma.employee.findUnique({
      where: { id },
      include: {
        user: true,
        role_rel: true,
        department_rel: true,
        post_rel: true,
        shift_rel: true,
      },
    });
  }

  async updateEmployee(
    id: string,
    data: any,
  ) {
    return prisma.employee.update({ where: { id }, data });
  }

  async deleteEmployee(id: string) {
    return prisma.employee.update({
      where: { id },
      data: { is_deleted: true },
    });
  }

  async createJoinRequest(uid: string, branchId: string, message: string | undefined) {
    return prisma.joinRequest.create({
      data: { uid, branch_id: branchId, message },
    });
  }

  async findPendingJoinRequest(uid: string, branchId: string) {
    return prisma.joinRequest.findFirst({
      where: { uid, branch_id: branchId, status: 'PENDING' },
    });
  }

  async findJoinRequestsByBranch(branchId: string) {
    return prisma.joinRequest.findMany({
      where: { branch_id: branchId, status: 'PENDING' },
      orderBy: { created_at: 'desc' },
    });
  }

  async findJoinRequestById(id: string) {
    return prisma.joinRequest.findUnique({ where: { id } });
  }

  async updateJoinRequestStatus(id: string, status: JoinRequestStatus, reviewedBy: string) {
    return prisma.joinRequest.update({
      where: { id },
      data: { status, reviewed_by: reviewedBy },
    });
  }

  async createDepartment(branchId: string, name: string, description: string | undefined) {
    return prisma.department.create({
      data: { branch_id: branchId, name, description },
    });
  }

  async findDepartmentsByBranch(branchId: string) {
    return prisma.department.findMany({
      where: { branch_id: branchId, is_deleted: false },
    });
  }

  async findDepartmentById(id: string) {
    return prisma.department.findUnique({ where: { id } });
  }

  async createPost(
    branchId: string,
    departmentId: string,
    name: string,
    description: string | undefined,
  ) {
    return prisma.post.create({
      data: { branch_id: branchId, department_id: departmentId, name, description },
    });
  }

  async findPostsByBranch(branchId: string) {
    return prisma.post.findMany({
      where: { branch_id: branchId, is_deleted: false },
      include: { department: true },
    });
  }

  async createShift(
    branchId: string,
    name: string,
    startTime: string,
    endTime: string,
  ) {
    return prisma.shift.create({
      data: { branch_id: branchId, name, start_time: startTime, end_time: endTime },
    });
  }

  async findShiftsByBranch(branchId: string) {
    return prisma.shift.findMany({
      where: { branch_id: branchId, is_deleted: false },
    });
  }

  async createTimeLog(branchId: string, employeeId: string, clockIn: Date) {
    return prisma.timeLog.create({
      data: { branch_id: branchId, employee_id: employeeId, clock_in: clockIn },
    });
  }

  async findOpenTimeLog(employeeId: string) {
    return prisma.timeLog.findFirst({
      where: { employee_id: employeeId, clock_out: null },
    });
  }

  async closeTimeLog(id: string, clockOut: Date, totalHours: number) {
    return prisma.timeLog.update({
      where: { id },
      data: { clock_out: clockOut, total_hours: totalHours },
    });
  }

  async findTimeLogById(id: string) {
    return prisma.timeLog.findUnique({ where: { id } });
  }

  async findTimeLogsByBranch(branchId: string) {
    return prisma.timeLog.findMany({
      where: { branch_id: branchId },
      orderBy: { clock_in: 'desc' },
      include: { employee: true },
    });
  }

  async createCashRegister(branchId: string, registerName: string, macAddress: string | undefined) {
    return prisma.cashRegister.create({
      data: { branch_id: branchId, register_name: registerName, mac_address: macAddress },
    });
  }

  async findCashRegistersByBranch(branchId: string) {
    return prisma.cashRegister.findMany({
      where: { branch_id: branchId },
    });
  }

  async findCashRegisterById(id: string) {
    return prisma.cashRegister.findUnique({ where: { id } });
  }

  async openCashRegister(id: string, expectedCash: number, openedBy: string) {
    return prisma.cashRegister.update({
      where: { id },
      data: { expected_cash: expectedCash, opened_by: openedBy, status: 'OPEN' },
    });
  }

  async closeCashRegister(id: string, actualCash: number, closedBy: string) {
    return prisma.cashRegister.update({
      where: { id },
      data: { actual_cash: actualCash, closed_by: closedBy, status: 'CLOSED' },
    });
  }

  async findUserLogsByUid(uid: string) {
    return prisma.userLog.findMany({
      where: { uid },
      orderBy: { created_at: 'desc' },
    });
  }

  async createUserLog(data: any) {
    return prisma.userLog.create({ data });
  }

  // --- OTP Methods ---
  async createOtp(data: { actor: string; otp: string; type: any; valid_till: Date }) {
    return prisma.userOtp.create({ data });
  }

  async findValidOtp(actor: string, otp: string, type: any) {
    return prisma.userOtp.findFirst({
      where: {
        actor,
        otp,
        type,
        valid_till: { gt: new Date() },
      },
    });
  }

  async findLatestOtpByActor(actor: string, type: any) {
    return prisma.userOtp.findFirst({
      where: { actor, type },
      orderBy: { created_at: 'desc' },
    });
  }

  async deleteOtpsByActor(actor: string, type: any) {
    return prisma.userOtp.deleteMany({ where: { actor, type } });
  }

  // --- Session Methods ---
  async createSession(data: any) {
    return prisma.userSession.create({ data });
  }

  async findSessionsByUserId(uid: string) {
    return prisma.userSession.findMany({
      where: { uid },
      orderBy: { created_at: 'desc' },
    });
  }

  async findSessionByRefreshToken(refreshToken: string) {
    return prisma.userSession.findUnique({
      where: { refresh_token: refreshToken },
      include: { user: true },
    });
  }

  async deleteSession(id: string) {
    return prisma.userSession.delete({ where: { id } });
  }
}

export const coreHrRepo = new CoreHrRepo();
