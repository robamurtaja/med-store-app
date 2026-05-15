import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../core/router/router.dart';
import '../../../core/router/routers_name.dart';
import '../../../core/services/local_services/shared_perf.dart';
import '../../../core/widgets/loading_widget.dart';
import '../../../core/widgets/show_snackbar.dart';
import '../models/user_model.dart';

import '../../../core/services/remote_services/firebase_init.dart';
import '../../../core/utils/auth_exceptions.dart';

class AuthController extends ChangeNotifier {
  Future<void> register(UserModel user) async {
    loadingWithText();
    try {
      UserCredential credential = await getIt<FirebaseService>().auth
          .createUserWithEmailAndPassword(
            email: user.email,
            password: user.password,
          );
      if (credential.user != null) {
        await createUser(credential.user!.uid, user);
        NavigationManager.goToAndRemove(RouteName.login);
      }
    } on FirebaseAuthException catch (e) {
      NavigationManager.pop();
      showSnackBarCustom(text: AuthException.handleRegisterException(e));
    } on FirebaseException catch (e) {
      NavigationManager.pop();
      showSnackBarCustom(text: e.code);
    } catch (e) {
      NavigationManager.pop();
      showSnackBarCustom(text: 'Something went wrong');
    }
  }

  Future<void> login({required String email, required String password}) async {
    loadingWithText();
    try {
      UserCredential credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      if (credential.user != null) {
        await saveUser(email: email);
        SharedPrefController().isLoggedIn(value: true);
        SharedPrefController().setGuestUser(value: false);
        NavigationManager.goToAndRemove(RouteName.mainAppView);
        showSnackBarCustom(
          text: 'تم تسجيل الدخول بنجاح',
          backgroundColor: Colors.green,
        );
      }
    } on FirebaseAuthException catch (e) {
      NavigationManager.pop();
      showSnackBarCustom(text: AuthException.handleLoginException(e));
    } on FirebaseException catch (e) {
      NavigationManager.pop();
      showSnackBarCustom(text: e.code);
    } catch (e) {
      NavigationManager.pop();
      showSnackBarCustom(text: 'Something went wrong');
    }
  }

  Future<void> createUser(String userId, UserModel user) async {
    try {
      await getIt<FirebaseService>().firestore
          .collection('users')
          .doc(userId)
          .set(user.toJson());
    } on Exception catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> sendEmailResetPassword({required String email}) async {
    loadingWithText();
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      NavigationManager.pushNamed(RouteName.checkEmail);
      showSnackBarCustom(
        text: 'تم إرسال الرابط بنجاح',
        backgroundColor: Colors.green,
      );
    } on FirebaseAuthException catch (e) {
      NavigationManager.pop();
      showSnackBarCustom(text: AuthException.handleResetPasswordException(e));
    } on FirebaseException catch (e) {
      NavigationManager.pop();
      showSnackBarCustom(text: e.code);
    } catch (e) {
      NavigationManager.pop();
      showSnackBarCustom(text: 'Something went wrong');
    }
  }

  Future<void> saveUser({required String email}) async {
    try {
      final value = await getIt<FirebaseService>().firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (value.docs.isNotEmpty) {
        await SharedPrefController().save(
          UserModel.fromSnapshot(value.docs.first),
        );
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
