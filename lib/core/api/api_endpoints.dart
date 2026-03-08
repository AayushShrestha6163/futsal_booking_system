class ApiEndpoints {
  ApiEndpoints._();

  // Base URL - change this for production
  // static const String baseUrl = 'http://10.0.2.2:8000';
  // static const String baseUrl = 'http://10.0.2.2:8000';
  static const String baseUrl = 'http://192.168.1.9:8000';

  //static const String baseUrl = 'http://localhost:3000/api/v1';
  // For Android Emulator use: 'http://10.0.2.2:3000/api/v1'
  // For iOS Simulator use: 'http://localhost:5000/api/v1'
  // For Physical Device use your computer's IP: 'http://192.168.x.x:5000/api/v1'

  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // ============ User Endpoints ============
  static const String userLogin = '/api/auth/login';
  static const String userRegister = '/api/auth/register';
  static const String updateProfile = '/api/auth/update';
  static const String getUser = '/api/auth/users';
  static const String currentUser = '/api/auth/me';

  // ============ Courts ============
  static const String courts = '/api/courts'; // GET all
  static String courtById(String id) => '/api/courts/$id';

  // ============ Slots ============
  static String courtSlots(String courtId) => '/api/courts/$courtId/slots';

  // ============ Bookings ============
  static const String bookings = '/api/bookings'; // POST create
  static const String myBookings = '/api/bookings/me'; // GET my bookings
  static String cancelBooking(String id) => '/api/bookings/$id'; // DELETE

  // ============ Payments (eSewa) ============
  static const String initiateEsewa = '/api/payments/esewa/initiate';
  // success/failure are for browser redirect, Flutter doesn't call them directly

  // ============ Password Reset ============
  static const String requestPasswordReset = '/api/auth/request-password-reset';
  static String resetPassword(String token) =>
      '/api/auth/reset-password/$token';
}
