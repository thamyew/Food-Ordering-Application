class ApiConstant {
  // Base URL for the API Services
  static String baseUrl =
      "https://foodorderingapplicationgrouprenegades.000webhostapp.com";

  // User
  static String checkAdminPassword = "/user/check_admin_password.php";
  static String checkLogin = "/user/check_login.php";
  static String checkPassword = "/user/check_password.php";
  static String checkUsernameEmail = "/user/check_username_email.php";
  static String checkPassKey = "/user/check_passkey.php";
  static String resetPassword = "/user/reset_password.php";

  static String deleteUser = "/user/delete_user.php";
  static String registerUser = "/user/register_user.php";

  static String retrieveProfile = "/user/retrieve_profile.php";
  static String retrieveProfileImage = "/user/retrieve_profile_image.php";

  static String updateAddress = "/user/update_address.php";
  static String updateEmail = "/user/update_email.php";
  static String updateGender = "/user/update_gender.php";
  static String updateName = "/user/update_name.php";
  static String updatePassword = "/user/update_password.php";
  static String updateAdminPassword = "/user/update_admin_password.php";
  static String updatePhoneNumber = "/user/update_phone_num.php";
  static String updateProfileImage = "/user/update_profile_pic.php";
  static String updateDefaultProfileImage = "/user/update_profile_pic_def.php";

  // Food Menu Manage & View
  static String addFood = "/food_menu/add_food.php";
  static String addFoodWithDefImg = "/food_menu/add_food_def_img.php";

  static String readMenu = "/food_menu/read_menu.php";
  static String readArchivedMenu = "/food_menu/read_archived_menu.php";
  static String readFoodDetail = "/food_menu/read_food_detail.php";

  static String recommendFood = "/food_menu/recommend_food.php";
  static String updateFoodDetail = "/food_menu/update_food_detail.php";
  static String updateFoodImage = "/food_menu/update_food_image.php";
  static String updateFoodImageDefault = "/food_menu/update_food_image_def.php";

  static String archiveFood = "/food_menu/archive_food.php";
  static String deleteFood = "/food_menu/delete_food.php";
  static String restoreArchivedFood = "/food_menu/restore_archived_food.php";
  static String deleteAllArchivedFood =
      "/food_menu/delete_all_archived_menu.php";
  static String restoreAllArchivedFood =
      "/food_menu/restore_all_archived_menu.php";

  // Food Order Cart
  static String getCart = "/cart/retrieve_order_cart.php";
  static String addCartLine = "/cart/add_order_cart_line.php";
  static String deleteCartLine = "/cart/delete_order_cart_line.php";
  static String updateCartLine = "/cart/update_order_cart_line.php";

  // Food Order (Both)
  static String getOrderList = "/order/retrieve_order_list.php";
  static String getArchivedOrderList =
      "/order/retrieve_archived_order_list.php";
  static String getOrderInfo = "/order/retrieve_order_info.php";

  // Food Order (Customer)
  static String addOrder = "/order/add_order.php";
  static String cancelOrder = "/order/cancel_order.php";
  static String checkOngoingOrder = "/order/check_ongoing_order.php";

  // Food Order (Administrator)
  static String acceptOrder = "/order/accept_order.php";
  static String rejectOrder = "/order/reject_order.php";
  static String updateOrderStatus = "/order/update_order_status.php";
  static String completeOrder = "/order/complete_order.php";

  // Feedback
  static String addFeedback = "/feedback/add_feedback.php";

  // Rating
  static String addRating = "/feedback/add_rating.php";
  static String retrieveRating = "/feedback/retrieve_individual_rating.php";
  static String updateRating = "/feedback/update_rating.php";

  // FCM Token
  static String addFCM = "/fcm/insert_fcm_token.php";
  static String deleteFCM = "/fcm/delete_fcm_token.php";
  static String checkFCM = "/fcm/check_fcm_token.php";
  static String autoLoginFCM = "/fcm/auto_login_check_fcm_token.php";
  static String updateFCM = "/fcm/update_fcm_token.php";

  // FCM Messaging
  static String notifyAdmin = "/fcm/notify_admin.php";
  static String notifyCustomer = "/fcm/notify_customer.php";

  // Spending Record
  static String getSpending = "/spending/retrieve_spending.php";
  static String getTotalSpendingByDates =
      "/spending/retrieve_total_spending_by_dates.php";

  // Earning Record
  static String getEarning = "/earning/retrieve_earning.php";

  // Achievement
  static String getAchievement = "/achievement/retrieve_achievements.php";
  static String checkAchievement =
      "/achievement/manual_checking_achievements.php";
}
