import { catalogRepo } from "./catalog.repo";
import { _CATALOG_CONSTANTS } from "./catalog.constant";
import { AppError, NotFoundError, ConflictError } from "../../utils/error";
import { HttpStatus } from "../../constants/status";

export class CatalogService {
  async createMenuCategory(
    branchId: string,
    name: string,
    description?: string,
    display_order?: number,
  ) {
    return catalogRepo.createMenuCategory({
      branch_id: branchId,
      name,
      description,
      display_order,
    });
  }

  async listMenuCategories(branchId: string) {
    return catalogRepo.findMenuCategoriesByBranch(branchId);
  }

  async getMenuCategoryById(id: string, branchId: string) {
    const category = await catalogRepo.findMenuCategoryById(id);
    if (!category || category.branch_id !== branchId) {
      throw new NotFoundError(_CATALOG_CONSTANTS._E_R_R_O_R_S.MENU_CATEGORY_NOT_FOUND);
    }
    return category;
  }

  async updateMenuCategory(id: string, branchId: string, data: any) {
    await this.getMenuCategoryById(id, branchId);
    return catalogRepo.updateMenuCategory(id, data);
  }

  async deleteMenuCategory(id: string, branchId: string) {
    await this.getMenuCategoryById(id, branchId);
    return catalogRepo.deleteMenuCategory(id);
  }

  async createMenuItem(
    branchId: string,
    category_id: string,
    variant_id: string,
    display_name: string,
    selling_price: number,
    description?: string,
    image_url?: string,
  ) {
    return catalogRepo.createMenuItem({
      branch_id: branchId,
      category_id,
      variant_id,
      display_name,
      selling_price,
      description,
      image_url,
    });
  }

  async listMenuItems(branchId: string) {
    return catalogRepo.findMenuItemsByBranch(branchId);
  }

  async getMenuItemById(id: string, branchId: string) {
    const item = await catalogRepo.findMenuItemById(id);
    if (!item || item.branch_id !== branchId) {
      throw new NotFoundError(_CATALOG_CONSTANTS._E_R_R_O_R_S.MENU_ITEM_NOT_FOUND);
    }
    return item;
  }

  async updateMenuItem(id: string, branchId: string, data: any) {
    await this.getMenuItemById(id, branchId);
    return catalogRepo.updateMenuItem(id, data);
  }

  async deleteMenuItem(id: string, branchId: string) {
    await this.getMenuItemById(id, branchId);
    return catalogRepo.deleteMenuItem(id);
  }

  async createModifierGroup(
    branchId: string,
    name: string,
    min_select: number,
    max_select: number,
  ) {
    return catalogRepo.createModifierGroup({
      branch_id: branchId,
      name,
      min_select,
      max_select,
    });
  }

  async listModifierGroups(branchId: string) {
    return catalogRepo.findModifierGroupsByBranch(branchId);
  }

  async createModifier(
    branchId: string,
    group_id: string,
    name: string,
    extra_price: number,
    variant_id?: string,
  ) {
    return catalogRepo.createModifier({
      branch_id: branchId,
      group_id,
      name,
      extra_price,
      variant_id,
    });
  }

  async listModifiersByGroup(groupId: string, branchId: string) {
    const group = await catalogRepo.findModifierGroupById(groupId);
    if (!group || group.branch_id !== branchId) {
      throw new NotFoundError(_CATALOG_CONSTANTS._E_R_R_O_R_S.MODIFIER_GROUP_NOT_FOUND);
    }
    return catalogRepo.findModifiersByGroup(groupId);
  }

  async updateModifier(id: string, branchId: string, data: any) {
    const modifier = await catalogRepo.findModifierById(id);
    if (!modifier || modifier.branch_id !== branchId) {
      throw new NotFoundError(_CATALOG_CONSTANTS._E_R_R_O_R_S.MODIFIER_NOT_FOUND);
    }
    return catalogRepo.updateModifier(id, data);
  }

  async deleteModifier(id: string, branchId: string) {
    const modifier = await catalogRepo.findModifierById(id);
    if (!modifier || modifier.branch_id !== branchId) {
      throw new NotFoundError(_CATALOG_CONSTANTS._E_R_R_O_R_S.MODIFIER_NOT_FOUND);
    }
    return catalogRepo.deleteModifier(id);
  }

  async createComboMeal(
    branchId: string,
    name: string,
    fixed_price: number,
    image_url?: string,
  ) {
    return catalogRepo.createComboMeal({
      branch_id: branchId,
      name,
      fixed_price,
      image_url,
    });
  }

  async listComboMeals(branchId: string) {
    return catalogRepo.findComboMealsByBranch(branchId);
  }

  async getComboMealById(id: string, branchId: string) {
    const meal = await catalogRepo.findComboMealById(id);
    if (!meal || meal.branch_id !== branchId) {
      throw new NotFoundError(_CATALOG_CONSTANTS._E_R_R_O_R_S.COMBO_MEAL_NOT_FOUND);
    }
    return meal;
  }

  async updateComboMeal(id: string, branchId: string, data: any) {
    await this.getComboMealById(id, branchId);
    return catalogRepo.updateComboMeal(id, data);
  }

  async deleteComboMeal(id: string, branchId: string) {
    await this.getComboMealById(id, branchId);
    return catalogRepo.deleteComboMeal(id);
  }

  async addComboItem(
    combo_id: string,
    menu_item_id: string,
    qty_included: number,
    branchId: string,
  ) {
    await this.getComboMealById(combo_id, branchId);
    await this.getMenuItemById(menu_item_id, branchId);
    return catalogRepo.addComboItem({ combo_id, menu_item_id, qty_included });
  }

  async removeComboItem(
    combo_id: string,
    menu_item_id: string,
    branchId: string,
  ) {
    await this.getComboMealById(combo_id, branchId);
    // Find the item first if needed, or just let repo delete
    return catalogRepo.removeComboItem(menu_item_id);
  }

  async getFullMenu(branchId: string) {
    return catalogRepo.getFullMenu(branchId);
  }
}

export const catalogService = new CatalogService();
