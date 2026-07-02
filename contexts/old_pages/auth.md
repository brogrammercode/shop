import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mobile/features/auth/constants/user.constant.dart';
import 'package:mobile/features/auth/controllers/user.repo.dart';
import 'package:mobile/features/auth/controllers/user.state.dart';
import 'package:mobile/features/auth/models/user_log.dart';
import 'package:mobile/features/auth/models/user_session.dart';
import 'package:mobile/features/auth/models/user.dart';
import 'package:mobile/features/business/repo/business_repo.dart';
import 'package:mobile/services/json_cache.dart';

import 'package:mobile/utils/error.dart';

class UserCubit extends Cubit<UserState> {
final UserRepo \_userRepo;
final BusinessRepo \_businessRepo;
final JsonCache \_jsonCache;

UserCubit({
required UserRepo userRepo,
required BusinessRepo businessRepo,
}) : \_userRepo = userRepo,
\_businessRepo = businessRepo,
\_jsonCache = JsonCache(),
super(const UserState()) {
\_initFromCache();
}

Future<void> _initFromCache() async {
final userData = await \_jsonCache.getUser();
final businessContextData = await \_jsonCache.getBusinessContext();
if (userData != null) {
try {
final user = UserModel.fromJson(userData);
emit(state.copyWith(
user: user,
hasEmployeeProfile: businessContextData != null,
));
} catch (_) {}
}
}

Future<void> loginWithGoogle({required bool rememberLogin}) async {
emit(state.copyWith(loginInfo: const OperationInfo(status: OperationStatus.loading)));

    final result = await _userRepo.loginWithGoogle(rememberLogin: rememberLogin);

    await result.fold(
      (failure) async {
        if (failure.message != UserConstant.googleSignInCanceled) Fluttertoast.showToast(msg: failure.message);
        emit(state.copyWith(
          loginInfo: failure.message == UserConstant.googleSignInCanceled
              ? const OperationInfo(status: OperationStatus.initial)
              : OperationInfo(status: OperationStatus.error, error: failure),
        ));
      },
      (user) async {
        final contextResult = await _businessRepo.getContext();
        await contextResult.fold(
          (failure) async {
            // User does not have a business context yet.
            if (rememberLogin) {
              await _jsonCache.saveUser(user.toJson());
              final token = await _userRepo.getToken();
              if (token != null) {
                await _jsonCache.saveSavedProfile({'user': user.toJson(), 'token': token});
              }
            }
            emit(state.copyWith(
              user: user,
              hasEmployeeProfile: false,
              loginInfo: const OperationInfo(status: OperationStatus.success),
            ));
          },
          (businessContext) async {
            if (rememberLogin) {
              await _jsonCache.saveUser(user.toJson());
              await _jsonCache.saveBusinessContext(businessContext.toJson());
              final token = await _userRepo.getToken();
              if (token != null) {
                await _jsonCache.saveSavedProfile({'user': user.toJson(), 'token': token});
              }
            }
            Fluttertoast.showToast(msg: UserConstant.loginSuccessMessage);
            emit(state.copyWith(
              user: user,
              hasEmployeeProfile: true,
              loginInfo: const OperationInfo(status: OperationStatus.success),
            ));
          },
        );
      },
    );

}

Future<void> getCurrentUser() async {
emit(
state.copyWith(
loadUserInfo: const OperationInfo(status: OperationStatus.loading),
),
);

    final result = await _userRepo.getCurrentUser();

    await result.fold(
      (failure) async => emit(
        state.copyWith(
          loadUserInfo: OperationInfo(
            status: OperationStatus.error,
            error: failure,
          ),
        ),
      ),
      (user) async {
        await _jsonCache.saveUser(user.toJson());
        final contextResult = await _businessRepo.getContext();

        await contextResult.fold(
          (failure) async {
            emit(
              state.copyWith(
                user: user,
                hasEmployeeProfile: false,
                loadUserInfo: const OperationInfo(status: OperationStatus.success),
              ),
            );
          },
          (businessContext) async {
            await _jsonCache.saveBusinessContext(businessContext.toJson());
            emit(
              state.copyWith(
                user: user,
                hasEmployeeProfile: true,
                loadUserInfo: const OperationInfo(status: OperationStatus.success),
              ),
            );
          },
        );
      },
    );

}

Future<void> logout() async {
emit(
state.copyWith(
logoutInfo: const OperationInfo(status: OperationStatus.loading),
),
);

    final result = await _userRepo.logout();

    await result.fold(
      (failure) async {
        Fluttertoast.showToast(msg: failure.message);
        emit(
          state.copyWith(
            logoutInfo: OperationInfo(
              status: OperationStatus.error,
              error: failure,
            ),
          ),
        );
      },
      (_) async {
        await _jsonCache.clearAll();
        Fluttertoast.showToast(msg: UserConstant.logoutSuccessMessage);
        emit(
          const UserState(
            logoutInfo: OperationInfo(status: OperationStatus.success),
          ),
        );
      },
    );

}

Future<void> logActivity(UserLogModel log) async {
emit(
state.copyWith(
logActivityInfo: const OperationInfo(status: OperationStatus.loading),
),
);

    final result = await _userRepo.logActivity(log);

    await result.fold(
      (failure) async => emit(
        state.copyWith(
          logActivityInfo: OperationInfo(
            status: OperationStatus.error,
            error: failure,
          ),
        ),
      ),
      (_) async => emit(
        state.copyWith(
          logActivityInfo: const OperationInfo(status: OperationStatus.success),
        ),
      ),
    );

}

Future<void> getActivities(String userId) async {
emit(
state.copyWith(
loadActivitiesInfo: const OperationInfo(status: OperationStatus.loading),
),
);

    final result = await _userRepo.getActivities(userId);

    await result.fold(
      (failure) async => emit(
        state.copyWith(
          loadActivitiesInfo: OperationInfo(
            status: OperationStatus.error,
            error: failure,
          ),
        ),
      ),
      (activities) async => emit(
        state.copyWith(
          activities: activities,
          loadActivitiesInfo: const OperationInfo(status: OperationStatus.success),
        ),
      ),
    );

}

Future<void> sendOtp(String phoneNumber) async {
emit(
state.copyWith(
sendOtpInfo: const OperationInfo(status: OperationStatus.loading),
),
);

    final result = await _userRepo.sendOtp(phoneNumber);

    await result.fold(
      (failure) async {
        Fluttertoast.showToast(msg: failure.message);
        emit(
          state.copyWith(
            sendOtpInfo: OperationInfo(
              status: OperationStatus.error,
              error: failure,
            ),
          ),
        );
      },
      (_) async {
        Fluttertoast.showToast(msg: UserConstant.otpSentSuccess);
        emit(
          state.copyWith(
            sendOtpInfo: const OperationInfo(status: OperationStatus.success),
          ),
        );
      },
    );

}

Future<void> verifyOtp(String phoneNumber, String otp, {required bool rememberLogin}) async {
emit(
state.copyWith(
verifyOtpInfo: const OperationInfo(status: OperationStatus.loading),
),
);

    final result = await _userRepo.verifyOtp(phoneNumber, otp, rememberLogin: rememberLogin);

    await result.fold(
      (failure) async {
        Fluttertoast.showToast(msg: failure.message);
        emit(
          state.copyWith(
            verifyOtpInfo: OperationInfo(
              status: OperationStatus.error,
              error: failure,
            ),
          ),
        );
      },
      (user) async {
        final contextResult = await _businessRepo.getContext();

        await contextResult.fold(
          (failure) async {
            if (rememberLogin) {
              await _jsonCache.saveUser(user.toJson());
              final token = await _userRepo.getToken();
              if (token != null) {
                await _jsonCache.saveSavedProfile({'user': user.toJson(), 'token': token});
              }
            }
            emit(
              state.copyWith(
                user: user,
                hasEmployeeProfile: false,
                verifyOtpInfo: const OperationInfo(status: OperationStatus.success),
              ),
            );
          },
          (businessContext) async {
            if (rememberLogin) {
              await _jsonCache.saveUser(user.toJson());
              await _jsonCache.saveBusinessContext(businessContext.toJson());
              final token = await _userRepo.getToken();
              if (token != null) {
                await _jsonCache.saveSavedProfile({'user': user.toJson(), 'token': token});
              }
            }
            Fluttertoast.showToast(msg: UserConstant.otpVerifiedSuccess);
            emit(
              state.copyWith(
                user: user,
                hasEmployeeProfile: true,
                verifyOtpInfo: const OperationInfo(status: OperationStatus.success),
              ),
            );
          },
        );
      },
    );

}

Future<void> loginWithSavedProfile() async {
emit(state.copyWith(loginInfo: const OperationInfo(status: OperationStatus.loading)));

    final savedProfile = await _jsonCache.getSavedProfile();
    if (savedProfile != null && savedProfile['token'] != null) {
      await _userRepo.saveToken(savedProfile['token']);

      final result = await _userRepo.getCurrentUser();

      await result.fold(
        (failure) async {
          await _userRepo.logout();
          await _jsonCache.clearAll();
          emit(state.copyWith(
            loginInfo: OperationInfo(status: OperationStatus.error, error: failure),
          ));
        },
        (user) async {
          final contextResult = await _businessRepo.getContext();

          await contextResult.fold(
            (failure) async {
              emit(state.copyWith(
                user: user,
                hasEmployeeProfile: false,
                loginInfo: const OperationInfo(status: OperationStatus.success),
              ));
            },
            (businessContext) async {
              await _jsonCache.saveUser(user.toJson());
              await _jsonCache.saveBusinessContext(businessContext.toJson());
              Fluttertoast.showToast(msg: UserConstant.loginSuccessMessage);
              emit(state.copyWith(
                user: user,
                hasEmployeeProfile: true,
                loginInfo: const OperationInfo(status: OperationStatus.success),
              ));
            },
          );
        },
      );
    } else {
      emit(state.copyWith(
        loginInfo: const OperationInfo(status: OperationStatus.error, error: AuthFailure(UserConstant.noSavedProfileFound)),
      ));
    }

}
Future<void> getSessions() async {
emit(
state.copyWith(
loadSessionsInfo: const OperationInfo(status: OperationStatus.loading),
),
);

    final result = await _userRepo.getSessions();

    await result.fold(
      (failure) async => emit(
        state.copyWith(
          loadSessionsInfo: OperationInfo(
            status: OperationStatus.error,
            error: failure,
          ),
        ),
      ),
      (sessions) async => emit(
        state.copyWith(
          sessions: sessions,
          loadSessionsInfo: const OperationInfo(status: OperationStatus.success),
        ),
      ),
    );

}

Future<void> createSession(UserSessionModel session) async {
emit(
state.copyWith(
createSessionInfo: const OperationInfo(status: OperationStatus.loading),
),
);

    final result = await _userRepo.createSession(session);

    await result.fold(
      (failure) async => emit(
        state.copyWith(
          createSessionInfo: OperationInfo(
            status: OperationStatus.error,
            error: failure,
          ),
        ),
      ),
      (_) async => emit(
        state.copyWith(
          createSessionInfo: const OperationInfo(status: OperationStatus.success),
        ),
      ),
    );

}

Future<void> terminateSession(String sessionId) async {
emit(
state.copyWith(
terminateSessionInfo: const OperationInfo(status: OperationStatus.loading),
),
);

    final result = await _userRepo.terminateSession(sessionId);

    await result.fold(
      (failure) async {
        Fluttertoast.showToast(msg: failure.message);
        emit(
          state.copyWith(
            terminateSessionInfo: OperationInfo(
              status: OperationStatus.error,
              error: failure,
            ),
          ),
        );
      },
      (_) async {
        Fluttertoast.showToast(msg: UserConstant.sessionTerminatedSuccess);
        final currentSessions = state.sessions != null
            ? List<UserSessionModel>.from(state.sessions!)
            : <UserSessionModel>[];
        currentSessions.removeWhere((session) => session.id == sessionId);
        emit(
          state.copyWith(
            sessions: currentSessions,
            terminateSessionInfo: const OperationInfo(status: OperationStatus.success),
          ),
        );
      },
    );

}

Future<void> getAdBanners() async {
emit(
state.copyWith(
loadAdBannersInfo: const OperationInfo(status: OperationStatus.loading),
),
);

    final result = await _userRepo.getAdBanners();

    await result.fold(
      (failure) async => emit(
        state.copyWith(
          loadAdBannersInfo: OperationInfo(
            status: OperationStatus.error,
            error: failure,
          ),
        ),
      ),
      (adBanners) async => emit(
        state.copyWith(
          adBanners: adBanners,
          loadAdBannersInfo: const OperationInfo(status: OperationStatus.success),
        ),
      ),
    );

}
}

import 'package:mobile/features/auth/constants/user.endpoints.dart';
import 'package:mobile/features/auth/constants/user.params.dart';
import 'package:mobile/features/auth/models/user.dart';
import 'package:mobile/features/auth/models/user_log.dart';
import 'package:mobile/features/auth/models/user_session.dart';
import 'package:mobile/features/auth/models/ad_banner.dart';
import 'package:mobile/services/api_client.dart';
import 'package:mobile/services/local_storage.dart';
import 'package:mobile/utils/try_catch.dart';
import 'package:mobile/utils/error.dart';
import 'package:mobile/features/auth/constants/user.constant.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:mobile/core/config.dart';

class UserRepo {
final ApiClient \_apiClient;
final LocalStorage \_localStorage;

UserRepo({
required ApiClient apiClient,
required LocalStorage localStorage,
}) : \_apiClient = apiClient,
\_localStorage = localStorage;

Future<String?> getToken() => \_localStorage.getToken();
Future<void> saveToken(String token) => \_localStorage.saveToken(token);

TaskResult<UserModel> loginWithGoogle({required bool rememberLogin}) async {
return tryCatchAsync(() async {
final googleSignIn = GoogleSignIn(
clientId: AppConfig.googleClientId,
serverClientId: AppConfig.googleServerClientId,
);
final account = await googleSignIn.signIn();

      if (account == null) {
        throw const ServerException(UserConstant.googleSignInCanceled);
      }

      final auth = await account.authentication;
      final idToken = auth.idToken;

      if (idToken == null) {
        throw const ServerException(UserConstant.googleTokenRetrievalFailed);
      }

      final response = await _apiClient.post(
        UserEndpoints.loginEndpoint,
        data: {
          UserParams.idTokenKey: idToken,
          if (account.photoUrl != null) UserParams.pictureKey: account.photoUrl,
        },
      );
      final data = response.data[UserParams.dataKey];
      final user = UserModel.fromJson(data[UserParams.userKey]);
      final token = data[UserParams.tokensKey][UserParams.accessTokenKey]?.toString() ?? '';
      if (rememberLogin) {
        await _localStorage.saveToken(token);
      }
      return user;
    });

}

TaskResult<UserModel> getCurrentUser() async {
return tryCatchAsync(() async {
final response = await \_apiClient.get(UserEndpoints.meEndpoint);
final data = response.data[UserParams.dataKey];
return UserModel.fromJson(data);
});
}

TaskResult<void> logout() async {
return tryCatchAsync(() async {
await \_localStorage.clearSession();
});
}

TaskResult<void> logActivity(UserLogModel log) async {
return tryCatchAsync(() async {
await \_apiClient.post(
UserEndpoints.activityEndpoint,
data: log.toJson(),
);
});
}

TaskResult<List<UserLogModel>> getActivities(String userId) async {
return tryCatchAsync(() async {
final response = await \_apiClient.get(
'${UserEndpoints.activityEndpoint}/$userId',
);
final list = response.data[UserParams.dataKey] as List;
return list.map((item) => UserLogModel.fromJson(item)).toList();
});
}

TaskResult<void> sendOtp(String phoneNumber) async {
return tryCatchAsync(() async {
await \_apiClient.post(
UserEndpoints.sendOtp,
data: {UserParams.phoneNumberKey: phoneNumber},
);
});
}

TaskResult<UserModel> verifyOtp(String phoneNumber, String otp, {required bool rememberLogin}) async {
return tryCatchAsync(() async {
final response = await \_apiClient.post(
UserEndpoints.verifyOtp,
data: {
UserParams.phoneNumberKey: phoneNumber,
UserParams.otpKey: otp,
},
);
final data = response.data[UserParams.dataKey];
final user = UserModel.fromJson(data[UserParams.userKey]);
final token = data[UserParams.tokensKey][UserParams.accessTokenKey]?.toString() ?? '';
if (rememberLogin) {
await \_localStorage.saveToken(token);
}
return user;
});
}

TaskResult<List<UserSessionModel>> getSessions() async {
return tryCatchAsync(() async {
final response = await \_apiClient.get(UserEndpoints.sessions);
final list = response.data[UserParams.dataKey] as List;
return list.map((item) => UserSessionModel.fromJson(item)).toList();
});
}

TaskResult<void> createSession(UserSessionModel session) async {
return tryCatchAsync(() async {
await \_apiClient.post(
UserEndpoints.sessions,
data: session.toJson(),
);
});
}

TaskResult<void> terminateSession(String sessionId) async {
return tryCatchAsync(() async {
await \_apiClient.delete(
'${UserEndpoints.sessions}/$sessionId',
);
});
}

TaskResult<List<AdBannerModel>> getAdBanners() async {
return tryCatchAsync(() async {
final response = await _apiClient.get(UserEndpoints.adBanners);
final list = response.data[UserParams.dataKey] as List;
final banners = list.map((item) => AdBannerModel.fromJson(item)).toList();
final now = DateTime.now();
return banners.where((banner) {
final isActive = banner.status.toUpperCase() == 'ACTIVE';
DateTime? fromDate;
DateTime? toDate;
try {
fromDate = DateTime.parse(banner.valid_from);
} catch (_) {}
try {
toDate = DateTime.parse(banner.valid*to);
} catch (*) {}
final isFromValid = fromDate == null || now.isAfter(fromDate);
final isToValid = toDate == null || now.isBefore(toDate);
return isActive && isFromValid && isToValid;
}).toList();
});
}
}

import 'package:mobile/features/auth/models/user.dart';
import 'package:mobile/features/auth/models/user_log.dart';
import 'package:mobile/features/auth/models/user_session.dart';
import 'package:mobile/features/auth/models/ad_banner.dart';
import 'package:mobile/utils/error.dart';

class UserState {
final UserModel? user;
final List<UserLogModel>? activities;
final List<UserSessionModel>? sessions;
final List<AdBannerModel>? adBanners;
final bool? hasEmployeeProfile;
final OperationInfo loginInfo;
final OperationInfo logoutInfo;
final OperationInfo loadUserInfo;
final OperationInfo loadActivitiesInfo;
final OperationInfo logActivityInfo;
final OperationInfo sendOtpInfo;
final OperationInfo verifyOtpInfo;
final OperationInfo loadSessionsInfo;
final OperationInfo terminateSessionInfo;
final OperationInfo createSessionInfo;
final OperationInfo loadAdBannersInfo;

const UserState({
this.user,
this.activities,
this.sessions,
this.adBanners,
this.hasEmployeeProfile,
this.loginInfo = const OperationInfo(status: OperationStatus.initial),
this.logoutInfo = const OperationInfo(status: OperationStatus.initial),
this.loadUserInfo = const OperationInfo(status: OperationStatus.initial),
this.loadActivitiesInfo = const OperationInfo(status: OperationStatus.initial),
this.logActivityInfo = const OperationInfo(status: OperationStatus.initial),
this.sendOtpInfo = const OperationInfo(status: OperationStatus.initial),
this.verifyOtpInfo = const OperationInfo(status: OperationStatus.initial),
this.loadSessionsInfo = const OperationInfo(status: OperationStatus.initial),
this.terminateSessionInfo = const OperationInfo(status: OperationStatus.initial),
this.createSessionInfo = const OperationInfo(status: OperationStatus.initial),
this.loadAdBannersInfo = const OperationInfo(status: OperationStatus.initial),
});

UserState copyWith({
UserModel? user,
List<UserLogModel>? activities,
List<UserSessionModel>? sessions,
List<AdBannerModel>? adBanners,
bool? hasEmployeeProfile,
OperationInfo? loginInfo,
OperationInfo? logoutInfo,
OperationInfo? loadUserInfo,
OperationInfo? loadActivitiesInfo,
OperationInfo? logActivityInfo,
OperationInfo? sendOtpInfo,
OperationInfo? verifyOtpInfo,
OperationInfo? loadSessionsInfo,
OperationInfo? terminateSessionInfo,
OperationInfo? createSessionInfo,
OperationInfo? loadAdBannersInfo,
}) {
return UserState(
user: user ?? this.user,
activities: activities ?? this.activities,
sessions: sessions ?? this.sessions,
adBanners: adBanners ?? this.adBanners,
hasEmployeeProfile: hasEmployeeProfile ?? this.hasEmployeeProfile,
loginInfo: loginInfo ?? this.loginInfo,
logoutInfo: logoutInfo ?? this.logoutInfo,
loadUserInfo: loadUserInfo ?? this.loadUserInfo,
loadActivitiesInfo: loadActivitiesInfo ?? this.loadActivitiesInfo,
logActivityInfo: logActivityInfo ?? this.logActivityInfo,
sendOtpInfo: sendOtpInfo ?? this.sendOtpInfo,
verifyOtpInfo: verifyOtpInfo ?? this.verifyOtpInfo,
loadSessionsInfo: loadSessionsInfo ?? this.loadSessionsInfo,
terminateSessionInfo: terminateSessionInfo ?? this.terminateSessionInfo,
createSessionInfo: createSessionInfo ?? this.createSessionInfo,
loadAdBannersInfo: loadAdBannersInfo ?? this.loadAdBannersInfo,
);
}

@override
bool operator ==(Object other) {
if (identical(this, other)) return true;

    return other is UserState &&
        other.user == user &&
        other.activities == activities &&
        other.sessions == sessions &&
        other.adBanners == adBanners &&
        other.hasEmployeeProfile == hasEmployeeProfile &&
        other.loginInfo == loginInfo &&
        other.logoutInfo == logoutInfo &&
        other.loadUserInfo == loadUserInfo &&
        other.loadActivitiesInfo == loadActivitiesInfo &&
        other.logActivityInfo == logActivityInfo &&
        other.sendOtpInfo == sendOtpInfo &&
        other.verifyOtpInfo == verifyOtpInfo &&
        other.loadSessionsInfo == loadSessionsInfo &&
        other.terminateSessionInfo == terminateSessionInfo &&
        other.createSessionInfo == createSessionInfo &&
        other.loadAdBannersInfo == loadAdBannersInfo;

}

@override
int get hashCode =>
user.hashCode ^
activities.hashCode ^
sessions.hashCode ^
adBanners.hashCode ^
hasEmployeeProfile.hashCode ^
loginInfo.hashCode ^
logoutInfo.hashCode ^
loadUserInfo.hashCode ^
loadActivitiesInfo.hashCode ^
logActivityInfo.hashCode ^
sendOtpInfo.hashCode ^
verifyOtpInfo.hashCode ^
loadSessionsInfo.hashCode ^
terminateSessionInfo.hashCode ^
createSessionInfo.hashCode ^
loadAdBannersInfo.hashCode;
}

import prisma from '../../infra/database/client';
import { User, UserLog, UserSession, UserAddress, UserOtp, OtpType } from './user.type';

export class UserRepo {
async findById(id: string): Promise<User | null> {
return prisma.user.findUnique({
where: { id }
});
}

    async findByEmail(email: string): Promise<User | null> {
        return prisma.user.findUnique({
            where: { email }
        });
    }

    async findByPhoneNumber(phone_number: string): Promise<User | null> {
        return prisma.user.findFirst({
            where: { phone_number }
        });
    }

    async create(data: Omit<User, 'id' | 'created_at' | 'updated_at'>): Promise<User> {
        return prisma.user.create({
            data
        });
    }

    async update(id: string, data: Partial<Omit<User, 'id' | 'created_at' | 'updated_at'>>): Promise<User> {
        return prisma.user.update({
            where: { id },
            data
        });
    }

    async delete(id: string): Promise<User> {
        return prisma.user.delete({
            where: { id }
        });
    }

    async createUserLog(data: Omit<UserLog, 'id' | 'created_at' | 'updated_at'>): Promise<UserLog> {
        return prisma.userLog.create({
            data
        });
    }

    async getUserLogs(uid: string): Promise<UserLog[]> {
        return prisma.userLog.findMany({
            where: { uid },
            orderBy: { created_at: 'desc' }
        });
    }

    async createSession(data: Omit<UserSession, 'id' | 'created_at' | 'updated_at'>): Promise<UserSession> {
        return prisma.userSession.create({
            data
        });
    }

    async findSessionsByUserId(uid: string): Promise<UserSession[]> {
        return prisma.userSession.findMany({
            where: { uid },
            orderBy: { created_at: 'desc' }
        });
    }

    async deleteSession(id: string): Promise<UserSession> {
        return prisma.userSession.delete({
            where: { id }
        });
    }

    async createAddress(data: Omit<UserAddress, 'id' | 'created_at' | 'updated_at'>): Promise<UserAddress> {
        return prisma.userAddress.create({
            data
        });
    }

    async findAddressesByUserId(uid: string): Promise<UserAddress[]> {
        return prisma.userAddress.findMany({
            where: { uid },
            orderBy: { created_at: 'desc' }
        });
    }

    async updateAddress(id: string, data: Partial<Omit<UserAddress, 'id' | 'created_at' | 'updated_at'>>): Promise<UserAddress> {
        return prisma.userAddress.update({
            where: { id },
            data
        });
    }

    async deleteAddress(id: string): Promise<UserAddress> {
        return prisma.userAddress.delete({
            where: { id }
        });
    }

    async createOtp(data: { actor: string; otp: string; type: OtpType; valid_till: Date }): Promise<UserOtp> {
        return prisma.userOtp.create({ data }) as unknown as UserOtp;
    }

    async findValidOtp(actor: string, otp: string, type: OtpType): Promise<UserOtp | null> {
        return prisma.userOtp.findFirst({
            where: {
                actor,
                otp,
                type,
                valid_till: { gt: new Date() },
            },
        }) as unknown as UserOtp | null;
    }

    async findLatestOtpByActor(actor: string, type: OtpType): Promise<UserOtp | null> {
        return prisma.userOtp.findFirst({
            where: { actor, type },
            orderBy: { created_at: 'desc' },
        }) as unknown as UserOtp | null;
    }

    async deleteOtpsByActor(actor: string, type: OtpType): Promise<void> {
        await prisma.userOtp.deleteMany({ where: { actor, type } });
    }

    async getAdBanners() {
        return await prisma.adBanner.findMany({
            where: {
                status: 'ACTIVE'
            },
            orderBy: {
                created_at: 'desc'
            }
        });
    }

}

import admin from '../../infra/firebase/config';
import config from '../../core/config';
import { UserService } from './user.service';
import { User } from './user.type';
import { AUTH_MESSAGES, AUTH_CONFIG } from './auth.constant';
import { BadRequestError } from '../../utils/error';
import { SmsService } from '../../infra/messaging/sms.service';
import { UserRepo } from './user.repo';

export class AuthService {
private userService: UserService;
private smsService: SmsService;
private userRepo: UserRepo;

    constructor() {
        this.userService = new UserService();
        this.smsService = new SmsService();
        this.userRepo = new UserRepo();
    }

    async loginWithFirebase(idToken: string, fallbackPicture?: string): Promise<{ user: User, tokens: { accessToken: string, refreshToken: string } }> {
        let email: string | undefined;
        let name: string | undefined;
        let picture: string | undefined;

        try {
            const payloadSegment = idToken.split(AUTH_CONFIG.TOKEN_SPLITTER)[1];
            if (!payloadSegment) throw new Error(AUTH_MESSAGES.INVALID_TOKEN_FORMAT);

            const payload = JSON.parse(Buffer.from(payloadSegment, 'base64').toString('utf-8'));
            const isGoogleIssuer = AUTH_CONFIG.GOOGLE_ISSUERS.includes(payload.iss);

            if (isGoogleIssuer) {
                const response = await fetch(`${AUTH_CONFIG.GOOGLE_TOKEN_INFO_URL}${idToken}`);
                if (!response.ok) {
                    throw new Error(AUTH_MESSAGES.GOOGLE_VERIFICATION_FAILED);
                }
                const decodedToken = await response.json() as any;
                email = decodedToken.email;
                name = decodedToken.name;
                picture = decodedToken.picture || fallbackPicture;
            } else {
                const decodedToken = await admin.auth().verifyIdToken(idToken);
                email = decodedToken.email;
                name = decodedToken.name;
                picture = decodedToken.picture || fallbackPicture;
            }
        } catch (error: any) {
            throw new Error(`${AUTH_MESSAGES.TOKEN_VERIFICATION_FAILED}: ${error.message}`);
        }

        if (!email) {
            throw new Error(AUTH_MESSAGES.EMAIL_REQUIRED);
        }

        let user = await this.userService.getByEmail(email);

        if (!user) {
            user = await this.userService.create({
                email,
                name: name || email.split(AUTH_CONFIG.EMAIL_SPLITTER)[0],
                phone_number: AUTH_CONFIG.EMPTY_FALLBACK,
                avatar_url: picture || AUTH_CONFIG.EMPTY_FALLBACK,
            });
        } else if (picture && (!user.avatar_url || user.avatar_url === AUTH_CONFIG.EMPTY_FALLBACK)) {
            user = await this.userService.update(user.id, { avatar_url: picture });
        }

        const tokens = this.userService.generateTokens(user);

        return { user, tokens };
    }

    async refreshAccessToken(refreshToken: string): Promise<{ accessToken: string }> {
        const decoded = this.userService.verifyToken<{ id: string }>(refreshToken, config.JWT_REFRESH_SECRET);
        const user = await this.userService.getById(decoded.id);

        if (!user) {
            throw new Error(AUTH_MESSAGES.USER_NOT_FOUND);
        }

        const tokens = this.userService.generateTokens(user);
        return { accessToken: tokens.accessToken };
    }

    async sendOtp(phoneNumber: string): Promise<void> {
        if (!phoneNumber) {
            throw new BadRequestError(AUTH_MESSAGES.PHONE_REQUIRED);
        }

        let user = await this.userService.getByPhoneNumber(phoneNumber);

        if (!user) {
            user = await this.userService.create({
                email: `${phoneNumber}${AUTH_CONFIG.DEFAULT_EMAIL_DOMAIN}`,
                name: `${AUTH_CONFIG.DEFAULT_USER_NAME_PREFIX}${phoneNumber}`,
                phone_number: phoneNumber,
                avatar_url: AUTH_CONFIG.EMPTY_FALLBACK,
            });
        }

        const latestOtp = await this.userRepo.findLatestOtpByActor(user.id, AUTH_CONFIG.OTP_TYPE_LOGIN);
        if (latestOtp && latestOtp.created_at) {
            const timeSinceLastOtp = Date.now() - new Date(latestOtp.created_at).getTime();
            if (timeSinceLastOtp < 30 * 1000) {
                throw new BadRequestError(AUTH_MESSAGES.RATE_LIMIT_WAIT);
            }
        }

        await this.userRepo.deleteOtpsByActor(user.id, AUTH_CONFIG.OTP_TYPE_LOGIN);

        const otp = Math.floor(100000 + Math.random() * 900000).toString();
        const valid_till = new Date(Date.now() + AUTH_CONFIG.OTP_EXPIRY_MS);

        await this.userRepo.createOtp({
            actor: user.id,
            otp,
            type: AUTH_CONFIG.OTP_TYPE_LOGIN,
            valid_till,
        });

        const body = AUTH_CONFIG.OTP_MESSAGE_TEMPLATE.replace('{otp}', otp);
        await this.smsService.sendSms(phoneNumber, body);
    }

    async verifyOtp(phoneNumber: string, otp: string): Promise<{ user: User, tokens: { accessToken: string, refreshToken: string } }> {
        if (!phoneNumber || !otp) {
            throw new BadRequestError(AUTH_MESSAGES.PHONE_AND_OTP_REQUIRED);
        }

        const user = await this.userService.getByPhoneNumber(phoneNumber);

        if (!user) {
            throw new BadRequestError(AUTH_MESSAGES.USER_NOT_FOUND_FOR_OTP);
        }

        const isMockOtp = otp === AUTH_CONFIG.MOCK_OTP;

        if (!isMockOtp) {
            const record = await this.userRepo.findValidOtp(user.id, otp, AUTH_CONFIG.OTP_TYPE_LOGIN);

            if (!record) {
                throw new BadRequestError(AUTH_MESSAGES.INVALID_OTP);
            }

            if (record.valid_till < new Date()) {
                await this.userRepo.deleteOtpsByActor(user.id, AUTH_CONFIG.OTP_TYPE_LOGIN);
                throw new BadRequestError(AUTH_MESSAGES.OTP_EXPIRED);
            }

            await this.userRepo.deleteOtpsByActor(user.id, AUTH_CONFIG.OTP_TYPE_LOGIN);
        }

        const tokens = this.userService.generateTokens(user);
        return { user, tokens };
    }

    async getAdBanners() {
        return await this.userRepo.getAdBanners();
    }

}

import { Request, Response } from 'express';
import { AuthService } from './auth.service';
import { UserService } from './user.service';
import { sendSuccess } from '../../utils/error';
import { asyncHandler } from '../../utils/async';
import { AUTH_MESSAGES } from './auth.constant';
import { User } from './user.type';

export class AuthController {
private authService: AuthService;
private userService: UserService;

    constructor() {
        this.authService = new AuthService();
        this.userService = new UserService();
    }

    login = asyncHandler(async (req: Request, res: Response) => {
        const { idToken, picture } = req.body;
        const result = await this.authService.loginWithFirebase(idToken, picture);
        return sendSuccess(res, result, AUTH_MESSAGES.LOGIN_SUCCESS);
    });

    refresh = asyncHandler(async (req: Request, res: Response) => {
        const { refreshToken } = req.body;
        const result = await this.authService.refreshAccessToken(refreshToken);
        return sendSuccess(res, result, AUTH_MESSAGES.REFRESH_SUCCESS);
    });

    me = asyncHandler(async (req: Request, res: Response) => {
        const user = (req as any).user as User;
        return sendSuccess(res, user, AUTH_MESSAGES.SESSION_SUCCESS);
    });

    logActivity = asyncHandler(async (req: Request, res: Response) => {
        const user = (req as any).user as User | undefined;
        const uid = req.body.uid || req.body.user_id || user?.id;
        const result = await this.userService.logActivity({
            ...req.body,
            uid,
        });
        return sendSuccess(res, result, AUTH_MESSAGES.ACTIVITY_LOGGED);
    });

    getActivities = asyncHandler(async (req: Request, res: Response) => {
        const { user_id } = req.params;
        const result = await this.userService.getActivities(user_id as string);
        return sendSuccess(res, result, AUTH_MESSAGES.ACTIVITIES_FETCHED);
    });

    sendOtp = asyncHandler(async (req: Request, res: Response) => {
        const { phone_number } = req.body;
        await this.authService.sendOtp(phone_number);
        return sendSuccess(res, null, AUTH_MESSAGES.OTP_SENT);
    });

    verifyOtp = asyncHandler(async (req: Request, res: Response) => {
        const { phone_number, otp } = req.body;
        const result = await this.authService.verifyOtp(phone_number, otp);
        return sendSuccess(res, result, AUTH_MESSAGES.LOGIN_SUCCESS);
    });

    getAdBanners = asyncHandler(async (req: Request, res: Response) => {
        const result = await this.authService.getAdBanners();
        return sendSuccess(res, result, AUTH_MESSAGES.BANNERS_FETCHED);
    });

    getSessions = asyncHandler(async (req: Request, res: Response) => {
        const user = (req as any).user as User;
        const result = await this.userService.getSessions(user.id);
        return sendSuccess(res, result, AUTH_MESSAGES.SESSIONS_FETCHED);
    });

    createSession = asyncHandler(async (req: Request, res: Response) => {
        const user = (req as any).user as User;
        const result = await this.userService.createSession({
            ...req.body,
            uid: user.id,
        });
        return sendSuccess(res, result, AUTH_MESSAGES.SESSION_CREATED);
    });

    terminateSession = asyncHandler(async (req: Request, res: Response) => {
        const { id } = req.params;
        const result = await this.userService.terminateSession(id as string);
        return sendSuccess(res, result, AUTH_MESSAGES.SESSION_TERMINATED);
    });

    createAddress = asyncHandler(async (req: Request, res: Response) => {
        const user = (req as any).user as User;
        const result = await this.userService.createAddress({
            ...req.body,
            uid: user.id,
        });
        return sendSuccess(res, result, AUTH_MESSAGES.ADDRESS_CREATED);
    });

    getAddresses = asyncHandler(async (req: Request, res: Response) => {
        const user = (req as any).user as User;
        const result = await this.userService.getAddresses(user.id);
        return sendSuccess(res, result, AUTH_MESSAGES.ADDRESSES_FETCHED);
    });

    updateAddress = asyncHandler(async (req: Request, res: Response) => {
        const { id } = req.params;
        const result = await this.userService.updateAddress(id as string, req.body);
        return sendSuccess(res, result, AUTH_MESSAGES.ADDRESS_UPDATED);
    });

    deleteAddress = asyncHandler(async (req: Request, res: Response) => {
        const { id } = req.params;
        const result = await this.userService.deleteAddress(id as string);
        return sendSuccess(res, result, AUTH_MESSAGES.ADDRESS_DELETED);
    });

}
