import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import 'package:frontend/app/core/constants/asset_paths.dart';
import 'package:frontend/app/shared/widgets/brand_title.dart';
import 'package:frontend/app/shared/widgets/custom_button.dart';
import 'package:frontend/app/shared/widgets/fish_asset_image.dart';

class OnboardingPage2 extends StatelessWidget {
  final VoidCallback onContinue;

  const OnboardingPage2({
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
              const SizedBox(height: 12),
              Expanded(
                flex: 5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    FishAssetImage(
                      assetPath: AssetPaths.onboardingDocumentFish,
                      width: 300,
                    ),
                    SizedBox(height: 12),
                    FishAssetImage(
                      assetPath: AssetPaths.onboardingDocumentFish2,
                      width: 320,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Usa la aplicación FishTrack para documentar tus registros ictiológicos',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textPrimary,
                    height: 1.4,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'FishTrack permite registrar observaciones de peces con precisión geográfica y ambiental, facilitando la recolección de datos en campo.',
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
                backgroundColor: AppColors.onboardingBrown,
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}