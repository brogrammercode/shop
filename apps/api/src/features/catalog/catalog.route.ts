import { Router } from 'express';
import { _CATALOG_CONSTANTS } from './catalog.constant';
import * as catalogController from './catalog.controller';
import { authenticate, requireCatalogAccess } from './catalog.middleware';

const router = Router();

// Public route
router.get(_CATALOG_CONSTANTS._R_O_U_T_E_S.FULL_MENU, catalogController.getFullMenu);

// Protected routes
router.use(authenticate, requireCatalogAccess);

router.get(_CATALOG_CONSTANTS._R_O_U_T_E_S.MENU_CATEGORIES, catalogController.listMenuCategories);
router.post(_CATALOG_CONSTANTS._R_O_U_T_E_S.MENU_CATEGORIES, catalogController.createMenuCategory);
router.get(_CATALOG_CONSTANTS._R_O_U_T_E_S.MENU_CATEGORY_BY_ID, catalogController.getMenuCategoryById);
router.patch(_CATALOG_CONSTANTS._R_O_U_T_E_S.MENU_CATEGORY_BY_ID, catalogController.updateMenuCategory);
router.delete(_CATALOG_CONSTANTS._R_O_U_T_E_S.MENU_CATEGORY_BY_ID, catalogController.deleteMenuCategory);

router.get(_CATALOG_CONSTANTS._R_O_U_T_E_S.MENU_ITEMS, catalogController.listMenuItems);
router.post(_CATALOG_CONSTANTS._R_O_U_T_E_S.MENU_ITEMS, catalogController.createMenuItem);
router.get(_CATALOG_CONSTANTS._R_O_U_T_E_S.MENU_ITEM_BY_ID, catalogController.getMenuItemById);
router.patch(_CATALOG_CONSTANTS._R_O_U_T_E_S.MENU_ITEM_BY_ID, catalogController.updateMenuItem);
router.delete(_CATALOG_CONSTANTS._R_O_U_T_E_S.MENU_ITEM_BY_ID, catalogController.deleteMenuItem);

router.get(_CATALOG_CONSTANTS._R_O_U_T_E_S.MODIFIER_GROUPS, catalogController.listModifierGroups);
router.post(_CATALOG_CONSTANTS._R_O_U_T_E_S.MODIFIER_GROUPS, catalogController.createModifierGroup);
router.get(_CATALOG_CONSTANTS._R_O_U_T_E_S.MODIFIER_GROUP_MODIFIERS, catalogController.listModifiersByGroup);
router.post(_CATALOG_CONSTANTS._R_O_U_T_E_S.MODIFIER_GROUP_MODIFIERS, catalogController.createModifier);
router.patch(_CATALOG_CONSTANTS._R_O_U_T_E_S.MODIFIER_BY_ID, catalogController.updateModifier);
router.delete(_CATALOG_CONSTANTS._R_O_U_T_E_S.MODIFIER_BY_ID, catalogController.deleteModifier);

router.get(_CATALOG_CONSTANTS._R_O_U_T_E_S.COMBO_MEALS, catalogController.listComboMeals);
router.post(_CATALOG_CONSTANTS._R_O_U_T_E_S.COMBO_MEALS, catalogController.createComboMeal);
router.get(_CATALOG_CONSTANTS._R_O_U_T_E_S.COMBO_MEAL_BY_ID, catalogController.getComboMealById);
router.patch(_CATALOG_CONSTANTS._R_O_U_T_E_S.COMBO_MEAL_BY_ID, catalogController.updateComboMeal);
router.delete(_CATALOG_CONSTANTS._R_O_U_T_E_S.COMBO_MEAL_BY_ID, catalogController.deleteComboMeal);

router.post(_CATALOG_CONSTANTS._R_O_U_T_E_S.COMBO_MEAL_ITEMS, catalogController.addComboItem);
router.delete(_CATALOG_CONSTANTS._R_O_U_T_E_S.COMBO_MEAL_ITEM_BY_ID, catalogController.removeComboItem);

export default router;
