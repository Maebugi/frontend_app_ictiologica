import 'package:flutter/material.dart';

import 'package:frontend/app/theme/app_colors.dart';
import 'package:frontend/app/core/constants/asset_paths.dart';
import 'package:frontend/app/shared/widgets/brand_title.dart';
import 'package:frontend/app/shared/widgets/custom_button.dart';
import 'package:frontend/app/shared/widgets/fish_asset_image.dart';

class OnboardingPage3 extends StatelessWidget {
  final VoidCallback onLogin;
  final VoidCallback onRegister;

  const OnboardingPage3({
    super.key,
    required this.onLogin,
    required this.onRegister,
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
              const SizedBox(height: 10),

              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  const Align(
                    alignment: Alignment.centerRight,
                    child: FishAssetImage(
                      assetPath: AssetPaths.onboardingFeaturesFish,
                      width: 350,
                    ),
                  ),

                  Transform.translate(
                    offset: const Offset(-40, -60),
                    child: const Align(
                      alignment: Alignment.centerLeft,
                      child: FishAssetImage(
                        assetPath: AssetPaths.onboardingFeaturesFish,
                        width: 350,
                        flipHorizontally: true,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 2),

              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Descubre todo lo que puedes hacer con FishTrack',
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
                  '🐟 Accede a tus bases de datos y listas de especies registradas\n'
                  '🌊 Descubre peces que aún no has observado\n'
                  '🗂️ Sube fotos y exporta tus datos ictiológicos.',
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.6,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              CustomButton(
                text: 'Log in',
                onPressed: onLogin,
                width: 220,
                backgroundColor: AppColors.darkOlive,
              ),

              const SizedBox(height: 8),

              TextButton(
                onPressed: onRegister,
                child: const Text(
                  'Sign up',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

