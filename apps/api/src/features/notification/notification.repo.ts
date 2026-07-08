import prisma from "../../infra/database/client";
import { NotificationCreateDTO } from "./notification.type";

export class NotificationRepo {
  async create(data: NotificationCreateDTO) {
    return prisma.notification.create({
      data: {
        branch_id: data.branch_id,
        title: data.title,
        message: data.message,
        type: data.type,
        ref_type: data.ref_type,
        ref_link: data.ref_link,
        module: data.module,
        actor_id: data.actor_id,
        receipent_ids: data.receipent_ids,
        channels: data.channels,
      },
    });
  }

  async listByBranch(branchId: string) {
    return prisma.notification.findMany({
      where: { branch_id: branchId },
      orderBy: { created_at: "desc" },
      take: 100,
    });
  }

  async markRead(id: string) {
    return prisma.notification.update({
      where: { id },
      data: { read: true },
    });
  }

  async markAllRead(ids: string[]) {
    if (ids.length === 0) {
      return { count: 0 };
    }
    return prisma.notification.updateMany({
      where: { id: { in: ids } },
      data: { read: true },
    });
  }

  async saveDeviceToken(uid: string, token: string, platform?: string) {
    return prisma.userDeviceToken.upsert({
      where: { token },
      create: { uid, token, platform },
      update: { uid, platform },
    });
  }

  async listDeviceTokens(receipentIds: string[]) {
    if (receipentIds.length === 0) {
      return [];
    }
    return prisma.userDeviceToken.findMany({
      where: { uid: { in: receipentIds } },
    });
  }

  async listBranchEmployeeUids(branchId: string) {
    const employees = await prisma.employee.findMany({
      where: { branch_id: branchId, is_deleted: false },
      select: { uid: true },
    });
    return employees.map((employee) => employee.uid);
  }
}

export const notificationRepo = new NotificationRepo();
