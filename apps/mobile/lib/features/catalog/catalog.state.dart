import 'package:mobile/utils/error.dart';
import 'package:mobile/features/catalog/menu_category.model.dart';
import 'package:mobile/features/catalog/menu_item.model.dart';
import 'package:mobile/features/catalog/modifier_group.model.dart';
import 'package:mobile/features/catalog/modifier.model.dart';
import 'package:mobile/features/catalog/combo_meal.model.dart';

class CatalogState {
  final List<MenuCategoryModel> categories;
  final List<MenuItemModel> items;
  final List<ModifierGroupModel> modifierGroups;
  final List<ModifierModel> modifiers;
  final List<ComboMealModel> comboMeals;
  final dynamic publicMenu;

  final OperationInfo loadCategoriesInfo;
  final OperationInfo saveCategoriesInfo;
  final OperationInfo loadItemsInfo;
  final OperationInfo saveItemsInfo;
  final OperationInfo loadModifiersInfo;
  final OperationInfo saveModifiersInfo;
  final OperationInfo loadCombosInfo;
  final OperationInfo saveCombosInfo;
  final OperationInfo loadMenuInfo;

  const CatalogState({
    this.categories = const [],
    this.items = const [],
    this.modifierGroups = const [],
    this.modifiers = const [],
    this.comboMeals = const [],
    this.publicMenu,
    this.loadCategoriesInfo = const OperationInfo(status: OperationStatus.initial),
    this.saveCategoriesInfo = const OperationInfo(status: OperationStatus.initial),
    this.loadItemsInfo = const OperationInfo(status: OperationStatus.initial),
    this.saveItemsInfo = const OperationInfo(status: OperationStatus.initial),
    this.loadModifiersInfo = const OperationInfo(status: OperationStatus.initial),
    this.saveModifiersInfo = const OperationInfo(status: OperationStatus.initial),
    this.loadCombosInfo = const OperationInfo(status: OperationStatus.initial),
    this.saveCombosInfo = const OperationInfo(status: OperationStatus.initial),
    this.loadMenuInfo = const OperationInfo(status: OperationStatus.initial),
  });

  CatalogState copyWith({
    List<MenuCategoryModel>? categories,
    List<MenuItemModel>? items,
    List<ModifierGroupModel>? modifierGroups,
    List<ModifierModel>? modifiers,
    List<ComboMealModel>? comboMeals,
    dynamic publicMenu,
    OperationInfo? loadCategoriesInfo,
    OperationInfo? saveCategoriesInfo,
    OperationInfo? loadItemsInfo,
    OperationInfo? saveItemsInfo,
    OperationInfo? loadModifiersInfo,
    OperationInfo? saveModifiersInfo,
    OperationInfo? loadCombosInfo,
    OperationInfo? saveCombosInfo,
    OperationInfo? loadMenuInfo,
  }) {
    return CatalogState(
      categories: categories ?? this.categories,
      items: items ?? this.items,
      modifierGroups: modifierGroups ?? this.modifierGroups,
      modifiers: modifiers ?? this.modifiers,
      comboMeals: comboMeals ?? this.comboMeals,
      publicMenu: publicMenu ?? this.publicMenu,
      loadCategoriesInfo: loadCategoriesInfo ?? this.loadCategoriesInfo,
      saveCategoriesInfo: saveCategoriesInfo ?? this.saveCategoriesInfo,
      loadItemsInfo: loadItemsInfo ?? this.loadItemsInfo,
      saveItemsInfo: saveItemsInfo ?? this.saveItemsInfo,
      loadModifiersInfo: loadModifiersInfo ?? this.loadModifiersInfo,
      saveModifiersInfo: saveModifiersInfo ?? this.saveModifiersInfo,
      loadCombosInfo: loadCombosInfo ?? this.loadCombosInfo,
      saveCombosInfo: saveCombosInfo ?? this.saveCombosInfo,
      loadMenuInfo: loadMenuInfo ?? this.loadMenuInfo,
    );
  }
}
