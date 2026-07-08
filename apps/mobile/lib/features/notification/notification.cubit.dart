import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mobile/features/notification/notification.repo.dart';
import 'package:mobile/features/notification/notification.state.dart';
import 'package:mobile/utils/error.dart';

class NotificationCubit extends Cubit<NotificationState> {
  final NotificationRepo _repo;
  bool _messagingInitialized = false;

  NotificationCubit({required NotificationRepo repo})
    : _repo = repo,
      super(const NotificationState());

  Future<void> initializeFirebaseMessaging() async {
    if (_messagingInitialized) {
      return;
    }
    _messagingInitialized = true;
    emit(
      state.copyWith(
        deviceTokenInfo: const OperationInfo(status: OperationStatus.loading),
      ),
    );
    final result = await _repo.initializeFirebaseMessaging();
    result.fold(
      (failure) {
        emit(
          state.copyWith(
            deviceTokenInfo: OperationInfo(
              status: OperationStatus.error,
              error: failure,
            ),
          ),
        );
      },
      (_) {
        emit(
          state.copyWith(
            deviceTokenInfo: const OperationInfo(
              status: OperationStatus.success,
            ),
          ),
        );
      },
    );
  }

  Future<void> listNotifications({bool silent = false}) async {
    if (!silent) {
      emit(
        state.copyWith(
          loadInfo: const OperationInfo(status: OperationStatus.loading),
        ),
      );
    }
    final result = await _repo.listNotifications();
    result.fold(
      (failure) {
        if (!silent) {
          Fluttertoast.showToast(msg: failure.message);
        }
        emit(
          state.copyWith(
            loadInfo: OperationInfo(
              status: OperationStatus.error,
              error: failure,
            ),
          ),
        );
      },
      (notifications) {
        emit(
          state.copyWith(
            notifications: notifications,
            loadInfo: const OperationInfo(status: OperationStatus.success),
          ),
        );
      },
    );
  }

  Future<void> openNotificationPage() async {
    await markAllRead(silent: true);
    await listNotifications();
  }

  Future<void> markAllRead({bool silent = false}) async {
    emit(
      state.copyWith(
        readInfo: const OperationInfo(status: OperationStatus.loading),
      ),
    );
    final result = await _repo.markAllRead();
    result.fold(
      (failure) {
        if (!silent) {
          Fluttertoast.showToast(msg: failure.message);
        }
        emit(
          state.copyWith(
            readInfo: OperationInfo(
              status: OperationStatus.error,
              error: failure,
            ),
          ),
        );
      },
      (_) {
        final notifications = state.notifications
            .map((notification) => notification.copyWith(read: true))
            .toList();
        emit(
          state.copyWith(
            notifications: notifications,
            readInfo: const OperationInfo(status: OperationStatus.success),
          ),
        );
      },
    );
  }

  Future<void> markRead(String id) async {
    final result = await _repo.markRead(id);
    result.fold((failure) => Fluttertoast.showToast(msg: failure.message), (_) {
      final notifications = state.notifications.map((notification) {
        if (notification.id == id) {
          return notification.copyWith(read: true);
        }
        return notification;
      }).toList();
      emit(state.copyWith(notifications: notifications));
    });
  }
}
