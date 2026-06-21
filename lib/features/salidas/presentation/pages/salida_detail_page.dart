import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../app/theme/app_colors.dart';
import 'package:frontend/app/shared/widgets/custom_button.dart';
import '../providers/salida_provider.dart';
import '../../../ocurrencias/presentation/pages/ocurrencia_create_page.dart';
import '../../../ocurrencias/presentation/pages/ocurrencia_detail_page.dart';
import '../../../ocurrencias/presentation/providers/ocurrencia_provider.dart';
import '../../../salida_evidencias/presentation/pages/salida_evidencia_create_page.dart';
import 'salida_create_page.dart';

class SalidaDetailPage extends StatefulWidget {
  final String salidaId;

  const SalidaDetailPage({
    super.key,
    required this.salidaId,
  });

  @override
  State<SalidaDetailPage> createState() => _SalidaDetailPageState();
}

class _SalidaDetailPageState extends State<SalidaDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<SalidaProvider>().loadSalidaDetail(widget.salidaId);
      context.read<OcurrenciaProvider>().loadOcurrenciasBySalida(widget.salidaId);
    });
  }

  String _formatDateTime(DateTime? date) {
    if (date == null) return 'No definida';
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year} '
        '${date.hour.toString().padLeft(2, '0')}:'
        '${date.minute.toString().padLeft(2, '0')}';
  }

  Future<DateTime?> _pickDateTime(DateTime initialValue) async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: initialValue,
      firstDate: DateTime(2024),
      lastDate: DateTime(2035),
    );

    if (selectedDate == null) return null;
    if (!mounted) return null;

    final selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initialValue),
    );

    if (selectedTime == null) return null;

    return DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      selectedTime.hour,
      selectedTime.minute,
    );
  }

  Future<void> _showFinalizeDialog() async {
    DateTime selectedFechaFin = DateTime.now();
    final observacionesController = TextEditingController();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return AlertDialog(
              title: const Text(
                'Finalizar salida',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFD9D9D9),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        'Fecha fin sugerida:\n${_formatDateTime(selectedFechaFin)}',
                        style: const TextStyle(
                          fontSize: 15,
                          height: 1.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          final picked = await _pickDateTime(selectedFechaFin);
                          if (picked != null) {
                            setModalState(() {
                              selectedFechaFin = picked;
                            });
                          }
                        },
                        child: const Text('Editar fecha/hora'),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: observacionesController,
                      minLines: 3,
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: 'Observación final (opcional)',
                        filled: true,
                        fillColor: const Color(0xFFF2F2F2),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext, false),
                  child: const Text('Cancelar'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pop(dialogContext, true),
                  child: const Text('Confirmar'),
                ),
              ],
            );
          },
        );
      },
    );

    if (confirmed != true) {
      observacionesController.dispose();
      return;
    }

    final provider = context.read<SalidaProvider>();

    final success = await provider.finalizeSalida(
      salidaId: widget.salidaId,
      fechaFin: selectedFechaFin,
      observaciones: observacionesController.text.trim().isEmpty
          ? null
          : observacionesController.text.trim(),
    );

    observacionesController.dispose();

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Salida finalizada correctamente'),
          backgroundColor: Colors.green.shade600,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(provider.errorMessage ?? 'Error al finalizar salida'),
          backgroundColor: Colors.red.shade600,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SalidaProvider>();
    final salida = provider.selectedSalida;

    return Scaffold(
      backgroundColor: const Color(0xFFF0EED6),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: provider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : salida == null
                  ? const Center(child: Text('No se pudo cargar la salida'))
                  : Column(
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
                                  'Detalle del evento',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () async {
                                  if (salida == null) return;

                                  final updated = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => SalidaCreatePage(salida: salida),
                                    ),
                                  );

                                  if (updated == true && mounted) {
                                    context.read<SalidaProvider>().loadSalidaDetail(widget.salidaId);
                                  }
                                },
                                icon: const Icon(Icons.edit),
                              ),
                              IconButton(
                                onPressed: () async {
                                  final confirm = await showDialog<bool>(
                                    context: context,
                                    builder: (_) => AlertDialog(
                                      title: const Text('Eliminar salida'),
                                      content: const Text(
                                        '¿Seguro que deseas eliminar esta salida? Solo se podrá eliminar si no tiene ocurrencias.',
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

                                  final success = await context.read<SalidaProvider>().deleteSalida(widget.salidaId);

                                  if (!mounted) return;

                                  if (success) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: const Text('Salida eliminada correctamente'),
                                        backgroundColor: Colors.green.shade600,
                                        behavior: SnackBarBehavior.floating,
                                        margin: const EdgeInsets.all(16),
                                      ),
                                    );
                                    Navigator.pop(context, true);
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          context.read<SalidaProvider>().errorMessage ?? 'Error al eliminar salida',
                                        ),
                                        backgroundColor: Colors.red.shade600,
                                        behavior: SnackBarBehavior.floating,
                                        margin: const EdgeInsets.all(16),
                                      ),
                                    );
                                  }
                                },
                                icon: const Icon(Icons.delete_outline),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: const Color(0xFFD9D9D9),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '📍 ${salida.nombreLugar ?? 'Lugar no definido'}',
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Fecha inicio: ${_formatDateTime(salida.fechaInicio)}',
                                style: const TextStyle(fontSize: 16, height: 1.5),
                              ),
                              Text(
                                'Fecha fin: ${_formatDateTime(salida.fechaFin)}',
                                style: const TextStyle(fontSize: 16, height: 1.5),
                              ),
                              Text(
                                'Estado: ${salida.estado}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  height: 1.5,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Observaciones: ${salida.observaciones ?? 'Sin observaciones'}',
                                style: const TextStyle(fontSize: 16, height: 1.5),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                            child: Consumer<OcurrenciaProvider>(
                                builder: (context, ocurrenciaProvider, _) {
                                if (ocurrenciaProvider.isLoading) {
                                    return const Center(child: CircularProgressIndicator());
                                }

                                if (ocurrenciaProvider.ocurrencias.isEmpty) {
                                    return Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(18),
                                    decoration: BoxDecoration(
                                        color: const Color(0xFFD9D9D9),
                                        borderRadius: BorderRadius.circular(14),
                                    ),
                                    child: const Center(
                                        child: Text(
                                        'Aún no hay ocurrencias registradas',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w600,
                                        ),
                                        ),
                                    ),
                                    );
                                }

                                return Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(14),
                                    decoration: BoxDecoration(
                                    color: const Color(0xFFD9D9D9),
                                    borderRadius: BorderRadius.circular(14),
                                    ),
                                    child: ListView.separated(
                                    itemCount: ocurrenciaProvider.ocurrencias.length,
                                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                                    itemBuilder: (context, index) {
                                        final item = ocurrenciaProvider.ocurrencias[index];

                                        return GestureDetector(
                                          onTap: () async {
                                            final changed = await Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) => OcurrenciaDetailPage(
                                                  ocurrenciaId: item.idOcurrencia,
                                                ),
                                              ),
                                            );

                                            if (changed == true && mounted) {
                                              context.read<OcurrenciaProvider>().loadOcurrenciasBySalida(widget.salidaId);
                                            }
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.all(12),
                                            decoration: BoxDecoration(
                                              color: Colors.white70,
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            child: Text(
                                              'Pez: ${item.nombreComun ?? item.nombreCientifico ?? 'Especie no disponible'}\n'
                                              'Familia: ${item.familia ?? 'N/D'}\n'
                                              'Estación: ${item.nombreEstacion ?? "Sin estación"}\n'
                                              'Código estación: ${item.codigoEstacion ?? "N/D"}'
                                              'Sexo: ${item.sexo ?? 'No definido'}\n'
                                              'Longitud: ${item.longitudPez?.toString() ?? 'N/D'}\n'
                                              'Peso: ${item.peso?.toString() ?? 'N/D'}',

                                              style: const TextStyle(
                                                fontSize: 14,
                                                height: 1.5,
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                );
                                },
                            ),
                            ),
                        const SizedBox(height: 20),
                        CustomButton(
                            text: 'Agregar ocurrencia',
                            onPressed: salida.estado == 'cerrada'
                                ? null
                                : () async {
                                    final created = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                        builder: (_) => OcurrenciaCreatePage(salidaId: widget.salidaId),
                                        ),
                                    );

                                    if (created == true && mounted) {
                                        context.read<OcurrenciaProvider>().loadOcurrenciasBySalida(widget.salidaId);
                                    }
                                    },
                            backgroundColor: AppColors.loginBlue,
                            width: 240,
                            ),
                        const SizedBox(height: 12),

                        CustomButton(
                          text: 'Registrar evidencia',
                          onPressed: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => SalidaEvidenciaCreatePage(
                                  salidaId: widget.salidaId,
                                ),
                              ),
                            );
                          },
                          backgroundColor: Colors.orange,
                          width: 240,
                        ),
                        const SizedBox(height: 12),
                        CustomButton(
                          text: 'Finalizar salida',
                          onPressed: salida.estado == 'cerrada'
                              ? null
                              : _showFinalizeDialog,
                          backgroundColor: AppColors.darkOlive,
                          width: 240,
                        ),
                      ],
                    ),
        ),
      ),
    );
  }
}