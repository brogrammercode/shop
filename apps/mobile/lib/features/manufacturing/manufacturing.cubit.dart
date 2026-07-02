import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mobile/utils/error.dart';
import 'package:mobile/features/manufacturing/manufacturing.repo.dart';
import 'package:mobile/features/manufacturing/manufacturing.state.dart';

class ManufacturingCubit extends Cubit<ManufacturingState> {
  final ManufacturingRepo _repo;

  ManufacturingCubit({required ManufacturingRepo repo})
      : _repo = repo,
        super(const ManufacturingState());

  Future<void> listBOMs() async {
    emit(state.copyWith(loadBomsInfo: const OperationInfo(status: OperationStatus.loading)));
    final result = await _repo.listBOMs();
    result.fold(
      (failure) {
        Fluttertoast.showToast(msg: failure.message);
        emit(state.copyWith(loadBomsInfo: OperationInfo(status: OperationStatus.error, error: failure)));
      },
      (boms) {
        emit(state.copyWith(
          boms: boms,
          loadBomsInfo: const OperationInfo(status: OperationStatus.success),
        ));
      },
    );
  }

  Future<void> createBOM(Map<String, dynamic> data) async {
    emit(state.copyWith(saveBomsInfo: const OperationInfo(status: OperationStatus.loading)));
    final result = await _repo.createBOM(data);
    result.fold(
      (failure) {
        Fluttertoast.showToast(msg: failure.message);
        emit(state.copyWith(saveBomsInfo: OperationInfo(status: OperationStatus.error, error: failure)));
      },
      (_) {
        Fluttertoast.showToast(msg: 'BOM created');
        emit(state.copyWith(saveBomsInfo: const OperationInfo(status: OperationStatus.success)));
        listBOMs();
      },
    );
  }

  Future<void> getBOM(String id) async {
    emit(state.copyWith(loadBomsInfo: const OperationInfo(status: OperationStatus.loading)));
    final result = await _repo.getBOM(id);
    result.fold(
      (failure) {
        Fluttertoast.showToast(msg: failure.message);
        emit(state.copyWith(loadBomsInfo: OperationInfo(status: OperationStatus.error, error: failure)));
      },
      (bom) {
        emit(state.copyWith(
          selectedBom: bom,
          loadBomsInfo: const OperationInfo(status: OperationStatus.success),
        ));
      },
    );
  }

  Future<void> addBOMItem(String id, Map<String, dynamic> data) async {
    emit(state.copyWith(saveBomsInfo: const OperationInfo(status: OperationStatus.loading)));
    final result = await _repo.addBOMItem(id, data);
    result.fold(
      (failure) {
        Fluttertoast.showToast(msg: failure.message);
        emit(state.copyWith(saveBomsInfo: OperationInfo(status: OperationStatus.error, error: failure)));
      },
      (_) {
        Fluttertoast.showToast(msg: 'BOM item added');
        emit(state.copyWith(saveBomsInfo: const OperationInfo(status: OperationStatus.success)));
        getBOM(id);
      },
    );
  }

  Future<void> listBatches() async {
    emit(state.copyWith(loadBatchesInfo: const OperationInfo(status: OperationStatus.loading)));
    final result = await _repo.listBatches();
    result.fold(
      (failure) {
        Fluttertoast.showToast(msg: failure.message);
        emit(state.copyWith(loadBatchesInfo: OperationInfo(status: OperationStatus.error, error: failure)));
      },
      (batches) {
        emit(state.copyWith(
          batches: batches,
          loadBatchesInfo: const OperationInfo(status: OperationStatus.success),
        ));
      },
    );
  }

  Future<void> createBatch(Map<String, dynamic> data) async {
    emit(state.copyWith(saveBatchesInfo: const OperationInfo(status: OperationStatus.loading)));
    final result = await _repo.createBatch(data);
    result.fold(
      (failure) {
        Fluttertoast.showToast(msg: failure.message);
        emit(state.copyWith(saveBatchesInfo: OperationInfo(status: OperationStatus.error, error: failure)));
      },
      (_) {
        Fluttertoast.showToast(msg: 'Production batch created');
        emit(state.copyWith(saveBatchesInfo: const OperationInfo(status: OperationStatus.success)));
        listBatches();
      },
    );
  }

  Future<void> updateBatchStatus(String id, Map<String, dynamic> data) async {
    emit(state.copyWith(saveBatchesInfo: const OperationInfo(status: OperationStatus.loading)));
    final result = await _repo.updateBatchStatus(id, data);
    result.fold(
      (failure) {
        Fluttertoast.showToast(msg: failure.message);
        emit(state.copyWith(saveBatchesInfo: OperationInfo(status: OperationStatus.error, error: failure)));
      },
      (_) {
        Fluttertoast.showToast(msg: 'Batch status updated');
        emit(state.copyWith(saveBatchesInfo: const OperationInfo(status: OperationStatus.success)));
        listBatches();
      },
    );
  }

  Future<void> listQCAudits() async {
    emit(state.copyWith(loadAuditsInfo: const OperationInfo(status: OperationStatus.loading)));
    final result = await _repo.listQCAudits();
    result.fold(
      (failure) {
        Fluttertoast.showToast(msg: failure.message);
        emit(state.copyWith(loadAuditsInfo: OperationInfo(status: OperationStatus.error, error: failure)));
      },
      (audits) {
        emit(state.copyWith(
          qcAudits: audits,
          loadAuditsInfo: const OperationInfo(status: OperationStatus.success),
        ));
      },
    );
  }

  Future<void> createQCAudit(Map<String, dynamic> data) async {
    emit(state.copyWith(saveAuditsInfo: const OperationInfo(status: OperationStatus.loading)));
    final result = await _repo.createQCAudit(data);
    result.fold(
      (failure) {
        Fluttertoast.showToast(msg: failure.message);
        emit(state.copyWith(saveAuditsInfo: OperationInfo(status: OperationStatus.error, error: failure)));
      },
      (_) {
        Fluttertoast.showToast(msg: 'QC audit created');
        emit(state.copyWith(saveAuditsInfo: const OperationInfo(status: OperationStatus.success)));
        listQCAudits();
      },
    );
  }

  Future<void> listWastageLogs() async {
    emit(state.copyWith(loadWastageInfo: const OperationInfo(status: OperationStatus.loading)));
    final result = await _repo.listWastageLogs();
    result.fold(
      (failure) {
        Fluttertoast.showToast(msg: failure.message);
        emit(state.copyWith(loadWastageInfo: OperationInfo(status: OperationStatus.error, error: failure)));
      },
      (logs) {
        emit(state.copyWith(
          wastageLogs: logs,
          loadWastageInfo: const OperationInfo(status: OperationStatus.success),
        ));
      },
    );
  }

  Future<void> createWastageLog(Map<String, dynamic> data) async {
    emit(state.copyWith(saveWastageInfo: const OperationInfo(status: OperationStatus.loading)));
    final result = await _repo.createWastageLog(data);
    result.fold(
      (failure) {
        Fluttertoast.showToast(msg: failure.message);
        emit(state.copyWith(saveWastageInfo: OperationInfo(status: OperationStatus.error, error: failure)));
      },
      (_) {
        Fluttertoast.showToast(msg: 'Wastage log created');
        emit(state.copyWith(saveWastageInfo: const OperationInfo(status: OperationStatus.success)));
        listWastageLogs();
      },
    );
  }
}
