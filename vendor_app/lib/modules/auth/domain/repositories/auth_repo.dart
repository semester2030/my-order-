import 'package:vendor_app/core/errors/failure.dart';
import 'package:vendor_app/core/utils/result.dart' as res;

import '../entities/register_result.dart';
import '../entities/register_vendor_request.dart';
import '../entities/vendor_session.dart';

/// Repository for auth: login and register.
/// Returns [res.Result] to avoid throwing; [Failure] for domain errors.
abstract interface class AuthRepo {
  /// Login with email and password. Returns [VendorSession] on success.
  Future<res.Result<VendorSession, Failure>> login(String email, String password);

  /// Register a new vendor. Returns [RegisterResult] on success.
  Future<res.Result<RegisterResult, Failure>> register(RegisterVendorRequest request);

  /// Refresh access token using refresh token (Phase 17).
  Future<res.Result<VendorSession, Failure>> refresh();
}
