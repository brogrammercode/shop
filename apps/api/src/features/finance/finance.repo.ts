import { AccountType, RoyaltyStatus } from '@prisma/client';
import prisma from '../../infra/database/client';

export class FinanceRepo {
  async createAccount(data: { branch_id: string; name: string; account_type: AccountType; avatar?: string }) {
    return prisma.account.create({ data });
  }

  async findAccountsByBranch(branchId: string) {
    return prisma.account.findMany({ where: { branch_id: branchId } });
  }

  async findAccountById(id: string) {
    return prisma.account.findUnique({ where: { id } });
  }

  async updateAccount(id: string, data: Partial<{ name: string; account_type: AccountType }>) {
    return prisma.account.update({ where: { id }, data });
  }

  async createTransaction(data: { branch_id: string; account_id: string; debit?: number; credit?: number; notes?: string; reference_id: string; reference_type: string; created_by?: string; }) {
    return prisma.ledgerEntry.create({ data });
  }

  async findTransactionsByBranch(branchId: string) {
    return prisma.ledgerEntry.findMany({ where: { branch_id: branchId }, include: { account: true }, orderBy: { created_at: 'desc' } });
  }

  async findTransactionById(id: string) {
    return prisma.ledgerEntry.findUnique({ where: { id }, include: { account: true } });
  }

  async createAsset(data: { branch_id: string; name: string; purchase_value: number; depreciation_pct: number }) {
    return prisma.fixedAsset.create({ data });
  }

  async findAssetsByBranch(branchId: string) {
    return prisma.fixedAsset.findMany({ where: { branch_id: branchId }, orderBy: { created_at: 'desc' } });
  }

  async findAssetById(id: string) {
    return prisma.fixedAsset.findUnique({ where: { id } });
  }

  async updateAsset(id: string, data: Partial<{ purchase_value: number; status: any }>) {
    return prisma.fixedAsset.update({ where: { id }, data });
  }

  async createRoyalty(data: { branch_id: string; franchise_id: string; calculated_amt: number; status: RoyaltyStatus; }) {
    return prisma.royaltyTrans.create({ data });
  }

  async findRoyaltiesByBranch(branchId: string) {
    return prisma.royaltyTrans.findMany({ where: { branch_id: branchId }, include: { franchise: true }, orderBy: { created_at: 'desc' } });
  }

  async findRoyaltyById(id: string) {
    return prisma.royaltyTrans.findUnique({ where: { id }, include: { franchise: true } });
  }

  async updateRoyaltyStatus(id: string, status: RoyaltyStatus) {
    return prisma.royaltyTrans.update({ where: { id }, data: { status } });
  }
}

export const financeRepo = new FinanceRepo();
