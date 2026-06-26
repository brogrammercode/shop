// Auto-generated DTO file for DeliveryPartner

import { AddressDTO } from '../core_hr/address.type';
import { BankDetailDTO } from '../finance/bank_detail.type';

export interface DeliveryPartnerDTO {
  id: string;
  branch_id: string;
  name: string;
  avatar?: string;
  commission_pct: number;
  status: string;
  created_at: string | Date;
  updated_at: string | Date;
  is_deleted: boolean;
  addresses?: AddressDTO[];
  bank_details?: BankDetailDTO[];
}
