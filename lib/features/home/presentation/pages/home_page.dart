import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../../../app/theme/app_colors.dart';
import 'package:frontend/app/shared/widgets/brand_title.dart';
import '../../../salidas/presentation/pages/salida_list_page.dart';
import '../../../profile/presentation/pages/profile_page.dart';
//test
import 'package:frontend/features/salidas/presentation/providers/salida_provider.dart';
import 'package:provider/provider.dart';
import 'package:frontend/features/salidas/presentation/providers/salida_provider.dart';
import 'package:frontend/features/ocurrencias/presentation/providers/ocurrencia_provider.dart';
import 'package:provider/provider.dart';
import 'package:frontend/features/mediciones/presentation/providers/medicion_provider.dart';
import 'package:frontend/features/evidencias/presentation/providers/evidencia_provider.dart';
import 'package:frontend/features/salida_evidencias/presentation/providers/salida_evidencia_provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Widget _menuItem({
    required String title,
    required String emoji,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
        decoration: BoxDecoration(
          color: const Color(0xFFD9D9D9),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          '$emoji $title',
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0EED6),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                decoration: BoxDecoration(
                  color: const Color(0xFFC8D3F0),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  '←   Menú',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              const SizedBox(height: 26),
              _menuItem(
                title: 'Perfil',
                emoji: '👤',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ProfilePage(),
                    ),
                  );
                },
              ),
              _menuItem(
                title: 'Eventos de muestreo',
                emoji: '📍',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const SalidaListPage(),
                    ),
                  );
                },
              ),
              _menuItem(
                title: 'Lista de especies registradas',
                emoji: '🐟',
                onTap: () {},
              ),
              _menuItem(
                title: 'Exportar datos',
                emoji: '📤',
                onTap: () {},
              ),
              _menuItem(
                title: 'Sincronización de datos',
                emoji: '↻',
                onTap: () async {
                  final salidaProvider =
                        context.read<SalidaProvider>();

                  final ocurrenciaProvider =
                        context.read<OcurrenciaProvider>();

                  final medicionProvider =
                        context.read<MedicionProvider>();

                  final evidenciaProvider =
                        context.read<EvidenciaProvider>();

                  final salidaEvidenciaProvider =
                        context.read<SalidaEvidenciaProvider>();
                  await salidaProvider.syncPendingSalidas();

                  await ocurrenciaProvider.syncPendingOcurrencias();

                  await medicionProvider.syncPendingMediciones();

                  await evidenciaProvider.syncPendingEvidencias();

                  await salidaEvidenciaProvider.syncPendingEvidencias();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Sync completo ejecutado'),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
