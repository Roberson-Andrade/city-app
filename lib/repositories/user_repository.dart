import 'package:city/model/user.dart';
import 'package:city/services/user_service.dart';
import 'package:flutter/material.dart';

class UserRepository extends ChangeNotifier {
  late UserService _userService;
  late User? loggedUser = null;

  UserRepository({required UserService userService}) {
    _userService = userService;
  }

  void saveUser(User user) async {
    _userService.saveUser(user);
  }

  void getCurrentUser(String id) async {
    var response = await _userService.getUserById(id);

    if (response == null) {
      return;
    }

    loggedUser = response;
    notifyListeners();
  }

  Future<User?> getUserById(String id) async {
    return await _userService.getUserById(id);
  }
}
