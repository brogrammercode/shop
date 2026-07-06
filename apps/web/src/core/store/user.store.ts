import { create } from 'zustand';
import { persist } from 'zustand/middleware';

export interface UserModel {
  id: string;
  email: string;
  name: string;
  user_id: string;
  image: string;
  cover: string;
  bio: string;
  created_at: string;
  updated_at: string;
  roles?: { role: { name: string } }[];
}

export interface AddressModel {
  id: string;
  address_line_1: string;
  address_line_2?: string;
  city: string;
  state: string;
  postal_code: string;
}

export interface BankDetailModel {
  id: string;
  account_name: string;
  account_number: string;
  bank_name: string;
  ifsc_code: string;
}

export interface EmployeeContext {
  branch_id: string;
  employee_id: string;
  business_id: string;
  role_name?: string;
}

interface UserState {
  token: string | null;
  user: UserModel | null;
  addresses: AddressModel[];
  bankDetails: BankDetailModel[];
  employeeContext: EmployeeContext | null;
  
  setAuth: (token: string, user: UserModel) => void;
  setAddresses: (addresses: AddressModel[]) => void;
  setBankDetails: (details: BankDetailModel[]) => void;
  setEmployeeContext: (context: EmployeeContext) => void;
  clearContext: () => void;
}

export const useUserStore = create<UserState>()(
  persist(
    (set) => ({
      token: null,
      user: null,
      addresses: [],
      bankDetails: [],
      employeeContext: null,

      setAuth: (token, user) => set({ token, user }),
      setAddresses: (addresses) => set({ addresses }),
      setBankDetails: (bankDetails) => set({ bankDetails }),
      setEmployeeContext: (employeeContext) => set({ employeeContext }),
      
      clearContext: () => set({
        token: null,
        user: null,
        addresses: [],
        bankDetails: [],
        employeeContext: null,
      }),
    }),
    {
      name: 'ladyluck-user-storage',
    }
  )
);
