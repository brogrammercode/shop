import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:user/utils/error.dart';
import 'store.repo.dart';
import 'store.state.dart';

class StoreCubit extends Cubit<StoreState> {
  final StoreRepo _storeRepo;

  StoreCubit({required StoreRepo storeRepo})
      : _storeRepo = storeRepo,
        super(const StoreState());

  Future<void> fetchMenu() async {
    emit(state.copyWith(loadMenuInfo: const OperationInfo(status: OperationStatus.loading)));

    final result = await _storeRepo.getMenu();

    result.fold(
      (failure) {
        Fluttertoast.showToast(msg: failure.message);
        emit(
          state.copyWith(
            loadMenuInfo: OperationInfo(status: OperationStatus.error, error: failure),
          ),
        );
      },
      (data) {
        emit(
          state.copyWith(
            menuCategories: data,
            loadMenuInfo: const OperationInfo(status: OperationStatus.success),
          ),
        );
      },
    );
  }
}
