import { financeRepo } from './finance.repo';
import { _FINANCE_CONSTANTS } from './finance.constant';
import { AppError, NotFoundError, BadRequestError } from '../../utils/error';
import { HttpStatus } from '../../constants/status';
import { AccountType } from '@prisma/client';

export class FinanceService {
  async createAccount(branchId: string, name: string, account_type: AccountType) {
    return financeRepo.createAccount({ branch_id: branchId, name, account_type });
  }

  async listAccounts(branchId: string) {
    return financeRepo.findAccountsByBranch(branchId);
  }

  async getAccountById(id: string, branchId: string) {
    const account = await financeRepo.findAccountById(id);
    if (!account || account.branch_id !== branchId) {
      throw new NotFoundError(_FINANCE_CONSTANTS._E_R_R_O_R_S.ACCOUNT_NOT_FOUND);
    }
    return account;
  }

  async updateAccount(id: string, branchId: string, data: any) {
    await this.getAccountById(id, branchId);
    return financeRepo.updateAccount(id, data);
  }

  async createTransaction(branchId: string, account_id: string, transaction_type: string, amount: number, description: string, employeeId: string, reference_id?: string) {
    let debit = 0;
    let credit = 0;

    if (transaction_type === 'DEBIT') {
      debit = amount;
    } else {
      credit = amount;
    }

    return financeRepo.createTransaction({
      branch_id: branchId,
      account_id,
      debit,
      credit,
      notes: description,
      reference_id: reference_id || 'manual',
      reference_type: 'MANUAL',
      created_by: employeeId,
    });
  }

  async listTransactions(branchId: string) {
    return financeRepo.findTransactionsByBranch(branchId);
  }

  async getTransactionById(id: string, branchId: string) {
    const transaction = await financeRepo.findTransactionById(id);
    if (!transaction || transaction.branch_id !== branchId) {
      throw new NotFoundError(_FINANCE_CONSTANTS._E_R_R_O_R_S.TRANSACTION_NOT_FOUND);
    }
    return transaction;
  }

  async createAsset(branchId: string, asset_name: string, purchase_price: number, depreciation_rate?: number) {
    return financeRepo.createAsset({ branch_id: branchId, name: asset_name, purchase_value: purchase_price, depreciation_pct: depreciation_rate || 0 });
  }

  async listAssets(branchId: string) {
    return financeRepo.findAssetsByBranch(branchId);
  }

  async getAssetById(id: string, branchId: string) {
    const asset = await financeRepo.findAssetById(id);
    if (!asset || asset.branch_id !== branchId) {
      throw new NotFoundError(_FINANCE_CONSTANTS._E_R_R_O_R_S.ASSET_NOT_FOUND);
    }
    return asset;
  }

  async updateAsset(id: string, branchId: string, data: any) {
    await this.getAssetById(id, branchId);
    return financeRepo.updateAsset(id, data);
  }

  async createRoyalty(branchId: string, franchise_id: string, calculated_amount: number) {
    return financeRepo.createRoyalty({
      branch_id: branchId,
      franchise_id,
      calculated_amt: calculated_amount,
      status: 'PENDING',
    });
  }

  async listRoyalties(branchId: string) {
    return financeRepo.findRoyaltiesByBranch(branchId);
  }

  async getRoyaltyById(id: string, branchId: string) {
    const royalty = await financeRepo.findRoyaltyById(id);
    if (!royalty || royalty.branch_id !== branchId) {
      throw new NotFoundError(_FINANCE_CONSTANTS._E_R_R_O_R_S.ROYALTY_NOT_FOUND);
    }
    return royalty;
  }

  async payRoyalty(id: string, branchId: string) {
    const royalty = await this.getRoyaltyById(id, branchId);
    if (royalty.status !== 'PENDING' && royalty.status !== 'INVOICED') {
      throw new BadRequestError(_FINANCE_CONSTANTS._E_R_R_O_R_S.INVALID_STATUS);
    }
    return financeRepo.updateRoyaltyStatus(id, 'PAID');
  }
}

export const financeService = new FinanceService();
