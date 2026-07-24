import { apiClient } from "@/core/api/client";
import { ADMIN_API_ENDPOINTS } from "../constants/admin.constants";
import {
  AdminBranch,
  AdminItem,
  AdminItemCategory,
  AdminItemVariant,
  AdminMenuCategory,
  AdminMenuItem,
  AdminMenuItemSaleMode,
  AdminUom,
  AdminUser,
  AdminUserPayload,
  ApiEnvelope,
} from "../types/admin.types";

export class AdminApi {
  static async listUsers(): Promise<AdminUser[]> {
    const response = await apiClient.get<ApiEnvelope<AdminUser[]>>(ADMIN_API_ENDPOINTS.USERS);
    return response.data.data;
  }

  static async createUser(payload: AdminUserPayload): Promise<AdminUser> {
    const response = await apiClient.post<ApiEnvelope<AdminUser>>(ADMIN_API_ENDPOINTS.USERS, payload);
    return response.data.data;
  }

  static async updateUser(id: string, payload: AdminUserPayload): Promise<AdminUser> {
    const response = await apiClient.patch<ApiEnvelope<AdminUser>>(ADMIN_API_ENDPOINTS.USER(id), payload);
    return response.data.data;
  }

  static async deleteUser(id: string): Promise<AdminUser> {
    const response = await apiClient.delete<ApiEnvelope<AdminUser>>(ADMIN_API_ENDPOINTS.USER(id));
    return response.data.data;
  }

  static async listBranches(): Promise<AdminBranch[]> {
    const response = await apiClient.get<ApiEnvelope<AdminBranch[]>>(ADMIN_API_ENDPOINTS.BRANCHES);
    return response.data.data;
  }

  static async createBranch(payload: Partial<AdminBranch>): Promise<{ branch: AdminBranch }> {
    const response = await apiClient.post<ApiEnvelope<{ branch: AdminBranch }>>(ADMIN_API_ENDPOINTS.BRANCHES, payload);
    return response.data.data;
  }

  static async updateBranch(id: string, payload: Partial<AdminBranch>): Promise<AdminBranch> {
    const response = await apiClient.patch<ApiEnvelope<AdminBranch>>(ADMIN_API_ENDPOINTS.BRANCH(id), payload);
    return response.data.data;
  }

  static async deleteBranch(id: string): Promise<AdminBranch> {
    const response = await apiClient.delete<ApiEnvelope<AdminBranch>>(ADMIN_API_ENDPOINTS.BRANCH(id));
    return response.data.data;
  }

  static async listItemCategories(): Promise<AdminItemCategory[]> {
    const response = await apiClient.get<ApiEnvelope<AdminItemCategory[]>>(ADMIN_API_ENDPOINTS.ITEM_CATEGORIES);
    return response.data.data;
  }

  static async createItemCategory(payload: Partial<AdminItemCategory>): Promise<AdminItemCategory> {
    const response = await apiClient.post<ApiEnvelope<AdminItemCategory>>(ADMIN_API_ENDPOINTS.ITEM_CATEGORIES, payload);
    return response.data.data;
  }

  static async updateItemCategory(id: string, payload: Partial<AdminItemCategory>): Promise<AdminItemCategory> {
    const response = await apiClient.patch<ApiEnvelope<AdminItemCategory>>(ADMIN_API_ENDPOINTS.ITEM_CATEGORY(id), payload);
    return response.data.data;
  }

  static async listItems(): Promise<AdminItem[]> {
    const response = await apiClient.get<ApiEnvelope<AdminItem[]>>(ADMIN_API_ENDPOINTS.ITEMS);
    return response.data.data;
  }

  static async createItem(payload: Partial<AdminItem>): Promise<AdminItem> {
    const response = await apiClient.post<ApiEnvelope<AdminItem>>(ADMIN_API_ENDPOINTS.ITEMS, payload);
    return response.data.data;
  }

  static async updateItem(id: string, payload: Partial<AdminItem>): Promise<AdminItem> {
    const response = await apiClient.patch<ApiEnvelope<AdminItem>>(ADMIN_API_ENDPOINTS.ITEM(id), payload);
    return response.data.data;
  }

  static async deleteItem(id: string): Promise<AdminItem> {
    const response = await apiClient.delete<ApiEnvelope<AdminItem>>(ADMIN_API_ENDPOINTS.ITEM(id));
    return response.data.data;
  }

  static async listVariants(itemId: string): Promise<AdminItemVariant[]> {
    const response = await apiClient.get<ApiEnvelope<AdminItemVariant[]>>(ADMIN_API_ENDPOINTS.ITEM_VARIANTS(itemId));
    return response.data.data;
  }

  static async createVariant(itemId: string, payload: Partial<AdminItemVariant>): Promise<AdminItemVariant> {
    const response = await apiClient.post<ApiEnvelope<AdminItemVariant>>(ADMIN_API_ENDPOINTS.ITEM_VARIANTS(itemId), payload);
    return response.data.data;
  }

  static async updateVariant(id: string, payload: Partial<AdminItemVariant>): Promise<AdminItemVariant> {
    const response = await apiClient.patch<ApiEnvelope<AdminItemVariant>>(ADMIN_API_ENDPOINTS.VARIANT(id), payload);
    return response.data.data;
  }

  static async deleteVariant(id: string): Promise<AdminItemVariant> {
    const response = await apiClient.delete<ApiEnvelope<AdminItemVariant>>(ADMIN_API_ENDPOINTS.VARIANT(id));
    return response.data.data;
  }

  static async listUom(): Promise<AdminUom[]> {
    const response = await apiClient.get<ApiEnvelope<AdminUom[]>>(ADMIN_API_ENDPOINTS.UOM);
    return response.data.data;
  }

  static async createUom(payload: Partial<AdminUom>): Promise<AdminUom> {
    const response = await apiClient.post<ApiEnvelope<AdminUom>>(ADMIN_API_ENDPOINTS.UOM, payload);
    return response.data.data;
  }

  static async listMenuCategories(): Promise<AdminMenuCategory[]> {
    const response = await apiClient.get<ApiEnvelope<AdminMenuCategory[]>>(ADMIN_API_ENDPOINTS.MENU_CATEGORIES);
    return response.data.data;
  }

  static async createMenuCategory(payload: Partial<AdminMenuCategory>): Promise<AdminMenuCategory> {
    const response = await apiClient.post<ApiEnvelope<AdminMenuCategory>>(ADMIN_API_ENDPOINTS.MENU_CATEGORIES, payload);
    return response.data.data;
  }

  static async updateMenuCategory(id: string, payload: Partial<AdminMenuCategory>): Promise<AdminMenuCategory> {
    const response = await apiClient.patch<ApiEnvelope<AdminMenuCategory>>(ADMIN_API_ENDPOINTS.MENU_CATEGORY(id), payload);
    return response.data.data;
  }

  static async deleteMenuCategory(id: string): Promise<AdminMenuCategory> {
    const response = await apiClient.delete<ApiEnvelope<AdminMenuCategory>>(ADMIN_API_ENDPOINTS.MENU_CATEGORY(id));
    return response.data.data;
  }

  static async listMenuItems(): Promise<AdminMenuItem[]> {
    const response = await apiClient.get<ApiEnvelope<AdminMenuItem[]>>(ADMIN_API_ENDPOINTS.MENU_ITEMS);
    return response.data.data;
  }

  static async createMenuItem(payload: Partial<AdminMenuItem>): Promise<AdminMenuItem> {
    const response = await apiClient.post<ApiEnvelope<AdminMenuItem>>(ADMIN_API_ENDPOINTS.MENU_ITEMS, payload);
    return response.data.data;
  }

  static async updateMenuItem(id: string, payload: Partial<AdminMenuItem>): Promise<AdminMenuItem> {
    const response = await apiClient.patch<ApiEnvelope<AdminMenuItem>>(ADMIN_API_ENDPOINTS.MENU_ITEM(id), payload);
    return response.data.data;
  }

  static async deleteMenuItem(id: string): Promise<AdminMenuItem> {
    const response = await apiClient.delete<ApiEnvelope<AdminMenuItem>>(ADMIN_API_ENDPOINTS.MENU_ITEM(id));
    return response.data.data;
  }

  static async replaceSaleModes(id: string, sale_modes: AdminMenuItemSaleMode[]): Promise<AdminMenuItemSaleMode[]> {
    const response = await apiClient.put<ApiEnvelope<AdminMenuItemSaleMode[]>>(ADMIN_API_ENDPOINTS.MENU_ITEM_SALE_MODES(id), { sale_modes });
    return response.data.data;
  }
}
