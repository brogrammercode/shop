import 'package:get_it/get_it.dart';
import 'package:user/features/auth/auth.cubit.dart';
import 'package:user/features/auth/auth.repo.dart';
import 'package:user/features/store/store.cubit.dart';
import 'package:user/features/store/store.repo.dart';
import 'package:user/features/order/order.cubit.dart';
import 'package:user/features/order/order.repo.dart';
import 'package:user/services/api_client.dart';
import 'package:user/services/local_storage.dart';
import 'package:user/services/socket_service.dart';

final GetIt serviceLocator = GetIt.instance;

Future<void> setupDependencies() async {
  if (serviceLocator.isRegistered<LocalStorage>()) {
    return;
  }
  
  serviceLocator.registerLazySingleton<LocalStorage>(LocalStorage.new);
  
  serviceLocator.registerLazySingleton<ApiClient>(
    () => ApiClient(localStorage: serviceLocator<LocalStorage>()),
  );

  serviceLocator.registerLazySingleton<SocketService>(
    () => SocketService('http://10.0.2.2:3000', serviceLocator<LocalStorage>()),
  );

  serviceLocator.registerFactory<AuthRepo>(
    () => AuthRepo(
      apiClient: serviceLocator<ApiClient>(),
      localStorage: serviceLocator<LocalStorage>(),
    ),
  );
  
  serviceLocator.registerFactory<AuthCubit>(
    () => AuthCubit(authRepo: serviceLocator<AuthRepo>()),
  );

  serviceLocator.registerFactory<StoreRepo>(
    () => StoreRepo(apiClient: serviceLocator<ApiClient>()),
  );
  
  serviceLocator.registerFactory<StoreCubit>(
    () => StoreCubit(storeRepo: serviceLocator<StoreRepo>()),
  );

  serviceLocator.registerFactory<OrderRepo>(
    () => OrderRepo(apiClient: serviceLocator<ApiClient>()),
  );

  serviceLocator.registerFactory<OrderCubit>(
    () => OrderCubit(repo: serviceLocator<OrderRepo>()),
  );
}

class AppDependencies {
  static LocalStorage get localStorage => serviceLocator<LocalStorage>();
  static ApiClient get apiClient => serviceLocator<ApiClient>();
  static SocketService get socketService => serviceLocator<SocketService>();
  
  static AuthRepo get authRepo => serviceLocator<AuthRepo>();
  static AuthCubit get authCubit => serviceLocator<AuthCubit>();
  
  static StoreRepo get storeRepo => serviceLocator<StoreRepo>();
  static StoreCubit get storeCubit => serviceLocator<StoreCubit>();

  static OrderRepo get orderRepo => serviceLocator<OrderRepo>();
  static OrderCubit get orderCubit => serviceLocator<OrderCubit>();
}
