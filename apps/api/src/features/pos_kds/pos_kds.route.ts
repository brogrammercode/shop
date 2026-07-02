import { Router } from 'express';
import { _POS_KDS_CONSTANTS } from './pos_kds.constant';
import * as posKdsController from './pos_kds.controller';
import { authenticate, requirePosKdsAccess } from './pos_kds.middleware';

const router = Router();

router.use(authenticate, requirePosKdsAccess);

router.get(_POS_KDS_CONSTANTS._R_O_U_T_E_S._O_R_D_E_R_S, posKdsController.listOrders);
router.post(_POS_KDS_CONSTANTS._R_O_U_T_E_S._O_R_D_E_R_S, posKdsController.createOrder);
router.get(_POS_KDS_CONSTANTS._R_O_U_T_E_S.ORDER_BY_ID, posKdsController.getOrderById);
router.patch(_POS_KDS_CONSTANTS._R_O_U_T_E_S.ORDER_PAY, posKdsController.payOrder);
router.patch(_POS_KDS_CONSTANTS._R_O_U_T_E_S.ORDER_REFUND, posKdsController.refundOrder);
router.patch(_POS_KDS_CONSTANTS._R_O_U_T_E_S.ORDER_CANCEL, posKdsController.cancelOrder);

router.get(_POS_KDS_CONSTANTS._R_O_U_T_E_S._T_A_B_L_E_S, posKdsController.listTables);
router.post(_POS_KDS_CONSTANTS._R_O_U_T_E_S._T_A_B_L_E_S, posKdsController.createTable);
router.get(_POS_KDS_CONSTANTS._R_O_U_T_E_S.TABLE_BY_ID, posKdsController.getTableById);
router.patch(_POS_KDS_CONSTANTS._R_O_U_T_E_S.TABLE_BY_ID, posKdsController.updateTable);
router.delete(_POS_KDS_CONSTANTS._R_O_U_T_E_S.TABLE_BY_ID, posKdsController.deleteTable);

router.get(_POS_KDS_CONSTANTS._R_O_U_T_E_S._K_O_T_S, posKdsController.listKOTs);
router.get(_POS_KDS_CONSTANTS._R_O_U_T_E_S.KOT_BY_ID, posKdsController.getKOTById);
router.patch(_POS_KDS_CONSTANTS._R_O_U_T_E_S.KOT_STATUS, posKdsController.updateKOTStatus);

router.get(_POS_KDS_CONSTANTS._R_O_U_T_E_S._P_A_Y_M_E_N_T_S, posKdsController.listPayments);
router.get(_POS_KDS_CONSTANTS._R_O_U_T_E_S.PAYMENT_BY_ID, posKdsController.getPaymentById);

export default router;
