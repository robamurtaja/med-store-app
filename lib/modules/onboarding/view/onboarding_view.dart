import 'package:flutter/material.dart';
import '../../../core/router/router.dart';
import '../../../core/router/routers_name.dart';
import '../../../core/services/local_services/shared_perf.dart';
import '../../../core/utils/color_manager.dart';
import '../../../core/utils/extentions.dart';
import '../../../core/widgets/animated_entry.dart';
import '../controller/onboarding_controller.dart';
import '../model/onboarding_model.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoardingView extends StatefulWidget {
  const OnBoardingView({super.key});

  @override
  State<OnBoardingView> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingView> {
  final PageController controller = PageController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: ColorManager.premiumGradient),
        child: SafeArea(
          child: Consumer<OnBoardingController>(
            builder: (context, onboardingProvider, child) {
              final selected = onboardingProvider.selectedIndex;
              final item = onboardingContent[selected];
              return Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Align(
                      alignment: AlignmentDirectional.centerEnd,
                      child: TextButton(
                        onPressed: () {
                          SharedPrefController().setOnBoarding(value: true);
                          NavigationManager.goToAndRemove(RouteName.auth);
                        },
                        child: Text(
                          'تخطي',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.78),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: PageView.builder(
                        controller: controller,
                        onPageChanged: onboardingProvider.changeIndex,
                        physics: const BouncingScrollPhysics(),
                        itemCount: onboardingContent.length,
                        itemBuilder: (context, index) => AnimatedEntry(
                          key: ValueKey(index),
                          child: Image.asset(
                            onboardingContent[index].image,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 350),
                      child: Column(
                        key: ValueKey(item.title),
                        children: [
                          Text(
                            item.title,
                            textAlign: TextAlign.center,
                            style: context.h1.copyWith(
                              color: Colors.white,
                              fontSize: 28,
                              height: 1.25,
                            ),
                          ),
                          const SizedBox(height: 14),
                          Text(
                            item.description,
                            textAlign: TextAlign.center,
                            style: context.b1.copyWith(
                              color: Colors.white.withOpacity(0.78),
                              fontSize: 16,
                              height: 1.7,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),
                    SmoothPageIndicator(
                      controller: controller,
                      count: onboardingContent.length,
                      effect: const ExpandingDotsEffect(
                        dotHeight: 8,
                        dotWidth: 10,
                        expansionFactor: 4,
                        activeDotColor: ColorManager.gold,
                        dotColor: Colors.white30,
                      ),
                    ),
                    const SizedBox(height: 28),
                    ElevatedButton(
                      onPressed: () {
                        if (selected == onboardingContent.length - 1) {
                          SharedPrefController().setOnBoarding(value: true);
                          NavigationManager.goToAndRemove(RouteName.auth);
                        } else {
                          controller.nextPage(
                            duration: const Duration(milliseconds: 520),
                            curve: Curves.easeOutCubic,
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: ColorManager.navy,
                      ),
                      child: Text(
                        selected == onboardingContent.length - 1
                            ? 'ابدأ الآن'
                            : 'التالي',
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
