import '../../../domain/models/client_info.dart';
import '../../services/local/client_info_service.dart';
import 'client_info_repository.dart';

class ClientInfoRepositoryImpl implements ClientInfoRepository {
  ClientInfoRepositoryImpl({required ClientInfoService clientInfoService})
    : _clientInfoService = clientInfoService;

  final ClientInfoService _clientInfoService;

  @override
  ClientInfo get clientInfo => ClientInfo(
    appName: _clientInfoService.appName,
    appVersion: _clientInfoService.appVersion,
    buildNumber: _clientInfoService.buildNumber,
    deviceModel: _clientInfoService.deviceModel,
    osVersion: _clientInfoService.osVersion,
  );

  @override
  Future<void> initializeClientInfo() async {
    await _clientInfoService.init();
  }
}
