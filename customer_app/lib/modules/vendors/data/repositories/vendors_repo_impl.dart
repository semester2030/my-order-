import '../../domain/repositories/vendors_repo.dart';
import '../../domain/entities/vendor.dart';
import '../../domain/entities/menu_item.dart';
import '../datasources/vendors_remote_ds.dart';
import '../mappers/vendors_mapper.dart';

class VendorsRepositoryImpl implements VendorsRepository {
  final VendorsRemoteDataSource remoteDataSource;

  VendorsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Vendor> getVendor(String vendorId) async {
    final dto = await remoteDataSource.getVendor(vendorId);
    return VendorsMapper.mapVendorFromDto(dto);
  }

  @override
  Future<List<MenuItem>> getVendorMenu(String vendorId) async {
    final dtos = await remoteDataSource.getVendorMenu(vendorId);
    return VendorsMapper.mapMenuItemsFromDto(dtos);
  }

  @override
  Future<List<MenuItem>> getSignatureItems(String vendorId) async {
    final dtos = await remoteDataSource.getSignatureItems(vendorId);
    return VendorsMapper.mapMenuItemsFromDto(dtos);
  }
}
