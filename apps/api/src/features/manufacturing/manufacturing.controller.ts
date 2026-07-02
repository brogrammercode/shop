import { Request, Response } from 'express';
import { asyncHandler } from '../../utils/async';
import { sendSuccess } from '../../utils/error';
import { HttpStatus } from '../../constants/status';
import { manufacturingService } from './manufacturing.service';
import { _MANUFACTURING_CONSTANTS } from './manufacturing.constant';

export const listBOMs = asyncHandler(async (req: Request, res: Response) => {
  const result = await manufacturingService.listBOMs(req.employee.branch_id);
  return sendSuccess(res, result, _MANUFACTURING_CONSTANTS._M_E_S_S_A_G_E_S.BOMS_LISTED, HttpStatus.OK);
});

export const createBOM = asyncHandler(async (req: Request, res: Response) => {
  const { output_variant_id, instructions, estimated_time_mins } = req.body;
  const result = await manufacturingService.createBOM(req.employee.branch_id, output_variant_id, instructions, estimated_time_mins);
  return sendSuccess(res, result, _MANUFACTURING_CONSTANTS._M_E_S_S_A_G_E_S.BOM_CREATED, HttpStatus.CREATED);
});

export const getBOMById = asyncHandler(async (req: Request, res: Response) => {
  const { id } = req.params as Record<string, string>;
  const result = await manufacturingService.getBOMById(id, req.employee.branch_id);
  return sendSuccess(res, result, _MANUFACTURING_CONSTANTS._M_E_S_S_A_G_E_S.BOMS_LISTED, HttpStatus.OK);
});

export const updateBOM = asyncHandler(async (req: Request, res: Response) => {
  const { id } = req.params as Record<string, string>;
  const result = await manufacturingService.updateBOM(id, req.employee.branch_id, req.body);
  return sendSuccess(res, result, _MANUFACTURING_CONSTANTS._M_E_S_S_A_G_E_S.BOM_UPDATED, HttpStatus.OK);
});

export const deleteBOM = asyncHandler(async (req: Request, res: Response) => {
  const { id } = req.params as Record<string, string>;
  const result = await manufacturingService.deleteBOM(id, req.employee.branch_id);
  return sendSuccess(res, result, _MANUFACTURING_CONSTANTS._M_E_S_S_A_G_E_S.BOM_DELETED, HttpStatus.OK);
});

export const addBOMItem = asyncHandler(async (req: Request, res: Response) => {
  const { id } = req.params as Record<string, string>;
  const { input_variant_id, quantity } = req.body;
  const result = await manufacturingService.addBOMItem(id, req.employee.branch_id, input_variant_id, quantity);
  return sendSuccess(res, result, _MANUFACTURING_CONSTANTS._M_E_S_S_A_G_E_S.BOM_ITEM_ADDED, HttpStatus.CREATED);
});

export const removeBOMItem = asyncHandler(async (req: Request, res: Response) => {
  const { id } = req.params as Record<string, string>;
  const { input_variant_id } = req.body; // or could be a path param
  const result = await manufacturingService.removeBOMItem(id, input_variant_id, req.employee.branch_id);
  return sendSuccess(res, result, _MANUFACTURING_CONSTANTS._M_E_S_S_A_G_E_S.BOM_ITEM_REMOVED, HttpStatus.OK);
});

export const listBatches = asyncHandler(async (req: Request, res: Response) => {
  const result = await manufacturingService.listBatches(req.employee.branch_id);
  return sendSuccess(res, result, _MANUFACTURING_CONSTANTS._M_E_S_S_A_G_E_S.BATCHES_LISTED, HttpStatus.OK);
});

export const createBatch = asyncHandler(async (req: Request, res: Response) => {
  const { bom_id, batch_number, planned_qty } = req.body;
  const result = await manufacturingService.createBatch(req.employee.branch_id, bom_id, batch_number, planned_qty, req.employee.id);
  return sendSuccess(res, result, _MANUFACTURING_CONSTANTS._M_E_S_S_A_G_E_S.BATCH_CREATED, HttpStatus.CREATED);
});

export const getBatchById = asyncHandler(async (req: Request, res: Response) => {
  const { id } = req.params as Record<string, string>;
  const result = await manufacturingService.getBatchById(id, req.employee.branch_id);
  return sendSuccess(res, result, _MANUFACTURING_CONSTANTS._M_E_S_S_A_G_E_S.BATCHES_LISTED, HttpStatus.OK);
});

export const updateBatchStatus = asyncHandler(async (req: Request, res: Response) => {
  const { id } = req.params as Record<string, string>;
  const { status, produced_qty } = req.body;
  const result = await manufacturingService.updateBatchStatus(id, req.employee.branch_id, status, req.employee.id, produced_qty);
  return sendSuccess(res, result, _MANUFACTURING_CONSTANTS._M_E_S_S_A_G_E_S.BATCH_STATUS_UPDATED, HttpStatus.OK);
});

export const listQCAudits = asyncHandler(async (req: Request, res: Response) => {
  const result = await manufacturingService.listQCAudits(req.employee.branch_id);
  return sendSuccess(res, result, _MANUFACTURING_CONSTANTS._M_E_S_S_A_G_E_S.QC_AUDITS_LISTED, HttpStatus.OK);
});

export const createQCAudit = asyncHandler(async (req: Request, res: Response) => {
  const { batch_id, status, remarks } = req.body;
  const result = await manufacturingService.createQCAudit(req.employee.branch_id, batch_id, req.employee.id, status, remarks);
  return sendSuccess(res, result, _MANUFACTURING_CONSTANTS._M_E_S_S_A_G_E_S.QC_AUDIT_CREATED, HttpStatus.CREATED);
});

export const getQCAuditById = asyncHandler(async (req: Request, res: Response) => {
  const { id } = req.params as Record<string, string>;
  const result = await manufacturingService.getQCAuditById(id, req.employee.branch_id);
  return sendSuccess(res, result, _MANUFACTURING_CONSTANTS._M_E_S_S_A_G_E_S.QC_AUDITS_LISTED, HttpStatus.OK);
});

export const listWastageLogs = asyncHandler(async (req: Request, res: Response) => {
  const result = await manufacturingService.listWastageLogs(req.employee.branch_id);
  return sendSuccess(res, result, _MANUFACTURING_CONSTANTS._M_E_S_S_A_G_E_S.WASTAGE_LOGS_LISTED, HttpStatus.OK);
});

export const createWastageLog = asyncHandler(async (req: Request, res: Response) => {
  const { variant_id, quantity, reason, batch_id } = req.body;
  const result = await manufacturingService.createWastageLog(req.employee.branch_id, variant_id, quantity, reason, req.employee.id, batch_id);
  return sendSuccess(res, result, _MANUFACTURING_CONSTANTS._M_E_S_S_A_G_E_S.WASTAGE_LOG_CREATED, HttpStatus.CREATED);
});
