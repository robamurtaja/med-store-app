import 'package:flutter/material.dart';
import '../../../core/services/remote_services/base_model.dart';

import '../../../core/utils/extentions.dart';
import '../../../core/widgets/appbar_custom.dart';
import '../../../core/widgets/loading_widget.dart';
import '../controller/profile_controller.dart';
import 'package:provider/provider.dart';

class FAQView extends StatefulWidget {
  const FAQView({super.key});

  @override
  State<FAQView> createState() => _FAQViewState();
}

class _FAQViewState extends State<FAQView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<ProfileController>().faqs();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarCustom(title: 'الأسئلة الشائعة'),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Consumer<ProfileController>(
        builder: (context, profileController, child) {
          if (profileController.faq.status == Status.COMPLETED) {
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
                        ...(profileController.faq.data ?? []).map(
                          (e) => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 10),
                              Text(
                                '• ${e.title}',
                                style: context.h1.copyWith(fontSize: 14),
                              ),
                              Text(e.description, style: context.b1),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          } else if (profileController.faq.status == Status.ERROR) {
            return const Text('something went wrong');
          } else {
            return loading();
          }
        },
      ),
    );
  }
}
