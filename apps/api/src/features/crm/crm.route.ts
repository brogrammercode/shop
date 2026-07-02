import { Router } from 'express';
import { _CRM_CONSTANTS } from './crm.constant';
import * as crmController from './crm.controller';
import { authenticate, requireCrmAccess } from './crm.middleware';

const router = Router();

router.use(authenticate, requireCrmAccess);

router.get(_CRM_CONSTANTS._R_O_U_T_E_S._C_O_U_P_O_N_S, crmController.listCoupons);
router.post(_CRM_CONSTANTS._R_O_U_T_E_S._C_O_U_P_O_N_S, crmController.createCoupon);
router.get(_CRM_CONSTANTS._R_O_U_T_E_S.COUPON_BY_ID, crmController.getCouponById);
router.patch(_CRM_CONSTANTS._R_O_U_T_E_S.COUPON_BY_ID, crmController.updateCoupon);

router.post(_CRM_CONSTANTS._R_O_U_T_E_S.LOYALTY_TRANSACTIONS, crmController.createLoyaltyTransaction);
router.get(_CRM_CONSTANTS._R_O_U_T_E_S.LOYALTY_BY_CUSTOMER, crmController.getLoyaltyByCustomer);

router.get(_CRM_CONSTANTS._R_O_U_T_E_S._C_O_M_P_L_A_I_N_T_S, crmController.listComplaints);
router.post(_CRM_CONSTANTS._R_O_U_T_E_S._C_O_M_P_L_A_I_N_T_S, crmController.createComplaint);
router.get(_CRM_CONSTANTS._R_O_U_T_E_S.COMPLAINT_BY_ID, crmController.getComplaintById);
router.patch(_CRM_CONSTANTS._R_O_U_T_E_S.COMPLAINT_STATUS, crmController.updateComplaintStatus);

export default router;
