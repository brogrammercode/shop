class FinanceConstant {
  static const String moduleTitle = 'Finance';

  // Accounts
  static const String accountListTitle = 'Chart of Accounts';
  static const String accountDetailTitle = 'Account Detail';
  static const String accountFormTitleCreate = 'New Account';
  static const String accountFormTitleEdit = 'Edit Account';
  static const String labelAccountName = 'Account Name';
  static const String labelAccountType = 'Account Type';
  static const String labelAccountStatus = 'Status';
  static const String hintAccountName = 'e.g. Cash, Sales Revenue';

  // Account types
  static const String typeAsset = 'Asset';
  static const String typeLiability = 'Liability';
  static const String typeRevenue = 'Revenue';
  static const String typeExpense = 'Expense';
  static const String typeEquity = 'Equity';

  // Ledger
  static const String ledgerTitle = 'Ledger';
  static const String ledgerEntryListTitle = 'Ledger Entries';
  static const String ledgerEntryFormTitle = 'New Journal Entry';
  static const String labelDebit = 'Debit';
  static const String labelCredit = 'Credit';
  static const String labelNotes = 'Notes';
  static const String labelReferenceType = 'Reference Type';
  static const String labelReferenceId = 'Reference ID';
  static const String labelAccount = 'Account';
  static const String labelCreatedBy = 'Created By';
  static const String sectionDebitCredit = 'DEBIT / CREDIT';

  // Fixed Assets
  static const String assetListTitle = 'Fixed Assets';
  static const String assetDetailTitle = 'Asset Detail';
  static const String assetFormTitleCreate = 'Add Fixed Asset';
  static const String labelAssetName = 'Asset Name';
  static const String labelPurchaseValue = 'Purchase Value';
  static const String labelDepreciationPct = 'Depreciation % (annual)';

  // Royalty
  static const String royaltyListTitle = 'Royalty Transactions';
  static const String royaltyDetailTitle = 'Royalty Detail';
  static const String labelFranchiseId = 'Franchise';
  static const String labelCalculatedAmt = 'Calculated Amount';
  static const String labelRoyaltyStatus = 'Status';

  // Status labels
  static const String statusActive = 'Active';
  static const String statusInactive = 'Inactive';
  static const String statusPaid = 'Paid';
  static const String statusPending = 'Pending';
  static const String statusOverdue = 'Overdue';

  // Actions
  static const String btnSave = 'Save';
  static const String btnAddAccount = 'Add Account';
  static const String btnAddEntry = 'New Entry';
  static const String btnAddAsset = 'Add Asset';
  static const String btnMarkPaid = 'Mark as Paid';
  static const String btnDeactivate = 'Deactivate Account';

  // Section headers (ALL-CAPS)
  static const String sectionBankDetails = 'BANK DETAILS';
  static const String sectionRecentEntries = 'RECENT ENTRIES';
  static const String sectionMetadata = 'METADATA';

  // Dummy data labels
  static const String dummyBranchId = 'branch-001';
  static const String dummyAccountId = 'acc-001';
  static const String dummyCreatedBy = 'Admin User';
}
