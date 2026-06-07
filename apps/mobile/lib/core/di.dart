import 'package:get_it/get_it.dart';
import 'package:mobile/features/auth/controllers/user.cubit.dart';
import 'package:mobile/features/auth/controllers/user.repo.dart';
import 'package:mobile/features/business/controllers/business.repo.dart';
import 'package:mobile/services/api_client.dart';
import 'package:mobile/services/local_storage.dart';

final GetIt serviceLocator = GetIt.instance;

Future<void> setupDependencies() async {
  if (serviceLocator.isRegistered<LocalStorage>()) {
    return;
  }
  serviceLocator.registerLazySingleton<LocalStorage>(LocalStorage.new);
  serviceLocator.registerLazySingleton<ApiClient>(
    () => ApiClient(localStorage: serviceLocator<LocalStorage>()),
  );
  serviceLocator.registerFactory<UserRepo>(
    () => UserRepo(
      apiClient: serviceLocator<ApiClient>(),
      localStorage: serviceLocator<LocalStorage>(),
    ),
  );
  serviceLocator.registerFactory<UserCubit>(
    () => UserCubit(
      userRepo: serviceLocator<UserRepo>(),
      businessRepo: serviceLocator<BusinessRepo>(),
    ),
  );
  serviceLocator.registerFactory<BusinessRepo>(
    () => BusinessRepo(apiClient: serviceLocator<ApiClient>()),
  );
}

class AppDependencies {
  static LocalStorage get localStorage {
    return serviceLocator<LocalStorage>();
  }

  static ApiClient get apiClient {
    return serviceLocator<ApiClient>();
  }

  static UserRepo get userRepo {
    return serviceLocator<UserRepo>();
  }

  static UserCubit get userCubit {
    return serviceLocator<UserCubit>();
  }

  static BusinessRepo get businessRepo {
    return serviceLocator<BusinessRepo>();
  }
}

