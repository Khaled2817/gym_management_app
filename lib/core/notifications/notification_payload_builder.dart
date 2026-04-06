class NotificationPayloadBuilder {
  static String login() {
    return 'login|';
  }

  static String order(String orderId) {
    return 'order|$orderId';
  }

  static String promotion(String promotionId) {
    return 'promotion|$promotionId';
  }

  static String booking(String bookingId) {
    return 'booking|$bookingId';
  }

  static String attendance({String? action}) {
    return 'attendance|${action ?? ''}';
  }
}