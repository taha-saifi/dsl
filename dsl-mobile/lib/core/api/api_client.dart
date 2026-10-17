import 'dart:io';

import 'package:dio/dio.dart';

import '../storage/token_storage.dart';
import 'api_exception.dart';

/// Turns the JSON inside the `data` envelope into a value.
typedef JsonDecoder<T> = T Function(Object? json);

/// Thin wrapper over Dio that speaks the API envelope from
/// docs/contracts/api-contract.md: success is `{data: …}`, failure is
/// `{error: {code, message}}`. Every failure surfaces as an [ApiException].
class ApiClient {
  ApiClient(this._dio);

  final Dio _dio;

  Future<T> get<T>(
    String path, {
    required JsonDecoder<T> decode,
    Map<String, Object?>? query,
  }) => _send(() => _dio.get<Object?>(path, queryParameters: query), decode);

  Future<T> post<T>(
    String path, {
    required JsonDecoder<T> decode,
    Object? body,
  }) => _send(() => _dio.post<Object?>(path, data: body), decode);

  Future<T> patch<T>(
    String path, {
    required JsonDecoder<T> decode,
    Object? body,
  }) => _send(() => _dio.patch<Object?>(path, data: body), decode);

  Future<T> delete<T>(String path, {required JsonDecoder<T> decode}) =>
      _send(() => _dio.delete<Object?>(path), decode);

  Future<T> _send<T>(
    Future<Response<Object?>> Function() request,
    JsonDecoder<T> decode,
  ) async {
    final Response<Object?> response;
    try {
      response = await request();
    } on DioException catch (error) {
      throw mapDioException(error);
    }

    final body = response.data;
    if (body is Map<String, Object?> && body.containsKey('data')) {
      return decode(body['data']);
    }
    throw const ApiException(
      failure: ApiFailure.badResponse,
      message: 'The server sent an unexpected response.',
    );
  }
}

/// Maps any Dio failure onto [ApiException]. Exposed for tests.
ApiException mapDioException(DioException error) {
  switch (error.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
    case DioExceptionType.transformTimeout:
      return const ApiException(
        failure: ApiFailure.timeout,
        message: 'The server took too long to answer.',
      );
    case DioExceptionType.cancel:
      return const ApiException(
        failure: ApiFailure.cancelled,
        message: 'The request was cancelled.',
      );
    case DioExceptionType.connectionError:
      return const ApiException(
        failure: ApiFailure.network,
        message: 'Could not reach the server.',
      );
    case DioExceptionType.badResponse:
      final response = error.response;
      final status = response?.statusCode ?? 0;
      final apiError = _errorBody(response?.data);
      return ApiException(
        failure: ApiFailure.http,
        status: status,
        code: apiError.code,
        message: apiError.message ?? 'Request failed ($status).',
      );
    case DioExceptionType.badCertificate:
    case DioExceptionType.unknown:
      final cause = error.error;
      if (cause is SocketException || cause is HttpException) {
        return const ApiException(
          failure: ApiFailure.network,
          message: 'Could not reach the server.',
        );
      }
      return ApiException(
        failure: ApiFailure.network,
        message: error.message ?? 'Could not reach the server.',
      );
  }
}

({String? code, String? message}) _errorBody(Object? body) {
  if (body is Map<String, Object?>) {
    final error = body['error'];
    if (error is Map<String, Object?>) {
      final code = error['code'];
      final message = error['message'];
      return (
        code: code is String ? code : null,
        message: message is String && message.isNotEmpty ? message : null,
      );
    }
  }
  return (code: null, message: null);
}

/// Attaches the bearer token and applies the session rule: **only a real 401
/// on a request that carried a token ends the session.** Network errors,
/// timeouts and 5xx keep the token (same as the dashboard, see
/// docs/architecture/auth-and-roles.md). A 401 on login (no token) is just a
/// wrong password.
class AuthInterceptor extends Interceptor {
  AuthInterceptor({required this.tokenStorage, required this.onUnauthorized});

  final TokenStorage tokenStorage;
  final void Function() onUnauthorized;

  static const _sentTokenKey = 'dsl.sentToken';

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await tokenStorage.read();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
      options.extra[_sentTokenKey] = true;
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final sentToken = err.requestOptions.extra[_sentTokenKey] == true;
    if (sentToken && err.response?.statusCode == 401) {
      await tokenStorage.clear();
      onUnauthorized();
    }
    handler.next(err);
  }
}

Dio createDio({
  required String baseUrl,
  required TokenStorage tokenStorage,
  required void Function() onUnauthorized,
  void Function(String line)? logRequest,
}) {
  final dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 10),
      sendTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 20),
      responseType: ResponseType.json,
      contentType: Headers.jsonContentType,
      headers: {Headers.acceptHeader: Headers.jsonContentType},
    ),
  );
  dio.interceptors.add(
    AuthInterceptor(tokenStorage: tokenStorage, onUnauthorized: onUnauthorized),
  );
  if (logRequest != null) {
    // One line per request ("DSL api → GET /learn/courses"); no bodies or
    // headers, so tokens and answers never reach the log.
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          logRequest('DSL api → ${options.method} ${options.path}');
          handler.next(options);
        },
      ),
    );
  }
  return dio;
}
