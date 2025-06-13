import 'user.dart';

class Auth {
  Auth({
    required this.accessToken,
    required this.refreshToken,
    required this.tokenExpires,
    required this.user,
  });

  final String accessToken;
  final String refreshToken;
  final int tokenExpires;
  final User user;
}
