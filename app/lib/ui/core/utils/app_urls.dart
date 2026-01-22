import '../../../config/environment/env.dart';

abstract final class AppUrls {
  static Uri get website => Uri.parse(Env.websiteBaseUrl);

  static Uri get privacyPolicy =>
      Uri.parse('${Env.websiteBaseUrl}/privacy-policy');

  static Uri get termsAndConditions =>
      Uri.parse('${Env.websiteBaseUrl}/terms-and-conditions');

  static const String supportEmail = 'support@taskieapp.xyz';

  static Uri get supportEmailLaunchUri => Uri.parse('mailto:$supportEmail');
}
