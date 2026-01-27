import '../../../domain/models/client_info.dart';
import '../../../utils/command.dart';

abstract class ClientInfoRepository {
  /// Not async since client info is initalized on app startup
  ClientInfo get clientInfo;

  Future<Result<void>> initializeClientInfo();
}
