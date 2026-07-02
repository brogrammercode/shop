export const _CRM_CONSTANTS = {
  _R_O_U_T_E_S: {
    _B_A_S_E: '/crm',
    _C_O_U_P_O_N_S: '/coupons',
    COUPON_BY_ID: '/coupons/:id',
    LOYALTY_TRANSACTIONS: '/loyalty',
    LOYALTY_BY_CUSTOMER: '/loyalty/customer/:customerId',
    _C_O_M_P_L_A_I_N_T_S: '/complaints',
    COMPLAINT_BY_ID: '/complaints/:id',
    COMPLAINT_STATUS: '/complaints/:id/status',
  },
  _M_E_S_S_A_G_E_S: {
    COUPON_CREATED: 'Coupon created successfully',
    COUPONS_LISTED: 'Coupons fetched successfully',
    COUPON_UPDATED: 'Coupon updated successfully',
    LOYALTY_CREATED: 'Loyalty transaction recorded successfully',
    LOYALTY_LISTED: 'Loyalty transactions fetched successfully',
    COMPLAINT_CREATED: 'Complaint recorded successfully',
    COMPLAINTS_LISTED: 'Complaints fetched successfully',
    COMPLAINT_UPDATED: 'Complaint updated successfully',
  },
  _E_R_R_O_R_S: {
    COUPON_NOT_FOUND: 'Coupon not found',
    COMPLAINT_NOT_FOUND: 'Complaint not found',
    INSUFFICIENT_LOYALTY: 'Insufficient loyalty points',
  },
  COUPON_TYPE: {
    _P_E_R_C_E_N_T: 'PERCENTAGE',
    _F_L_A_T: 'FLAT',
  },
  COMPLAINT_STATUS: {
    _O_P_E_N: 'OPEN',
    IN_PROGRESS: 'IN_PROGRESS',
    _R_E_S_O_L_V_E_D: 'RESOLVED',
    _R_E_J_E_C_T_E_D: 'REJECTED',
  },
};
