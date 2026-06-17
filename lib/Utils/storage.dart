import 'package:hive_flutter/hive_flutter.dart';

final userBox = Hive.box('userBox');

String getUserId() {
  return userBox.get('user_id', defaultValue: '');
}
String isLogin()
{
  return userBox.get('isLogin', defaultValue: '');
}
String getUserType() {
  return userBox.get('user_type', defaultValue: '');
}

String getUserName() {
  return userBox.get('name', defaultValue: '');
}

String getUserEmail() {
  return userBox.get('email', defaultValue: '');
}

String getUserPhone() {
  return userBox.get('phone', defaultValue: '');
}

String getToken() {
  return userBox.get('token', defaultValue: '');
}

String profileImage() {
  return userBox.get('profile_image', defaultValue: '');
}