import '../../../domain/models/client_info.dart';
import '../../services/local/client_info_service.dart';
import 'client_info_repository_impl.dart';

class ClientInfoRepositoryImpl implements ClientInfoRepository {
  ClientInfoRepositoryImpl({required ClientInfoService clientInfoService})
    : _clientInfoService = clientInfoService;

  final ClientInfoService _clientInfoService;

  @override
  ClientInfo get clientInfo => ClientInfo(
    appVersion: _clientInfoService.appVersion,
    deviceModel: _clientInfoService.deviceModel,
    osVersion: _clientInfoService.osVersion,
  );

  @override
  Future<void> initializeClientInfo() async {
    await _clientInfoService.init();
  }
}
