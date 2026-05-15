import 'package:flutter/material.dart';
import '../../../core/services/remote_services/base_model.dart';
import '../../../core/utils/color_manager.dart';
import '../../../core/utils/extentions.dart';
import '../../../core/widgets/appbar_custom.dart';
import '../../../core/widgets/loading_widget.dart';
import '../controller/profile_controller.dart';
import 'package:provider/provider.dart';

class UsesPolicyView extends StatefulWidget {
  const UsesPolicyView({super.key});

  @override
  State<UsesPolicyView> createState() => _UsesPolicyViewState();
}

class _UsesPolicyViewState extends State<UsesPolicyView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<ProfileController>().usesPolice();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarCustom(title: 'سياسية الاستخدام'),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Consumer<ProfileController>(
        builder: (context, profileController, child) {
          if (profileController.usesPolices.status == Status.COMPLETED) {
            return ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 30),
              children: [
                Card(
                  elevation: 0,
                  margin: const EdgeInsets.only(bottom: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  color: Theme.of(context).colorScheme.surface,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        Text(
                          '''
مرحباً بك في تطبيق ميدستور. يرجى قراءة هذه السياسة بعناية قبل استخدام التطبيق. باستخدام التطبيق، فإنك توافق على الالتزام بجميع الشروط والأحكام الواردة في هذه السياسة.
''',
                          style: context.b1.copyWith(
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        ...(profileController.usesPolices.data ?? []).map(
                          (e) => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '• ${e.title}',
                                style: context.h1.copyWith(fontSize: 14),
                              ),
                              Text(e.description, style: context.b1),
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'انضم إلينا اليوم واستمتع بتجربة تسوق مميزة للأدوات الطبية!',
                          style: context.h1.copyWith(
                            fontSize: 14,
                            color: ColorManager.blue,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          } else if (profileController.usesPolices.status == Status.ERROR) {
            return const Text('something went wrong');
          } else {
            return loading();
          }
        },
      ),
    );
  }
}
