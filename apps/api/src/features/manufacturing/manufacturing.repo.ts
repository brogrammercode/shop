import { BatchStatus, QCType } from '@prisma/client';
import prisma from '../../infra/database/client';
export class ManufacturingRepo {
  async createBOM(data: { branch_id: string; output_variant_id: string; instructions?: string; estimated_time_mins?: number; yield_quantity: number }) {
    return prisma.billOfMaterial.create({ data });
  }

  async findBOMsByBranch(branchId: string) {
    return prisma.billOfMaterial.findMany({ where: { branch_id: branchId }, include: { output_variant: true } });
  }

  async findBOMById(id: string) {
    return prisma.billOfMaterial.findUnique({ where: { id }, include: { ingredients: true, output_variant: true } });
  }

  async updateBOM(id: string, data: Partial<{ instructions: string; estimated_time_mins: number }>) {
    return prisma.billOfMaterial.update({ where: { id }, data });
  }

  async deleteBOM(id: string) {
    return prisma.billOfMaterial.delete({ where: { id } });
  }

  async addBOMItem(data: { bom_id: string; input_variant_id: string; quantity: number }) {
    return prisma.bOMItem.create({ data });
  }

  async removeBOMItem(bom_id: string, input_variant_id: string) {
    return prisma.bOMItem.deleteMany({ where: { bom_id, input_variant_id } });
  }

  async createBatch(data: { branch_id: string; bom_id: string; batch_number: string; planned_qty: number; produced_qty?: number; status: BatchStatus; supervisor_id?: string; start_time?: Date; end_time?: Date }) {
    return prisma.productionBatch.create({ data });
  }

  async findBatchesByBranch(branchId: string) {
    return prisma.productionBatch.findMany({ where: { branch_id: branchId }, include: { bom: true }, orderBy: { created_at: 'desc' } });
  }

  async findBatchById(id: string) {
    return prisma.productionBatch.findUnique({ where: { id }, include: { bom: true, audits: true, wastes: true } });
  }

  async updateBatchStatus(id: string, status: BatchStatus, produced_qty?: number, end_time?: Date) {
    const data: any = { status };
    if (produced_qty !== undefined) data.produced_qty = produced_qty;
    if (end_time !== undefined) data.end_time = end_time;
    return prisma.productionBatch.update({ where: { id }, data });
  }

  async createQCAudit(data: { branch_id: string; batch_id?: string; audit_type: any; result_value: string; notes?: string; auditor_name?: string }) {
    return prisma.qCAudit.create({ data });
  }

  async findQCAuditsByBranch(branchId: string) {
    return prisma.qCAudit.findMany({ where: { branch_id: branchId }, include: { batch: true }, orderBy: { created_at: 'desc' } });
  }

  async findQCAuditById(id: string) {
    return prisma.qCAudit.findUnique({ where: { id }, include: { batch: true } });
  }

  async createWastageLog(data: { branch_id: string; variant_id: string; quantity: number; reason: string; logged_by: string }) {
    return prisma.wastageLog.create({ data });
  }

  async findWastageLogsByBranch(branchId: string) {
    return prisma.wastageLog.findMany({ where: { branch_id: branchId }, orderBy: { created_at: 'desc' } });
  }

  async findWastageLogById(id: string) {
    return prisma.wastageLog.findUnique({ where: { id } });
  }
}

export const manufacturingRepo = new ManufacturingRepo();
