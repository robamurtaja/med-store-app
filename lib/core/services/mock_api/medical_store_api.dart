import '../../../modules/category/model/category_model.dart';
import '../../../modules/home/model/device_model.dart';

class MedicalStoreApi {
  const MedicalStoreApi();

  List<CategoryModel> getCategories() {
    return _categories.map(CategoryModel.fromJson).toList();
  }

  List<DeviceModel> getDevices({String? categoryId}) {
    final devices = categoryId == null
        ? _devices
        : _devices.where((device) => device['categoryId'] == categoryId);
    return devices.map(DeviceModel.fromJson).toList();
  }
}

const List<Map<String, dynamic>> _categories = [
  {
    'categoryId': 'mobility',
    'name': 'أجهزة الحركة',
    'image': 'assets/images/device.jpeg',
  },
  {
    'categoryId': 'monitoring',
    'name': 'أجهزة القياس',
    'image': 'assets/images/device1.jpeg',
  },
  {
    'categoryId': 'care',
    'name': 'الرعاية المنزلية',
    'image': 'assets/images/category.png',
  },
];

const List<Map<String, dynamic>> _devices = [
  {
    'deviceId': 'wheel-chair-pro',
    'categoryId': 'mobility',
    'name': 'كرسي متحرك فاخر',
    'image': 'assets/images/device.jpeg',
    'price': '320',
    'details': 'كرسي متحرك عملي بتصميم مريح وخفيف مناسب للاستخدام اليومي.',
    'for': 'كبار السن والمرضى الذين يحتاجون دعماً في الحركة.',
    'note': 'يفضل التأكد من المقاس المناسب قبل الطلب.',
    'points': ['هيكل قوي وخفيف', 'سهل الطي والتخزين', 'مساند يد مريحة'],
  },
  {
    'deviceId': 'oxygen-care',
    'categoryId': 'care',
    'name': 'جهاز رعاية تنفسية',
    'image': 'assets/images/device1.jpeg',
    'price': '480',
    'details': 'جهاز مساعد للرعاية المنزلية مع واجهة استخدام بسيطة وواضحة.',
    'for': 'الرعاية المنزلية والمتابعة اليومية حسب إرشادات المختص.',
    'note': 'لا يستخدم كبديل عن الاستشارة الطبية.',
    'points': ['تشغيل هادئ', 'مناسب للمنزل', 'سهل التنظيف'],
  },
  {
    'deviceId': 'pressure-monitor',
    'categoryId': 'monitoring',
    'name': 'جهاز قياس ضغط رقمي',
    'image': 'assets/images/category.png',
    'price': '75',
    'details': 'جهاز قياس ضغط رقمي بشاشة واضحة ونتائج سريعة.',
    'for': 'المتابعة المنزلية لضغط الدم.',
    'note': 'اتبع طريقة القياس الصحيحة للحصول على قراءة أدق.',
    'points': ['شاشة كبيرة', 'ذاكرة للقراءات', 'سهل الحمل'],
  },
];