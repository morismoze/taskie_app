import '../../../domain/models/client_info.dart';

abstract class ClientInfoRepository {
  ClientInfo get clientInfo;

  Future<void> initializeClientInfo();
}
