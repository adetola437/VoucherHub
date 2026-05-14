import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../../../config/flavor/app_constants.dart';
import '../../network/network_info.dart';
import '../../storage/local_storage.dart';
import '../exception/failure.dart';
import '../response/api_response.dart';
import 'api_client.dart';

class ApiClientImpl implements IApiClient {
  late final Dio _dio;
  final NetworkInfo networkInfo;
  final LocalStorage localStorage;

  ApiClientImpl({required this.networkInfo, required this.localStorage}) {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConstants.baseUrl,
        connectTimeout: AppConstants.connectTimeout,
        sendTimeout: AppConstants.sendTimeout,
        receiveTimeout: AppConstants.receiveTimeout,
        headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
      ),
    );

    _dio.interceptors.add(_AuthInterceptor(localStorage: localStorage, dio: _dio));

    // ── Only log in debug builds — never expose tokens/codes in production ──
    if (kDebugMode) {
      _dio.interceptors.add(PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        compact: true,
      ));
    }
  }

  @override
  void setToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  @override
  void clearToken() {
    _dio.options.headers.remove('Authorization');
  }

  @override
  Future<Either<Failure, T>> request<T>({
    required String endpoint,
    required HttpMethod method,
    required T Function(dynamic json) fromJson,
    dynamic body,
    Map<String, dynamic>? queryParams,
    Map<String, String>? headers,
  }) async {
    try {
      final response = await _makeRequest(endpoint, method, body, queryParams, headers);

      if (response.data is! Map<String, dynamic>) {
        return right(fromJson(response.data));
      }

      final responseData = response.data as Map<String, dynamic>;

      if (_isRequestSuccessful(responseData)) {
        if (responseData.containsKey('data') && responseData['data'] != null) {
          return right(fromJson(responseData['data']));
        }
        return right(fromJson(responseData));
      } else {
        final message = responseData['message']?.toString() ?? 'An error occurred';
        return left(ValidationFailure(message));
      }
    } on DioException catch (e) {
      return left(_mapDioError(e));
    } on SocketException {
      return left(const NetworkFailure());
    } catch (e) {
      return left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, dynamic>> rawRequest({
    required String endpoint,
    required HttpMethod method,
    dynamic body,
    Map<String, dynamic>? queryParams,
  }) async {
    try {
      final response = await _makeRequest(endpoint, method, body, queryParams, null);
      return right(response.data);
    } on DioException catch (e) {
      return left(_mapDioError(e));
    } on SocketException {
      return left(const NetworkFailure());
    } catch (e) {
      return left(UnknownFailure(e.toString()));
    }
  }

  Future<Either<Failure, ApiResponse<T>>> requestWithApiResponse<T>({
    required String endpoint,
    required HttpMethod method,
    required T Function(dynamic json) fromJson,
    dynamic body,
    Map<String, dynamic>? queryParams,
    Map<String, String>? headers,
  }) async {
    try {
      final response = await _makeRequest(endpoint, method, body, queryParams, headers);

      if (response.data is! Map<String, dynamic>) {
        throw Exception('Expected Map response but got ${response.data.runtimeType}');
      }

      final responseData = response.data as Map<String, dynamic>;
      final apiResponse = ApiResponse.fromJson(responseData, fromJson);

      if (apiResponse.success) {
        return right(apiResponse);
      } else {
        final message = apiResponse.message ?? 'An error occurred';
        return left(ValidationFailure(message));
      }
    } on DioException catch (e) {
      return left(_mapDioError(e));
    } on SocketException {
      return left(const NetworkFailure());
    } catch (e) {
      return left(UnknownFailure(e.toString()));
    }
  }

  Future<Either<Failure, PaginatedResponse<T>>> requestWithPaginatedResponse<T>({
    required String endpoint,
    required HttpMethod method,
    required T Function(Map<String, dynamic> json) fromJson,
    dynamic body,
    Map<String, dynamic>? queryParams,
    Map<String, String>? headers,
  }) async {
    try {
      final response = await _makeRequest(endpoint, method, body, queryParams, headers);

      if (response.data is! Map<String, dynamic>) {
        throw Exception('Expected Map response but got ${response.data.runtimeType}');
      }

      final responseData = response.data as Map<String, dynamic>;
      final paginatedResponse = PaginatedResponse.fromJson(responseData, fromJson);

      return right(paginatedResponse);
    } on DioException catch (e) {
      return left(_mapDioError(e));
    } on SocketException {
      return left(const NetworkFailure());
    } catch (e) {
      return left(UnknownFailure(e.toString()));
    }
  }

  Future<Response> _makeRequest(
    String endpoint,
    HttpMethod method,
    dynamic body,
    Map<String, dynamic>? queryParams,
    Map<String, String>? headers,
  ) {
    final opts = headers != null ? Options(headers: headers) : null;
    switch (method) {
      case HttpMethod.get:
        return _dio.get(endpoint, queryParameters: queryParams, options: opts);
      case HttpMethod.post:
        return _dio.post(endpoint, data: body, queryParameters: queryParams, options: opts);
      case HttpMethod.put:
        return _dio.put(endpoint, data: body, queryParameters: queryParams, options: opts);
      case HttpMethod.patch:
        return _dio.patch(endpoint, data: body, queryParameters: queryParams, options: opts);
      case HttpMethod.delete:
        return _dio.delete(endpoint, data: body, queryParameters: queryParams, options: opts);
    }
  }

  bool _isRequestSuccessful(Map<String, dynamic> responseData) {
    if (responseData.containsKey('success')) {
      return responseData['success'] == true;
    }
    return true;
  }

  Failure _mapDioError(DioException error) {
    if (error.error is SocketException) return const NetworkFailure();
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return const TimeoutFailure('Connection timeout. Please try again.');
      case DioExceptionType.sendTimeout:
        return const TimeoutFailure('Send timeout. Please try again.');
      case DioExceptionType.receiveTimeout:
        return const TimeoutFailure('Receive timeout. Please try again.');
      case DioExceptionType.cancel:
        return const CancelledFailure();
      case DioExceptionType.connectionError:
        return const NetworkFailure();
      case DioExceptionType.badResponse:
        return _mapHttpError(error.response);
      case DioExceptionType.badCertificate:
        return const ServerFailure('Certificate validation failed.');
      default:
        return UnknownFailure(error.message ?? 'An unexpected error occurred');
    }
  }

  Failure _mapHttpError(Response? response) {
    if (response == null) return const UnknownFailure();

    final statusCode = response.statusCode ?? 0;
    final responseData = response.data;

    if (responseData is! Map<String, dynamic>) {
      if (statusCode == 401) {
        return UnauthorizedFailure(
            responseData?.toString() ?? 'Unauthorized access. Please login again.');
      }
      if (statusCode >= 500) return const ServerFailure();
      if (statusCode >= 400) {
        return ValidationFailure(responseData?.toString() ?? 'An error occurred');
      }
      return const UnknownFailure('Unexpected response format');
    }

    if (statusCode == 401) {
      return UnauthorizedFailure(
          responseData['message'] ?? 'Unauthorized access. Please login again.');
    }

    if (statusCode == 422 || statusCode == 400) {
      final message = responseData['message']?.toString() ?? 'Validation error';
      final errors = responseData['errors'];

      if (errors is Map && errors.isNotEmpty) {
        final firstErrorKey = errors.keys.first;
        final firstError = errors[firstErrorKey];
        if (firstError is List && firstError.isNotEmpty) {
          return ValidationFailure(firstError.first.toString());
        }
      }
      return ValidationFailure(message);
    }

    if (statusCode >= 500) return const ServerFailure();

    final message = responseData['message']?.toString() ?? 'An error occurred';
    return ValidationFailure(message);
  }
}

// ─── Auth Interceptor ─────────────────────────────────────────────────────────
class _AuthInterceptor extends Interceptor {
  final LocalStorage localStorage;
  final Dio dio;

  _AuthInterceptor({required this.localStorage, required this.dio});

  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await localStorage.getAccessToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // 401 is handled at repository level — just pass through
    handler.next(err);
  }
}