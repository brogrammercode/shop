import { Router } from 'express';
import { _MANUFACTURING_CONSTANTS } from './manufacturing.constant';
import * as manufacturingController from './manufacturing.controller';
import { authenticate, requireManufacturingAccess } from './manufacturing.middleware';

const router = Router();

router.use(authenticate, requireManufacturingAccess);

router.get(_MANUFACTURING_CONSTANTS._R_O_U_T_E_S._B_O_M_S, manufacturingController.listBOMs);
router.post(_MANUFACTURING_CONSTANTS._R_O_U_T_E_S._B_O_M_S, manufacturingController.createBOM);
router.get(_MANUFACTURING_CONSTANTS._R_O_U_T_E_S.BOM_BY_ID, manufacturingController.getBOMById);
router.patch(_MANUFACTURING_CONSTANTS._R_O_U_T_E_S.BOM_BY_ID, manufacturingController.updateBOM);
router.delete(_MANUFACTURING_CONSTANTS._R_O_U_T_E_S.BOM_BY_ID, manufacturingController.deleteBOM);
router.post(_MANUFACTURING_CONSTANTS._R_O_U_T_E_S.BOM_ITEMS, manufacturingController.addBOMItem);
router.delete(_MANUFACTURING_CONSTANTS._R_O_U_T_E_S.BOM_ITEMS, manufacturingController.removeBOMItem);

router.get(_MANUFACTURING_CONSTANTS._R_O_U_T_E_S._B_A_T_C_H_E_S, manufacturingController.listBatches);
router.post(_MANUFACTURING_CONSTANTS._R_O_U_T_E_S._B_A_T_C_H_E_S, manufacturingController.createBatch);
router.get(_MANUFACTURING_CONSTANTS._R_O_U_T_E_S.BATCH_BY_ID, manufacturingController.getBatchById);
router.patch(_MANUFACTURING_CONSTANTS._R_O_U_T_E_S.BATCH_STATUS, manufacturingController.updateBatchStatus);

router.get(_MANUFACTURING_CONSTANTS._R_O_U_T_E_S.QC_AUDITS, manufacturingController.listQCAudits);
router.post(_MANUFACTURING_CONSTANTS._R_O_U_T_E_S.QC_AUDITS, manufacturingController.createQCAudit);
router.get(_MANUFACTURING_CONSTANTS._R_O_U_T_E_S.QC_AUDIT_BY_ID, manufacturingController.getQCAuditById);

router.get(_MANUFACTURING_CONSTANTS._R_O_U_T_E_S.WASTAGE_LOGS, manufacturingController.listWastageLogs);
router.post(_MANUFACTURING_CONSTANTS._R_O_U_T_E_S.WASTAGE_LOGS, manufacturingController.createWastageLog);

export default router;
