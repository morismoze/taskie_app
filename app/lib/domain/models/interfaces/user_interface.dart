abstract interface class BaseUser {
  String get firstName;
  String get lastName;
  String? get email;
}

extension UserContractX on BaseUser {
  String get fullName => '$firstName $lastName'.trim();

  bool get isVirtual => email == null;
}
