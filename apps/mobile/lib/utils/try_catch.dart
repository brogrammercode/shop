import 'package:dartz/dartz.dart';
import 'package:mobile/utils/error.dart';

typedef TaskResult<T> = Future<Either<Failure, T>>;
typedef SyncResult<T> = Either<Failure, T>;

TaskResult<T> tryCatchAsync<T>(Future<T> Function() fn) async {
  try {
    return Right(await fn());
  } on ServerException catch (e) {
    return Left(ServerFailure(e.message, statusCode: e.statusCode));
  } on AuthException catch (e) {
    return Left(AuthFailure(e.message, statusCode: e.statusCode));
  } on CacheException catch (e) {
    return Left(CacheFailure(e.message));
  } on NetworkException catch (e) {
    return Left(NetworkFailure(e.message));
  } catch (e) {
    return Left(ServerFailure(e.toString()));
  }
}

SyncResult<T> tryCatchSync<T>(T Function() fn) {
  try {
    return Right(fn());
  } on ServerException catch (e) {
    return Left(ServerFailure(e.message, statusCode: e.statusCode));
  } on AuthException catch (e) {
    return Left(AuthFailure(e.message, statusCode: e.statusCode));
  } on CacheException catch (e) {
    return Left(CacheFailure(e.message));
  } on NetworkException catch (e) {
    return Left(NetworkFailure(e.message));
  } catch (e) {
    return Left(ServerFailure(e.toString()));
  }
}
