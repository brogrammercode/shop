import 'package:mobile/services/api_client.dart';
import 'package:mobile/utils/try_catch.dart';
import 'package:mobile/features/finance/account.model.dart';
import 'package:mobile/features/finance/ledger_entry.model.dart';
import 'package:mobile/features/finance/fixed_asset.model.dart';
import 'package:mobile/features/finance/royalty_trans.model.dart';

class FinanceEndpoints {
  static const String accounts = '/finance/accounts';
  static String account(String id) => '/finance/accounts/$id';
  
  static const String transactions = '/finance/transactions';
  static String transaction(String id) => '/finance/transactions/$id';
  
  static const String assets = '/finance/assets';
  static String asset(String id) => '/finance/assets/$id';
  
  static const String royalties = '/finance/royalties';
  static String royalty(String id) => '/finance/royalties/$id';
  static String royaltyPay(String id) => '/finance/royalties/$id/pay';
}

class FinanceRepo {
  final ApiClient _apiClient;

  FinanceRepo({required ApiClient apiClient}) : _apiClient = apiClient;

  TaskResult<List<AccountModel>> listAccounts() async {
    return tryCatchAsync(() async {
      final response = await _apiClient.get(FinanceEndpoints.accounts);
      final data = response.data['data'] as List;
      return data.map((e) => AccountModel.fromJson(e)).toList();
    });
  }

  TaskResult<AccountModel> createAccount(Map<String, dynamic> data) async {
    return tryCatchAsync(() async {
      final response = await _apiClient.post(FinanceEndpoints.accounts, data: data);
      return AccountModel.fromJson(response.data['data']);
    });
  }

  TaskResult<AccountModel> getAccount(String id) async {
    return tryCatchAsync(() async {
      final response = await _apiClient.get(FinanceEndpoints.account(id));
      return AccountModel.fromJson(response.data['data']);
    });
  }

  TaskResult<AccountModel> updateAccount(String id, Map<String, dynamic> data) async {
    return tryCatchAsync(() async {
      final response = await _apiClient.patch(FinanceEndpoints.account(id), data: data);
      return AccountModel.fromJson(response.data['data']);
    });
  }

  TaskResult<List<LedgerEntryModel>> listTransactions() async {
    return tryCatchAsync(() async {
      final response = await _apiClient.get(FinanceEndpoints.transactions);
      final data = response.data['data'] as List;
      return data.map((e) => LedgerEntryModel.fromJson(e)).toList();
    });
  }

  TaskResult<LedgerEntryModel> createTransaction(Map<String, dynamic> data) async {
    return tryCatchAsync(() async {
      final response = await _apiClient.post(FinanceEndpoints.transactions, data: data);
      return LedgerEntryModel.fromJson(response.data['data']);
    });
  }

  TaskResult<LedgerEntryModel> getTransaction(String id) async {
    return tryCatchAsync(() async {
      final response = await _apiClient.get(FinanceEndpoints.transaction(id));
      return LedgerEntryModel.fromJson(response.data['data']);
    });
  }

  TaskResult<List<FixedAssetModel>> listAssets() async {
    return tryCatchAsync(() async {
      final response = await _apiClient.get(FinanceEndpoints.assets);
      final data = response.data['data'] as List;
      return data.map((e) => FixedAssetModel.fromJson(e)).toList();
    });
  }

  TaskResult<FixedAssetModel> createAsset(Map<String, dynamic> data) async {
    return tryCatchAsync(() async {
      final response = await _apiClient.post(FinanceEndpoints.assets, data: data);
      return FixedAssetModel.fromJson(response.data['data']);
    });
  }

  TaskResult<FixedAssetModel> getAsset(String id) async {
    return tryCatchAsync(() async {
      final response = await _apiClient.get(FinanceEndpoints.asset(id));
      return FixedAssetModel.fromJson(response.data['data']);
    });
  }

  TaskResult<FixedAssetModel> updateAsset(String id, Map<String, dynamic> data) async {
    return tryCatchAsync(() async {
      final response = await _apiClient.patch(FinanceEndpoints.asset(id), data: data);
      return FixedAssetModel.fromJson(response.data['data']);
    });
  }

  TaskResult<List<RoyaltyTransModel>> listRoyalties() async {
    return tryCatchAsync(() async {
      final response = await _apiClient.get(FinanceEndpoints.royalties);
      final data = response.data['data'] as List;
      return data.map((e) => RoyaltyTransModel.fromJson(e)).toList();
    });
  }

  TaskResult<RoyaltyTransModel> createRoyalty(Map<String, dynamic> data) async {
    return tryCatchAsync(() async {
      final response = await _apiClient.post(FinanceEndpoints.royalties, data: data);
      return RoyaltyTransModel.fromJson(response.data['data']);
    });
  }

  TaskResult<RoyaltyTransModel> getRoyalty(String id) async {
    return tryCatchAsync(() async {
      final response = await _apiClient.get(FinanceEndpoints.royalty(id));
      return RoyaltyTransModel.fromJson(response.data['data']);
    });
  }

  TaskResult<dynamic> payRoyalty(String id) async {
    return tryCatchAsync(() async {
      final response = await _apiClient.patch(FinanceEndpoints.royaltyPay(id));
      return response.data['data'];
    });
  }
}
