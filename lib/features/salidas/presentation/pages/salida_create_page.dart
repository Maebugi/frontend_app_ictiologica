import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../app/theme/app_colors.dart';
import 'package:frontend/app/shared/widgets/custom_button.dart';
import '../providers/salida_provider.dart';
import '../../data/models/salida_model.dart';

class SalidaCreatePage extends StatefulWidget {
  final SalidaModel? salida;

  const SalidaCreatePage({
    super.key,
    this.salida,
  });

  bool get isEditMode => salida != null;

  @override
  State<SalidaCreatePage> createState() => _SalidaCreatePageState();
}

class _SalidaCreatePageState extends State<SalidaCreatePage> {
  final _nombreLugarController = TextEditingController();
  final _nombreProyectoController = TextEditingController();
  final _observacionesController = TextEditingController();

  DateTime? fechaInicio;
  @override
  void initState() {
    super.initState();

    if (widget.salida != null) {
      _nombreLugarController.text = widget.salida!.nombreLugar ?? '';
      _nombreProyectoController.text = widget.salida!.nombreProyecto ?? '';
      _observacionesController.text = widget.salida!.observaciones ?? '';
      fechaInicio = widget.salida!.fechaInicio;
    }
  }

  @override
  void dispose() {
    _nombreLugarController.dispose();
    _nombreProyectoController.dispose();
    _observacionesController.dispose();
    super.dispose();
  }

  String _formatDateTime(DateTime? date) {
    if (date == null) return 'Seleccionar fecha y hora';
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year} - '
        '${date.hour.toString().padLeft(2, '0')}:'
        '${date.minute.toString().padLeft(2, '0')}';
  }

  Future<DateTime?> _pickDateTime() async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2035),
    );

    if (selectedDate == null) return null;
    if (!mounted) return null;

    final selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
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

  Future<void> _saveSalida() async {
    final provider = context.read<SalidaProvider>();

    final nombreLugar = _nombreLugarController.text.trim().isEmpty
        ? null
        : _nombreLugarController.text.trim();

    final nombreProyecto =
        _nombreProyectoController.text.trim().isEmpty
            ? null
            : _nombreProyectoController.text.trim();

    final observaciones = _observacionesController.text.trim().isEmpty
        ? null
        : _observacionesController.text.trim();

    bool success;

    if (widget.isEditMode) {
      success = await provider.updateSalida(
        salidaId: widget.salida!.salidaId,
        nombreLugar: nombreLugar,
        nombreProyecto: nombreProyecto,
        fechaInicio: fechaInicio,
        observaciones: observaciones,
        fechaFin: widget.salida!.fechaFin,
        estado: widget.salida!.estado,
      );
    } else {
      success = await provider.createSalida(
        nombreLugar: nombreLugar,
        nombreProyecto: nombreProyecto,
        fechaInicio: fechaInicio,
        observaciones: observaciones,
      );
    }

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.isEditMode
                ? 'Evento actualizado correctamente'
                : 'Evento creado correctamente',
          ),
          backgroundColor: Colors.green.shade600,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
        ),
      );
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(provider.errorMessage ?? 'Error'),
          backgroundColor: Colors.red.shade600,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
        ),
      );
    }
  }

  Widget _pickerCard({
    required String title,
    required String value,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        decoration: BoxDecoration(
          color: const Color(0xFFD9D9D9),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          '$title\n$value',
          style: const TextStyle(
            fontSize: 16,
            height: 1.5,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }

  InputDecoration _localInputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(
        color: Colors.black45,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      border: InputBorder.none,
      enabledBorder: InputBorder.none,
      focusedBorder: InputBorder.none,
      disabledBorder: InputBorder.none,
      filled: false,
      contentPadding: EdgeInsets.zero,
      isDense: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SalidaProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF0EED6),
      body: SafeArea(
        child: SingleChildScrollView(
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
                    Text(
                      widget.isEditMode ? 'Editar evento' : 'Crear evento',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFD9D9D9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  controller: _nombreProyectoController,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: _localInputDecoration(
                    'Nombre del proyecto',
                  ),
                ),
              ),

              const SizedBox(height: 14),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFD9D9D9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  controller: _nombreLugarController,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: _localInputDecoration(
                    'Nombre del lugar (ej. Río Coello)',
                  ),
                ),
              ),

              const SizedBox(height: 14),

              _pickerCard(
                title: 'Fecha inicio',
                value: _formatDateTime(fechaInicio),
                onTap: () async {
                  final value = await _pickDateTime();
                  if (value != null) {
                    setState(() {
                      fechaInicio = value;
                    });
                  }
                },
              ),

              const SizedBox(height: 14),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: const Color(0xFFD9D9D9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  controller: _observacionesController,
                  minLines: 5,
                  maxLines: 7,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: _localInputDecoration('Observaciones del evento'),
                ),
              ),

              const SizedBox(height: 24),

              CustomButton(
                text: 'Guardar evento',
                onPressed: provider.isLoading ? null : _saveSalida,
                backgroundColor: AppColors.darkOlive,
                width: 240,
                isLoading: provider.isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}