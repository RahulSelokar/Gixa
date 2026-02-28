class ApiEndpoints {
  ApiEndpoints._();

  /// AUTH – OTP
  static const String sendOtp = '/api/student/send-otp/';
  static const String verifyOtp = '/api/student/verify-otp/';
  static const String logout = '/api/logout/';
  static const logoutOtherDevice = '/api/logout-other-device/';

  /// AUTH – TOKEN
  static const String refreshToken = '/api/student/refresh-token/';

  /// AUTH – GOOGLE
  static const String googleLogin = '/auth/google';

  /// Payment
  static const String paymentCredentials = '/api/payment-credentials/';

  //ragisterss
  static const String registerStudent = '/api/student/register/';
  //masters
  static const masters = '/api/masters/';

  static const String profile = '/api/student/profile/';

  /// 🏫 COLLEGES
  static const String colleges = '/api/colleges';
  static const String college = '/api/college';


  //fav collage
  static const String addToFavourite = '/api/student/favourite-colleges/';
  static const String removeFromFavourite= '/api/student/favourite-colleges/remove/';
  static const String favourite= '/api/student/favourite-colleges/';
  //seat matrix
  static const String seatMatrix = "/api/seat-matrix/";

  // Compare Collage
  static const String compareColleges = '/api/colleges/compare/';
  static const String saveCompareColleges ='/api/colleges/compare/save/';
  static const String compareHistory ='/api/colleges/compare/history/';

//prediction
  static const String predictCollege = "/api/predict/";


  /// 💳 SUBSCRIPTIONS
  static const String subscriptionPlans = '/subscription-plans/';
  static const String subscriptionPurchase = '/api/subscription/purchase/';
  static const String subscriptionCreateOrder ='/api/student/subscription/create-order/';
  static const String subscriptionVerifyPayment = '/api/student/subscription/verify-payment/';
  static String subscriptionHistory(int userId) => "/api/subscriptions/user/$userId/";


  //Documents
  static const String documents = '/api/student/documents/upload/';
  static const updateStudentDocument = '/api/student/documents/update/';
  static const String studentDocuments = "/api/student/documents/";

  /// 💬 CHAT SUPPORT (BOT + HUMAN)
static const String chatStart = '/api/chat/start/';
static const String chatBotResponse = '/api/chat/bot-response/';
static const String chatSwitchToHuman = '/api/chat/switch-to-human/';
static const String chatMessage = '/api/chat/message/';
static const String chatClear = '/api/chat/clear/';
static const String chatClose = '/api/chat/close/';

static String chatMessages({
  required String sessionId,
  String? lastMessageId,
}) {
  return '/api/chat/messages/?session_id=$sessionId'
      '${lastMessageId != null ? '&last_message_id=$lastMessageId' : ''}';
}

/// 🎓 ASSISTANCE – COUNSELORS
static const String assistanceCounselors = '/api/assistance/counselors/';
static const String selectCounselor = '/api/assistance/select-counselor/';
static const String counselorDetail = '/api/assistance/counselor';
static const String requestGuidance = "/api/request-guidance/";

//notification 
static const String notificationSettings= '/api/user/notification-settings/';
static const String putNotifcationSettings= '/api/user/notification-settings/';
static const String supportContact = "/api/support/contact/";
//version check
static const String versionCheck = "/app/version-check/";

}
