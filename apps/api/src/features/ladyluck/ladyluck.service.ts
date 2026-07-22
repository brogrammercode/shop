import {
  LadyluckDiscountStatus,
  LadyluckDiscountType,
  LadyluckScratchCardStatus,
  LoyaltyTransType,
  OrderStatus,
} from '@prisma/client';
import prisma from '../../infra/database/client';
import { withDatabaseRetry } from '../../infra/database/retry';
import { BadRequestError, NotFoundError } from '../../utils/error';
import { _LADYLUCK_CONSTANTS } from './ladyluck.constant';
import { ladyluckRepo } from './ladyluck.repo';

export class LadyluckService {
  async getSummary(uid: string, branchId: string) {
    const account = await this.ensureScratchCardAvailability(uid, branchId);
    const [scratchCards, activeDiscounts, transactions] = await Promise.all([
      ladyluckRepo.findAvailableScratchCards(uid, branchId),
      ladyluckRepo.findActiveDiscounts(uid, branchId),
      ladyluckRepo.findTransactions(uid, branchId),
    ]);
    void ladyluckRepo.expireRewards(uid, branchId).catch(() => undefined);

    return {
      account: account || {
        points_balance: _LADYLUCK_CONSTANTS._D_E_F_A_U_L_T_S.ZERO,
        lifetime_points: _LADYLUCK_CONSTANTS._D_E_F_A_U_L_T_S.ZERO,
      },
      available_scratch_cards: account && account.points_balance >= _LADYLUCK_CONSTANTS._D_E_F_A_U_L_T_S.POINTS_PER_CARD
        ? scratchCards
        : [],
      active_discounts: activeDiscounts,
      transactions,
    };
  }

  async scratchCard(uid: string, branchId: string, cardId: string) {
    const card = await ladyluckRepo.findScratchCard(cardId);
    const now = new Date();

    if (!card || card.uid !== uid || card.branch_id !== branchId) {
      throw new NotFoundError(_LADYLUCK_CONSTANTS._E_R_R_O_R_S.CARD_NOT_FOUND);
    }

    if (card.status !== LadyluckScratchCardStatus.AVAILABLE || (card.expires_at && card.expires_at < now)) {
      throw new BadRequestError(_LADYLUCK_CONSTANTS._E_R_R_O_R_S.CARD_NOT_AVAILABLE);
    }

    const reward = this.pickReward();
    const discount = await withDatabaseRetry(() => prisma.$transaction(async (tx) => {
      const account = await tx.ladyluckAccount.findUnique({
        where: { branch_id_uid: { branch_id: branchId, uid } },
      });
      if (!account || account.points_balance < _LADYLUCK_CONSTANTS._D_E_F_A_U_L_T_S.POINTS_PER_CARD) {
        throw new BadRequestError(_LADYLUCK_CONSTANTS._E_R_R_O_R_S.INSUFFICIENT_POINTS);
      }

      await tx.ladyluckScratchCard.update({
        where: { id: cardId },
        data: {
          status: LadyluckScratchCardStatus.SCRATCHED,
          scratched_at: now,
        },
      });

      const discount = await tx.ladyluckDiscount.create({
        data: {
          branch_id: branchId,
          uid,
          scratch_card_id: cardId,
          discount_type: reward.DISCOUNT_TYPE as LadyluckDiscountType,
          discount_value: reward.DISCOUNT_VALUE,
          min_order_amount: reward.MIN_ORDER_AMOUNT,
          max_discount_amount: reward.MAX_DISCOUNT_AMOUNT,
          valid_until: this.addDays(now, _LADYLUCK_CONSTANTS._D_E_F_A_U_L_T_S.DISCOUNT_VALID_DAYS),
        },
        include: { scratch_card: true },
      });

      const updatedAccount = await tx.ladyluckAccount.update({
        where: { branch_id_uid: { branch_id: branchId, uid } },
        data: {
          points_balance: {
            decrement: _LADYLUCK_CONSTANTS._D_E_F_A_U_L_T_S.POINTS_PER_CARD,
          },
        },
      });

      await tx.loyaltyTrans.create({
        data: {
          branch_id: branchId,
          uid,
          scratch_card_id: cardId,
          points: _LADYLUCK_CONSTANTS._D_E_F_A_U_L_T_S.POINTS_PER_CARD,
          trans_type: LoyaltyTransType.SCRATCH_CARD_CREATED,
          balance_after: updatedAccount.points_balance,
        },
      });

      if (updatedAccount.points_balance >= _LADYLUCK_CONSTANTS._D_E_F_A_U_L_T_S.POINTS_PER_CARD) {
        const availableCardCount = await tx.ladyluckScratchCard.count({
          where: {
            branch_id: branchId,
            uid,
            status: LadyluckScratchCardStatus.AVAILABLE,
            OR: [
              { expires_at: null },
              { expires_at: { gt: now } },
            ],
          },
        });
        if (availableCardCount === _LADYLUCK_CONSTANTS._D_E_F_A_U_L_T_S.ZERO) {
          await tx.ladyluckScratchCard.create({
            data: {
              branch_id: branchId,
              uid,
              points_spent: _LADYLUCK_CONSTANTS._D_E_F_A_U_L_T_S.POINTS_PER_CARD,
              expires_at: this.addDays(now, _LADYLUCK_CONSTANTS._D_E_F_A_U_L_T_S.CARD_VALID_DAYS),
            },
          });
        }
      }

      return discount;
    }));

    return discount;
  }

  async calculateDiscount(uid: string | undefined, branchId: string, discountId: string | undefined, subtotal: number) {
    if (!uid || !discountId) {
      return {
        discount_id: undefined,
        discount_amount: _LADYLUCK_CONSTANTS._D_E_F_A_U_L_T_S.ZERO,
      };
    }

    const discount = await ladyluckRepo.findDiscount(discountId);
    const now = new Date();

    if (!discount || discount.uid !== uid || discount.branch_id !== branchId) {
      throw new NotFoundError(_LADYLUCK_CONSTANTS._E_R_R_O_R_S.DISCOUNT_NOT_FOUND);
    }

    if (discount.status !== LadyluckDiscountStatus.ACTIVE || discount.valid_from > now || (discount.valid_until && discount.valid_until < now)) {
      throw new BadRequestError(_LADYLUCK_CONSTANTS._E_R_R_O_R_S.DISCOUNT_NOT_ACTIVE);
    }

    if (subtotal < Number(discount.min_order_amount || 0)) {
      throw new BadRequestError(_LADYLUCK_CONSTANTS._E_R_R_O_R_S.DISCOUNT_MINIMUM_NOT_MET);
    }

    return {
      discount_id: discount.id,
      discount_amount: this.discountAmount(discount.discount_type, Number(discount.discount_value), Number(discount.max_discount_amount || 0), subtotal),
    };
  }

  async markDiscountUsed(discountId: string | undefined, amount: number) {
    if (!discountId) {
      return;
    }

    await withDatabaseRetry(() => prisma.ladyluckDiscount.update({
      where: { id: discountId },
      data: {
        status: LadyluckDiscountStatus.USED,
        used_at: new Date(),
        applied_amount: amount,
      },
    }));
  }

  async awardOrderPoints(orderId: string) {
    return withDatabaseRetry(() => prisma.$transaction(async (tx) => {
      const order = await tx.order.findUnique({ where: { id: orderId } });
      if (!order || !order.uid || order.ladyluck_points_awarded_at) {
        return order;
      }

      if (order.status !== OrderStatus.PAID && order.status !== OrderStatus.DELIVERED) {
        return order;
      }

      const earnedPoints = Math.floor(Number(order.subtotal || 0));
      if (earnedPoints <= _LADYLUCK_CONSTANTS._D_E_F_A_U_L_T_S.ZERO) {
        return order;
      }

      let account = await tx.ladyluckAccount.upsert({
        where: { branch_id_uid: { branch_id: order.branch_id, uid: order.uid } },
        create: {
          branch_id: order.branch_id,
          uid: order.uid,
          points_balance: earnedPoints,
          lifetime_points: earnedPoints,
        },
        update: {
          points_balance: { increment: earnedPoints },
          lifetime_points: { increment: earnedPoints },
        },
      });

      await tx.loyaltyTrans.create({
        data: {
          branch_id: order.branch_id,
          uid: order.uid,
          order_id: order.id,
          points: earnedPoints,
          trans_type: LoyaltyTransType.EARNED,
          balance_after: account.points_balance,
        },
      });

      if (account.points_balance >= _LADYLUCK_CONSTANTS._D_E_F_A_U_L_T_S.POINTS_PER_CARD) {
        const availableCardCount = await tx.ladyluckScratchCard.count({
          where: {
            branch_id: order.branch_id,
            uid: order.uid,
            status: LadyluckScratchCardStatus.AVAILABLE,
            OR: [
              { expires_at: null },
              { expires_at: { gt: new Date() } },
            ],
          },
        });
        if (availableCardCount === _LADYLUCK_CONSTANTS._D_E_F_A_U_L_T_S.ZERO) {
          await tx.ladyluckScratchCard.create({
            data: {
              branch_id: order.branch_id,
              uid: order.uid,
              created_from_order_id: order.id,
              points_spent: _LADYLUCK_CONSTANTS._D_E_F_A_U_L_T_S.POINTS_PER_CARD,
              expires_at: this.addDays(new Date(), _LADYLUCK_CONSTANTS._D_E_F_A_U_L_T_S.CARD_VALID_DAYS),
            },
          });
        }
      }

      return tx.order.update({
        where: { id: order.id },
        data: {
          ladyluck_points_earned: earnedPoints,
          ladyluck_points_awarded_at: new Date(),
        },
      });
    }));
  }

  async reverseOrderPoints(orderId: string) {
    return withDatabaseRetry(() => prisma.$transaction(async (tx) => {
      const order = await tx.order.findUnique({ where: { id: orderId } });
      if (!order || !order.uid || !order.ladyluck_points_awarded_at || order.ladyluck_points_earned <= 0) {
        return order;
      }

      const account = await tx.ladyluckAccount.findUnique({
        where: { branch_id_uid: { branch_id: order.branch_id, uid: order.uid } },
      });
      if (!account) {
        return order;
      }

      const reversal = Math.min(account.points_balance, order.ladyluck_points_earned);
      const updatedAccount = await tx.ladyluckAccount.update({
        where: { branch_id_uid: { branch_id: order.branch_id, uid: order.uid } },
        data: { points_balance: { decrement: reversal } },
      });
      await tx.loyaltyTrans.create({
        data: {
          branch_id: order.branch_id,
          uid: order.uid,
          order_id: order.id,
          points: reversal,
          trans_type: LoyaltyTransType.REVERSED,
          balance_after: updatedAccount.points_balance,
        },
      });
      return order;
    }));
  }

  private pickReward() {
    const totalWeight = _LADYLUCK_CONSTANTS._R_E_W_A_R_D_S.reduce((total, reward) => total + reward.WEIGHT, 0);
    let pick = Math.random() * totalWeight;
    for (const reward of _LADYLUCK_CONSTANTS._R_E_W_A_R_D_S) {
      pick -= reward.WEIGHT;
      if (pick <= _LADYLUCK_CONSTANTS._D_E_F_A_U_L_T_S.ZERO) {
        return reward;
      }
    }
    return _LADYLUCK_CONSTANTS._R_E_W_A_R_D_S[0];
  }

  private async ensureScratchCardAvailability(uid: string, branchId: string) {
    const account = await ladyluckRepo.findAccount(uid, branchId);
    if (!account || account.points_balance < _LADYLUCK_CONSTANTS._D_E_F_A_U_L_T_S.POINTS_PER_CARD) {
      return account;
    }

    const availableCards = await ladyluckRepo.findAvailableScratchCards(uid, branchId);
    if (availableCards.length > _LADYLUCK_CONSTANTS._D_E_F_A_U_L_T_S.ZERO) {
      return account;
    }

    await withDatabaseRetry(() => prisma.ladyluckScratchCard.create({
      data: {
        branch_id: branchId,
        uid,
        points_spent: _LADYLUCK_CONSTANTS._D_E_F_A_U_L_T_S.POINTS_PER_CARD,
        expires_at: this.addDays(new Date(), _LADYLUCK_CONSTANTS._D_E_F_A_U_L_T_S.CARD_VALID_DAYS),
      },
    }));
    return account;
  }

  private discountAmount(type: LadyluckDiscountType, value: number, maxDiscount: number, subtotal: number) {
    const rawAmount = type === LadyluckDiscountType.PERCENTAGE
      ? subtotal * value / _LADYLUCK_CONSTANTS._D_E_F_A_U_L_T_S.HUNDRED
      : value;
    const cappedAmount = maxDiscount > _LADYLUCK_CONSTANTS._D_E_F_A_U_L_T_S.ZERO
      ? Math.min(rawAmount, maxDiscount)
      : rawAmount;
    return Math.max(_LADYLUCK_CONSTANTS._D_E_F_A_U_L_T_S.ZERO, Math.min(subtotal, Number(cappedAmount.toFixed(2))));
  }

  private addDays(date: Date, days: number) {
    const nextDate = new Date(date);
    nextDate.setDate(nextDate.getDate() + days);
    return nextDate;
  }
}

export const ladyluckService = new LadyluckService();
