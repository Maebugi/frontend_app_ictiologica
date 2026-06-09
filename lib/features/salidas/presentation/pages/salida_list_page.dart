import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../app/theme/app_colors.dart';
import '../../data/models/salida_model.dart';
import '../providers/salida_provider.dart';
import 'salida_create_page.dart';
import 'salida_detail_page.dart';

class SalidaListPage extends StatefulWidget {
  const SalidaListPage({super.key});

  @override
  State<SalidaListPage> createState() => _SalidaListPageState();
}

class _SalidaListPageState extends State<SalidaListPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<SalidaProvider>().loadSalidas();
    });
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Sin fecha';
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  Widget _statusChip(String estado) {
    final isOpen = estado == 'abierta';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: isOpen ? Colors.green.shade100 : Colors.grey.shade300,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        isOpen ? 'Abierta' : 'Cerrada',
        style: TextStyle(
          fontWeight: FontWeight.w700,
          color: isOpen ? Colors.green.shade800 : Colors.black87,
        ),
      ),
    );
  }

  Widget _salidaCard(SalidaModel salida) {
    return GestureDetector(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => SalidaDetailPage(salidaId: salida.salidaId),
          ),
        );

        if (mounted) {
          context.read<SalidaProvider>().loadSalidas();
        }
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFD9D9D9),
          borderRadius: BorderRadius.circular(14),
        ),
        // Mostrar datos del proyecto
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
        // Titulo del proyecto
                    '🧪 ${salida.nombreProyecto ?? 'Proyecto no definido'}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                _statusChip(salida.estado),
              ],
            ),
            // datos complementarios de la salida
            const SizedBox(height: 12),
           Text(
               'Nombre lugar: ${salida.nombreLugar ?? 'Sin lugar'}',
               style: const TextStyle(fontSize: 15, height: 1.4),
            ),
            Text(
              'Fecha inicio: ${_formatDate(salida.fechaInicio)}',
              style: const TextStyle(fontSize: 15, height: 1.4),
            ),
            Text(
              'Fecha fin: ${_formatDate(salida.fechaFin)}',
              style: const TextStyle(fontSize: 15, height: 1.4),
            ),
            const SizedBox(height: 6),
            Text(
              'Observaciones: ${salida.observaciones ?? 'Sin observaciones'}',
              style: const TextStyle(fontSize: 15, height: 1.4),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SalidaProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF0EED6),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFD9D9D9),
        foregroundColor: Colors.black87,
        onPressed: () async {
          final created = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const SalidaCreatePage(),
            ),
          );

          if (created == true && mounted) {
            context.read<SalidaProvider>().loadSalidas();
          }
        },
        child: const Icon(Icons.add, size: 34),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFC8D3F0),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back),
                    ),
                    const SizedBox(width: 6),
                    const Expanded(
                      child: Text(
                        'Eventos de muestreo',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: provider.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : provider.salidas.isEmpty
                        ? const Center(
                            child: Text(
                              'Aún no has creado eventos de muestreo',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          )
                        : ListView.separated(
                            itemCount: provider.salidas.length,
                            separatorBuilder: (_, __) => const SizedBox(height: 14),
                            itemBuilder: (context, index) {
                              return _salidaCard(provider.salidas[index]);
                            },
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}