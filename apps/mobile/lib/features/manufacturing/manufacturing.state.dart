import 'package:mobile/utils/error.dart';
import 'package:mobile/features/manufacturing/bill_of_material.model.dart';
import 'package:mobile/features/manufacturing/production_batch.model.dart';
import 'package:mobile/features/manufacturing/q_c_audit.model.dart';
import 'package:mobile/features/manufacturing/wastage_log.model.dart';

class ManufacturingState {
  final List<BillOfMaterialModel> boms;
  final BillOfMaterialModel? selectedBom;
  final List<ProductionBatchModel> batches;
  final ProductionBatchModel? selectedBatch;
  final List<QCAuditModel> qcAudits;
  final List<WastageLogModel> wastageLogs;

  final OperationInfo loadBomsInfo;
  final OperationInfo saveBomsInfo;
  final OperationInfo loadBatchesInfo;
  final OperationInfo saveBatchesInfo;
  final OperationInfo loadAuditsInfo;
  final OperationInfo saveAuditsInfo;
  final OperationInfo loadWastageInfo;
  final OperationInfo saveWastageInfo;

  const ManufacturingState({
    this.boms = const [],
    this.selectedBom,
    this.batches = const [],
    this.selectedBatch,
    this.qcAudits = const [],
    this.wastageLogs = const [],
    this.loadBomsInfo = const OperationInfo(status: OperationStatus.initial),
    this.saveBomsInfo = const OperationInfo(status: OperationStatus.initial),
    this.loadBatchesInfo = const OperationInfo(status: OperationStatus.initial),
    this.saveBatchesInfo = const OperationInfo(status: OperationStatus.initial),
    this.loadAuditsInfo = const OperationInfo(status: OperationStatus.initial),
    this.saveAuditsInfo = const OperationInfo(status: OperationStatus.initial),
    this.loadWastageInfo = const OperationInfo(status: OperationStatus.initial),
    this.saveWastageInfo = const OperationInfo(status: OperationStatus.initial),
  });

  ManufacturingState copyWith({
    List<BillOfMaterialModel>? boms,
    BillOfMaterialModel? selectedBom,
    List<ProductionBatchModel>? batches,
    ProductionBatchModel? selectedBatch,
    List<QCAuditModel>? qcAudits,
    List<WastageLogModel>? wastageLogs,
    OperationInfo? loadBomsInfo,
    OperationInfo? saveBomsInfo,
    OperationInfo? loadBatchesInfo,
    OperationInfo? saveBatchesInfo,
    OperationInfo? loadAuditsInfo,
    OperationInfo? saveAuditsInfo,
    OperationInfo? loadWastageInfo,
    OperationInfo? saveWastageInfo,
  }) {
    return ManufacturingState(
      boms: boms ?? this.boms,
      selectedBom: selectedBom ?? this.selectedBom,
      batches: batches ?? this.batches,
      selectedBatch: selectedBatch ?? this.selectedBatch,
      qcAudits: qcAudits ?? this.qcAudits,
      wastageLogs: wastageLogs ?? this.wastageLogs,
      loadBomsInfo: loadBomsInfo ?? this.loadBomsInfo,
      saveBomsInfo: saveBomsInfo ?? this.saveBomsInfo,
      loadBatchesInfo: loadBatchesInfo ?? this.loadBatchesInfo,
      saveBatchesInfo: saveBatchesInfo ?? this.saveBatchesInfo,
      loadAuditsInfo: loadAuditsInfo ?? this.loadAuditsInfo,
      saveAuditsInfo: saveAuditsInfo ?? this.saveAuditsInfo,
      loadWastageInfo: loadWastageInfo ?? this.loadWastageInfo,
      saveWastageInfo: saveWastageInfo ?? this.saveWastageInfo,
    );
  }
}
