// Auto-generated DTO file for Supplier

import { AddressDTO } from '../core_hr/address.type';
import { BankDetailDTO } from '../finance/bank_detail.type';

export interface SupplierDTO {
  id: string;
  branch_id: string;
  name: string;
  avatar?: string;
  tax_number?: string;
  contact_email?: string;
  contact_phone?: string;
  status: string;
  created_at: string | Date;
  updated_at: string | Date;
  is_deleted: boolean;
  addresses?: AddressDTO[];
  bank_details?: BankDetailDTO[];
}
