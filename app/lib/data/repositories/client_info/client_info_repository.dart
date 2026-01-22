import '../../../domain/models/client_info.dart';
import '../../../utils/command.dart';

abstract class ClientInfoRepository {
  ClientInfo get clientInfo;

  Future<Result<void>> initializeClientInfo();
}
