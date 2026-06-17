class AppConstants {
   // static const String BASE_URL = 'http://46.225.130.234:5000/api/';
  static const String BASE_URL = 'https://rich-jamrok.hipl-staging3.com/api';
  // static const String imageBaseUrl= 'http://46.225.130.234:5001/api/';

//****************************  Auth Sign Up ************************ */


  static const String registerCustomer = "${BASE_URL}/auth/register";
  static const String sendEmailOTP = "${BASE_URL}/email/send-otp";
  static const String sendPhoneOTP = "${BASE_URL}/phone/send-otp";
  static const String verifyEmailOTP = "${BASE_URL}/email/verify-otp";
  static const String verifyPhoneOTP = "${BASE_URL}/phone/verify-otp";
  static const String register = "${BASE_URL}/auth/register";
  static const String login = "${BASE_URL}/auth/login";
  static const String forgotPasswordStep1 = "${BASE_URL}/auth/forgot-password";
  static const String forgotPasswordStep2 = "${BASE_URL}/auth/password/verify-otp";
  static const String forgotPasswordStep3 = "${BASE_URL}/auth/password/reset-password";

  //*************************** Profile Section ************************ */
  static const String getProfile = "${BASE_URL}/profile";
  static const String getTermsPrivacy = "${BASE_URL}/common/terms-privacy";
  static const String faq = "${BASE_URL}/common/faq";
  static const String logout = "${BASE_URL}/auth/logout";
  static const String deleteAccount = "${BASE_URL}/profile/destroy";
  static const String getVehicles = "${BASE_URL}/common/get-vehicles";
  static const String editProfile = "${BASE_URL}/profile";



}



