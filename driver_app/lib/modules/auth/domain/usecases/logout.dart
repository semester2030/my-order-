import '../repositories/auth_repo.dart';

/// Logout Use Case
/// 
/// Handles driver logout:
/// - Calls repository to logout from backend
/// - Clears local tokens and user data
class LogoutUseCase {
  final AuthRepository repository;

  LogoutUseCase(this.repository);

  /// Execute logout
  Future<void> call() async {
    await repository.logout();
  }
}
