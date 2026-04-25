import 'package:flutter/material.dart';
import 'package:frontend/app/theme/app_colors.dart';

class BrandTitle extends StatelessWidget {
  const BrandTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      'FishTrack',
      style: TextStyle(
        fontSize: 26,
        fontWeight: FontWeight.w900,
        color: AppColors.textPrimary,
        shadows: [
          Shadow(
            offset: Offset(0, 2),
            blurRadius: 3,
            color: Color(0x33000000),
          ),
        ],
      ),
    );
  }
}
