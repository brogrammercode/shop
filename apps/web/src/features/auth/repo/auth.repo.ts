import { apiClient } from '@/core/api/client';
import { useUserStore, UserModel } from '@/core/store/user.store';

export interface VerifyOtpResponse {
  user: UserModel;
  tokens: { accessToken: string; refreshToken: string };
  employeeContext?: unknown;
  addresses?: unknown[];
  bankDetails?: unknown[];
}

export class AuthRepo {
  static async sendOtp(phoneNumber: string): Promise<void> {
    const response = await apiClient.post('/hr/auth/send-otp', { phone_number: phoneNumber });
    return response.data?.data;
  }

  static async verifyOtp(phoneNumber: string, otp: string): Promise<VerifyOtpResponse> {
    const response = await apiClient.post('/hr/auth/login', { phone_number: phoneNumber, otp });
    const data = response.data?.data;
    
    if (data?.tokens?.accessToken && data?.user) {
      const store = useUserStore.getState();
      store.setAuth(data.tokens.accessToken, data.user);
      
      if (data.addresses) {
        store.setAddresses(data.addresses);
      }
      if (data.bankDetails) {
        store.setBankDetails(data.bankDetails);
      }
      if (data.employeeContext) {
        store.setEmployeeContext(data.employeeContext);
      }
    }
    
    return data;
  }
}
