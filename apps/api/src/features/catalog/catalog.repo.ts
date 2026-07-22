import prisma, { pool } from '../../infra/database/client';
import { withDatabaseRetry } from '../../infra/database/retry';
import { MenuCategoryDTO } from './menu_category.type';
import { MenuItemDTO } from './menu_item.type';
import { ModifierGroupDTO } from './modifier_group.type';
import { ModifierDTO } from './modifier.type';
import { ComboMealDTO } from './combo_meal.type';
import { ComboItemDTO } from './combo_item.type';
import { MenuItemSaleModeDTO } from './menu_item_sale_mode.type';

const menuItemInclude = {
  variant: {
    select: {
      item_id: true,
      uom_id: true,
      uom: {
        select: {
          id: true,
          code: true,
          description: true,
        },
      },
    },
  },
  sale_modes: {
    where: { is_deleted: false },
    include: {
      uom: {
        select: {
          id: true,
          code: true,
          description: true,
        },
      },
    },
    orderBy: { sort_order: 'asc' as const },
  },
};

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
    images?: string[];
    videos?: string[];
    sale_modes?: any[];
    created_by?: string;
  }): Promise<MenuItemDTO> {
    const { sale_modes, ...menuData } = data;
    return prisma.$transaction(async (tx) => {
      const menuItem = await tx.menuItem.create({ data: menuData });
      if (sale_modes?.length) {
        await tx.menuItemSaleMode.createMany({
          data: sale_modes.map((mode, index) => ({
            branch_id: data.branch_id,
            menu_item_id: menuItem.id,
            uom_id: mode.uom_id,
            label: mode.label,
            price_per_unit: Number(mode.price_per_unit),
            min_qty: Number(mode.min_qty ?? 1),
            step_qty: Number(mode.step_qty ?? 1),
            allow_decimal: Boolean(mode.allow_decimal),
            is_default: Boolean(mode.is_default),
            sort_order: Number(mode.sort_order ?? index),
            status: mode.status ?? 'ACTIVE',
          })),
        });
      }
      return tx.menuItem.findUnique({
        where: { id: menuItem.id },
        include: menuItemInclude,
      }) as unknown as MenuItemDTO;
    });
  }

  async findMenuItemsByBranch(branch_id: string): Promise<MenuItemDTO[]> {
    return prisma.menuItem.findMany({
      where: { branch_id, is_deleted: false },
      include: menuItemInclude,
      orderBy: { created_at: 'desc' },
    }) as unknown as MenuItemDTO[];
  }

  async findMenuItemsByCategory(category_id: string): Promise<MenuItemDTO[]> {
    return prisma.menuItem.findMany({
      where: { category_id, is_deleted: false },
      include: menuItemInclude,
      orderBy: { created_at: 'desc' },
    }) as unknown as MenuItemDTO[];
  }

  async findMenuItemById(id: string): Promise<MenuItemDTO | null> {
    return prisma.menuItem.findFirst({
      where: { id, is_deleted: false },
      include: menuItemInclude,
    }) as unknown as MenuItemDTO | null;
  }

  async updateMenuItem(id: string, data: any): Promise<MenuItemDTO> {
    const { sale_modes, ...menuData } = data;
    return prisma.$transaction(async (tx) => {
      await tx.menuItem.update({ where: { id }, data: menuData });
      if (Array.isArray(sale_modes)) {
        await tx.menuItemSaleMode.updateMany({
          where: { menu_item_id: id },
          data: { is_deleted: true },
        });
        if (sale_modes.length) {
          const item = await tx.menuItem.findUnique({ where: { id } });
          if (item) {
            await tx.menuItemSaleMode.createMany({
              data: sale_modes.map((mode, index) => ({
                branch_id: item.branch_id,
                menu_item_id: id,
                uom_id: mode.uom_id,
                label: mode.label,
                price_per_unit: Number(mode.price_per_unit),
                min_qty: Number(mode.min_qty ?? 1),
                step_qty: Number(mode.step_qty ?? 1),
                allow_decimal: Boolean(mode.allow_decimal),
                is_default: Boolean(mode.is_default),
                sort_order: Number(mode.sort_order ?? index),
                status: mode.status ?? 'ACTIVE',
              })),
            });
          }
        }
      }
      return tx.menuItem.findUnique({
        where: { id },
        include: menuItemInclude,
      }) as unknown as MenuItemDTO;
    });
  }

  async deleteMenuItem(id: string): Promise<MenuItemDTO> {
    return prisma.menuItem.update({
      where: { id },
      data: { is_deleted: true },
    }) as unknown as MenuItemDTO;
  }

  async replaceMenuItemSaleModes(menuItemId: string, branchId: string, saleModes: any[]): Promise<MenuItemSaleModeDTO[]> {
    return prisma.$transaction(async (tx) => {
      await tx.menuItemSaleMode.updateMany({
        where: { menu_item_id: menuItemId },
        data: { is_deleted: true },
      });
      if (saleModes.length) {
        await tx.menuItemSaleMode.createMany({
          data: saleModes.map((mode, index) => ({
            branch_id: branchId,
            menu_item_id: menuItemId,
            uom_id: mode.uom_id,
            label: mode.label,
            price_per_unit: Number(mode.price_per_unit),
            min_qty: Number(mode.min_qty ?? 1),
            step_qty: Number(mode.step_qty ?? 1),
            allow_decimal: Boolean(mode.allow_decimal),
            is_default: Boolean(mode.is_default),
            sort_order: Number(mode.sort_order ?? index),
            status: mode.status ?? 'ACTIVE',
          })),
        });
      }
      return tx.menuItemSaleMode.findMany({
        where: { menu_item_id: menuItemId, is_deleted: false },
        include: { uom: true },
        orderBy: { sort_order: 'asc' },
      }) as unknown as MenuItemSaleModeDTO[];
    });
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
    return withDatabaseRetry(async () => {
      const [categoryResult, itemResult, saleModeResult] = await Promise.all([
        pool.query(`
          SELECT
            id,
            branch_id,
            name,
            description,
            images,
            display_order,
            status,
            created_at,
            updated_at,
            is_deleted
          FROM menu_categories
          WHERE branch_id = $1
            AND is_deleted = false
            AND status = 'ACTIVE'
          ORDER BY display_order ASC
        `, [branch_id]),
        pool.query(`
          SELECT
            mi.id,
            mi.branch_id,
            mi.category_id,
            mi.variant_id,
            mi.display_name,
            mi.description,
            mi.selling_price,
            mi.images,
            mi.videos,
            mi.status,
            mi.created_at,
            mi.updated_at,
            mi.created_by,
            mi.is_deleted,
            iv.item_id AS variant_item_id,
            iv.uom_id AS variant_uom_id,
            vu.code AS variant_uom_code,
            vu.description AS variant_uom_description
          FROM menu_items mi
          LEFT JOIN item_variants iv ON iv.id = mi.variant_id
          LEFT JOIN units_of_measure vu ON vu.id = iv.uom_id
          WHERE mi.branch_id = $1
            AND mi.is_deleted = false
            AND mi.status = 'ACTIVE'
          ORDER BY mi.created_at ASC
        `, [branch_id]),
        pool.query(`
          SELECT
            sm.id,
            sm.branch_id,
            sm.menu_item_id,
            sm.uom_id,
            sm.label,
            sm.price_per_unit,
            sm.min_qty,
            sm.step_qty,
            sm.allow_decimal,
            sm.is_default,
            sm.sort_order,
            sm.status,
            sm.created_at,
            sm.updated_at,
            sm.is_deleted,
            u.code AS uom_code,
            u.description AS uom_description
          FROM menu_item_sale_modes sm
          LEFT JOIN units_of_measure u ON u.id = sm.uom_id
          WHERE sm.branch_id = $1
            AND sm.is_deleted = false
          ORDER BY sm.sort_order ASC
        `, [branch_id]),
      ]);

      const saleModesByItem = saleModeResult.rows.reduce<Record<string, any[]>>((next, row) => {
        next[row.menu_item_id] = [
          ...(next[row.menu_item_id] || []),
          {
            id: row.id,
            branch_id: row.branch_id,
            menu_item_id: row.menu_item_id,
            uom_id: row.uom_id,
            label: row.label,
            price_per_unit: Number(row.price_per_unit),
            min_qty: Number(row.min_qty),
            step_qty: Number(row.step_qty),
            allow_decimal: row.allow_decimal,
            is_default: row.is_default,
            sort_order: row.sort_order,
            status: row.status,
            created_at: row.created_at,
            updated_at: row.updated_at,
            is_deleted: row.is_deleted,
            uom: {
              id: row.uom_id,
              code: row.uom_code,
              description: row.uom_description,
            },
          },
        ];
        return next;
      }, {});

      const itemsByCategory = itemResult.rows.reduce<Record<string, any[]>>((next, row) => {
        next[row.category_id] = [
          ...(next[row.category_id] || []),
          {
            id: row.id,
            branch_id: row.branch_id,
            category_id: row.category_id,
            variant_id: row.variant_id,
            display_name: row.display_name,
            description: row.description,
            selling_price: Number(row.selling_price),
            images: row.images || [],
            videos: row.videos || [],
            status: row.status,
            created_at: row.created_at,
            updated_at: row.updated_at,
            created_by: row.created_by,
            is_deleted: row.is_deleted,
            variant: {
              item_id: row.variant_item_id,
              uom_id: row.variant_uom_id,
              uom: {
                id: row.variant_uom_id,
                code: row.variant_uom_code,
                description: row.variant_uom_description,
              },
            },
            sale_modes: saleModesByItem[row.id] || [],
          },
        ];
        return next;
      }, {});

      return categoryResult.rows.map((row) => ({
        id: row.id,
        branch_id: row.branch_id,
        name: row.name,
        description: row.description,
        images: row.images || [],
        display_order: row.display_order,
        status: row.status,
        created_at: row.created_at,
        updated_at: row.updated_at,
        is_deleted: row.is_deleted,
        items: itemsByCategory[row.id] || [],
      })) as unknown as MenuCategoryDTO[];
    });
  }
}

export const catalogRepo = new CatalogRepo();
