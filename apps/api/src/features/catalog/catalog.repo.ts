import prisma from '../../infra/database/client';
import { MenuCategoryDTO } from './menu_category.type';
import { MenuItemDTO } from './menu_item.type';
import { ModifierGroupDTO } from './modifier_group.type';
import { ModifierDTO } from './modifier.type';
import { ComboMealDTO } from './combo_meal.type';
import { ComboItemDTO } from './combo_item.type';

export class CatalogRepo {
  async createMenuCategory(data: {
    branch_id: string;
    name: string;
    description?: string;
    display_order?: number;
  }): Promise<MenuCategoryDTO> {
    return prisma.menuCategory.create({ data }) as unknown as MenuCategoryDTO;
  }

  async findMenuCategoriesByBranch(branch_id: string): Promise<MenuCategoryDTO[]> {
    return prisma.menuCategory.findMany({
      where: { branch_id, is_deleted: false },
      orderBy: { display_order: 'asc' },
    }) as unknown as MenuCategoryDTO[];
  }

  async findMenuCategoryById(id: string): Promise<MenuCategoryDTO | null> {
    return prisma.menuCategory.findFirst({
      where: { id, is_deleted: false },
    }) as unknown as MenuCategoryDTO | null;
  }

  async updateMenuCategory(id: string, data: any): Promise<MenuCategoryDTO> {
    return prisma.menuCategory.update({ where: { id }, data }) as unknown as MenuCategoryDTO;
  }

  async deleteMenuCategory(id: string): Promise<MenuCategoryDTO> {
    return prisma.menuCategory.update({
      where: { id },
      data: { is_deleted: true },
    }) as unknown as MenuCategoryDTO;
  }

  async createMenuItem(data: {
    branch_id: string;
    category_id: string;
    variant_id: string;
    display_name: string;
    description?: string;
    selling_price: number;
    image_url?: string;
    created_by?: string;
  }): Promise<MenuItemDTO> {
    return prisma.menuItem.create({ data }) as unknown as MenuItemDTO;
  }

  async findMenuItemsByBranch(branch_id: string): Promise<MenuItemDTO[]> {
    return prisma.menuItem.findMany({
      where: { branch_id, is_deleted: false },
      orderBy: { created_at: 'desc' },
    }) as unknown as MenuItemDTO[];
  }

  async findMenuItemsByCategory(category_id: string): Promise<MenuItemDTO[]> {
    return prisma.menuItem.findMany({
      where: { category_id, is_deleted: false },
      orderBy: { created_at: 'desc' },
    }) as unknown as MenuItemDTO[];
  }

  async findMenuItemById(id: string): Promise<MenuItemDTO | null> {
    return prisma.menuItem.findFirst({
      where: { id, is_deleted: false },
    }) as unknown as MenuItemDTO | null;
  }

  async updateMenuItem(id: string, data: any): Promise<MenuItemDTO> {
    return prisma.menuItem.update({ where: { id }, data }) as unknown as MenuItemDTO;
  }

  async deleteMenuItem(id: string): Promise<MenuItemDTO> {
    return prisma.menuItem.update({
      where: { id },
      data: { is_deleted: true },
    }) as unknown as MenuItemDTO;
  }

  async createModifierGroup(data: {
    branch_id: string;
    name: string;
    min_select?: number;
    max_select?: number;
  }): Promise<ModifierGroupDTO> {
    return prisma.modifierGroup.create({ data }) as unknown as ModifierGroupDTO;
  }

  async findModifierGroupsByBranch(branch_id: string): Promise<ModifierGroupDTO[]> {
    return prisma.modifierGroup.findMany({
      where: { branch_id, is_deleted: false },
      orderBy: { created_at: 'desc' },
    }) as unknown as ModifierGroupDTO[];
  }

  async findModifierGroupById(id: string): Promise<ModifierGroupDTO | null> {
    return prisma.modifierGroup.findFirst({
      where: { id, is_deleted: false },
    }) as unknown as ModifierGroupDTO | null;
  }

  async updateModifierGroup(id: string, data: any): Promise<ModifierGroupDTO> {
    return prisma.modifierGroup.update({ where: { id }, data }) as unknown as ModifierGroupDTO;
  }

  async createModifier(data: {
    branch_id: string;
    group_id: string;
    variant_id?: string;
    name: string;
    extra_price?: number;
  }): Promise<ModifierDTO> {
    return prisma.modifier.create({ data }) as unknown as ModifierDTO;
  }

  async findModifiersByGroup(group_id: string): Promise<ModifierDTO[]> {
    return prisma.modifier.findMany({
      where: { group_id, is_deleted: false },
      orderBy: { created_at: 'desc' },
    }) as unknown as ModifierDTO[];
  }

  async findModifierById(id: string): Promise<ModifierDTO | null> {
    return prisma.modifier.findFirst({
      where: { id, is_deleted: false },
    }) as unknown as ModifierDTO | null;
  }

  async updateModifier(id: string, data: any): Promise<ModifierDTO> {
    return prisma.modifier.update({ where: { id }, data }) as unknown as ModifierDTO;
  }

  async deleteModifier(id: string): Promise<ModifierDTO> {
    return prisma.modifier.update({
      where: { id },
      data: { is_deleted: true },
    }) as unknown as ModifierDTO;
  }

  async createComboMeal(data: {
    branch_id: string;
    name: string;
    fixed_price: number;
    image_url?: string;
  }): Promise<ComboMealDTO> {
    return prisma.comboMeal.create({ data }) as unknown as ComboMealDTO;
  }

  async findComboMealsByBranch(branch_id: string): Promise<ComboMealDTO[]> {
    return prisma.comboMeal.findMany({
      where: { branch_id, is_deleted: false },
      orderBy: { created_at: 'desc' },
    }) as unknown as ComboMealDTO[];
  }

  async findComboMealById(id: string): Promise<ComboMealDTO | null> {
    return prisma.comboMeal.findFirst({
      where: { id, is_deleted: false },
    }) as unknown as ComboMealDTO | null;
  }

  async updateComboMeal(id: string, data: any): Promise<ComboMealDTO> {
    return prisma.comboMeal.update({ where: { id }, data }) as unknown as ComboMealDTO;
  }

  async deleteComboMeal(id: string): Promise<ComboMealDTO> {
    return prisma.comboMeal.update({
      where: { id },
      data: { is_deleted: true },
    }) as unknown as ComboMealDTO;
  }

  async addComboItem(data: {
    combo_id: string;
    menu_item_id: string;
    qty_included?: number;
  }): Promise<ComboItemDTO> {
    return prisma.comboItem.create({ data }) as unknown as ComboItemDTO;
  }

  async removeComboItem(id: string): Promise<ComboItemDTO> {
    return prisma.comboItem.delete({ where: { id } }) as unknown as ComboItemDTO;
  }

  async getFullMenu(branch_id: string): Promise<MenuCategoryDTO[]> {
    return prisma.menuCategory.findMany({
      where: { branch_id, is_deleted: false, status: 'ACTIVE' },
      orderBy: { display_order: 'asc' },
      include: {
        items: {
          where: { is_deleted: false, status: 'ACTIVE' },
          orderBy: { created_at: 'asc' },
        },
      },
    }) as unknown as MenuCategoryDTO[];
  }
}

export const catalogRepo = new CatalogRepo();
