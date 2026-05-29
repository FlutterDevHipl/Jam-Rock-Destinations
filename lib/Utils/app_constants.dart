class AppConstants {
   // static const String BASE_URL = 'http://46.225.130.234:5000/api/';
  static const String BASE_URL = 'https://staging-api.solfana.app/api/';
  static const String imageBaseUrl= 'http://46.225.130.234:5001/api/';

//****************************  Auth Sign Up ************************ */

  static const String sendEmailOtp = "${BASE_URL}mobile/auth/login/email";
  static const String verifyOtp = "${BASE_URL}mobile/auth/login/verify-otp";
  static const String phoneNumber = "${BASE_URL}mobile/auth/signup/phone";
  static const String createPassword ="${BASE_URL}mobile/auth/signup/create-password";

  static const String forgotPasswordEmail  ="${BASE_URL}mobile/auth/forgot-password/email";
  static const String forgotPasswordVerifyOtp  ="${BASE_URL}mobile/auth/forgot-password/verify-otp";
  static const String resetPassword ="${BASE_URL}mobile/auth/reset-password";
  static const String interests ="${BASE_URL}mobile/interests";
  static const String saveInterests ="${BASE_URL}mobile/auth/user/interests";

  static const String getProfile ="${BASE_URL}mobile/auth/me";
  static const String updateProfile ="${BASE_URL}mobile/auth/update-profile";
  static const String logout ="${BASE_URL}mobile/auth/logout";


  static const String changePassword ="${BASE_URL}mobile/auth/change-password";
  

  static const String loginWithPassword = "${BASE_URL}mobile/auth/login";


  static const String settings ="${BASE_URL}mobile/static-pages/settings/";
  static const String supportEmail ="${BASE_URL}mobile/static-pages/support-email/";

  static const String notificationSettings ="${BASE_URL}mobile/notification-settings";
  static const String getPlay="${BASE_URL}mobile/track-analytics/play";


  


  //****************************  Dashboard ************************ */

  static const String audioAds ="${BASE_URL}mobile/common/internal-audio-ads";
  static const String dashBoardBannerAds ="${BASE_URL}mobile/common/banner-ads";
  static const String dashBoard ="${BASE_URL}mobile/dashboard/?type=";
  static const String allGenres ="${BASE_URL}mobile/dashboard/genres/all";
  static const String allPodcasters ="${BASE_URL}mobile/dashboard/podcasters/all";
  static const String allRecommended ="${BASE_URL}mobile/dashboard/recommended-for-you/all";
  static const String allBestPodcasts ="${BASE_URL}mobile/dashboard/best-podcasts/all";
  static const String allAudioBooks ="${BASE_URL}mobile/dashboard/audiobooks/all";

  //****************************  Search ************************ */

  static const String search ="${BASE_URL}mobile/category/search";
  static const String subcategory ="${BASE_URL}mobile/category/genres-children";
  static const String audiobooksWithSearch ="${BASE_URL}mobile/category/audiobooks";
  static const String audiobooks ="${BASE_URL}mobile/category/audiobooks";
  static const String podcasts ="${BASE_URL}mobile/category/podcasts";
  static const String categoryGenres ="${BASE_URL}mobile/category/genres";

//****************************  report ************************ */
  static const String reportReason ="${BASE_URL}mobile/report-content/";
  static const String report ="${BASE_URL}mobile/report-content/";
  //****************************  report ************************ */

  static const String podcasterProfile ="${BASE_URL}mobile/podcaster/profile/";
  static const String followPodcaster ="${BASE_URL}mobile/podcaster/toggle-follow";

  static const String followedPodcaster ="${BASE_URL}mobile/podcaster/followed-podcasters";

  static const String albumDetails ="${BASE_URL}mobile/album/";
  static const String tracksDetails ="${BASE_URL}mobile/tracks/detail";
  static const String createPlaylist ="${BASE_URL}mobile/playlist";
  static const String addPlaylist ="${BASE_URL}mobile/playlist";
  static const String addFav ="${BASE_URL}mobile/library/favorite";
  static const String addToLib="${BASE_URL}mobile/library";
  static const String addLike="${BASE_URL}mobile/library/like";

  //*********************** Library *************************************** */

  static const String getLibrary="${BASE_URL}mobile/library";
  static const String getFavorites="${BASE_URL}mobile/library/favorites";
  static const String getLikes="${BASE_URL}mobile/library/likes";


  //***************** Subscription ********************* */
  static const String getSubscriptionPlan="${BASE_URL}mobile/subscription/plans";
  static const String initiatePaymentApi="${BASE_URL}mobile/payment/initiate";
  static const String getSubscriptionHistory="${BASE_URL}mobile/subscription/history";
  static const String cancelPlan  ="${BASE_URL}mobile/subscription/cancel/";
  static const String userListenStatus ="${BASE_URL}mobile/track-analytics/listen/status";
  static const String listenStart ="${BASE_URL}mobile/track-analytics/listen/start";
  static const String listenProgress ="${BASE_URL}mobile/track-analytics/listen/progress";
  static const String adsReward ="${BASE_URL}mobile/track-analytics/ads/reward";
  static const String becomePodcaster ="${BASE_URL}mobile/static-pages/become-podcaster";
  static const String deleteAccount ="${BASE_URL}mobile/static-pages/delete-account";
  static const String googleAdmobSettings ="${BASE_URL}mobile/common/google-admob-settings";
}



