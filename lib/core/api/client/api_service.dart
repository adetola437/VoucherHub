import 'package:dartz/dartz.dart';
import '../exception/failure.dart';

abstract class IApiService {
  Future<Either<Failure, T>> get<T>(
    String endpoint, {
    T Function(dynamic)? fromJson,
    Map<String, dynamic>? queryParams,
  });

  Future<Either<Failure, T>> post<T>(
    String endpoint, {
    required dynamic body,
    T Function(dynamic)? fromJson,
  });

  Future<Either<Failure, T>> put<T>(
    String endpoint, {
    required dynamic body,
    T Function(dynamic)? fromJson,
  });

  Future<Either<Failure, T>> patch<T>(
    String endpoint, {
    required dynamic body,
    T Function(dynamic)? fromJson,
  });

  Future<Either<Failure, T>> delete<T>(
    String endpoint, {
    dynamic body,
    T Function(dynamic)? fromJson,
  });
}
