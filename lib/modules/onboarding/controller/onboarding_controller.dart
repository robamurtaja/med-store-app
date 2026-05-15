import 'package:flutter/widgets.dart';

class OnBoardingController extends ChangeNotifier {
  int selectedIndex = 0;

  void changeIndex(int index) {
    selectedIndex = index;
    notifyListeners();
  }
}


