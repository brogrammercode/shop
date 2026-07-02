import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mobile/utils/error.dart';
import 'package:mobile/features/catalog/catalog.repo.dart';
import 'package:mobile/features/catalog/catalog.state.dart';

class CatalogCubit extends Cubit<CatalogState> {
  final CatalogRepo _repo;

  CatalogCubit({required CatalogRepo repo})
      : _repo = repo,
        super(const CatalogState());

  Future<void> getPublicMenu(String branchId) async {
    emit(state.copyWith(loadMenuInfo: const OperationInfo(status: OperationStatus.loading)));
    final result = await _repo.getPublicMenu(branchId);
    result.fold(
      (failure) {
        Fluttertoast.showToast(msg: failure.message);
        emit(state.copyWith(loadMenuInfo: OperationInfo(status: OperationStatus.error, error: failure)));
      },
      (menu) {
        emit(state.copyWith(
          publicMenu: menu,
          loadMenuInfo: const OperationInfo(status: OperationStatus.success),
        ));
      },
    );
  }

  Future<void> listCategories() async {
    emit(state.copyWith(loadCategoriesInfo: const OperationInfo(status: OperationStatus.loading)));
    final result = await _repo.listCategories();
    result.fold(
      (failure) {
        Fluttertoast.showToast(msg: failure.message);
        emit(state.copyWith(loadCategoriesInfo: OperationInfo(status: OperationStatus.error, error: failure)));
      },
      (categories) {
        emit(state.copyWith(
          categories: categories,
          loadCategoriesInfo: const OperationInfo(status: OperationStatus.success),
        ));
      },
    );
  }

  Future<void> createCategory(Map<String, dynamic> data) async {
    emit(state.copyWith(saveCategoriesInfo: const OperationInfo(status: OperationStatus.loading)));
    final result = await _repo.createCategory(data);
    result.fold(
      (failure) {
        Fluttertoast.showToast(msg: failure.message);
        emit(state.copyWith(saveCategoriesInfo: OperationInfo(status: OperationStatus.error, error: failure)));
      },
      (_) {
        Fluttertoast.showToast(msg: 'Category created');
        emit(state.copyWith(saveCategoriesInfo: const OperationInfo(status: OperationStatus.success)));
        listCategories();
      },
    );
  }

  Future<void> listItems() async {
    emit(state.copyWith(loadItemsInfo: const OperationInfo(status: OperationStatus.loading)));
    final result = await _repo.listItems();
    result.fold(
      (failure) {
        Fluttertoast.showToast(msg: failure.message);
        emit(state.copyWith(loadItemsInfo: OperationInfo(status: OperationStatus.error, error: failure)));
      },
      (items) {
        emit(state.copyWith(
          items: items,
          loadItemsInfo: const OperationInfo(status: OperationStatus.success),
        ));
      },
    );
  }

  Future<void> createItem(Map<String, dynamic> data) async {
    emit(state.copyWith(saveItemsInfo: const OperationInfo(status: OperationStatus.loading)));
    final result = await _repo.createItem(data);
    result.fold(
      (failure) {
        Fluttertoast.showToast(msg: failure.message);
        emit(state.copyWith(saveItemsInfo: OperationInfo(status: OperationStatus.error, error: failure)));
      },
      (_) {
        Fluttertoast.showToast(msg: 'Item created');
        emit(state.copyWith(saveItemsInfo: const OperationInfo(status: OperationStatus.success)));
        listItems();
      },
    );
  }

  Future<void> listModifierGroups() async {
    emit(state.copyWith(loadModifiersInfo: const OperationInfo(status: OperationStatus.loading)));
    final result = await _repo.listModifierGroups();
    result.fold(
      (failure) {
        Fluttertoast.showToast(msg: failure.message);
        emit(state.copyWith(loadModifiersInfo: OperationInfo(status: OperationStatus.error, error: failure)));
      },
      (groups) {
        emit(state.copyWith(
          modifierGroups: groups,
          loadModifiersInfo: const OperationInfo(status: OperationStatus.success),
        ));
      },
    );
  }

  Future<void> createModifierGroup(Map<String, dynamic> data) async {
    emit(state.copyWith(saveModifiersInfo: const OperationInfo(status: OperationStatus.loading)));
    final result = await _repo.createModifierGroup(data);
    result.fold(
      (failure) {
        Fluttertoast.showToast(msg: failure.message);
        emit(state.copyWith(saveModifiersInfo: OperationInfo(status: OperationStatus.error, error: failure)));
      },
      (_) {
        Fluttertoast.showToast(msg: 'Modifier group created');
        emit(state.copyWith(saveModifiersInfo: const OperationInfo(status: OperationStatus.success)));
        listModifierGroups();
      },
    );
  }

  Future<void> listComboMeals() async {
    emit(state.copyWith(loadCombosInfo: const OperationInfo(status: OperationStatus.loading)));
    final result = await _repo.listComboMeals();
    result.fold(
      (failure) {
        Fluttertoast.showToast(msg: failure.message);
        emit(state.copyWith(loadCombosInfo: OperationInfo(status: OperationStatus.error, error: failure)));
      },
      (combos) {
        emit(state.copyWith(
          comboMeals: combos,
          loadCombosInfo: const OperationInfo(status: OperationStatus.success),
        ));
      },
    );
  }

  Future<void> createComboMeal(Map<String, dynamic> data) async {
    emit(state.copyWith(saveCombosInfo: const OperationInfo(status: OperationStatus.loading)));
    final result = await _repo.createComboMeal(data);
    result.fold(
      (failure) {
        Fluttertoast.showToast(msg: failure.message);
        emit(state.copyWith(saveCombosInfo: OperationInfo(status: OperationStatus.error, error: failure)));
      },
      (_) {
        Fluttertoast.showToast(msg: 'Combo meal created');
        emit(state.copyWith(saveCombosInfo: const OperationInfo(status: OperationStatus.success)));
        listComboMeals();
      },
    );
  }
}
