/// This exception should be used only when backend sends
/// 404 status, not as missing route error, but rather
/// programatical 404 (e.g. workspace not found, workspace
/// user not found, workspace invite link not found etc.).
class NotFoundException implements Exception {
  const NotFoundException();
}
