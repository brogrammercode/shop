import 'package:get_it/get_it.dart';
import 'package:mobile/services/api_client.dart';
import 'package:mobile/services/local_storage.dart';
import 'package:mobile/features/core_hr/controllers/core_hr.repo.dart';
import 'package:mobile/features/core_hr/controllers/core_hr.cubit.dart';
import 'package:mobile/features/inventory/inventory.repo.dart';
import 'package:mobile/features/inventory/inventory.cubit.dart';
import 'package:mobile/features/catalog/catalog.repo.dart';
import 'package:mobile/features/catalog/catalog.cubit.dart';
import 'package:mobile/features/pos_kds/pos_kds.repo.dart';
import 'package:mobile/features/pos_kds/pos_kds.cubit.dart';
import 'package:mobile/features/manufacturing/manufacturing.repo.dart';
import 'package:mobile/features/manufacturing/manufacturing.cubit.dart';
import 'package:mobile/features/finance/finance.repo.dart';
import 'package:mobile/features/finance/finance.cubit.dart';
import 'package:mobile/features/crm/crm.repo.dart';
import 'package:mobile/features/crm/crm.cubit.dart';

final GetIt serviceLocator = GetIt.instance;

Future<void> setupDependencies() async {
  if (serviceLocator.isRegistered<LocalStorage>()) {
    return;
  }
  serviceLocator.registerLazySingleton<LocalStorage>(LocalStorage.new);
  serviceLocator.registerLazySingleton<ApiClient>(
    () => ApiClient(localStorage: serviceLocator<LocalStorage>()),
  );
}

class AppDependencies {
  static LocalStorage get localStorage {
    return serviceLocator<LocalStorage>();
  }

  static ApiClient get apiClient {
    return serviceLocator<ApiClient>();
  }

  static CoreHrRepo coreHrRepo() {
    return CoreHrRepo(apiClient: apiClient, localStorage: localStorage);
  }

  static CoreHrCubit coreHrCubit() {
    return CoreHrCubit(repo: coreHrRepo());
  }

  static InventoryRepo inventoryRepo() {
    return InventoryRepo(apiClient: apiClient);
  }

  static InventoryCubit inventoryCubit() {
    return InventoryCubit(repo: inventoryRepo());
  }

  static CatalogRepo catalogRepo() {
    return CatalogRepo(apiClient: apiClient);
  }

  static CatalogCubit catalogCubit() {
    return CatalogCubit(repo: catalogRepo());
  }

  static PosKdsRepo posKdsRepo() {
    return PosKdsRepo(apiClient: apiClient);
  }

  static PosKdsCubit posKdsCubit() {
    return PosKdsCubit(repo: posKdsRepo());
  }

  static ManufacturingRepo manufacturingRepo() {
    return ManufacturingRepo(apiClient: apiClient);
  }

  static ManufacturingCubit manufacturingCubit() {
    return ManufacturingCubit(repo: manufacturingRepo());
  }

  static FinanceRepo financeRepo() {
    return FinanceRepo(apiClient: apiClient);
  }

  static FinanceCubit financeCubit() {
    return FinanceCubit(repo: financeRepo());
  }

  static CrmRepo crmRepo() {
    return CrmRepo(apiClient: apiClient);
  }

  static CrmCubit crmCubit() {
    return CrmCubit(repo: crmRepo());
  }
}
