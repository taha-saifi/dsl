/// What went wrong with a request, before any HTTP status is considered.
enum ApiFailure {
  /// The server answered with a non-2xx status. See [ApiException.status].
  http,

  /// No connection, DNS failure, connection refused.
  network,

  /// Connect, send or receive timed out.
  timeout,

  /// A 2xx response that doesn't follow the `{data}` envelope.
  badResponse,

  /// The request was cancelled by the app.
  cancelled,
}

/// The app's single error type for API calls. Mirrors the dashboard's
/// `ApiError` (status, machine-readable `code`, server `message`).
class ApiException implements Exception {
  const ApiException({
    required this.failure,
    required this.message,
    this.status,
    this.code,
  });

  final ApiFailure failure;

  /// The server's `error.message`, or a client-side description.
  final String message;

  /// HTTP status when [failure] is [ApiFailure.http].
  final int? status;

  /// The server's `error.code`, e.g. `VALIDATION_ERROR`, when it sent one.
  final String? code;

  /// Only a genuine 401 from the API means the session is over.
  bool get isUnauthorized => failure == ApiFailure.http && status == 401;

  /// Worth offering "Try again": the request may succeed unchanged.
  bool get isRetryable =>
      failure == ApiFailure.network ||
      failure == ApiFailure.timeout ||
      (failure == ApiFailure.http && (status ?? 0) >= 500);

  @override
  String toString() =>
      'ApiException($failure, status: $status, code: $code, message: $message)';
}
