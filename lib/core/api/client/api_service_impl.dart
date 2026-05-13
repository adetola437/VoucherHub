import 'package:dartz/dartz.dart';

import '../exception/failure.dart';
import 'api_client.dart';
import 'api_service.dart';

class ApiServiceImpl implements IApiService {
  final IApiClient apiClient;
  ApiServiceImpl({required this.apiClient});

  T _identity<T>(dynamic json) => json as T;

  @override
  Future<Either<Failure, T>> get<T>(
    String endpoint, {
    T Function(dynamic)? fromJson,
    Map<String, dynamic>? queryParams,
  }) =>
      apiClient.request<T>(
        endpoint: endpoint,
        method: HttpMethod.get,
        fromJson: fromJson ?? _identity,
        queryParams: queryParams,
      );

  @override
  Future<Either<Failure, T>> post<T>(
    String endpoint, {
    required dynamic body,
    T Function(dynamic)? fromJson,
  }) =>
      apiClient.request<T>(
        endpoint: endpoint,
        method: HttpMethod.post,
        fromJson: fromJson ?? _identity,
        body: body,
      );

  @override
  Future<Either<Failure, T>> put<T>(
    String endpoint, {
    required dynamic body,
    T Function(dynamic)? fromJson,
  }) =>
      apiClient.request<T>(
        endpoint: endpoint,
        method: HttpMethod.put,
        fromJson: fromJson ?? _identity,
        body: body,
      );

  @override
  Future<Either<Failure, T>> patch<T>(
    String endpoint, {
    required dynamic body,
    T Function(dynamic)? fromJson,
  }) =>
      apiClient.request<T>(
        endpoint: endpoint,
        method: HttpMethod.patch,
        fromJson: fromJson ?? _identity,
        body: body,
      );

  @override
  Future<Either<Failure, T>> delete<T>(
    String endpoint, {
    dynamic body,
    T Function(dynamic)? fromJson,
  }) =>
      apiClient.request<T>(
        endpoint: endpoint,
        method: HttpMethod.delete,
        fromJson: fromJson ?? _identity,
        body: body,
      );
}
