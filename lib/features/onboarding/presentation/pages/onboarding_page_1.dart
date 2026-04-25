import 'package:flutter/material.dart';

import 'package:frontend/app/theme/app_colors.dart';
import 'package:frontend/app/core/constants/asset_paths.dart';
import 'package:frontend/app/shared/widgets/brand_title.dart';
import 'package:frontend/app/shared/widgets/custom_button.dart';
import 'package:frontend/app/shared/widgets/fish_asset_image.dart';

class OnboardingPage1 extends StatelessWidget {
  final VoidCallback onContinue;

  const OnboardingPage1({
    super.key,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          child: Column(
            children: [
              const SizedBox(height: 10),
              const BrandTitle(),
              const SizedBox(height: 14),
              Expanded(
                flex: 5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    FishAssetImage(
                      assetPath: AssetPaths.onboardingWaterFish,
                      width: 360,
                    ),
                    SizedBox(height: 4),
                    FishAssetImage(
                      assetPath: AssetPaths.onboardingWaterFish,
                      width: 360,
                      flipHorizontally: true,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Explora la vida bajo el agua',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Registra tus avistamientos de peces y ayuda a conocer mejor la diversidad acuática de nuestros ríos, lagos y mares.',
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              CustomButton(
                text: 'Continuar',
                onPressed: onContinue,
                width: 200,
                backgroundColor: AppColors.onboardingGreen,
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}