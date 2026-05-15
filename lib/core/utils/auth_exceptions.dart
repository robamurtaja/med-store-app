
import 'package:firebase_auth/firebase_auth.dart';

class AuthException {
  static String handleRegisterException(FirebaseAuthException e) {
    String errorMessage = '';
    switch (e.code) {
      case 'weak-password':
        errorMessage = 'كلمة المرور ضعيفة جداً. يرجى استخدام كلمة مرور أقوى.';
        break;
      case 'email-already-in-use':
        errorMessage = 'هناك حساب مرتبط بالبريد الإلكتروني الذي تم ادخاله.';
        break;
      case 'invalid-email':
        errorMessage = 'ادخل ايميل صالح';
        break;
      case 'network-request-failed':
        errorMessage = 'حدث خطأ في الاتصال بالخادم.';
        break;
      default:
        errorMessage = 'حدث خطأ غير متوقع. الرجاء المحاولة مرة أخرى.';
    }
    return errorMessage;
  }

  static String handleLoginException(FirebaseAuthException e) {
    String errorMessage = '';
    switch (e.code) {
      case 'user-not-found':
        errorMessage = 'لا يوجد مستخدم مسجل بهذا البريد الإلكتروني.';
        break;
      case 'wrong-password':
        errorMessage = 'كلمة المرور غير صحيحة.';
        break;
      case 'invalid-email':
        errorMessage = 'ادخل ايميل صالح';
        break;
      case 'too-many-requests':
        errorMessage = 'تم تجاوز الحد الأقصى لعدد مرات محاولات تسجيل الدخول.';
        break;
      case 'network-request-failed':
        errorMessage = 'حدث خطأ في الاتصال بالخادم.';
        break;
      case 'user-token-expired':
        errorMessage = 'انتهت صلاحية الرمز المميز للمستخدم.';
        break;
      default:
        errorMessage = 'حدث خطأ غير متوقع. الرجاء المحاولة مرة أخرى.';
    }
    return errorMessage;
  }

  static String handleResetPasswordException(FirebaseAuthException e) {
    String errorMessage = '';
    switch (e.code) {
      case 'user-not-found':
        errorMessage = 'لا يوجد مستخدم مسجل بهذا البريد الإلكتروني.';
        break;
      case 'invalid-email':
        errorMessage = 'ادخل ايميل صالح';
        break;
      case 'too-many-requests':
        errorMessage = 'تم تجاوز الحد الأقصى لعدد مرات محاولات تسجيل الدخول.';
        break;
      case 'network-request-failed':
        errorMessage = 'حدث خطأ في الاتصال بالخادم.';
        break;
      default:
        errorMessage = 'حدث خطأ غير متوقع. الرجاء المحاولة مرة أخرى.';
    }
    return errorMessage;
  }
}