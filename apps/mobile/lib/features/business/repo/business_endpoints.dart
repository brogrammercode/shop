class BusinessEndpoints {
  static const String initialize = '/business/initialize';
  static const String search = '/business/search';
  static const String context = '/business/context';
  static const String branches = '/business/branches';
  static const String joinRequests = '/business/join-requests';
  static const String myJoinRequests = '/business/join-requests/me';

  static String approveJoinRequest(String id) {
    return '/business/join-requests/$id/approve';
  }

  static String rejectJoinRequest(String id) {
    return '/business/join-requests/$id/reject';
  }
}
