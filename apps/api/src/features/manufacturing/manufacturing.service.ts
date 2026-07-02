import { manufacturingRepo } from './manufacturing.repo';
import { inventoryRepo } from '../inventory/inventory.repo';
import { _MANUFACTURING_CONSTANTS } from './manufacturing.constant';
import { AppError, NotFoundError, BadRequestError } from '../../utils/error';
import { HttpStatus } from '../../constants/status';
import { BatchStatus, QCType } from '@prisma/client';

export class ManufacturingService {
  async createBOM(branchId: string, output_variant_id: string, instructions?: string, estimated_time_mins?: number) {
    return manufacturingRepo.createBOM({ branch_id: branchId, output_variant_id, instructions, estimated_time_mins, yield_quantity: 1 });
  }

  async listBOMs(branchId: string) {
    return manufacturingRepo.findBOMsByBranch(branchId);
  }

  async getBOMById(id: string, branchId: string) {
    const bom = await manufacturingRepo.findBOMById(id);
    if (!bom || bom.branch_id !== branchId) {
      throw new NotFoundError(_MANUFACTURING_CONSTANTS._E_R_R_O_R_S.BOM_NOT_FOUND);
    }
    return bom;
  }

  async updateBOM(id: string, branchId: string, data: any) {
    await this.getBOMById(id, branchId);
    return manufacturingRepo.updateBOM(id, data);
  }

  async deleteBOM(id: string, branchId: string) {
    await this.getBOMById(id, branchId);
    return manufacturingRepo.deleteBOM(id);
  }

  async addBOMItem(bom_id: string, branchId: string, input_variant_id: string, quantity: number) {
    await this.getBOMById(bom_id, branchId);
    return manufacturingRepo.addBOMItem({ bom_id, input_variant_id, quantity });
  }

  async removeBOMItem(bom_id: string, input_variant_id: string, branchId: string) {
    await this.getBOMById(bom_id, branchId);
    return manufacturingRepo.removeBOMItem(bom_id, input_variant_id);
  }

  async createBatch(branchId: string, bom_id: string, batch_number: string, planned_qty: number, supervisor_id?: string) {
    await this.getBOMById(bom_id, branchId);
    return manufacturingRepo.createBatch({
      branch_id: branchId,
      bom_id,
      batch_number,
      planned_qty,
      status: 'PLANNED',
      supervisor_id,
    });
  }

  async listBatches(branchId: string) {
    return manufacturingRepo.findBatchesByBranch(branchId);
  }

  async getBatchById(id: string, branchId: string) {
    const batch = await manufacturingRepo.findBatchById(id);
    if (!batch || batch.branch_id !== branchId) {
      throw new NotFoundError(_MANUFACTURING_CONSTANTS._E_R_R_O_R_S.BATCH_NOT_FOUND);
    }
    return batch;
  }

  async updateBatchStatus(id: string, branchId: string, status: BatchStatus, employeeId: string, produced_qty?: number) {
    const batch = await this.getBatchById(id, branchId);
    const bom = await this.getBOMById(batch.bom_id, branchId);

    if (status === 'IN_PROGRESS' && batch.status === 'PLANNED') {
      // Deduct raw materials (BOM items * planned_qty)
      for (const item of bom.ingredients) {
        const requiredQty = item.quantity * batch.planned_qty;
        const lastEntry = await inventoryRepo.getLastStockEntryForVariant(item.input_variant_id);
        const currentBalance = lastEntry?.running_balance || 0;
        
        if (currentBalance < requiredQty) {
          throw new BadRequestError(`Insufficient stock for variant ${item.input_variant_id}`);
        }

        await inventoryRepo.createStockEntry({
          branch_id: branchId,
          variant_id: item.input_variant_id,
          transaction_type: 'PRODUCTION_OUT',
          quantity_change: -requiredQty,
          running_balance: currentBalance - requiredQty,
          reference_id: batch.id,
          created_by: employeeId,
        });
      }
      return manufacturingRepo.updateBatchStatus(id, status, undefined, undefined);
    } else if (status === 'COMPLETED' && batch.status === 'IN_PROGRESS') {
      if (produced_qty === undefined) throw new BadRequestError('Produced quantity is required to complete batch');
      // Add produced goods
      const lastEntry = await inventoryRepo.getLastStockEntryForVariant(bom.output_variant_id);
      const currentBalance = lastEntry?.running_balance || 0;
      
      await inventoryRepo.createStockEntry({
        branch_id: branchId,
        variant_id: bom.output_variant_id,
        transaction_type: 'PRODUCTION_IN',
        quantity_change: produced_qty,
        running_balance: currentBalance + produced_qty,
        reference_id: batch.id,
        created_by: employeeId,
      });

      return manufacturingRepo.updateBatchStatus(id, status, produced_qty, new Date());
    } else {
      // Allow other simple status updates (e.g. Cancelled from planned)
      return manufacturingRepo.updateBatchStatus(id, status);
    }
  }

  async createQCAudit(branchId: string, batch_id: string, auditor_name: string, audit_type: QCType, result_value: string, notes?: string) {
    await this.getBatchById(batch_id, branchId);
    return manufacturingRepo.createQCAudit({ branch_id: branchId, batch_id, auditor_name, audit_type, result_value, notes });
  }

  async listQCAudits(branchId: string) {
    return manufacturingRepo.findQCAuditsByBranch(branchId);
  }

  async getQCAuditById(id: string, branchId: string) {
    const audit = await manufacturingRepo.findQCAuditById(id);
    if (!audit || audit.branch_id !== branchId) {
      throw new NotFoundError(_MANUFACTURING_CONSTANTS._E_R_R_O_R_S.QC_AUDIT_NOT_FOUND);
    }
    return audit;
  }

  async createWastageLog(branchId: string, variant_id: string, quantity: number, reason: string, logged_by: string, batch_id?: string) {
    if (batch_id) {
      await this.getBatchById(batch_id, branchId);
    }
    const log = await manufacturingRepo.createWastageLog({ branch_id: branchId, variant_id, quantity, reason, logged_by });
    
    // Deduct stock
    const lastEntry = await inventoryRepo.getLastStockEntryForVariant(variant_id);
    const currentBalance = lastEntry?.running_balance || 0;
    
    if (currentBalance < quantity) {
      throw new BadRequestError('Insufficient stock to log wastage');
    }

    await inventoryRepo.createStockEntry({
      branch_id: branchId,
      variant_id,
      transaction_type: 'WASTAGE',
      quantity_change: -quantity,
      running_balance: currentBalance - quantity,
      reference_id: log.id,
      created_by: logged_by,
    });

    return log;
  }

  async listWastageLogs(branchId: string) {
    return manufacturingRepo.findWastageLogsByBranch(branchId);
  }
}

export const manufacturingService = new ManufacturingService();
