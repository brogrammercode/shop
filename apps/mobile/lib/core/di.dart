import 'package:get_it/get_it.dart';
import 'package:mobile/features/auth/cubit/auth_cubit.dart';
import 'package:mobile/features/auth/repo/auth_repo.dart';
import 'package:mobile/features/business/cubit/business_cubit.dart';
import 'package:mobile/features/business/repo/business_repo.dart';
import 'package:mobile/services/api_client.dart';
import 'package:mobile/services/google_auth_service.dart';
import 'package:mobile/services/local_storage.dart';

final GetIt serviceLocator = GetIt.instance;

Future<void> setupDependencies() async {
  if (serviceLocator.isRegistered<LocalStorage>()) {
    return;
  }

  serviceLocator.registerLazySingleton<LocalStorage>(LocalStorage.new);
  serviceLocator.registerLazySingleton<GoogleAuthService>(
    GoogleAuthService.new,
  );
  await serviceLocator<GoogleAuthService>().initialize();
  serviceLocator.registerLazySingleton<ApiClient>(
    () => ApiClient(localStorage: serviceLocator<LocalStorage>()),
  );
  serviceLocator.registerFactory<AuthRepo>(
    () => AuthRepo(
      apiClient: serviceLocator<ApiClient>(),
      localStorage: serviceLocator<LocalStorage>(),
    ),
  );
  serviceLocator.registerFactory<BusinessRepo>(
    () => BusinessRepo(
      apiClient: serviceLocator<ApiClient>(),
      localStorage: serviceLocator<LocalStorage>(),
    ),
  );
  serviceLocator.registerFactory<AuthCubit>(
    () => AuthCubit(
      authRepo: serviceLocator<AuthRepo>(),
      googleAuthService: serviceLocator<GoogleAuthService>(),
    ),
  );
  serviceLocator.registerFactory<BusinessCubit>(
    () => BusinessCubit(serviceLocator<BusinessRepo>()),
  );
}

class AppDependencies {
  static LocalStorage get localStorage {
    return serviceLocator<LocalStorage>();
  }

  static ApiClient get apiClient {
    return serviceLocator<ApiClient>();
  }

  static GoogleAuthService get googleAuthService {
    return serviceLocator<GoogleAuthService>();
  }

  static AuthRepo authRepo() {
    return serviceLocator<AuthRepo>();
  }

  static BusinessRepo businessRepo() {
    return serviceLocator<BusinessRepo>();
  }

  static AuthCubit authCubit() {
    return serviceLocator<AuthCubit>();
  }

  static BusinessCubit businessCubit() {
    return serviceLocator<BusinessCubit>();
  }
}
