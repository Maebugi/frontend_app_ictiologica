import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:frontend/app/routes.dart';
import 'package:frontend/app/theme/app_colors.dart';
import 'package:frontend/app/core/constants/asset_paths.dart';
import 'package:frontend/app/shared/widgets/brand_title.dart';
import 'package:frontend/app/shared/widgets/custom_button.dart';
import 'package:frontend/app/shared/widgets/custom_text_field.dart';
import 'package:frontend/app/shared/widgets/fish_asset_image.dart';
import '../providers/auth_provider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _nombreController = TextEditingController();
  final _correoController = TextEditingController();
  final _contrasenaController = TextEditingController();
  final _confirmarController = TextEditingController();
  final _institucionController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _acceptTerms = false;
  bool _rememberUser = true;

  @override
  void dispose() {
    _nombreController.dispose();
    _correoController.dispose();
    _contrasenaController.dispose();
    _confirmarController.dispose();
    _institucionController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (_contrasenaController.text.trim() != _confirmarController.text.trim()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Las contraseñas no coinciden'),
          backgroundColor: Colors.red.shade600,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
        ),
      );
      return;
    }

    if (!_acceptTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Debes aceptar términos y condiciones'),
          backgroundColor: Colors.red.shade600,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
        ),
      );
      return;
    }

    final authProvider = context.read<AuthProvider>();

    final success = await authProvider.register(
      nombre: _nombreController.text.trim(),
      correo: _correoController.text.trim(),
      contrasena: _contrasenaController.text.trim(),
      institucion: _institucionController.text.trim().isEmpty
          ? null
          : _institucionController.text.trim(),
    );

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Usuario registrado correctamente'),
          backgroundColor: Colors.green.shade600,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
        ),
      );
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authProvider.errorMessage ?? 'Error'),
          backgroundColor: Colors.red.shade600,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          duration: const Duration(seconds: 4),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 14),
          child: Column(
            children: [
              const SizedBox(height: 8),
              const BrandTitle(),
              const SizedBox(height: 8),
              const Text(
                'Crear cuenta en FishTrack',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                '📱 Cuenta local del dispositivo',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              const FishAssetImage(
                assetPath: AssetPaths.authFish,
                width: 190,
              ),
              const SizedBox(height: 18),
              CustomTextField(
                controller: _nombreController,
                hintText: 'Nombre',
              ),
              const SizedBox(height: 12),
              CustomTextField(
                controller: _correoController,
                hintText: 'Correo',
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 12),
              CustomTextField(
                controller: _contrasenaController,
                hintText: 'Contraseña',
                obscureText: _obscurePassword,
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                  icon: Icon(
                    _obscurePassword ? Icons.visibility : Icons.visibility_off,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              CustomTextField(
                controller: _confirmarController,
                hintText: 'Confirmar contraseña',
                obscureText: _obscureConfirm,
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _obscureConfirm = !_obscureConfirm;
                    });
                  },
                  icon: Icon(
                    _obscureConfirm ? Icons.visibility : Icons.visibility_off,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              CustomTextField(
                controller: _institucionController,
                hintText: 'Institución',
              ),
              const SizedBox(height: 16),
              const Text(
                'El usuario se almacenará únicamente en este dispositivo y permitirá registrar eventos de muestreo sin conexión.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  height: 1.5,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              CheckboxListTile(
                value: _acceptTerms,
                onChanged: (value) {
                  setState(() {
                    _acceptTerms = value ?? false;
                  });
                },
                title: const Text(
                  'Acepto términos y condiciones',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
              ),
              CheckboxListTile(
                value: _rememberUser,
                onChanged: (value) {
                  setState(() {
                    _rememberUser = value ?? true;
                  });
                },
                title: const Text(
                  'Recordar usuario',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
              ),
              const SizedBox(height: 12),
              CustomButton(
                text: 'Crear cuenta',
                onPressed: authProvider.isLoading ? null : _register,
                backgroundColor: AppColors.loginBlue,
                width: 230,
                isLoading: authProvider.isLoading,
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () {},
                child: const Text(
                  'Leer términos y condiciones',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
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
