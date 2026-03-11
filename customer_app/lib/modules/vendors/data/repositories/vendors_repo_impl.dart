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

  @override
  Future<void> createEventRequest(CreateEventRequestParams params) async {
    final body = <String, dynamic>{
      'vendorId': params.vendorId,
      'requestType': params.requestType,
      'scheduledDate': params.scheduledDate,
      'scheduledTime': params.scheduledTime,
      'guestsCount': params.guestsCount,
      'addOns': params.addOns.isEmpty
          ? null
          : params.addOns.map((e) => {'name': e['name'], if (e['price'] != null) 'price': e['price']}).toList(),
    };
    if (params.addressId != null) body['addressId'] = params.addressId;
    if (params.dishIds != null && params.dishIds!.isNotEmpty) body['dishIds'] = params.dishIds;
    if (params.customDishNames != null && params.customDishNames!.trim().isNotEmpty) body['customDishNames'] = params.customDishNames!.trim();
    if (params.delivery != null) body['delivery'] = params.delivery;
    if (params.notes != null && params.notes!.isNotEmpty) body['notes'] = params.notes;
    await remoteDataSource.createEventRequest(body);
  }

  @override
  Future<List<Map<String, dynamic>>> getVendorEventOffers(String vendorId) async {
    return remoteDataSource.getVendorEventOffers(vendorId);
  }

  @override
  Future<void> createPrivateEventRequest(CreatePrivateEventRequestParams params) async {
    final body = <String, dynamic>{
      'vendorId': params.vendorId,
      'eventType': params.eventType,
      'eventDate': params.eventDate,
      'eventTime': params.eventTime,
      'guestsCount': params.guestsCount,
      'services': params.services
          .map((s) => {
                'serviceType': s.serviceType,
                'guestsCount': s.guestsCount,
                if (s.notes != null && s.notes!.isNotEmpty) 'notes': s.notes,
              })
          .toList(),
    };
    if (params.addressId != null) body['addressId'] = params.addressId;
    if (params.notes != null && params.notes!.isNotEmpty) body['notes'] = params.notes;
    await remoteDataSource.createPrivateEventRequest(body);
  }
}
