import 'package:flutter/material.dart';
import '../../../core/services/remote_services/base_model.dart';
import '../../../core/services/remote_services/firebase_init.dart';
import '../model/about_app_model.dart';

import '../../../core/router/router.dart';
import '../../../core/router/routers_name.dart';
import '../../../core/services/local_services/shared_perf.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileController extends ChangeNotifier {
  FirebaseResponse<List<AboutAppModel>> aboutApp = FirebaseResponse.init();
  FirebaseResponse<List<AboutAppModel>> privacyPolices =
      FirebaseResponse.init();
  FirebaseResponse<List<AboutAppModel>> usesPolices = FirebaseResponse.init();
  FirebaseResponse<List<AboutAppModel>> faq = FirebaseResponse.init();

  Future<void> logOut() async {
    await getIt<FirebaseService>().auth.signOut();
    SharedPrefController().isLoggedIn(value: false);
    SharedPrefController().setGuestUser(value: false);
    SharedPrefController().remove();
    NavigationManager.goToAndRemove(RouteName.login);
  }

  Future<bool> whatsappSupport() async {
    try {
      // Remove "+" if present
      final cleanedNumber = "+972599896893".replaceAll('+', '');
      final Uri url = Uri.parse(
        'https://wa.me/$cleanedNumber?text=Hello%20Support',
      );

      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
        return true;
      } else {
        debugPrint('whatsapp error');
        return false;
      }
    } catch (e) {
      debugPrint('whatsapp error');
      return false;
    }
  }

  Future<void> emailSupport() async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'raghadaltawille@gmail.com',
      queryParameters: <String, String>{'subject': 'Support'},
    );

    if (await canLaunchUrl(emailLaunchUri)) {
      launchUrl(emailLaunchUri);
    } else {
      debugPrint('whatsapp error');
    }
  }

  Future<void> callSupport() async {
    try {
      Uri email = Uri(scheme: 'tel', path: "+972593295356");
      await launchUrl(email);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> aboutTheApp() async {
    aboutApp = FirebaseResponse.loading('loading');
    notifyListeners();
    await getIt<FirebaseService>().firestore
        .collection('aboutApp')
        .doc('HwGwArfS5nmrWXdgx19n')
        .get()
        .then((value) {
          List response = value.data()!['about'];
          aboutApp = FirebaseResponse.completed(
            response.map((e) => AboutAppModel.fromJson(e)).toList(),
          );
          notifyListeners();
        })
        .catchError((e) {
          aboutApp = FirebaseResponse.error('error');
          notifyListeners();
        });
  }

  Future<void> privacyPolice() async {
    privacyPolices = FirebaseResponse.loading('loading');
    notifyListeners();
    await getIt<FirebaseService>().firestore
        .collection('aboutApp')
        .doc('SHbDekFsJpMYbYrfhDcm')
        .get()
        .then((value) {
          List response = value.data()!['privacy '];
          privacyPolices = FirebaseResponse.completed(
            response.map((e) => AboutAppModel.fromJson(e)).toList(),
          );
          notifyListeners();
        })
        .catchError((e) {
          debugPrint(e.toString());
          privacyPolices = FirebaseResponse.error('error');
          notifyListeners();
        });
  }

  Future<void> usesPolice() async {
    usesPolices = FirebaseResponse.loading('loading');
    notifyListeners();
    await getIt<FirebaseService>().firestore
        .collection('aboutApp')
        .doc('UXemIynMWGiv8hy3Papd')
        .get()
        .then((value) {
          List response = value.data()!['usesPolicy'];
          usesPolices = FirebaseResponse.completed(
            response.map((e) => AboutAppModel.fromJson(e)).toList(),
          );
          notifyListeners();
        })
        .catchError((e) {
          debugPrint(e.toString());
          usesPolices = FirebaseResponse.error('error');
          notifyListeners();
        });
  }

  Future<void> faqs() async {
    faq = FirebaseResponse.loading('loading');
    notifyListeners();
    await getIt<FirebaseService>().firestore
        .collection('aboutApp')
        .doc('PXqhzZvSr6YguC9UiiE8')
        .get()
        .then((value) {
          List response = value.data()!['faq'];
          faq = FirebaseResponse.completed(
            response.map((e) => AboutAppModel.fromJson(e)).toList(),
          );
          notifyListeners();
        })
        .catchError((e) {
          faq = FirebaseResponse.error('error');
          notifyListeners();
        });
  }
}
