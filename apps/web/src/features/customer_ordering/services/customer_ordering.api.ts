import { apiClient } from '@/core/api/client';
import { CUSTOMER_ORDERING_ENDPOINTS } from '../constants/customer_ordering.constants';
import { CustomerMenuCategory, CustomerOrderPayload, CustomerOrderResponse, CustomerTable } from '../types/customer_ordering.types';

interface ApiEnvelope<T> {
  data: T;
}

export class CustomerOrderingApi {
  static async getMenu(branchId: string): Promise<CustomerMenuCategory[]> {
    const response = await apiClient.get<ApiEnvelope<CustomerMenuCategory[]>>(CUSTOMER_ORDERING_ENDPOINTS.MENU, {
      params: { branch_id: branchId },
    });
    return response.data.data;
  }

  static async getTables(branchId: string): Promise<CustomerTable[]> {
    const response = await apiClient.get<ApiEnvelope<CustomerTable[]>>(CUSTOMER_ORDERING_ENDPOINTS.PUBLIC_TABLES, {
      params: { branch_id: branchId },
    });
    return response.data.data;
  }

  static async createOrder(payload: CustomerOrderPayload): Promise<CustomerOrderResponse> {
    const response = await apiClient.post<ApiEnvelope<CustomerOrderResponse>>(CUSTOMER_ORDERING_ENDPOINTS.ORDERS, payload);
    return response.data.data;
  }
}
