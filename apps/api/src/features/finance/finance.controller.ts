import { Request, Response } from 'express';
import { asyncHandler } from '../../utils/async';
import { sendSuccess } from '../../utils/error';
import { HttpStatus } from '../../constants/status';
import { financeService } from './finance.service';
import { _FINANCE_CONSTANTS } from './finance.constant';

export const listAccounts = asyncHandler(async (req: Request, res: Response) => {
  const result = await financeService.listAccounts(req.employee.branch_id);
  return sendSuccess(res, result, _FINANCE_CONSTANTS._M_E_S_S_A_G_E_S.ACCOUNTS_LISTED, HttpStatus.OK);
});

export const createAccount = asyncHandler(async (req: Request, res: Response) => {
  const { account_name, account_type } = req.body;
  const result = await financeService.createAccount(req.employee.branch_id, account_name, account_type);
  return sendSuccess(res, result, _FINANCE_CONSTANTS._M_E_S_S_A_G_E_S.ACCOUNT_CREATED, HttpStatus.CREATED);
});

export const getAccountById = asyncHandler(async (req: Request, res: Response) => {
  const { id } = req.params as Record<string, string>;
  const result = await financeService.getAccountById(id, req.employee.branch_id);
  return sendSuccess(res, result, _FINANCE_CONSTANTS._M_E_S_S_A_G_E_S.ACCOUNTS_LISTED, HttpStatus.OK);
});

export const updateAccount = asyncHandler(async (req: Request, res: Response) => {
  const { id } = req.params as Record<string, string>;
  const result = await financeService.updateAccount(id, req.employee.branch_id, req.body);
  return sendSuccess(res, result, _FINANCE_CONSTANTS._M_E_S_S_A_G_E_S.ACCOUNT_UPDATED, HttpStatus.OK);
});

export const listTransactions = asyncHandler(async (req: Request, res: Response) => {
  const result = await financeService.listTransactions(req.employee.branch_id);
  return sendSuccess(res, result, _FINANCE_CONSTANTS._M_E_S_S_A_G_E_S.TRANSACTIONS_LISTED, HttpStatus.OK);
});

export const createTransaction = asyncHandler(async (req: Request, res: Response) => {
  const { account_id, transaction_type, amount, description, reference_id } = req.body;
  const result = await financeService.createTransaction(req.employee.branch_id, account_id, transaction_type, amount, description, req.employee.id, reference_id);
  return sendSuccess(res, result, _FINANCE_CONSTANTS._M_E_S_S_A_G_E_S.TRANSACTION_CREATED, HttpStatus.CREATED);
});

export const getTransactionById = asyncHandler(async (req: Request, res: Response) => {
  const { id } = req.params as Record<string, string>;
  const result = await financeService.getTransactionById(id, req.employee.branch_id);
  return sendSuccess(res, result, _FINANCE_CONSTANTS._M_E_S_S_A_G_E_S.TRANSACTIONS_LISTED, HttpStatus.OK);
});

export const listAssets = asyncHandler(async (req: Request, res: Response) => {
  const result = await financeService.listAssets(req.employee.branch_id);
  return sendSuccess(res, result, _FINANCE_CONSTANTS._M_E_S_S_A_G_E_S.ASSETS_LISTED, HttpStatus.OK);
});

export const createAsset = asyncHandler(async (req: Request, res: Response) => {
  const { asset_name, purchase_price, depreciation_rate } = req.body;
  const result = await financeService.createAsset(req.employee.branch_id, asset_name, purchase_price, depreciation_rate);
  return sendSuccess(res, result, _FINANCE_CONSTANTS._M_E_S_S_A_G_E_S.ASSET_CREATED, HttpStatus.CREATED);
});

export const getAssetById = asyncHandler(async (req: Request, res: Response) => {
  const { id } = req.params as Record<string, string>;
  const result = await financeService.getAssetById(id, req.employee.branch_id);
  return sendSuccess(res, result, _FINANCE_CONSTANTS._M_E_S_S_A_G_E_S.ASSETS_LISTED, HttpStatus.OK);
});

export const updateAsset = asyncHandler(async (req: Request, res: Response) => {
  const { id } = req.params as Record<string, string>;
  const result = await financeService.updateAsset(id, req.employee.branch_id, req.body);
  return sendSuccess(res, result, _FINANCE_CONSTANTS._M_E_S_S_A_G_E_S.ASSET_UPDATED, HttpStatus.OK);
});

export const listRoyalties = asyncHandler(async (req: Request, res: Response) => {
  const result = await financeService.listRoyalties(req.employee.branch_id);
  return sendSuccess(res, result, _FINANCE_CONSTANTS._M_E_S_S_A_G_E_S.ROYALTIES_LISTED, HttpStatus.OK);
});

export const createRoyalty = asyncHandler(async (req: Request, res: Response) => {
  const { franchise_id, calculated_amount } = req.body;
  const result = await financeService.createRoyalty(req.employee.branch_id, franchise_id, calculated_amount);
  return sendSuccess(res, result, _FINANCE_CONSTANTS._M_E_S_S_A_G_E_S.ROYALTY_CREATED, HttpStatus.CREATED);
});

export const getRoyaltyById = asyncHandler(async (req: Request, res: Response) => {
  const { id } = req.params as Record<string, string>;
  const result = await financeService.getRoyaltyById(id, req.employee.branch_id);
  return sendSuccess(res, result, _FINANCE_CONSTANTS._M_E_S_S_A_G_E_S.ROYALTIES_LISTED, HttpStatus.OK);
});

export const payRoyalty = asyncHandler(async (req: Request, res: Response) => {
  const { id } = req.params as Record<string, string>;
  const result = await financeService.payRoyalty(id, req.employee.branch_id);
  return sendSuccess(res, result, _FINANCE_CONSTANTS._M_E_S_S_A_G_E_S.ROYALTY_PAID, HttpStatus.OK);
});
