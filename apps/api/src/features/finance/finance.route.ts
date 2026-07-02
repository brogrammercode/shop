import { Router } from 'express';
import { _FINANCE_CONSTANTS } from './finance.constant';
import * as financeController from './finance.controller';
import { authenticate, requireFinanceAccess } from './finance.middleware';

const router = Router();

router.use(authenticate, requireFinanceAccess);

router.get(_FINANCE_CONSTANTS._R_O_U_T_E_S._A_C_C_O_U_N_T_S, financeController.listAccounts);
router.post(_FINANCE_CONSTANTS._R_O_U_T_E_S._A_C_C_O_U_N_T_S, financeController.createAccount);
router.get(_FINANCE_CONSTANTS._R_O_U_T_E_S.ACCOUNT_BY_ID, financeController.getAccountById);
router.patch(_FINANCE_CONSTANTS._R_O_U_T_E_S.ACCOUNT_BY_ID, financeController.updateAccount);

router.get(_FINANCE_CONSTANTS._R_O_U_T_E_S._T_R_A_N_S_A_C_T_I_O_N_S, financeController.listTransactions);
router.post(_FINANCE_CONSTANTS._R_O_U_T_E_S._T_R_A_N_S_A_C_T_I_O_N_S, financeController.createTransaction);
router.get(_FINANCE_CONSTANTS._R_O_U_T_E_S.TRANSACTION_BY_ID, financeController.getTransactionById);

router.get(_FINANCE_CONSTANTS._R_O_U_T_E_S._A_S_S_E_T_S, financeController.listAssets);
router.post(_FINANCE_CONSTANTS._R_O_U_T_E_S._A_S_S_E_T_S, financeController.createAsset);
router.get(_FINANCE_CONSTANTS._R_O_U_T_E_S.ASSET_BY_ID, financeController.getAssetById);
router.patch(_FINANCE_CONSTANTS._R_O_U_T_E_S.ASSET_BY_ID, financeController.updateAsset);

router.get(_FINANCE_CONSTANTS._R_O_U_T_E_S._R_O_Y_A_L_T_I_E_S, financeController.listRoyalties);
router.post(_FINANCE_CONSTANTS._R_O_U_T_E_S._R_O_Y_A_L_T_I_E_S, financeController.createRoyalty);
router.get(_FINANCE_CONSTANTS._R_O_U_T_E_S.ROYALTY_BY_ID, financeController.getRoyaltyById);
router.patch(_FINANCE_CONSTANTS._R_O_U_T_E_S.ROYALTY_PAY, financeController.payRoyalty);

export default router;
