import '../entities/vendor.dart';
import '../entities/menu_item.dart';

abstract class VendorsRepository {
  Future<Vendor> getVendor(String vendorId);
  Future<List<MenuItem>> getVendorMenu(String vendorId);
  Future<List<MenuItem>> getSignatureItems(String vendorId);
}
