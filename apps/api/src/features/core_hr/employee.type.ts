// Auto-generated DTO file for Employee

import { AddressDTO } from './address.type';

export interface EmployeeDTO {
  id: string;
  branch_id: string;
  uid: string;
  department?: string;
  post?: string;
  shift?: string;
  role?: string;
  status: string;
  created_at: string | Date;
  updated_at: string | Date;
  is_deleted: boolean;
  addresses?: AddressDTO[];
}
