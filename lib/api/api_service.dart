import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_ordering_application/model/achievement_model.dart';
import 'package:food_ordering_application/model/archived_food_menu_model.dart';
import 'package:food_ordering_application/model/cart_model.dart';
import 'package:food_ordering_application/model/check_login_model.dart';
import 'package:food_ordering_application/model/check_username_email_model.dart';
import 'package:food_ordering_application/model/earning_model.dart';
import 'package:food_ordering_application/model/food_detail_model.dart';
import 'package:food_ordering_application/model/food_menu_model.dart';
import 'package:food_ordering_application/model/image_model.dart';
import 'package:food_ordering_application/model/order_list_model.dart';
import 'package:food_ordering_application/model/order_model.dart';
import 'package:food_ordering_application/model/spending_model.dart';
import 'package:food_ordering_application/model/status_msg_model.dart';
import 'package:food_ordering_application/model/total_spending_model.dart';
import 'package:http/http.dart' as http;
import 'package:food_ordering_application/api/api_constant.dart';
import 'package:food_ordering_application/model/user_model.dart';

import 'package:food_ordering_application/user/saveLogin.dart';

class ApiService {
  // Real server api_service
  Future<List<UserModel>?> getUserProfile(username) async {
    var url = Uri.parse(ApiConstant.baseUrl + ApiConstant.retrieveProfile);
    var response = await http.post(url, body: {
      'username': username,
    });

    if (response.statusCode == 200) {
      List<UserModel> model = userModelFromJson(response.body);
      return model;
    }
    return null;
  }

  Future<List<ImageModel>?> getUserProfileImage(profilePicId) async {
    var url = Uri.parse(ApiConstant.baseUrl + ApiConstant.retrieveProfileImage);
    var response = await http.post(url, body: {
      'id': profilePicId,
    });

    if (response.statusCode != 404) {
      if (jsonDecode(response.body) != 404) {
        List<ImageModel> model = imageModelFromJson(response.body);
        return model;
      }
    }
    return null;
  }

  Future<int> checkAdminPassword(adminPassword) async {
    var url = Uri.parse(ApiConstant.baseUrl + ApiConstant.checkAdminPassword);
    var response = await http.post(url, body: {
      'admin_password': adminPassword,
    });

    return jsonDecode(response.body);
  }

  Future<int> login(username, password) async {
    var url = Uri.parse(ApiConstant.baseUrl + ApiConstant.checkLogin);
    var response = await http.post(url, body: {
      "username": username,
      "password": password,
    });

    if (response.statusCode != 404) {
      var data = jsonDecode(response.body);
      if (data != 404) {
        List<CheckLoginModel> model = checkLoginModelFromJson(response.body);
        SaveLogin().setUsername(model[0].username);
        SaveLogin().setLevel(model[0].level);

        if (model[0].level == 1) {
          SaveLogin().setCartId(model[0].cartId);
        }

        return model[0].statusCode;
      } else {
        return 404;
      }
    } else {
      Fluttertoast.showToast(
        backgroundColor: Colors.red,
        textColor: Colors.white,
        msg: 'Failed to Access Server',
        toastLength: Toast.LENGTH_SHORT,
      );
      return 404;
    }
  }

  Future<int> checkPassword(username, password) async {
    var url = Uri.parse(ApiConstant.baseUrl + ApiConstant.checkPassword);
    var response = await http.post(url, body: {
      "username": username,
      "password": password,
    });

    return jsonDecode(response.body);
  }

  Future<List<CheckUsernameEmailModel>?> checkUsernameEmail(
      verification) async {
    var url = Uri.parse(ApiConstant.baseUrl + ApiConstant.checkUsernameEmail);
    var response = await http.post(url, body: {
      "verification": verification,
    });

    if (response.statusCode != 404) {
      List<CheckUsernameEmailModel> model =
          checkUsernameEmailModelFromJson(response.body);
      return model;
    }
    return null;
  }

  Future<List<StatusMsgModel>?> checkPassKey(passKey, email) async {
    var url = Uri.parse(ApiConstant.baseUrl + ApiConstant.checkPassKey);
    var response = await http.post(url, body: {
      "passKey": passKey,
      "email": email,
    });

    if (response.statusCode != 404) {
      List<StatusMsgModel> model = statusMsgModelFromJson(response.body);
      return model;
    }
    return null;
  }

  Future<List<StatusMsgModel>?> resetPassword(email, resetPassword) async {
    var url = Uri.parse(ApiConstant.baseUrl + ApiConstant.resetPassword);
    var response = await http.post(url, body: {
      "email": email,
      "reset_password": resetPassword,
    });

    if (response.statusCode != 404) {
      List<StatusMsgModel> model = statusMsgModelFromJson(response.body);
      return model;
    }
    return null;
  }

  Future<int> deleteUser(username) async {
    var url = Uri.parse(ApiConstant.baseUrl + ApiConstant.deleteUser);
    var response = await http.post(url, body: {
      "username": username,
    });

    return jsonDecode(response.body);
  }

  Future<List<StatusMsgModel>?> registerCustomer(
      username, password, email, name, phoneNum, gender, address) async {
    var url = Uri.parse(ApiConstant.baseUrl + ApiConstant.registerUser);

    var response = await http.post(url, body: {
      "username": username,
      "password": password,
      "email": email,
      "name": name,
      "phone_num": phoneNum,
      "gender": gender,
      "address": address,
    });

    if (response.statusCode != 404) {
      List<StatusMsgModel> model = statusMsgModelFromJson(response.body);
      return model;
    }
    return null;
  }

  Future<List<StatusMsgModel>?> registerAdministrator(level, adminPass,
      username, password, email, name, phoneNum, gender, address) async {
    var url = Uri.parse(ApiConstant.baseUrl + ApiConstant.registerUser);

    var response = await http.post(url, body: {
      "level": level,
      "admin_pass": adminPass,
      "username": username,
      "password": password,
      "email": email,
      "name": name,
      "phone_num": phoneNum,
      "gender": gender,
      "address": address,
    });

    if (response.statusCode != 404) {
      List<StatusMsgModel> model = statusMsgModelFromJson(response.body);
      return model;
    }
    return null;
  }

  Future<int> updateAddress(username, address) async {
    var url = Uri.parse(ApiConstant.baseUrl + ApiConstant.updateAddress);
    var response = await http.post(url, body: {
      "username": username,
      "address": address,
    });

    return jsonDecode(response.body);
  }

  Future<int> updateAdminPassword(adminPass) async {
    var url = Uri.parse(ApiConstant.baseUrl + ApiConstant.updateAdminPassword);
    var response = await http.post(url, body: {
      "admin_password": adminPass,
    });

    return jsonDecode(response.body);
  }

  Future<List<StatusMsgModel>?> updateEmail(username, email) async {
    var url = Uri.parse(ApiConstant.baseUrl + ApiConstant.updateEmail);
    var response = await http.post(url, body: {
      "username": username,
      "email": email,
    });
    if (response.statusCode != 404) {
      List<StatusMsgModel> model = statusMsgModelFromJson(response.body);
      return model;
    }
    return null;
  }

  Future<int> updateGender(username, gender) async {
    var url = Uri.parse(ApiConstant.baseUrl + ApiConstant.updateGender);
    var response = await http.post(url, body: {
      "username": username,
      "gender": gender,
    });

    return jsonDecode(response.body);
  }

  Future<int> updateName(username, name) async {
    var url = Uri.parse(ApiConstant.baseUrl + ApiConstant.updateName);
    var response = await http.post(url, body: {
      "username": username,
      "name": name,
    });

    return jsonDecode(response.body);
  }

  Future<int> updatePassword(username, password) async {
    var url = Uri.parse(ApiConstant.baseUrl + ApiConstant.updatePassword);
    var response = await http.post(url, body: {
      "username": username,
      "password": password,
    });

    return jsonDecode(response.body);
  }

  Future<List<StatusMsgModel>?> updatePhoneNumber(username, phoneNum) async {
    var url = Uri.parse(ApiConstant.baseUrl + ApiConstant.updatePhoneNumber);
    var response = await http.post(url, body: {
      "username": username,
      "phoneNum": phoneNum,
    });

    if (response.statusCode != 404) {
      List<StatusMsgModel> model = statusMsgModelFromJson(response.body);
      return model;
    }
    return null;
  }

  Future<List<StatusMsgModel>?> updateProfileImage(username, filePath) async {
    var url = Uri.parse(ApiConstant.baseUrl + ApiConstant.updateProfileImage);
    var request = http.MultipartRequest('POST', url);
    request.fields['username'] = username;
    var pic = await http.MultipartFile.fromPath("file", filePath);
    request.files.add(pic);
    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode != 404) {
      List<StatusMsgModel> model = statusMsgModelFromJson(response.body);
      return model;
    }
    return null;
  }

  Future<List<StatusMsgModel>?> updateDefaultProfileImage(username) async {
    var url =
        Uri.parse(ApiConstant.baseUrl + ApiConstant.updateDefaultProfileImage);
    var response = await http.post(url, body: {
      "username": username,
    });

    if (response.statusCode != 404) {
      List<StatusMsgModel> model = statusMsgModelFromJson(response.body);
      return model;
    }
    return null;
  }

  // Food Menu Management & View
  Future<List<StatusMsgModel>?> addFood(
      foodName, foodDesc, foodPrice, foodRecommend, filePath) async {
    var url = Uri.parse(ApiConstant.baseUrl + ApiConstant.addFood);
    var request = http.MultipartRequest('POST', url);
    request.fields['food_name'] = foodName;
    request.fields['food_description'] = foodDesc;
    request.fields['food_price'] = foodPrice.toString();
    request.fields['food_recommend'] = foodRecommend.toString();
    var pic = await http.MultipartFile.fromPath("file", filePath);
    request.files.add(pic);
    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode != 404) {
      List<StatusMsgModel> model = statusMsgModelFromJson(response.body);
      return model;
    }
    return null;
  }

  Future<List<StatusMsgModel>?> addFoodDefImage(
      foodName, foodDesc, foodPrice, foodRecommend) async {
    var url = Uri.parse(ApiConstant.baseUrl + ApiConstant.addFoodWithDefImg);
    var response = await http.post(url, body: {
      'food_name': foodName,
      'food_description': foodDesc,
      'food_price': foodPrice.toString(),
      'food_recommend': foodRecommend.toString(),
    });

    if (response.statusCode != 404) {
      List<StatusMsgModel> model = statusMsgModelFromJson(response.body);
      return model;
    }
    return null;
  }

  Future<List<FoodMenuModel>?> readFoodMenu() async {
    var url = Uri.parse(ApiConstant.baseUrl + ApiConstant.readMenu);
    var response = await http.get(url);

    if (response.statusCode != 404) {
      if (response.body != "[]") {
        List<FoodMenuModel> model = foodMenuModelFromJson(response.body);
        return model;
      }
    }
    return null;
  }

  Future<List<ArchivedFoodMenuModel>?> readArchivedFoodMenu() async {
    var url = Uri.parse(ApiConstant.baseUrl + ApiConstant.readArchivedMenu);
    var response = await http.get(url);

    if (response.statusCode != 404) {
      if (response.body != "[]") {
        List<ArchivedFoodMenuModel> model =
            archivedFoodMenuModelFromJson(response.body);
        return model;
      }
    }

    return null;
  }

  Future<List<FoodDetailModel>?> readFoodDetail(foodId) async {
    var url = Uri.parse(ApiConstant.baseUrl + ApiConstant.readFoodDetail);
    var response = await http.post(url, body: {
      "food_id": foodId.toString(),
    });

    if (response.statusCode != 404) {
      List<FoodDetailModel> model = foodDetailModelFromJson(response.body);
      return model;
    }
    return null;
  }

  Future<List<StatusMsgModel>?> updateFoodDetail(
      foodId, foodName, foodDesc, foodPrice) async {
    var url = Uri.parse(ApiConstant.baseUrl + ApiConstant.updateFoodDetail);
    var response = await http.post(url, body: {
      "food_id": foodId.toString(),
      "food_name": foodName,
      "food_description": foodDesc,
      "food_price": foodPrice.toString(),
    });

    if (response.statusCode != 404) {
      List<StatusMsgModel> model = statusMsgModelFromJson(response.body);
      return model;
    }
    return null;
  }

  Future<List<StatusMsgModel>?> updateFoodImage(foodId, filePath) async {
    var url = Uri.parse(ApiConstant.baseUrl + ApiConstant.updateFoodImage);

    var request = http.MultipartRequest('POST', url);
    request.fields['food_id'] = foodId.toString();
    var pic = await http.MultipartFile.fromPath("file", filePath);
    request.files.add(pic);
    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode != 404) {
      List<StatusMsgModel> model = statusMsgModelFromJson(response.body);
      return model;
    }
    return null;
  }

  Future<List<StatusMsgModel>?> updateDefaultFoodImage(foodId) async {
    var url =
        Uri.parse(ApiConstant.baseUrl + ApiConstant.updateFoodImageDefault);
    var response = await http.post(url, body: {
      "food_id": foodId.toString(),
    });

    if (response.statusCode != 404) {
      List<StatusMsgModel> model = statusMsgModelFromJson(response.body);
      return model;
    }
    return null;
  }

  Future<int> recommendFood(foodId, foodRecommend) async {
    var url = Uri.parse(ApiConstant.baseUrl + ApiConstant.recommendFood);
    var response = await http.post(url, body: {
      "food_id": foodId.toString(),
      "food_recommend": foodRecommend.toString(),
    });

    return jsonDecode(response.body);
  }

  Future<int> archiveFood(foodId) async {
    var url = Uri.parse(ApiConstant.baseUrl + ApiConstant.archiveFood);
    var response = await http.post(url, body: {
      "food_id": foodId.toString(),
    });

    return jsonDecode(response.body);
  }

  Future<int> restoreArchivedFood(foodId) async {
    var url = Uri.parse(ApiConstant.baseUrl + ApiConstant.restoreArchivedFood);
    var response = await http.post(url, body: {
      "food_id": foodId.toString(),
    });

    return jsonDecode(response.body);
  }

  Future<int> restoreAllArchivedFood() async {
    var url =
        Uri.parse(ApiConstant.baseUrl + ApiConstant.restoreAllArchivedFood);
    var response = await http.get(url);

    return jsonDecode(response.body);
  }

  Future<int> deleteFood(foodId) async {
    var url = Uri.parse(ApiConstant.baseUrl + ApiConstant.deleteFood);
    var response = await http.post(url, body: {
      "food_id": foodId.toString(),
    });

    return jsonDecode(response.body);
  }

  Future<int> deleteAllFood() async {
    var url =
        Uri.parse(ApiConstant.baseUrl + ApiConstant.deleteAllArchivedFood);
    var response = await http.get(url);

    return jsonDecode(response.body);
  }

  // Order Cart
  Future<List<CartModel>?> readCart(username) async {
    var url = Uri.parse(ApiConstant.baseUrl + ApiConstant.getCart);
    var response = await http.post(url, body: {
      "username": username,
    });

    if (response.statusCode != 404) {
      if (jsonDecode(response.body) != 404) {
        List<CartModel> model = cartModelFromJson(response.body);
        return model;
      }

      return null;
    }
    return null;
  }

  Future<List<StatusMsgModel>?> addCartLine(cartId, foodId, quantity) async {
    var url = Uri.parse(ApiConstant.baseUrl + ApiConstant.addCartLine);
    var response = await http.post(url, body: {
      "cart_id": cartId.toString(),
      "food_id": foodId.toString(),
      "food_quantity": quantity.toString(),
    });

    if (response.statusCode != 404) {
      List<StatusMsgModel> model = statusMsgModelFromJson(response.body);
      return model;
    }
    return null;
  }

  Future<List<StatusMsgModel>?> deleteCartLine(cartId, foodId) async {
    var url = Uri.parse(ApiConstant.baseUrl + ApiConstant.deleteCartLine);
    var response = await http.post(url, body: {
      "cart_id": cartId.toString(),
      "food_id": foodId.toString(),
    });

    if (response.statusCode != 404) {
      List<StatusMsgModel> model = statusMsgModelFromJson(response.body);
      return model;
    }
    return null;
  }

  Future<List<StatusMsgModel>?> updateCartLine(
      cartId, foodId, increment) async {
    var url = Uri.parse(ApiConstant.baseUrl + ApiConstant.updateCartLine);
    var response = await http.post(url, body: {
      "cart_id": cartId.toString(),
      "food_id": foodId.toString(),
      "increment": increment.toString(),
    });

    if (response.statusCode != 404) {
      List<StatusMsgModel> model = statusMsgModelFromJson(response.body);
      return model;
    }
    return null;
  }

  Future<int?> retrieveRating(username, foodId) async {
    var url = Uri.parse(ApiConstant.baseUrl + ApiConstant.retrieveRating);
    var response = await http.post(url, body: {
      "username": username,
      "food_id": foodId.toString(),
    });

    if (response.statusCode != 404) {
      return jsonDecode(response.body);
    }
    return null;
  }

  // Order
  Future<List<OrderListModel>?> readOrderList(username, level) async {
    var url = Uri.parse(ApiConstant.baseUrl + ApiConstant.getOrderList);
    var response = await http.post(url, body: {
      "username": username,
      "level": level.toString(),
    });

    if (response.statusCode != 404) {
      if (jsonDecode(response.body) != 404) {
        List<OrderListModel> model = orderListModelFromJson(response.body);
        return model;
      }

      return null;
    }
    return null;
  }

  Future<List<OrderListModel>?> readArchivedOrderList(username, level) async {
    var url = Uri.parse(ApiConstant.baseUrl + ApiConstant.getArchivedOrderList);
    var response = await http.post(url, body: {
      "username": username,
      "level": level.toString(),
    });

    if (response.statusCode != 404) {
      if (jsonDecode(response.body) != 404) {
        List<OrderListModel> model = orderListModelFromJson(response.body);
        return model;
      }

      return null;
    }
    return null;
  }

  Future<List<OrderModel>?> readOrderInfo(orderId) async {
    var url = Uri.parse(ApiConstant.baseUrl + ApiConstant.getOrderInfo);
    var response = await http.post(url, body: {
      "order_id": orderId.toString(),
    });

    if (response.statusCode != 404) {
      List<OrderModel> model = orderModelFromJson(response.body);
      return model;
    }
    return null;
  }

  Future<List<StatusMsgModel>?> acceptOrder(orderId) async {
    var url = Uri.parse(ApiConstant.baseUrl + ApiConstant.acceptOrder);
    var response = await http.post(url, body: {
      "order_id": orderId.toString(),
    });

    if (response.statusCode != 404) {
      notifyCustomer(orderId, "Accept");
      List<StatusMsgModel> model = statusMsgModelFromJson(response.body);
      return model;
    }
    return null;
  }

  Future<List<StatusMsgModel>?> rejectOrder(orderId) async {
    var url = Uri.parse(ApiConstant.baseUrl + ApiConstant.rejectOrder);
    var response = await http.post(url, body: {
      "order_id": orderId.toString(),
    });

    if (response.statusCode != 404) {
      notifyCustomer(orderId, "Reject");
      List<StatusMsgModel> model = statusMsgModelFromJson(response.body);
      return model;
    }
    return null;
  }

  Future<List<StatusMsgModel>?> addOrder(
      username, cartId, orderRemark, subtotalPrice, totalPrice) async {
    var url = Uri.parse(ApiConstant.baseUrl + ApiConstant.addOrder);
    var response = await http.post(url, body: {
      "username": username,
      "cart_id": cartId.toString(),
      "order_remark": orderRemark,
      "subtotal_price": subtotalPrice.toString(),
      "total_price": totalPrice.toString(),
    });

    if (response.statusCode != 404) {
      notifyAdmin(username, "Add", -1);
      List<StatusMsgModel> model = statusMsgModelFromJson(response.body);
      return model;
    }
    return null;
  }

  Future<List<StatusMsgModel>?> cancelOrder(orderId) async {
    var url = Uri.parse(ApiConstant.baseUrl + ApiConstant.cancelOrder);
    var response = await http.post(url, body: {
      "order_id": orderId.toString(),
    });

    if (response.statusCode != 404) {
      notifyAdmin(SaveLogin().getUsername(), "Cancel", orderId.toString());
      List<StatusMsgModel> model = statusMsgModelFromJson(response.body);
      return model;
    }
    return null;
  }

  Future<int?> checkOngoingOrder(username) async {
    var url = Uri.parse(ApiConstant.baseUrl + ApiConstant.checkOngoingOrder);
    var response = await http.post(url, body: {
      'username': username,
    });

    return jsonDecode(response.body);
  }

  // Mark as ready
  Future<List<StatusMsgModel>?> updateOrderStatus(orderId) async {
    var url = Uri.parse(ApiConstant.baseUrl + ApiConstant.updateOrderStatus);
    var response = await http.post(url, body: {
      "order_id": orderId.toString(),
    });

    if (response.statusCode != 404) {
      notifyCustomer(orderId, "Ready");
      List<StatusMsgModel> model = statusMsgModelFromJson(response.body);
      return model;
    }
    return null;
  }

  Future<List<StatusMsgModel>?> completeOrder(orderId) async {
    var url = Uri.parse(ApiConstant.baseUrl + ApiConstant.completeOrder);
    var response = await http.post(url, body: {
      "order_id": orderId.toString(),
    });

    if (response.statusCode != 404) {
      notifyCustomer(orderId, "Complete");
      List<StatusMsgModel> model = statusMsgModelFromJson(response.body);
      return model;
    }
    return null;
  }

  // Rating
  Future<List<StatusMsgModel>?> addRating(username, foodId, rating) async {
    var url = Uri.parse(ApiConstant.baseUrl + ApiConstant.addRating);
    var response = await http.post(url, body: {
      "username": username,
      "food_id": foodId.toString(),
      "rating": rating.toString(),
    });

    if (response.statusCode != 404) {
      List<StatusMsgModel> model = statusMsgModelFromJson(response.body);
      return model;
    }
    return null;
  }

  Future<List<StatusMsgModel>?> updateRating(username, foodId, rating) async {
    var url = Uri.parse(ApiConstant.baseUrl + ApiConstant.updateRating);
    var response = await http.post(url, body: {
      "username": username,
      "food_id": foodId.toString(),
      "rating": rating.toString(),
    });

    if (response.statusCode != 404) {
      List<StatusMsgModel> model = statusMsgModelFromJson(response.body);
      return model;
    }
    return null;
  }

  // Feedback
  Future<List<StatusMsgModel>?> addFeedback(orderId, content) async {
    var url = Uri.parse(ApiConstant.baseUrl + ApiConstant.addFeedback);
    var response = await http.post(url, body: {
      "order_id": orderId.toString(),
      "content": content,
    });

    if (response.statusCode != 404) {
      List<StatusMsgModel> model = statusMsgModelFromJson(response.body);
      return model;
    }
    return null;
  }

  // FCM Token
  Future<int?> addFCMToken(username, fcmToken, level) async {
    var url = Uri.parse(ApiConstant.baseUrl + ApiConstant.addFCM);
    var response = await http.post(url, body: {
      "username": username,
      "fcm_token": fcmToken,
      "level": level.toString(),
    });

    if (response.statusCode != 404) {
      return jsonDecode(response.body);
    }
    return null;
  }

  Future<int> autoLoginFCMToken(username, fcmToken) async {
    var url = Uri.parse(ApiConstant.baseUrl + ApiConstant.autoLoginFCM);
    var response = await http.post(url, body: {
      "username": username,
      "fcm_token": fcmToken,
    });

    if (response.statusCode != 404) {
      return jsonDecode(response.body);
    }

    return response.statusCode;
  }

  Future<int> checkFCM(username) async {
    var url = Uri.parse(ApiConstant.baseUrl + ApiConstant.checkFCM);
    var response = await http.post(url, body: {
      "username": username,
    });

    if (response.statusCode != 404) {
      return jsonDecode(response.body);
    }

    return response.statusCode;
  }

  Future<int?> deleteFCM(username) async {
    var url = Uri.parse(ApiConstant.baseUrl + ApiConstant.deleteFCM);
    var response = await http.post(url, body: {
      "username": username,
    });

    if (response.statusCode != 404) {
      return jsonDecode(response.body);
    }
    return null;
  }

  Future<int?> updateFCM(username, fcmToken) async {
    var url = Uri.parse(ApiConstant.baseUrl + ApiConstant.updateFCM);
    var response = await http.post(url, body: {
      "username": username,
      "fcm_token": fcmToken,
    });

    if (response.statusCode != 404) {
      return jsonDecode(response.body);
    }
    return null;
  }

  // FCM Messaging
  void notifyAdmin(username, action, orderId) async {
    var url = Uri.parse(ApiConstant.baseUrl + ApiConstant.notifyAdmin);
    var response = await http.post(url, body: {
      "username": username,
      "action": action,
      "order_id": orderId.toString(),
    });
  }

  void notifyCustomer(orderId, action) async {
    var url = Uri.parse(ApiConstant.baseUrl + ApiConstant.notifyCustomer);
    var response = await http.post(url, body: {
      "order_id": orderId.toString(),
      "action": action,
    });
  }

  // Spending Record
  Future<List<SpendingModel>?> getSpending(username, level) async {
    var url = Uri.parse(ApiConstant.baseUrl + ApiConstant.getSpending);
    var response = await http.post(url, body: {
      "username": username,
      "level": level.toString(),
    });

    if (response.statusCode != 404) {
      if (jsonDecode(response.body) != 404) {
        List<SpendingModel> model = spendingModelFromJson(response.body);
        return model;
      } else {
        List<SpendingModel> model = [];
        return model;
      }
    }
    return null;
  }

  Future<List<TotalSpendingModel>?> getTotalSpending(
      level, startDate, endDate) async {
    var url =
        Uri.parse(ApiConstant.baseUrl + ApiConstant.getTotalSpendingByDates);
    var response = await http.post(url, body: {
      "level": level.toString(),
      "start_date": startDate,
      "end_date": endDate,
    });

    if (response.statusCode != 404) {
      if (jsonDecode(response.body) != 404) {
        List<TotalSpendingModel> model =
            totalSpendingModelFromJson(response.body);
        return model;
      } else {
        List<TotalSpendingModel> model = [];
        return model;
      }
    }
    return null;
  }

  // Earning Record
  Future<List<EarningModel>?> getEarning(level) async {
    var url = Uri.parse(ApiConstant.baseUrl + ApiConstant.getEarning);
    var response = await http.post(url, body: {
      "level": level.toString(),
    });

    if (response.statusCode != 404) {
      if (jsonDecode(response.body) != 404) {
        List<EarningModel> model = earningModelFromJson(response.body);
        return model;
      } else {
        List<EarningModel> model = [];
        return model;
      }
    }
    return null;
  }

  // Achievement Record
  Future<List<AchievementModel>?> getAchievement(username) async {
    var url = Uri.parse(ApiConstant.baseUrl + ApiConstant.getAchievement);
    var response = await http.post(url, body: {
      "username": username,
    });

    log(response.body);

    if (response.statusCode != 404) {
      List<AchievementModel> model = achievementModelFromJson(response.body);
      return model;
    }
    return null;
  }

  void checkAchievement(username) async {
    var url = Uri.parse(ApiConstant.baseUrl + ApiConstant.checkAchievement);
    var response = await http.post(url, body: {
      "username": username,
    });
  }
}
