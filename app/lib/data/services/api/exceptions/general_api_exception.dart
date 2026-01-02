import '../api_response.dart';

/// This is a general API exception which enables to
/// pass the API error from the API service to the UI
/// if needed.
class GeneralApiException implements Exception {
  const GeneralApiException({required this.error, this.stackTrace});

  final ApiError error;
  final StackTrace? stackTrace;
}
