class WorkspaceInvite {
  WorkspaceInvite({required this.token, required this.expiresAt});

  final String token;
  final DateTime expiresAt;

  Map<String, dynamic> toMap() => {
    'token': token,
    'expiresAt': expiresAt.toIso8601String(),
  };

  factory WorkspaceInvite.fromMap(Map<dynamic, dynamic> map) => WorkspaceInvite(
    token: map['token'] as String,
    expiresAt: DateTime.parse(map['expiresAt'] as String),
  );
}
