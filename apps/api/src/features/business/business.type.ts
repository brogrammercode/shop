type Branch = {
  readonly id: string;
  readonly name: string;
  readonly branch_code: string;
  readonly address?: Address;
  readonly employees?: Employee[];
  readonly created_at: Date;
  readonly updated_at: Date;
};

type Department = {
  readonly id: string;
  readonly name: string;
  readonly branch_id: string;
  readonly created_at: Date;
  readonly updated_at: Date;
};

type Post = {
  readonly id: string;
  readonly name: string;
  readonly department_id: string;
  readonly created_at: Date;
  readonly updated_at: Date;
};

type ShiftBasis = "DAY" | "MONTH" | "YEAR";
type ShiftType = "MORNING" | "AFTERNOON" | "EVENING" | "NIGHT" | "GENERAL";

type Shift = {
  readonly id: string;
  readonly branch_id: string;
  readonly name: string;
  readonly start_time: string;
  readonly end_time: string;
  readonly basis: ShiftBasis;
  readonly type: ShiftType;
  readonly created_at: Date;
  readonly updated_at: Date;
};

type Role = {
  readonly id: string;
  readonly branch_id: string;
  readonly name: string;
  readonly permissions: readonly string[];
  readonly created_at: Date;
  readonly updated_at: Date;
};

type BankDetails = {
  readonly account_name: string;
  readonly account_number: string;
  readonly bank_name: string;
  readonly ifsc_code: string;
};

type Address = {
  readonly street: string;
  readonly city: string;
  readonly state: string;
  readonly zip: string;
  readonly country: string;
  readonly latitude?: string;
  readonly longitude?: string;
};

type Employee = {
  readonly id: string;
  readonly uid: string;
  readonly name: string;
  readonly email: string;
  readonly phone_number?: string;
  readonly bank_details: BankDetails;
  readonly address: Address;
  readonly branch_id: string;
  readonly role_id: string;
  readonly shift_id: string;
  readonly post_id: string;
  readonly created_at: Date;
  readonly updated_at: Date;
};

type BusinessJoinRequestStatus = "PENDING" | "APPROVED" | "REJECTED";

type BusinessJoinRequest = {
  readonly id: string;
  readonly uid: string;
  readonly branch_id: string;
  readonly requested_role_id?: string;
  readonly status: BusinessJoinRequestStatus;
  readonly reviewed_by_id?: string;
  readonly created_at: Date;
  readonly updated_at: Date;
  readonly user?: {
    readonly id: string;
    readonly name: string;
    readonly email: string;
    readonly avatar_url: string;
  };
  readonly branch?: Branch;
  readonly requested_role?: Role;
};

export {
  Branch,
  Department,
  Post,
  ShiftBasis,
  ShiftType,
  Shift,
  Role,
  BankDetails,
  Address,
  Employee,
  BusinessJoinRequestStatus,
  BusinessJoinRequest,
};
