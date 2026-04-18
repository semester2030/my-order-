import '../../../../core/errors/network_exceptions.dart';
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
      'guestsCount': params.guestsCount,
      'addOns': params.addOns.isEmpty
          ? null
          : params.addOns.map((e) => {'name': e['name'], if (e['price'] != null) 'price': e['price']}).toList(),
    };
    if (params.mealSlot != null && params.mealSlot!.trim().isNotEmpty) {
      body['mealSlot'] = params.mealSlot!.trim();
    } else if (params.scheduledTime != null && params.scheduledTime!.trim().isNotEmpty) {
      body['scheduledTime'] = params.scheduledTime!.trim();
    }
    if (params.addressId != null) body['addressId'] = params.addressId;
    if (params.dishIds != null && params.dishIds!.isNotEmpty) body['dishIds'] = params.dishIds;
    if (params.customDishNames != null && params.customDishNames!.trim().isNotEmpty) body['customDishNames'] = params.customDishNames!.trim();
    if (params.delivery != null) body['delivery'] = params.delivery;
    if (params.notes != null && params.notes!.isNotEmpty) body['notes'] = params.notes;
    await remoteDataSource.createEventRequest(body);
  }

  static const _chefBookingTypes = {'popular_cooking', 'grilling'};

  @override
  Future<List<Map<String, dynamic>>> getMyChefBookingRequests() async {
    final all = await remoteDataSource.getMyEventRequests();
    return all.where((row) {
      final t = row['request_type'] ?? row['requestType'];
      return t is String && _chefBookingTypes.contains(t);
    }).toList();
  }

  @override
  Future<List<Map<String, dynamic>>> getMyHomeCookingRequests() async {
    final all = await remoteDataSource.getMyEventRequests();
    return all.where((row) {
      final t = row['request_type'] ?? row['requestType'];
      return t == 'home_cooking';
    }).toList();
  }

  @override
  Future<Map<String, dynamic>> getMyHomeCookingRequestById(String requestId) async {
    final row = await remoteDataSource.getMyEventRequestById(requestId);
    final t = row['request_type'] ?? row['requestType'];
    if (t != 'home_cooking') {
      throw NetworkException.badRequest();
    }
    return row;
  }

  @override
  Future<Map<String, dynamic>> getMyCustomerEventRequestById(
    String requestId,
  ) async {
    return remoteDataSource.getMyEventRequestById(requestId);
  }

  @override
  Future<Map<String, dynamic>> confirmChefServiceCompletion(
    String requestId,
  ) async {
    return remoteDataSource.confirmChefServiceCompletion(requestId);
  }

  @override
  Future<void> declareHomeCookingPayment(
    String requestId, {
    required String paymentReference,
    String? notes,
  }) async {
    await remoteDataSource.declareHomeCookingPayment(
      requestId,
      paymentReference: paymentReference,
      notes: notes,
    );
  }

  @override
  Future<Map<String, dynamic>> initiateHomeCookingCardPayment(
    String eventRequestId,
    String method,
  ) {
    return remoteDataSource.initiateHomeCookingCardPayment(eventRequestId, method);
  }

  @override
  Future<Map<String, dynamic>> confirmHomeCookingReceipt(String requestId) async {
    return remoteDataSource.confirmHomeCookingReceipt(requestId);
  }

  @override
  Future<void> cancelMyEventRequest(String requestId) async {
    await remoteDataSource.cancelEventRequest(requestId);
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
          .map(
            (s) => <String, dynamic>{
              'serviceType': s.serviceType,
              'guestsCount': s.guestsCount,
              if (s.notes != null && s.notes!.isNotEmpty) 'notes': s.notes,
            },
          )
          .toList(),
    };
    if (params.addressId != null) body['addressId'] = params.addressId;
    if (params.notes != null && params.notes!.isNotEmpty) body['notes'] = params.notes;
    await remoteDataSource.createPrivateEventRequest(body);
  }
}
