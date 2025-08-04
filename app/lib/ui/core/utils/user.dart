abstract final class UserUtils {
  static String constructFullName({
    required String firstName,
    required String lastName,
  }) {
    return '$firstName $lastName';
  }
}
