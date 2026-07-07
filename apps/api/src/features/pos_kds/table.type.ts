export interface TableDTO {
  id: string;
  branch_id: string;
  zone_id: string;
  table_number: string;
  capacity: number;
  side_count: number;
  side_labels?: string[];
  status: string;
  created_at: string | Date;
  updated_at: string | Date;
  is_deleted: boolean;
}
