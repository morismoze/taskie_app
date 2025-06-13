abstract final class ApiEndpoints {
  static const _prefix = '/api';
  // Auth
  static const loginGoogle = '$_prefix/auth/google';
  static const logout = '$_prefix/auth/logout';
  static const refreshToken = '/$_prefix/auth/refresh';

  // Users
  static const getCurrentUser = '/$_prefix/users/me';

  // Workspaces
  static const getWorkspaces = '/$_prefix/workspaces/me';
  static const createWorkspace = '/$_prefix/workspaces';
}
