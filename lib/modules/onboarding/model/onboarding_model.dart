// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:medical_devices_app/core/utils/asset_path_manager.dart';

class OnBoardingModel {
  final String image;
  final String title;
  final String description;

  OnBoardingModel({
    required this.image,
    required this.title,
    required this.description,
  });
}

List<OnBoardingModel> onboardingContent = [
  OnBoardingModel(
    image: AssetPathManager.onboarding1,
    title: 'كل ما تحتاجه من الأجهزة الطبية',
    description:
        'منصة واحدة تجمع المنتجات الطبية الموثوقة وتساعدك تختار الأنسب لصحتك واحتياجك.',
  ),
  OnBoardingModel(
    image: AssetPathManager.onboarding2,
    title: 'تجربة شراء واضحة وآمنة',
    description:
        'تفاصيل المنتجات، الأسعار، والمميزات تظهر لك بطريقة سهلة قبل إتمام الطلب.',
  ),
  OnBoardingModel(
    image: AssetPathManager.onboarding3,
    title: 'اطلب بثقة واستلم بسهولة',
    description:
        'أضف الأجهزة إلى السلة، أدخل بيانات التوصيل، وتابع حالة طلبك من داخل التطبيق.',
  ),
];
