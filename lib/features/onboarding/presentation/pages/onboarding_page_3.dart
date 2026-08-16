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

                const SizedBox(height: 10),

                // IMÁGENES
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Align(
                        alignment: Alignment.centerRight,
                        child: FishAssetImage(
                          assetPath: AssetPaths.onboardingFeaturesFish,
                          width: screenWidth * 0.80,
                        ),
                      ),

                      Transform.translate(
                        offset: const Offset(-40, -60),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: FishAssetImage(
                            assetPath: AssetPaths.onboardingFeaturesFish,
                            width: screenWidth * 0.80,
                            flipHorizontally: true,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 2),

                const Text(
                  'Descubre todo lo que puedes hacer con FishTrack',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textPrimary,
                    height: 1.4,
                  ),
                ),

                const SizedBox(height: 10),

                const Text(
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

                const SizedBox(height: 20),

                Center(
                  child: CustomButton(
                    text: 'Log in',
                    onPressed: onLogin,
                    width: 220,
                    backgroundColor: AppColors.darkOlive,
                  ),
                ),

                const SizedBox(height: 8),

                Center(
                  child: TextButton(
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