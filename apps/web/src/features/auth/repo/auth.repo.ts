import { apiClient } from '@/core/api/client';
import { AddressModel, BankDetailModel, EmployeeContext, useUserStore, UserModel } from '@/core/store/user.store';

export interface VerifyOtpResponse {
  user: UserModel;
  tokens: { accessToken: string; refreshToken: string };
  employeeContext?: unknown;
  addresses?: AddressModel[];
  bankDetails?: BankDetailModel[];
  requires_phone?: boolean;
}

interface UserSessionResponse {
  user: UserModel;
  employee?: unknown;
  employeeContext?: unknown;
  addresses?: unknown[];
  bankDetails?: unknown[];
  requires_phone?: boolean;
}

export class AuthRepo {
  static async sendOtp(phoneNumber: string): Promise<void> {
    const response = await apiClient.post('/hr/auth/send-otp', { phone_number: phoneNumber });
    return response.data?.data;
  }

  static async verifyOtp(phoneNumber: string, otp: string): Promise<VerifyOtpResponse> {
    const response = await apiClient.post('/hr/auth/login', { phone_number: phoneNumber, otp });
    const data = response.data?.data;
    applySessionData(data);
    
    return data;
  }

  static async loginWithGoogle(idToken: string): Promise<VerifyOtpResponse> {
    const response = await apiClient.post('/hr/auth/login', { id_token: idToken });
    const data = response.data?.data;
    applySessionData(data);
    return data;
  }

  static async completePhone(phoneNumber: string): Promise<VerifyOtpResponse> {
    const response = await apiClient.post('/hr/auth/complete-phone', { phone: phoneNumber });
    const data = response.data?.data;
    applySessionData(data);
    return data;
  }

  static async loadCurrentUser(): Promise<UserSessionResponse> {
    const response = await apiClient.get('/hr/auth/me');
    const data = response.data?.data as UserSessionResponse;
    const store = useUserStore.getState();
    const token = store.token;

    if (token && data?.user) {
      store.setAuth(token, data.user, Boolean(data.requires_phone));
    }
    if (data?.addresses) {
      store.setAddresses(data.addresses.map(normalizeAddress));
    }
    if (data?.bankDetails) {
      store.setBankDetails(data.bankDetails as BankDetailModel[]);
    }
    return data;
  }
}

const applySessionData = (data?: VerifyOtpResponse) => {
  if (!data?.tokens?.accessToken || !data.user) {
    return;
  }

  const store = useUserStore.getState();
  store.setAuth(data.tokens.accessToken, data.user, Boolean(data.requires_phone));

  if (data.addresses) {
    store.setAddresses(data.addresses.map(normalizeAddress));
  }
  if (data.bankDetails) {
    store.setBankDetails(data.bankDetails as BankDetailModel[]);
  }
  if (data.employeeContext) {
    store.setEmployeeContext(data.employeeContext as EmployeeContext);
  }
};

const normalizeAddress = (address: unknown): AddressModel => {
  const value = address as Record<string, unknown>;
  return {
    id: String(value.id || ''),
    address_line_1: String(value.address_line_1 || value.area || ''),
    address_line_2: value.address_line_2 || value.locality ? String(value.address_line_2 || value.locality) : undefined,
    city: String(value.city || ''),
    state: String(value.state || ''),
    postal_code: String(value.postal_code || value.pin_code || ''),
  };
};
