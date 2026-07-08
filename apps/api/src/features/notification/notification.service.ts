import admin from "../../infra/firebase/config";
import { _NOTIFICATION_CONSTANTS } from "./notification.constant";
import { notificationRepo } from "./notification.repo";
import { NotificationCreateDTO } from "./notification.type";

export class NotificationService {
  async list(uid: string, branchId: string) {
    const notifications = await notificationRepo.listByBranch(branchId);
    return notifications.filter((notification) => {
      const receipents = Array.isArray(notification.receipent_ids)
        ? notification.receipent_ids
            .map((id) => id?.toString() || "")
            .filter(Boolean)
        : [];
      return receipents.includes(uid);
    });
  }

  async markRead(id: string) {
    return notificationRepo.markRead(id);
  }

  async markAllRead(uid: string, branchId: string) {
    const notifications = await this.list(uid, branchId);
    const ids = notifications
      .filter((notification) => !notification.read)
      .map((notification) => notification.id);
    return notificationRepo.markAllRead(ids);
  }

  async saveDeviceToken(uid: string, token: string, platform?: string) {
    return notificationRepo.saveDeviceToken(uid, token, platform);
  }

  async create(data: NotificationCreateDTO) {
    const notification = await notificationRepo.create(data);
    if (data.channels.includes(_NOTIFICATION_CONSTANTS._C_H_A_N_N_E_L_S.PUSH)) {
      await this.sendPush(data).catch(() => null);
    }
    return notification;
  }

  async notifyOrderLifecycle(data: {
    branch_id: string;
    order_id: string;
    order_no?: number;
    type: string;
    title: string;
    message: string;
    actor_id?: string;
    extra_receipent_ids?: string[];
  }) {
    const branchUids = await notificationRepo.listBranchEmployeeUids(
      data.branch_id,
    );
    const receipent_ids = Array.from(
      new Set(
        [...branchUids, ...(data.extra_receipent_ids || [])].filter(Boolean),
      ),
    );
    if (receipent_ids.length === 0) {
      return null;
    }
    return this.create({
      branch_id: data.branch_id,
      title: data.title,
      message: data.message,
      type: data.type,
      ref_type: _NOTIFICATION_CONSTANTS._R_E_F_T_Y_P_E_S.ORDER,
      ref_link: `/pos-kds/orders/${data.order_id}`,
      module: _NOTIFICATION_CONSTANTS._M_O_D_U_L_E_S.POS_KDS,
      actor_id: data.actor_id,
      receipent_ids,
      channels: [
        _NOTIFICATION_CONSTANTS._C_H_A_N_N_E_L_S.IN_APP,
        _NOTIFICATION_CONSTANTS._C_H_A_N_N_E_L_S.PUSH,
      ],
    });
  }

  private async sendPush(data: NotificationCreateDTO) {
    const tokens = await notificationRepo.listDeviceTokens(data.receipent_ids);
    const tokenValues = tokens.map((token) => token.token).filter(Boolean);
    if (tokenValues.length === 0) {
      return;
    }
    await admin.messaging().sendEachForMulticast({
      tokens: tokenValues,
      notification: {
        title: data.title,
        body: data.message,
      },
      data: {
        ref_type: data.ref_type,
        ref_link: data.ref_link,
        type: data.type,
        module: data.module,
      },
    });
  }
}

export const notificationService = new NotificationService();
