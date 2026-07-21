import { Router } from 'express';
import { authenticate, requireBranchEmployee } from '../core_hr/core_hr.middleware';
import { _LADYLUCK_CONSTANTS } from './ladyluck.constant';
import * as ladyluckController from './ladyluck.controller';

const router = Router();

router.use(authenticate);

router.get(
  _LADYLUCK_CONSTANTS._R_O_U_T_E_S.CUSTOMER_SUMMARY,
  requireBranchEmployee,
  ladyluckController.getCustomerSummary,
);

router.post(
  _LADYLUCK_CONSTANTS._R_O_U_T_E_S.CUSTOMER_SCRATCH_CARD,
  requireBranchEmployee,
  ladyluckController.scratchCustomerCard,
);

router.get(
  _LADYLUCK_CONSTANTS._R_O_U_T_E_S.SUMMARY,
  ladyluckController.getSummary,
);

router.post(
  _LADYLUCK_CONSTANTS._R_O_U_T_E_S.SCRATCH_CARD,
  ladyluckController.scratchCard,
);

export default router;
