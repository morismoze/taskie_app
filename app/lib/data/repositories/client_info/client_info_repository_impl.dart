import '../../../domain/models/client_info.dart';
import '../../../logger/logger_interface.dart';
import '../../../utils/command.dart';
import '../../services/local/client_info_service.dart';
import 'client_info_repository.dart';

class ClientInfoRepositoryImpl implements ClientInfoRepository {
  ClientInfoRepositoryImpl({
    required ClientInfoService clientInfoService,
    required LoggerService loggerService,
  }) : _clientInfoService = clientInfoService,
       _loggerService = loggerService;

  final ClientInfoService _clientInfoService;
  final LoggerService _loggerService;

  // initializeClientInfo is invoked on app startup
  late final ClientInfo _clientInfo;

  @override
  ClientInfo get clientInfo {
    // If this getter is called before init is done,
    // LateInitializationError will be thrown which
    // is desired
    return _clientInfo;
  }

  @override
  Future<Result<void>> initializeClientInfo() async {
    final result = await _clientInfoService.init();

    switch (result) {
      case Ok<ClientInfo>():
        _clientInfo = result.value;
        return const Result.ok(null);
      case Error<ClientInfo>():
        _loggerService.log(
          LogLevel.warn,
          'clientInfoService.init failed',
          error: result.error,
          stackTrace: result.stackTrace,
          context: 'ClientInfoRepositoryImpl',
        );
        return Result.error(result.error, result.stackTrace);
    }
  }
}
