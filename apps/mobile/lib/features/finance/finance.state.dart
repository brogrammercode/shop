import 'package:mobile/utils/error.dart';
import 'package:mobile/features/finance/account.model.dart';
import 'package:mobile/features/finance/ledger_entry.model.dart';
import 'package:mobile/features/finance/fixed_asset.model.dart';
import 'package:mobile/features/finance/royalty_trans.model.dart';

class FinanceState {
  final List<AccountModel> accounts;
  final AccountModel? selectedAccount;
  final List<LedgerEntryModel> transactions;
  final List<FixedAssetModel> assets;
  final List<RoyaltyTransModel> royalties;

  final OperationInfo loadAccountsInfo;
  final OperationInfo saveAccountsInfo;
  final OperationInfo loadTransactionsInfo;
  final OperationInfo saveTransactionsInfo;
  final OperationInfo loadAssetsInfo;
  final OperationInfo saveAssetsInfo;
  final OperationInfo loadRoyaltiesInfo;
  final OperationInfo saveRoyaltiesInfo;

  const FinanceState({
    this.accounts = const [],
    this.selectedAccount,
    this.transactions = const [],
    this.assets = const [],
    this.royalties = const [],
    this.loadAccountsInfo = const OperationInfo(status: OperationStatus.initial),
    this.saveAccountsInfo = const OperationInfo(status: OperationStatus.initial),
    this.loadTransactionsInfo = const OperationInfo(status: OperationStatus.initial),
    this.saveTransactionsInfo = const OperationInfo(status: OperationStatus.initial),
    this.loadAssetsInfo = const OperationInfo(status: OperationStatus.initial),
    this.saveAssetsInfo = const OperationInfo(status: OperationStatus.initial),
    this.loadRoyaltiesInfo = const OperationInfo(status: OperationStatus.initial),
    this.saveRoyaltiesInfo = const OperationInfo(status: OperationStatus.initial),
  });

  FinanceState copyWith({
    List<AccountModel>? accounts,
    AccountModel? selectedAccount,
    List<LedgerEntryModel>? transactions,
    List<FixedAssetModel>? assets,
    List<RoyaltyTransModel>? royalties,
    OperationInfo? loadAccountsInfo,
    OperationInfo? saveAccountsInfo,
    OperationInfo? loadTransactionsInfo,
    OperationInfo? saveTransactionsInfo,
    OperationInfo? loadAssetsInfo,
    OperationInfo? saveAssetsInfo,
    OperationInfo? loadRoyaltiesInfo,
    OperationInfo? saveRoyaltiesInfo,
  }) {
    return FinanceState(
      accounts: accounts ?? this.accounts,
      selectedAccount: selectedAccount ?? this.selectedAccount,
      transactions: transactions ?? this.transactions,
      assets: assets ?? this.assets,
      royalties: royalties ?? this.royalties,
      loadAccountsInfo: loadAccountsInfo ?? this.loadAccountsInfo,
      saveAccountsInfo: saveAccountsInfo ?? this.saveAccountsInfo,
      loadTransactionsInfo: loadTransactionsInfo ?? this.loadTransactionsInfo,
      saveTransactionsInfo: saveTransactionsInfo ?? this.saveTransactionsInfo,
      loadAssetsInfo: loadAssetsInfo ?? this.loadAssetsInfo,
      saveAssetsInfo: saveAssetsInfo ?? this.saveAssetsInfo,
      loadRoyaltiesInfo: loadRoyaltiesInfo ?? this.loadRoyaltiesInfo,
      saveRoyaltiesInfo: saveRoyaltiesInfo ?? this.saveRoyaltiesInfo,
    );
  }
}
