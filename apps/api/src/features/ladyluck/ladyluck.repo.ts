import { LadyluckDiscountStatus, LadyluckScratchCardStatus, LoyaltyTransType } from '@prisma/client';
import prisma from '../../infra/database/client';
import { withDatabaseRetry } from '../../infra/database/retry';

export class LadyluckRepo {
  async expireRewards(uid: string, branchId: string) {
    const now = new Date();
    await withDatabaseRetry(() => prisma.ladyluckScratchCard.updateMany({
      where: {
        uid,
        branch_id: branchId,
        status: LadyluckScratchCardStatus.AVAILABLE,
        expires_at: { lt: now },
      },
      data: { status: LadyluckScratchCardStatus.EXPIRED },
    }));
    await withDatabaseRetry(() => prisma.ladyluckDiscount.updateMany({
      where: {
        uid,
        branch_id: branchId,
        status: LadyluckDiscountStatus.ACTIVE,
        valid_until: { lt: now },
      },
      data: { status: LadyluckDiscountStatus.EXPIRED },
    }));
  }

  async findAccount(uid: string, branchId: string) {
    return withDatabaseRetry(() => prisma.ladyluckAccount.findUnique({
      where: { branch_id_uid: { branch_id: branchId, uid } },
    }));
  }

  async findAvailableScratchCards(uid: string, branchId: string) {
    const now = new Date();
    return withDatabaseRetry(() => prisma.ladyluckScratchCard.findMany({
      where: {
        uid,
        branch_id: branchId,
        status: LadyluckScratchCardStatus.AVAILABLE,
        OR: [
          { expires_at: null },
          { expires_at: { gt: now } },
        ],
      },
      orderBy: { created_at: 'asc' },
    }));
  }

  async findActiveDiscounts(uid: string, branchId: string) {
    const now = new Date();
    return withDatabaseRetry(() => prisma.ladyluckDiscount.findMany({
      where: {
        uid,
        branch_id: branchId,
        status: LadyluckDiscountStatus.ACTIVE,
        valid_from: { lte: now },
        OR: [
          { valid_until: null },
          { valid_until: { gt: now } },
        ],
      },
      include: { scratch_card: true },
      orderBy: { created_at: 'asc' },
    }));
  }

  async findTransactions(uid: string, branchId: string) {
    return withDatabaseRetry(() => prisma.loyaltyTrans.findMany({
      where: { uid, branch_id: branchId },
      orderBy: { created_at: 'desc' },
      take: 20,
    }));
  }

  async findScratchCard(id: string) {
    return withDatabaseRetry(() => prisma.ladyluckScratchCard.findUnique({
      where: { id },
      include: { discount: true },
    }));
  }

  async findDiscount(id: string) {
    return withDatabaseRetry(() => prisma.ladyluckDiscount.findUnique({
      where: { id },
      include: { scratch_card: true },
    }));
  }

  async createLoyaltyTrans(data: {
    branch_id: string;
    uid: string;
    order_id?: string;
    scratch_card_id?: string;
    points: number;
    trans_type: LoyaltyTransType;
    balance_after?: number;
  }) {
    return withDatabaseRetry(() => prisma.loyaltyTrans.create({ data }));
  }
}

export const ladyluckRepo = new LadyluckRepo();
