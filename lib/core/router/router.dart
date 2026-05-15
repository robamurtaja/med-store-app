import 'package:flutter/material.dart';

class NavigationManager {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static Future<Object?>? pushNamed(String nameScreen, {Object? arguments}) {
    return navigatorKey.currentState?.pushNamed(
      nameScreen,
      arguments: arguments,
    );
  }

  static void pushNamedReplacement(String routeName, {Object? arguments}) {
    navigatorKey.currentState?.pushReplacementNamed(
      routeName,
      arguments: arguments,
    );
  }

  static void goToAndRemove(String routeName, {Object? argument}) {
    navigatorKey.currentState?.pushNamedAndRemoveUntil(
      routeName,
      (route) => false,
      arguments: argument,
    );
  }

  static void pop() {
    final state = navigatorKey.currentState;
    if (state?.canPop() ?? false) {
      state!.pop();
    }
  }

  static void mayPop() {
    navigatorKey.currentState?.maybePop();
  }

  static void popUntil(String screenName) {
    navigatorKey.currentState?.popUntil(ModalRoute.withName(screenName));
  }
}
