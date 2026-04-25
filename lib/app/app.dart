import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'routes.dart';
import 'theme/app_theme.dart';
import '../features/salidas/presentation/providers/salida_provider.dart';
import '../features/auth/presentation/pages/login_page.dart';
import '../features/auth/presentation/pages/register_page.dart';
import '../features/auth/presentation/pages/splash_decider_page.dart';
import '../features/auth/presentation/providers/auth_provider.dart';
import '../features/home/presentation/pages/home_page.dart';
import '../features/onboarding/presentation/pages/onboarding_flow_page.dart';
import '../features/ocurrencias/presentation/providers/ocurrencia_provider.dart';
import '../features/mediciones/presentation/providers/medicion_provider.dart';
import '../features/evidencias/presentation/providers/evidencia_provider.dart';

class FishTrackApp extends StatelessWidget {
  const FishTrackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => SalidaProvider()),
        ChangeNotifierProvider(create: (_) => OcurrenciaProvider()),
        ChangeNotifierProvider(create: (_) => MedicionProvider()),
        ChangeNotifierProvider(create: (_) => EvidenciaProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'FishTrack',
        theme: AppTheme.lightTheme,
        initialRoute: AppRoutes.splash,
        routes: {
          AppRoutes.splash: (_) => const SplashDeciderPage(),
          AppRoutes.onboarding: (_) => const OnboardingFlowPage(),
          AppRoutes.login: (_) => const LoginPage(),
          AppRoutes.register: (_) => const RegisterPage(),
          AppRoutes.home: (_) => const HomePage(),
        },
      ),
    );
  }
}
