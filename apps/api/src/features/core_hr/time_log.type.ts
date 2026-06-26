// Auto-generated DTO file for TimeLog

export interface TimeLogDTO {
  id: string;
  branch_id: string;
  employee_id: string;
  clock_in: string | Date;
  clock_out?: string | Date;
  total_hours?: number;
  created_at: string | Date;
  updated_at: string | Date;
}
