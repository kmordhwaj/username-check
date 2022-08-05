import 'package:flutter/cupertino.dart';
import 'package:usernamecheck/usermodel.dart';

class UserData extends ChangeNotifier {
  String? currentUserId;

  bool cameFromRegisterScreen = false;

  UserModal currentUser = UserModal();
}
