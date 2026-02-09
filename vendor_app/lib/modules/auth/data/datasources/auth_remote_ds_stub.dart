import '../models/login_request_dto.dart';
import '../models/login_response_dto.dart';
import '../models/register_response_dto.dart';
import 'auth_remote_ds.dart';
import '../models/register_vendor_dto.dart';

/// Stub implementation: throws until real API is wired in Phase 7.
class AuthRemoteDsStub implements AuthRemoteDs {
  @override
  Future<LoginResponseDto> login(LoginRequestDto request) async {
    throw UnimplementedError('Auth API not wired yet (Phase 7)');
  }

  @override
  Future<RegisterResponseDto> register(RegisterVendorDto dto) async {
    throw UnimplementedError('Auth API not wired yet (Phase 7)');
  }

  @override
  Future<LoginResponseDto> refresh(String refreshToken) async {
    throw UnimplementedError('Auth refresh not wired (Phase 17)');
  }
}
