import '../../../domain/models/remote_config.dart';
import '../../../utils/command.dart';

abstract class RemoteConfigRepository {
  Future<Result<RemoteConfig>> get appConfig;
}
