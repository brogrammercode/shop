import { Request, Response } from 'express';
import { asyncHandler } from '../../utils/async';
import { sendSuccess } from '../../utils/error';
import { HttpStatus } from '../../constants/status';
import { catalogService } from './catalog.service';
import { _CATALOG_CONSTANTS } from './catalog.constant';

export const listMenuCategories = asyncHandler(async (req: Request, res: Response) => {
  const result = await catalogService.listMenuCategories(req.employee.branch_id);
  return sendSuccess(res, result, _CATALOG_CONSTANTS._M_E_S_S_A_G_E_S.MENU_CATEGORY_FETCHED, HttpStatus.OK);
});

export const createMenuCategory = asyncHandler(async (req: Request, res: Response) => {
  const { name, description, display_order } = req.body;
  const result = await catalogService.createMenuCategory(req.employee.branch_id, name, description, display_order);
  return sendSuccess(res, result, _CATALOG_CONSTANTS._M_E_S_S_A_G_E_S.MENU_CATEGORY_CREATED, HttpStatus.CREATED);
});

export const getMenuCategoryById = asyncHandler(async (req: Request, res: Response) => {
  const { id } = req.params as Record<string, string>;
  const result = await catalogService.getMenuCategoryById(id, req.employee.branch_id);
  return sendSuccess(res, result, _CATALOG_CONSTANTS._M_E_S_S_A_G_E_S.MENU_CATEGORY_FETCHED, HttpStatus.OK);
});

export const updateMenuCategory = asyncHandler(async (req: Request, res: Response) => {
  const { id } = req.params as Record<string, string>;
  const result = await catalogService.updateMenuCategory(id, req.employee.branch_id, req.body);
  return sendSuccess(res, result, _CATALOG_CONSTANTS._M_E_S_S_A_G_E_S.MENU_CATEGORY_FOUND, HttpStatus.OK);
});

export const deleteMenuCategory = asyncHandler(async (req: Request, res: Response) => {
  const { id } = req.params as Record<string, string>;
  const result = await catalogService.deleteMenuCategory(id, req.employee.branch_id);
  return sendSuccess(res, result, _CATALOG_CONSTANTS._M_E_S_S_A_G_E_S.MENU_CATEGORY_DELETED, HttpStatus.OK);
});

export const listMenuItems = asyncHandler(async (req: Request, res: Response) => {
  const result = await catalogService.listMenuItems(req.employee.branch_id);
  return sendSuccess(res, result, _CATALOG_CONSTANTS._M_E_S_S_A_G_E_S.MENU_ITEM_FETCHED, HttpStatus.OK);
});

export const createMenuItem = asyncHandler(async (req: Request, res: Response) => {
  const { category_id, variant_id, display_name, selling_price, description, image_url } = req.body;
  const result = await catalogService.createMenuItem(req.employee.branch_id, category_id, variant_id, display_name, selling_price, description, image_url);
  return sendSuccess(res, result, _CATALOG_CONSTANTS._M_E_S_S_A_G_E_S.MENU_ITEM_CREATED, HttpStatus.CREATED);
});

export const getMenuItemById = asyncHandler(async (req: Request, res: Response) => {
  const { id } = req.params as Record<string, string>;
  const result = await catalogService.getMenuItemById(id, req.employee.branch_id);
  return sendSuccess(res, result, _CATALOG_CONSTANTS._M_E_S_S_A_G_E_S.MENU_ITEM_FETCHED, HttpStatus.OK);
});

export const updateMenuItem = asyncHandler(async (req: Request, res: Response) => {
  const { id } = req.params as Record<string, string>;
  const result = await catalogService.updateMenuItem(id, req.employee.branch_id, req.body);
  return sendSuccess(res, result, _CATALOG_CONSTANTS._M_E_S_S_A_G_E_S.MENU_ITEM_UPDATED, HttpStatus.OK);
});

export const deleteMenuItem = asyncHandler(async (req: Request, res: Response) => {
  const { id } = req.params as Record<string, string>;
  const result = await catalogService.deleteMenuItem(id, req.employee.branch_id);
  return sendSuccess(res, result, _CATALOG_CONSTANTS._M_E_S_S_A_G_E_S.MENU_ITEM_DELETED, HttpStatus.OK);
});

export const listModifierGroups = asyncHandler(async (req: Request, res: Response) => {
  const result = await catalogService.listModifierGroups(req.employee.branch_id);
  return sendSuccess(res, result, _CATALOG_CONSTANTS._M_E_S_S_A_G_E_S.MODIFIER_GROUP_FETCHED, HttpStatus.OK);
});

export const createModifierGroup = asyncHandler(async (req: Request, res: Response) => {
  const { name, min_select, max_select } = req.body;
  const result = await catalogService.createModifierGroup(req.employee.branch_id, name, min_select, max_select);
  return sendSuccess(res, result, _CATALOG_CONSTANTS._M_E_S_S_A_G_E_S.MODIFIER_GROUP_CREATED, HttpStatus.CREATED);
});

export const listModifiersByGroup = asyncHandler(async (req: Request, res: Response) => {
  const { id } = req.params as Record<string, string>;
  const result = await catalogService.listModifiersByGroup(id, req.employee.branch_id);
  return sendSuccess(res, result, _CATALOG_CONSTANTS._M_E_S_S_A_G_E_S.MODIFIER_FOUND, HttpStatus.OK);
});

export const createModifier = asyncHandler(async (req: Request, res: Response) => {
  const { group_id, name, extra_price, variant_id } = req.body;
  const result = await catalogService.createModifier(req.employee.branch_id, group_id, name, extra_price, variant_id);
  return sendSuccess(res, result, _CATALOG_CONSTANTS._M_E_S_S_A_G_E_S.MODIFIER_CREATED, HttpStatus.CREATED);
});

export const updateModifier = asyncHandler(async (req: Request, res: Response) => {
  const { id } = req.params as Record<string, string>;
  const result = await catalogService.updateModifier(id, req.employee.branch_id, req.body);
  return sendSuccess(res, result, _CATALOG_CONSTANTS._M_E_S_S_A_G_E_S.MODIFIER_UPDATED, HttpStatus.OK);
});

export const deleteModifier = asyncHandler(async (req: Request, res: Response) => {
  const { id } = req.params as Record<string, string>;
  const result = await catalogService.deleteModifier(id, req.employee.branch_id);
  return sendSuccess(res, result, _CATALOG_CONSTANTS._M_E_S_S_A_G_E_S.MODIFIER_FETCHED, HttpStatus.OK);
});

export const listComboMeals = asyncHandler(async (req: Request, res: Response) => {
  const result = await catalogService.listComboMeals(req.employee.branch_id);
  return sendSuccess(res, result, _CATALOG_CONSTANTS._M_E_S_S_A_G_E_S.COMBO_MEAL_FETCHED, HttpStatus.OK);
});

export const createComboMeal = asyncHandler(async (req: Request, res: Response) => {
  const { name, fixed_price, image_url } = req.body;
  const result = await catalogService.createComboMeal(req.employee.branch_id, name, fixed_price, image_url);
  return sendSuccess(res, result, _CATALOG_CONSTANTS._M_E_S_S_A_G_E_S.COMBO_MEAL_CREATED, HttpStatus.CREATED);
});

export const getComboMealById = asyncHandler(async (req: Request, res: Response) => {
  const { id } = req.params as Record<string, string>;
  const result = await catalogService.getComboMealById(id, req.employee.branch_id);
  return sendSuccess(res, result, _CATALOG_CONSTANTS._M_E_S_S_A_G_E_S.COMBO_MEAL_FETCHED, HttpStatus.OK);
});

export const updateComboMeal = asyncHandler(async (req: Request, res: Response) => {
  const { id } = req.params as Record<string, string>;
  const result = await catalogService.updateComboMeal(id, req.employee.branch_id, req.body);
  return sendSuccess(res, result, _CATALOG_CONSTANTS._M_E_S_S_A_G_E_S.COMBO_MEAL_UPDATED, HttpStatus.OK);
});

export const deleteComboMeal = asyncHandler(async (req: Request, res: Response) => {
  const { id } = req.params as Record<string, string>;
  const result = await catalogService.deleteComboMeal(id, req.employee.branch_id);
  return sendSuccess(res, result, _CATALOG_CONSTANTS._M_E_S_S_A_G_E_S.COMBO_MEAL_FETCHED, HttpStatus.OK);
});

export const addComboItem = asyncHandler(async (req: Request, res: Response) => {
  const { id } = req.params as Record<string, string>;
  const { menu_item_id, qty_included } = req.body;
  const result = await catalogService.addComboItem(id, menu_item_id, qty_included, req.employee.branch_id);
  return sendSuccess(res, result, _CATALOG_CONSTANTS._M_E_S_S_A_G_E_S.COMBO_ITEM_CREATED, HttpStatus.CREATED);
});

export const removeComboItem = asyncHandler(async (req: Request, res: Response) => {
  const { id, itemId } = req.params as Record<string, string>;
  const result = await catalogService.removeComboItem(id, itemId, req.employee.branch_id);
  return sendSuccess(res, result, _CATALOG_CONSTANTS._M_E_S_S_A_G_E_S.COMBO_ITEM_FETCHED, HttpStatus.OK);
});

export const getFullMenu = asyncHandler(async (req: Request, res: Response) => {
  // Public or auth doesn't matter, we can use branch_id from query or req.employee
  // Usually this is public, so let's check query branch_id
  const branchId = (req.query.branch_id as string) || (req.employee?.branch_id);
  if (!branchId) throw new Error('Branch ID required');
  const result = await catalogService.getFullMenu(branchId);
  return sendSuccess(res, result, _CATALOG_CONSTANTS._M_E_S_S_A_G_E_S.MENU_CATEGORY_FETCHED, HttpStatus.OK);
});
