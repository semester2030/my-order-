import 'package:vendor_app/core/errors/error_mapper.dart';
import 'package:vendor_app/core/errors/failure.dart';
import 'package:vendor_app/core/storage/secure_storage.dart';
import 'package:vendor_app/core/storage/storage_keys.dart';
import 'package:vendor_app/core/utils/result.dart' as res;

import '../../domain/entities/register_result.dart';
import '../../domain/entities/register_vendor_request.dart';
import '../../domain/entities/vendor_session.dart';
import '../../domain/repositories/auth_repo.dart';
import '../datasources/auth_remote_ds.dart';
import '../mappers/auth_mapper.dart';
import '../models/login_request_dto.dart';
import '../models/register_vendor_dto.dart';

/// Implementation of [AuthRepo]. Uses [AuthRemoteDs], [AuthMapper], saves tokens (Phase 7).
class AuthRepoImpl implements AuthRepo {
  AuthRepoImpl(this._remoteDs, this._secureStorage);

  final AuthRemoteDs _remoteDs;
  final SecureStorage _secureStorage;

  @override
  Future<res.Result<VendorSession, Failure>> login(String email, String password) async {
    try {
      final request = LoginRequestDto(email: email, password: password);
      final response = await _remoteDs.login(request);
      final session = AuthMapper.toSession(response);
      await _secureStorage.write(StorageKeys.accessToken, session.accessToken);
      await _secureStorage.write(StorageKeys.refreshToken, session.refreshToken);
      return res.Success(session);
    } catch (e) {
      return res.Failure(ErrorMapper.toFailure(e));
    }
  }

  @override
  Future<res.Result<RegisterResult, Failure>> register(RegisterVendorRequest request) async {
    try {
      final dto = RegisterVendorDto(
        name: request.name,
        email: request.email,
        password: request.password,
        phoneNumber: request.phoneNumber,
        providerCategory: request.providerCategory,
        tradeName: request.tradeName,
        description: request.description,
        popularCookingAddOns: request.popularCookingAddOns,
      );
      final response = await _remoteDs.register(dto);
      final result = AuthMapper.toRegisterResult(response);
      return res.Success(result);
    } catch (e) {
      return res.Failure(ErrorMapper.toFailure(e));
    }
  }

  @override
  Future<res.Result<VendorSession, Failure>> refresh() async {
    try {
      final refreshToken = await _secureStorage.read(StorageKeys.refreshToken);
      if (refreshToken == null || refreshToken.isEmpty) {
        return res.Failure(AuthFailure('لا يوجد توكن لتجديد الجلسة'));
      }
      final response = await _remoteDs.refresh(refreshToken);
      final session = AuthMapper.toSession(response);
      await _secureStorage.write(StorageKeys.accessToken, session.accessToken);
      await _secureStorage.write(StorageKeys.refreshToken, session.refreshToken);
      return res.Success(session);
    } catch (e) {
      return res.Failure(ErrorMapper.toFailure(e));
    }
  }
}
