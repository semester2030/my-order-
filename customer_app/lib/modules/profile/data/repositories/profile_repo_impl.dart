import '../../domain/repositories/profile_repo.dart';
import '../../domain/entities/profile.dart';
import '../datasources/profile_remote_ds.dart';
import '../mappers/profile_mapper.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;

  ProfileRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Profile> getProfile() async {
    final dto = await remoteDataSource.getProfile();
    return ProfileMapper.mapProfileFromDto(dto);
  }

  @override
  Future<Profile> updateProfile({String? name, String? email}) async {
    final dto = await remoteDataSource.updateProfile(name: name, email: email);
    return ProfileMapper.mapProfileFromDto(dto);
  }
}
