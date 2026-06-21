import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../app/theme/app_colors.dart';
import 'package:frontend/app/shared/widgets/custom_button.dart';
import '../providers/ocurrencia_provider.dart';
import 'ocurrencia_create_page.dart';
import '../../../mediciones/presentation/pages/medicion_create_page.dart';
import '../../../mediciones/presentation/providers/medicion_provider.dart';
import '../../../evidencias/presentation/pages/evidencia_create_page.dart';
import '../../../evidencias/presentation/providers/evidencia_provider.dart';
class OcurrenciaDetailPage extends StatefulWidget {
  final String ocurrenciaId;

  const OcurrenciaDetailPage({
    super.key,
    required this.ocurrenciaId,
  });

  @override
  State<OcurrenciaDetailPage> createState() => _OcurrenciaDetailPageState();
}

class _OcurrenciaDetailPageState extends State<OcurrenciaDetailPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OcurrenciaProvider>().loadOcurrenciaDetail(widget.ocurrenciaId);
      context.read<MedicionProvider>().loadMedicion(widget.ocurrenciaId);
      context.read<EvidenciaProvider>().loadEvidencias(widget.ocurrenciaId);
    });
  }
  String _buildImageUrl(String relativePath) {
    return 'http://192.168.1.10:8000/$relativePath';
    }

    Widget _sectionCard({required Widget child}) 
    {
      return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
          color: const Color(0xFFD9D9D9),
          borderRadius: BorderRadius.circular(14),
          ),
          child: child,
      );
    }

    Widget _sectionTitle(String title) {
      return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Text(
          title,
          style: const TextStyle
            (
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
      );
    }

    Future<void> _editEvidenceDialog(
      BuildContext context,
      String evidenciaId,
      String? currentObservaciones,
    ) async {
    final controller = TextEditingController(text: currentObservaciones ?? '');

    final confirm = await showDialog<bool>(
        context: context,
        builder: (_) => AlertDialog(
        title: const Text('Editar evidencia'),
        content: TextField(
            controller: controller,
            minLines: 3,
            maxLines: 4,
            decoration: const InputDecoration(
              hintText: 'Observaciones',
              border: OutlineInputBorder(),
            ),
          ),
        actions: [
            TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
            ),
            ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Guardar'),
            ),
        ],
        ),
    );

    if (confirm != true) {
        controller.dispose();
        return;
    }

    final success = await context.read<EvidenciaProvider>().updateEvidencia(
            evidenciaId: evidenciaId,
            observaciones: controller.text.trim().isEmpty ? null : controller.text.trim(),
        );

    controller.dispose();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
        content: Text(
            success ? 'Evidencia actualizada' : 'Error al actualizar evidencia',
        ),
        backgroundColor: success ? Colors.green.shade600 : Colors.red.shade600,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        ),
    );
    }  
  Widget _infoLine(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        '$label: $value',
        style: const TextStyle(fontSize: 15, height: 1.4),
      ),
    );
  }

  @override
Widget build(BuildContext context) {
  final provider = context.watch<OcurrenciaProvider>();
  final ocurrencia = provider.selectedOcurrencia;
  

  return Scaffold(
    backgroundColor: const Color(0xFFF0EED6),
    body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),

        // 🔥 SOLUCIÓN: un solo child → Column
        child: Column(
          children: [
            /// 🔄 LOADING / ERROR / CONTENIDO PRINCIPAL
            if (provider.isLoading)
              const Expanded(
                child: Center(child: CircularProgressIndicator()),
              )
            else if (ocurrencia == null)
              const Expanded(
                child: Center(child: Text('No se pudo cargar la ocurrencia')),
              )
            else
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _sectionCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _infoLine('Pez',ocurrencia.nombreComun ?? ocurrencia.nombreCientifico ?? 'No disponible',),
                            _infoLine('Nombre científico', ocurrencia.nombreCientifico ?? 'N/D'),
                            _infoLine('Familia', ocurrencia.familia ?? 'N/D'),
                            _infoLine('Sexo', ocurrencia.sexo ?? 'No definido'),
                            _infoLine('Longitud', ocurrencia.longitudPez?.toString() ?? 'N/D'),
                            _infoLine('Peso', ocurrencia.peso?.toString() ?? 'N/D'),
                            const SizedBox(height: 12),

                            const Text(
                              'Ubicación',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textPrimary,
                              ),
                            ),

                            const SizedBox(height: 8),

                            _infoLine(
                              'Estación',
                              ocurrencia.nombreEstacion ?? 'Sin estación asociada',
                            ),

                            _infoLine(
                              'Código estación',
                              ocurrencia.codigoEstacion ?? 'N/D',
                            ),

                            _infoLine(
                              'Latitud',
                              ocurrencia.latitud?.toStringAsFixed(6) ?? 'N/D',
                            ),

                            _infoLine(
                              'Longitud',
                              ocurrencia.longitud?.toStringAsFixed(6) ?? 'N/D',
                            ),

                            _infoLine(
                              'Altitud (m)',
                              ocurrencia.altitud?.toStringAsFixed(2) ?? 'N/D',
                            ),
                            _infoLine('Esfuerzo', ocurrencia.esfuerzo?.toString() ?? 'N/D'),
                            _infoLine('CPUE', ocurrencia.cpue?.toString() ?? 'N/D'),
                            _infoLine('Estado ontogenético', ocurrencia.estadoOntogenetico ?? 'N/D'),
                            _infoLine('Estadio de vida', ocurrencia.estadioVida ?? 'N/D'),
                            _infoLine(
                              'Condición reproductiva',
                              ocurrencia.condicionReproductiva ?? 'N/D',
                            ),
                            _infoLine('Voucher', ocurrencia.vouchers ?? 'N/D'),
                            _infoLine('Estado individuo', ocurrencia.mortalidad ?? 'N/D'),
                            _infoLine('Observaciones', ocurrencia.observaciones ?? 'N/D'),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      Consumer<MedicionProvider>(
                        builder: (context, medicionProvider, _) {
                          final medicion = medicionProvider.selectedMedicion;
                          print('====================');
                          print('🔥 BUILD EJECUTADO');
                          print('🔥 MEDICION EN UI: $medicion');
                          print('🔥 PH: ${medicion?.ph}');
                          print('🔥 IS LOADING: ${medicionProvider.isLoading}');
                          print('====================');
                          return _sectionCard(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _sectionTitle('Medición'),
                                if (medicion == null) ...[
                                  
                                  const Text(
                                    'Aún no hay medición registrada para esta ocurrencia.',
                                    style: TextStyle(fontSize: 15),
                                  ),
                                  const SizedBox(height: 12),
                                  CustomButton(
                                    text: 'Registrar medición',
                                    onPressed: () async {
                                      final created = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => MedicionCreatePage(
                                            ocurrenciaId: widget.ocurrenciaId,
                                          ),
                                        ),
                                      );

                                      if (mounted) {
                                        await context.read<MedicionProvider>().loadMedicion(widget.ocurrenciaId);
                                        await context.read<EvidenciaProvider>().loadEvidencias(widget.ocurrenciaId);
                                      }
                                    },
                                    backgroundColor: AppColors.loginBlue,
                                    width: 220,
                                  ),
                                ] else ...[
                                  _infoLine('pH', medicion.ph?.toString() ?? 'N/D'),
                                  _infoLine('Temperatura', medicion.temperaturaC?.toString() ?? 'N/D'),
                                  _infoLine('Oxígeno disuelto', medicion.oxigenoDisueltoMgL?.toString() ?? 'N/D'),
                                  _infoLine('Turbidez', medicion.turbidezNtu?.toString() ?? 'N/D'),
                                  _infoLine('Conductividad', medicion.conductividadUsCm?.toString() ?? 'N/D'),
                                  _infoLine('TDS', medicion.tdsMgL?.toString() ?? 'N/D'),
                                  _infoLine('Nivel del agua', medicion.nivelEstadoAgua ?? 'N/D'),
                                  _infoLine('Observaciones', medicion.observaciones ?? 'N/D'),
                                  const SizedBox(height: 12),
                                  CustomButton(
                                    text: 'Editar medición',
                                    onPressed: () async {
                                      final updated = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => MedicionCreatePage(
                                            ocurrenciaId: widget.ocurrenciaId,
                                            medicion: medicion,
                                          ),
                                        ),
                                      );

                                      if (updated == true && mounted) {
                                        context.read<MedicionProvider>().loadMedicion(widget.ocurrenciaId);
                                      }
                                    },
                                    backgroundColor: AppColors.loginBlue,
                                    width: 220,
                                  ),
                                ],
                              ],
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 16),

                      Consumer<EvidenciaProvider>(
                        builder: (context, evidenciaProvider, _) {
                          return _sectionCard(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _sectionTitle('Evidencias'),
                                if (evidenciaProvider.evidencias.isEmpty) ...[
                                  const Text(
                                    'Aún no hay evidencias registradas.',
                                    style: TextStyle(fontSize: 15),
                                  ),
                                ] else
                                  ListView.separated(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemCount: evidenciaProvider.evidencias.length,
                                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                                    itemBuilder: (context, index) {
                                      final evidencia = evidenciaProvider.evidencias[index];

                                      return Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: Colors.white70,
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            if (evidencia.ruta != null)
                                              ClipRRect(
                                                borderRadius: BorderRadius.circular(10),
                                                child: Image.network(
                                                  _buildImageUrl(evidencia.ruta!),
                                                  height: 180,
                                                  width: double.infinity,
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (_, __, ___) {
                                                    return Container(
                                                      height: 180,
                                                      color: Colors.grey.shade300,
                                                      child: const Center(
                                                        child: Text('No se pudo cargar la imagen'),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                            const SizedBox(height: 10),
                                            Text(
                                              evidencia.observaciones ?? 'Sin observaciones',
                                              style: const TextStyle(fontSize: 14),
                                            ),
                                            const SizedBox(height: 10),
                                            Row(
                                              children: [
                                                TextButton.icon(
                                                  onPressed: () {
                                                    _editEvidenceDialog(
                                                      context,
                                                      evidencia.idFoto,
                                                      evidencia.observaciones,
                                                    );
                                                  },
                                                  icon: const Icon(Icons.edit),
                                                  label: const Text('Editar'),
                                                ),
                                                TextButton.icon(
                                                  onPressed: () async {
                                                    final confirm = await showDialog<bool>(
                                                      context: context,
                                                      builder: (_) => AlertDialog(
                                                        title: const Text('Eliminar evidencia'),
                                                        content: const Text(
                                                          '¿Deseas eliminar esta evidencia?',
                                                        ),
                                                        actions: [
                                                          TextButton(
                                                            onPressed: () => Navigator.pop(context, false),
                                                            child: const Text('Cancelar'),
                                                          ),
                                                          ElevatedButton(
                                                            onPressed: () => Navigator.pop(context, true),
                                                            child: const Text('Eliminar'),
                                                          ),
                                                        ],
                                                      ),
                                                    );

                                                    if (confirm != true) return;

                                                    final success = await context
                                                        .read<EvidenciaProvider>()
                                                        .deleteEvidencia(evidencia.idFoto);

                                                    if (!mounted) return;

                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                      SnackBar(
                                                        content: Text(
                                                          success
                                                              ? 'Evidencia eliminada'
                                                              : 'Error al eliminar evidencia',
                                                        ),
                                                        backgroundColor: success
                                                            ? Colors.green.shade600
                                                            : Colors.red.shade600,
                                                        behavior: SnackBarBehavior.floating,
                                                        margin: const EdgeInsets.all(16),
                                                      ),
                                                    );
                                                  },
                                                  icon: const Icon(Icons.delete_outline),
                                                  label: const Text('Eliminar'),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                const SizedBox(height: 12),
                                CustomButton(
                                  text: 'Agregar evidencia',
                                  onPressed: () async {
                                    final added = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => EvidenciaCreatePage(
                                          ocurrenciaId: widget.ocurrenciaId,
                                        ),
                                      ),
                                    );

                                    if (added == true && mounted) {
                                      context.read<EvidenciaProvider>().loadEvidencias(widget.ocurrenciaId);
                                    }
                                  },
                                  backgroundColor: AppColors.loginBlue,
                                  width: 220,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  )
                ),
              ),
          ],
        ),
      ),
    ),
  );
}
}