class ApiConstants {
  static const String apiBaseUrl = "http://178.63.221.236:5353/";
  static const String login = "authentication/login";
  static const String refreshToken = "authentication/refreshToken";
  static const String checkIn = "attendanceRecord/checkin";
  static const String checkOut = "attendanceRecord/checkout";
  static const String todayAttendance = "attendanceRecord/GetCurrentRecord";
  static const String getCurrentEmployeeMonthlyAttendanceStatic = "attendanceRecord/GetCurrentEmployeeMonthlyAttendanceStatic";
  static const String getAttendanceRecords = "attendanceRecord/GetMyAttendancesPagedList";
}

class ApiErrors {
  static const String badRequestError = "badRequestError";
  static const String noContent = "noContent";
  static const String forbiddenError = "forbiddenError";
  static const String unauthorizedError = "unauthorizedError";
  static const String notFoundError = "notFoundError";
  static const String conflictError = "conflictError";
  static const String internalServerError = "internalServerError";
  static const String unknownError = "unknownError";
  static const String timeoutError = "timeoutError";
  static const String defaultError = "defaultError";
  static const String cacheError = "cacheError";
  static const String noInternetError = "noInternetError";
  static const String loadingMessage = "loading_message";
  static const String retryAgainMessage = "retry_again_message";
  static const String ok = "Ok";
}