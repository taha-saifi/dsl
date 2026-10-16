import 'api_exception.dart';

/// The sentence a student sees for a failed request. Server messages are
/// shown as-is (the backend owns validation wording); transport failures get
/// a plain explanation with what to do.
String describeError(Object error) {
  if (error is! ApiException) {
    return 'Something went wrong. Try again.';
  }
  switch (error.failure) {
    case ApiFailure.network:
      return "Can't reach the server. Check your connection and try again.";
    case ApiFailure.timeout:
      return 'The server took too long to answer. Try again.';
    case ApiFailure.badResponse:
      return 'The server sent something unexpected. Try again later.';
    case ApiFailure.cancelled:
      return 'The request was cancelled.';
    case ApiFailure.http:
      if ((error.status ?? 0) >= 500) {
        return 'The server had a problem. Try again in a moment.';
      }
      return error.message;
  }
}
