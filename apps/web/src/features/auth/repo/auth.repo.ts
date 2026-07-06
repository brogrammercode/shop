import { apiClient } from '@/core/api/client';
import { useUserStore, UserModel } from '@/core/store/user.store';

export interface VerifyOtpResponse {
  user: UserModel;
  tokens: { accessToken: string; refreshToken: string };
  // The backend might return employee data if they belong to a branch/business
  employeeContext?: any; 
  addresses?: any[];
  bankDetails?: any[];
}

export class AuthRepo {
  static async sendOtp(phoneNumber: string): Promise<void> {
    const response = await apiClient.post('/auth/send-otp', { phone_number: phoneNumber });
    return response.data?.data;
  }

  static async verifyOtp(phoneNumber: string, otp: string): Promise<VerifyOtpResponse> {
    const response = await apiClient.post('/auth/verify-otp', { phone_number: phoneNumber, otp });
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
