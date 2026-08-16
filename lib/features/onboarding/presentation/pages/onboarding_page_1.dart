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
    final screenWidth = MediaQuery.sizeOf(context).width;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 16,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),

                const Center(
                  child: BrandTitle(),
                ),

                const SizedBox(height: 14),

                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FishAssetImage(
                        assetPath: AssetPaths.onboardingWaterFish,
                        width: screenWidth * 0.82,
                      ),

                      const SizedBox(height: 4),

                      FishAssetImage(
                        assetPath: AssetPaths.onboardingWaterFish,
                        width: screenWidth * 0.82,
                        flipHorizontally: true,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                const Text(
                  'Explora la vida bajo el agua',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textPrimary,
                  ),
                ),

                const SizedBox(height: 10),

                const Text(
                  'Registra tus avistamientos de peces y ayuda a conocer mejor la diversidad acuática de nuestros ríos, lagos y mares.',
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                ),

                const SizedBox(height: 20),

                Center(
                  child: CustomButton(
                    text: 'Continuar',
                    onPressed: onContinue,
                    width: 200,
                    backgroundColor: AppColors.onboardingGreen,
                  ),
                ),

                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }
}