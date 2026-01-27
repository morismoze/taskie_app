import '../../../domain/models/remote_config.dart';
import '../../../logger/logger_interface.dart';
import '../../../utils/command.dart';
import '../../services/external/firebase/models/response/firebase_remote_config_response.dart';
import '../../services/external/firebase/remote_config_service.dart';
import 'remote_config_repository.dart';

class RemoteConfigRepositoryImpl implements RemoteConfigRepository {
  RemoteConfigRepositoryImpl({
    required RemoteConfigService remoteConfigService,
    required LoggerService loggerService,
  }) : _remoteConfigService = remoteConfigService,
       _loggerService = loggerService;

  final RemoteConfigService _remoteConfigService;
  final LoggerService _loggerService;

  @override
  Future<Result<RemoteConfig>> get appConfig async {
    final result = await _remoteConfigService.fetchConfig();

    switch (result) {
      case Ok<FirebaseRemoteConfigResponse>():
        final config = result.value;
        return Result.ok(
          RemoteConfig(appLatestVersion: config.versionControl.latestVersion),
        );
      case Error<FirebaseRemoteConfigResponse>():
        final errorMessage = result.error.toString();
        // Don't log missing Analytics SDK exception
        final isNoise =
            errorMessage.contains('ABT') ||
            errorMessage.contains('Analytics SDK');
        if (!isNoise) {
          _loggerService.log(
            LogLevel.warn,
            'remoteConfigService.fetchConfig failed',
            error: result.error,
            stackTrace: result.stackTrace,
            context: 'RemoteConfigRepositoryImpl',
          );
        }

        return Result.error(result.error, result.stackTrace);
    }
  }
}
