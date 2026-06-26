// Auto-generated DTO file for Branch

import { AddressDTO } from './address.type';
import { BankDetailDTO } from '../finance/bank_detail.type';

export interface BranchDTO {
  id: string;
  name: string;
  code: string;
  is_hq: boolean;
  status: string;
  created_at: string | Date;
  updated_at: string | Date;
  created_by?: string;
  updated_by?: string;
  is_deleted: boolean;
  franchise?: string;
  addresses?: AddressDTO[];
  bank_details?: BankDetailDTO[];
}
