import 'package:flutter/material.dart';
import '../../helper/localStorageData.dart';
import '../../view/controlView.dart';
import '../../core/service/fireStore_user.dart';
import '../../model/userModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AuthViewModel extends GetxController {
  int currentIndex = 0;
  ValueNotifier<bool> _loading = ValueNotifier(false);
  ValueNotifier<bool> get loading => _loading;
  Rxn<User> _user = Rxn<User>();
  String get user => _user.value?.email;
  @override
  void onInit() {
    _user.bindStream(_auth.authStateChanges());
    super.onInit();
  }

  String userName, email, password;
  FirebaseAuth _auth = FirebaseAuth.instance;
  final LocalStorageData _localStorageData = Get.find();

  setUser(UserModel user) {
    _localStorageData.setUserData(user);
  }

  signUp() async {
    try {
      _loading.value = true;
      update();
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((user) async {
        _loading.value = false;
        if (user != null) {
          UserModel userModel = UserModel(
            id: user.user.uid,
            userName: userName,
            email: email,
          );
          await FireStoreUser().addUserToFireStore(userModel);
          setUser(userModel);
          Get.to(() => ControlView());
        }
        update();
      });
    } catch (e) {
      _loading.value = false;
      update();
      handleAuthErrors(e);
    }
  }

  signIn() async {
    _loading.value = true;
    update();
    await _auth
        .signInWithEmailAndPassword(email: email, password: password)
        .onError((error, stackTrace) {
      _loading.value = false;
      update();
      return handleAuthErrors(error);
    }).then((user) async {
      _loading.value = false;
      if (user != null) {
        await FireStoreUser()
            .getUserFromFireStore(user.user.uid)
            .then((userData) {
          setUser(UserModel.fromJson(userData.data()));
          Get.to(() => ControlView());
        });
      }
      update();
    });
  }

  forgetPassword() async {
    try {
      _loading.value = true;
      update();
      await _auth.sendPasswordResetEmail(email: email).then((_) {
        _loading.value = false;
        update();
        Get.snackbar(
          'Congratulations',
          'Check you email !',
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 5),
        );
        clearAuthData();
      });
    } catch (e) {
      _loading.value = false;
      update();
      handleAuthErrors(e);
    }
  }

  clearAuthData() {
    userName = email = password = null;
    update();
  }

  handleAuthErrors(error) {
    Get.snackbar(
      'AuthError',
      error.message.toString(),
      snackPosition: SnackPosition.BOTTOM,
      duration: Duration(seconds: 5),
    );
  }

  logout() {
    _localStorageData.deleteUserData();
    _auth.signOut();
    currentIndex = 1;
    clearAuthData();
    update();
  }
}
