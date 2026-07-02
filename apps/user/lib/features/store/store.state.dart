import 'package:user/utils/error.dart';
import 'menu.model.dart';

class StoreState {
  final List<MenuCategory> menuCategories;
  final OperationInfo loadMenuInfo;

  const StoreState({
    this.menuCategories = const [],
    this.loadMenuInfo = const OperationInfo(status: OperationStatus.initial),
  });

  StoreState copyWith({
    List<MenuCategory>? menuCategories,
    OperationInfo? loadMenuInfo,
  }) {
    return StoreState(
      menuCategories: menuCategories ?? this.menuCategories,
      loadMenuInfo: loadMenuInfo ?? this.loadMenuInfo,
    );
  }
}
