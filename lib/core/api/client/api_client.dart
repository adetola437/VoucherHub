import 'package:dartz/dartz.dart';
import '../exception/failure.dart';

enum HttpMethod { get, post, put, patch, delete }

abstract class IApiClient {
  void setToken(String token);
  void clearToken();

  Future<Either<Failure, T>> request<T>({
    required String endpoint,
    required HttpMethod method,
    required T Function(dynamic json) fromJson,
    dynamic body,
    Map<String, dynamic>? queryParams,
    Map<String, String>? headers,
  });

  Future<Either<Failure, dynamic>> rawRequest({
    required String endpoint,
    required HttpMethod method,
    dynamic body,
    Map<String, dynamic>? queryParams,
  });
}
