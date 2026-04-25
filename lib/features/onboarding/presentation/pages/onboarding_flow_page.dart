import 'package:flutter/material.dart';

import '../../../../app/routes.dart';
import 'onboarding_page_1.dart';
import 'onboarding_page_2.dart';
import 'onboarding_page_3.dart';

class OnboardingFlowPage extends StatefulWidget {
  const OnboardingFlowPage({super.key});

  @override
  State<OnboardingFlowPage> createState() => _OnboardingFlowPageState();
}

class _OnboardingFlowPageState extends State<OnboardingFlowPage> {
  int currentPage = 0;

  void _nextPage() {
    setState(() {
      currentPage++;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (currentPage == 0) {
      return OnboardingPage1(onContinue: _nextPage);
    }

    if (currentPage == 1) {
      return OnboardingPage2(onContinue: _nextPage);
    }

    return OnboardingPage3(
      onLogin: () {
        Navigator.pushReplacementNamed(context, AppRoutes.login);
      },
      onRegister: () {
        Navigator.pushReplacementNamed(context, AppRoutes.register);
      },
    );
  }
}
