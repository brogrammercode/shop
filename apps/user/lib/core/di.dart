import 'package:get_it/get_it.dart';
import 'package:user/services/api_client.dart';
import 'package:user/services/local_storage.dart';

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
}
