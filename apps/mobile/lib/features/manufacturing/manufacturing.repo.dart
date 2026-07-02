import 'package:mobile/services/api_client.dart';
import 'package:mobile/utils/try_catch.dart';
import 'package:mobile/features/manufacturing/bill_of_material.model.dart';
import 'package:mobile/features/manufacturing/production_batch.model.dart';
import 'package:mobile/features/manufacturing/q_c_audit.model.dart';
import 'package:mobile/features/manufacturing/wastage_log.model.dart';

class ManufacturingEndpoints {
  static const String boms = '/manufacturing/boms';
  static String bom(String id) => '/manufacturing/boms/$id';
  static String bomItems(String id) => '/manufacturing/boms/$id/items';
  
  static const String batches = '/manufacturing/batches';
  static String batch(String id) => '/manufacturing/batches/$id';
  static String batchStatus(String id) => '/manufacturing/batches/$id/status';
  
  static const String qcAudits = '/manufacturing/qc-audits';
  static String qcAudit(String id) => '/manufacturing/qc-audits/$id';
  
  static const String wastageLogs = '/manufacturing/wastage-logs';
}

class ManufacturingRepo {
  final ApiClient _apiClient;

  ManufacturingRepo({required ApiClient apiClient}) : _apiClient = apiClient;

  TaskResult<List<BillOfMaterialModel>> listBOMs() async {
    return tryCatchAsync(() async {
      final response = await _apiClient.get(ManufacturingEndpoints.boms);
      final data = response.data['data'] as List;
      return data.map((e) => BillOfMaterialModel.fromJson(e)).toList();
    });
  }

  TaskResult<BillOfMaterialModel> createBOM(Map<String, dynamic> data) async {
    return tryCatchAsync(() async {
      final response = await _apiClient.post(ManufacturingEndpoints.boms, data: data);
      return BillOfMaterialModel.fromJson(response.data['data']);
    });
  }

  TaskResult<BillOfMaterialModel> getBOM(String id) async {
    return tryCatchAsync(() async {
      final response = await _apiClient.get(ManufacturingEndpoints.bom(id));
      return BillOfMaterialModel.fromJson(response.data['data']);
    });
  }

  TaskResult<dynamic> addBOMItem(String id, Map<String, dynamic> data) async {
    return tryCatchAsync(() async {
      final response = await _apiClient.post(ManufacturingEndpoints.bomItems(id), data: data);
      return response.data['data'];
    });
  }

  TaskResult<List<ProductionBatchModel>> listBatches() async {
    return tryCatchAsync(() async {
      final response = await _apiClient.get(ManufacturingEndpoints.batches);
      final data = response.data['data'] as List;
      return data.map((e) => ProductionBatchModel.fromJson(e)).toList();
    });
  }

  TaskResult<ProductionBatchModel> createBatch(Map<String, dynamic> data) async {
    return tryCatchAsync(() async {
      final response = await _apiClient.post(ManufacturingEndpoints.batches, data: data);
      return ProductionBatchModel.fromJson(response.data['data']);
    });
  }

  TaskResult<ProductionBatchModel> getBatch(String id) async {
    return tryCatchAsync(() async {
      final response = await _apiClient.get(ManufacturingEndpoints.batch(id));
      return ProductionBatchModel.fromJson(response.data['data']);
    });
  }

  TaskResult<ProductionBatchModel> updateBatchStatus(String id, Map<String, dynamic> data) async {
    return tryCatchAsync(() async {
      final response = await _apiClient.patch(ManufacturingEndpoints.batchStatus(id), data: data);
      return ProductionBatchModel.fromJson(response.data['data']);
    });
  }

  TaskResult<List<QCAuditModel>> listQCAudits() async {
    return tryCatchAsync(() async {
      final response = await _apiClient.get(ManufacturingEndpoints.qcAudits);
      final data = response.data['data'] as List;
      return data.map((e) => QCAuditModel.fromJson(e)).toList();
    });
  }

  TaskResult<QCAuditModel> createQCAudit(Map<String, dynamic> data) async {
    return tryCatchAsync(() async {
      final response = await _apiClient.post(ManufacturingEndpoints.qcAudits, data: data);
      return QCAuditModel.fromJson(response.data['data']);
    });
  }

  TaskResult<List<WastageLogModel>> listWastageLogs() async {
    return tryCatchAsync(() async {
      final response = await _apiClient.get(ManufacturingEndpoints.wastageLogs);
      final data = response.data['data'] as List;
      return data.map((e) => WastageLogModel.fromJson(e)).toList();
    });
  }

  TaskResult<WastageLogModel> createWastageLog(Map<String, dynamic> data) async {
    return tryCatchAsync(() async {
      final response = await _apiClient.post(ManufacturingEndpoints.wastageLogs, data: data);
      return WastageLogModel.fromJson(response.data['data']);
    });
  }
}
