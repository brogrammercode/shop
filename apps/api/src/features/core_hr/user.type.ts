// Auto-generated DTO file for User

import { AddressDTO } from './address.type';
import { BankDetailDTO } from '../finance/bank_detail.type';

export interface UserDTO {
  id: string;
  name: string;
  avatar?: string;
  phone: string;
  email?: string;
  status: string;
  created_at: string | Date;
  updated_at: string | Date;
  is_deleted: boolean;
  employee?: string;
  addresses?: AddressDTO[];
  bank_details?: BankDetailDTO[];
}
