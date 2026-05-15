import 'package:flutter_test/flutter_test.dart';
import 'package:medical_devices_app/modules/bnb/controller/bnb_controller.dart';

void main() {
  test('BnbController changes the selected tab', () {
    final controller = BnbController();

    controller.changeIndex(2);

    expect(controller.selectedTabIndex, 2);
  });
}
