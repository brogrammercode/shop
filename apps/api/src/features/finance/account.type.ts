// Auto-generated DTO file for Account

import { BankDetailDTO } from './bank_detail.type';

export interface AccountDTO {
  id: string;
  branch_id: string;
  name: string;
  avatar?: string;
  account_type: string;
  status: string;
  created_at: string | Date;
  updated_at: string | Date;
  is_deleted: boolean;
  bank_details?: BankDetailDTO[];
}
