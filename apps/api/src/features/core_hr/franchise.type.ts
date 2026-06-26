// Auto-generated DTO file for Franchise

import { BankDetailDTO } from '../finance/bank_detail.type';

export interface FranchiseDTO {
  id: string;
  branch_id: string;
  owner_name: string;
  royalty_pct: number;
  agreement_doc?: string;
  created_at: string | Date;
  updated_at: string | Date;
  is_deleted: boolean;
  bank_details?: BankDetailDTO[];
}
