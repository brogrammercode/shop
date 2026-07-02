import 'package:mobile/services/api_client.dart';
import 'package:mobile/utils/try_catch.dart';
import 'package:mobile/features/crm/coupon.model.dart';
import 'package:mobile/features/crm/complaint.model.dart';
import 'package:mobile/features/crm/loyalty_trans.model.dart';

class CrmEndpoints {
  static const String coupons = '/crm/coupons';
  static String coupon(String id) => '/crm/coupons/$id';
  
  static const String loyaltyTransactions = '/crm/loyalty';
  static String loyaltyByCustomer(String customerId) => '/crm/loyalty/customer/$customerId';
  
  static const String complaints = '/crm/complaints';
  static String complaint(String id) => '/crm/complaints/$id';
  static String complaintStatus(String id) => '/crm/complaints/$id/status';
}

class CrmRepo {
  final ApiClient _apiClient;

  CrmRepo({required ApiClient apiClient}) : _apiClient = apiClient;

  TaskResult<List<CouponModel>> listCoupons() async {
    return tryCatchAsync(() async {
      final response = await _apiClient.get(CrmEndpoints.coupons);
      final data = response.data['data'] as List;
      return data.map((e) => CouponModel.fromJson(e)).toList();
    });
  }

  TaskResult<CouponModel> createCoupon(Map<String, dynamic> data) async {
    return tryCatchAsync(() async {
      final response = await _apiClient.post(CrmEndpoints.coupons, data: data);
      return CouponModel.fromJson(response.data['data']);
    });
  }

  TaskResult<CouponModel> getCoupon(String id) async {
    return tryCatchAsync(() async {
      final response = await _apiClient.get(CrmEndpoints.coupon(id));
      return CouponModel.fromJson(response.data['data']);
    });
  }

  TaskResult<CouponModel> updateCoupon(String id, Map<String, dynamic> data) async {
    return tryCatchAsync(() async {
      final response = await _apiClient.patch(CrmEndpoints.coupon(id), data: data);
      return CouponModel.fromJson(response.data['data']);
    });
  }

  TaskResult<LoyaltyTransModel> createLoyaltyTransaction(Map<String, dynamic> data) async {
    return tryCatchAsync(() async {
      final response = await _apiClient.post(CrmEndpoints.loyaltyTransactions, data: data);
      return LoyaltyTransModel.fromJson(response.data['data']);
    });
  }

  TaskResult<dynamic> getLoyaltyByCustomer(String customerId) async {
    return tryCatchAsync(() async {
      final response = await _apiClient.get(CrmEndpoints.loyaltyByCustomer(customerId));
      return response.data['data']; // Returns { balance, transactions }
    });
  }

  TaskResult<List<ComplaintModel>> listComplaints() async {
    return tryCatchAsync(() async {
      final response = await _apiClient.get(CrmEndpoints.complaints);
      final data = response.data['data'] as List;
      return data.map((e) => ComplaintModel.fromJson(e)).toList();
    });
  }

  TaskResult<ComplaintModel> createComplaint(Map<String, dynamic> data) async {
    return tryCatchAsync(() async {
      final response = await _apiClient.post(CrmEndpoints.complaints, data: data);
      return ComplaintModel.fromJson(response.data['data']);
    });
  }

  TaskResult<ComplaintModel> getComplaint(String id) async {
    return tryCatchAsync(() async {
      final response = await _apiClient.get(CrmEndpoints.complaint(id));
      return ComplaintModel.fromJson(response.data['data']);
    });
  }

  TaskResult<ComplaintModel> updateComplaintStatus(String id, Map<String, dynamic> data) async {
    return tryCatchAsync(() async {
      final response = await _apiClient.patch(CrmEndpoints.complaintStatus(id), data: data);
      return ComplaintModel.fromJson(response.data['data']);
    });
  }
}
