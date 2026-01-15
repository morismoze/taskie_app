import 'package:envied/envied.dart';

part 'env.g.dart';

enum Environment {
  development('development'),
  production('production');

  final String value;

  const Environment(this.value);
}

@Envied(obfuscate: true)
abstract final class Env {
  @EnviedField(varName: 'ENV')
  static final Environment env = _Env.env;

  @EnviedField(varName: 'BACKEND_URL')
  static final String backendUrl = _Env.backendUrl;

  @EnviedField(varName: 'DEEPLINK_BASE_URL')
  static final String deepLinkBaseUrl = _Env.deepLinkBaseUrl;

  @EnviedField(varName: 'GOOGLE_AUTH_CLIENT_ID')
  static final String googleAuthClientId = _Env.googleAuthClientId;
}
