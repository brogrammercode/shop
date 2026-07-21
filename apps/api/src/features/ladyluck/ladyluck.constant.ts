export const _LADYLUCK_CONSTANTS = {
  _R_O_U_T_E_S: {
    SUMMARY: '/summary',
    SCRATCH_CARD: '/scratch-cards/:id/scratch',
    CUSTOMER_SUMMARY: '/customers/:uid/summary',
    CUSTOMER_SCRATCH_CARD: '/customers/:uid/scratch-cards/:id/scratch',
  },
  _Q_U_E_R_Y: {
    BRANCH_ID: 'branch_id',
  },
  _B_O_D_Y: {
    BRANCH_ID: 'branch_id',
  },
  _M_E_S_S_A_G_E_S: {
    SUMMARY_FETCHED: 'Ladyluck summary fetched successfully',
    CARD_SCRATCHED: 'Scratch card unlocked successfully',
  },
  _E_R_R_O_R_S: {
    BRANCH_REQUIRED: 'Branch is required',
    CARD_NOT_FOUND: 'Scratch card not found',
    CARD_NOT_AVAILABLE: 'Scratch card is not available',
    DISCOUNT_NOT_FOUND: 'Ladyluck discount not found',
    DISCOUNT_NOT_ACTIVE: 'Ladyluck discount is not active',
    DISCOUNT_MINIMUM_NOT_MET: 'Minimum order amount is not met for this Ladyluck discount',
    ORDER_NOT_REWARDABLE: 'Order cannot earn Ladyluck points',
  },
  _D_E_F_A_U_L_T_S: {
    POINTS_PER_CARD: 500,
    CARD_VALID_DAYS: 30,
    DISCOUNT_VALID_DAYS: 7,
    ZERO: 0,
    ONE: 1,
    HUNDRED: 100,
  },
  _R_E_W_A_R_D_S: [
    {
      WEIGHT: 40,
      DISCOUNT_TYPE: 'FLAT',
      DISCOUNT_VALUE: 20,
      MIN_ORDER_AMOUNT: 199,
      MAX_DISCOUNT_AMOUNT: null,
    },
    {
      WEIGHT: 30,
      DISCOUNT_TYPE: 'FLAT',
      DISCOUNT_VALUE: 40,
      MIN_ORDER_AMOUNT: 299,
      MAX_DISCOUNT_AMOUNT: null,
    },
    {
      WEIGHT: 20,
      DISCOUNT_TYPE: 'FLAT',
      DISCOUNT_VALUE: 60,
      MIN_ORDER_AMOUNT: 399,
      MAX_DISCOUNT_AMOUNT: null,
    },
    {
      WEIGHT: 8,
      DISCOUNT_TYPE: 'PERCENTAGE',
      DISCOUNT_VALUE: 10,
      MIN_ORDER_AMOUNT: 399,
      MAX_DISCOUNT_AMOUNT: 80,
    },
    {
      WEIGHT: 2,
      DISCOUNT_TYPE: 'FLAT',
      DISCOUNT_VALUE: 100,
      MIN_ORDER_AMOUNT: 599,
      MAX_DISCOUNT_AMOUNT: null,
    },
  ],
} as const;
