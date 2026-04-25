import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../app/theme/app_colors.dart';
import 'package:frontend/app/shared/widgets/custom_button.dart';
import '../providers/medicion_provider.dart';
import '../../../evidencias/presentation/pages/evidencia_create_page.dart';
import '../../data/models/medicion_model.dart';

class MedicionCreatePage extends StatefulWidget {
  final String ocurrenciaId;
  final MedicionModel? medicion;

  const MedicionCreatePage({
    super.key,
    required this.ocurrenciaId,
    this.medicion,
  });

  bool get isEditMode => medicion != null;

  @override
  State<MedicionCreatePage> createState() => _MedicionCreatePageState();
}

class _MedicionCreatePageState extends State<MedicionCreatePage> {
  final _oxigenoController = TextEditingController();
  final _phController = TextEditingController();
  final _turbidezController = TextEditingController();
  final _conductividadController = TextEditingController();
  final _tdsController = TextEditingController();
  final _temperaturaController = TextEditingController();
  final _transparenciaController = TextEditingController();
  final _orpController = TextEditingController();
  final _alcalinidadController = TextEditingController();
  final _durezaController = TextEditingController();
  final _salinidadController = TextEditingController();
  final _amonioController = TextEditingController();
  final _fosforoMetalesController = TextEditingController();
  final _nitratosController = TextEditingController();
  final _nitritosController = TextEditingController();
  final _fosfatosController = TextEditingController();
  final _clorofilaController = TextEditingController();
  final _sstController = TextEditingController();
  final _coliformesController = TextEditingController();
  final _observacionesController = TextEditingController();

  String? nivelEstadoAgua;

  final List<String> nivelEstadoAguaOptions = [
    'Bajo',
    'Medio',
    'Alto',
    'Creciente',
    'Estable',
  ];
  @override
  void initState() {
    super.initState();

    if (widget.medicion != null) {
      final m = widget.medicion!;
      _oxigenoController.text = m.oxigenoDisueltoMgL?.toString() ?? '';
      _phController.text = m.ph?.toString() ?? '';
      _turbidezController.text = m.turbidezNtu?.toString() ?? '';
      _conductividadController.text = m.conductividadUsCm?.toString() ?? '';
      _tdsController.text = m.tdsMgL?.toString() ?? '';
      _temperaturaController.text = m.temperaturaC?.toString() ?? '';
      _transparenciaController.text = m.transparenciaSecchiCm?.toString() ?? '';
      _orpController.text = m.orpMv?.toString() ?? '';
      _alcalinidadController.text = m.alcalinidadMgL?.toString() ?? '';
      _durezaController.text = m.durezaMgL?.toString() ?? '';
      _salinidadController.text = m.salinidad?.toString() ?? '';
      _amonioController.text = m.amonioMgL?.toString() ?? '';
      _fosforoMetalesController.text = m.fosforoMetalesMgL?.toString() ?? '';
      _nitratosController.text = m.nitratosMgL?.toString() ?? '';
      _nitritosController.text = m.nitritosMgL?.toString() ?? '';
      _fosfatosController.text = m.fosfatosMgL?.toString() ?? '';
      _clorofilaController.text = m.clorofilaAUgL?.toString() ?? '';
      _sstController.text = m.sstMgL?.toString() ?? '';
      _coliformesController.text = m.coliformesFecalesUfc?.toString() ?? '';
      _observacionesController.text = m.observaciones ?? '';
      nivelEstadoAgua = m.nivelEstadoAgua;
    }
  }
  @override
  void dispose() {
    _oxigenoController.dispose();
    _phController.dispose();
    _turbidezController.dispose();
    _conductividadController.dispose();
    _tdsController.dispose();
    _temperaturaController.dispose();
    _transparenciaController.dispose();
    _orpController.dispose();
    _alcalinidadController.dispose();
    _durezaController.dispose();
    _salinidadController.dispose();
    _amonioController.dispose();
    _fosforoMetalesController.dispose();
    _nitratosController.dispose();
    _nitritosController.dispose();
    _fosfatosController.dispose();
    _clorofilaController.dispose();
    _sstController.dispose();
    _coliformesController.dispose();
    _observacionesController.dispose();
    super.dispose();
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.black45, fontSize: 16),
      border: InputBorder.none,
      enabledBorder: InputBorder.none,
      focusedBorder: InputBorder.none,
      contentPadding: EdgeInsets.zero,
      isDense: true,
    );
  }

  Widget _grayInput({
    required TextEditingController controller,
    required String hint,
    TextInputType keyboardType = TextInputType.number,
    int minLines = 1,
    int maxLines = 1,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFD9D9D9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        minLines: minLines,
        maxLines: maxLines,

        style: const TextStyle(
          color: Colors.black54,
          fontSize: 16,
          fontWeight: FontWeight.normal,
        ),

        cursorColor: Colors.black54,

        // 👇 ESTA LÍNEA ES LA MÁS IMPORTANTE
        enableInteractiveSelection: false,

        decoration: _inputDecoration(hint),
      ),
    );
  }

  Widget _dropdownField({
    required String label,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFD9D9D9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonFormField<String>(
        value: value,
        style: const TextStyle(color: Colors.black87, fontSize: 16),
        dropdownColor: Colors.white,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
          ),
          border: InputBorder.none,
        ),
        iconEnabledColor: Colors.black87,
        items: items
            .map((item) => DropdownMenuItem(value: item, child: Text(item)))
            .toList(),
        onChanged: onChanged,
      ),
    );
  }

  Future<void> _saveMedicion() async {
    final provider = context.read<MedicionProvider>();

    bool success;

    if (widget.isEditMode) {
      success = await provider.updateMedicion(
        ocurrenciaId: widget.ocurrenciaId,
        oxigenoDisueltoMgL: double.tryParse(_oxigenoController.text.trim()),
        ph: double.tryParse(_phController.text.trim()),
        turbidezNtu: double.tryParse(_turbidezController.text.trim()),
        conductividadUsCm: double.tryParse(_conductividadController.text.trim()),
        tdsMgL: double.tryParse(_tdsController.text.trim()),
        temperaturaC: double.tryParse(_temperaturaController.text.trim()),
        transparenciaSecchiCm: double.tryParse(_transparenciaController.text.trim()),
        nivelEstadoAgua: nivelEstadoAgua,
        orpMv: double.tryParse(_orpController.text.trim()),
        alcalinidadMgL: double.tryParse(_alcalinidadController.text.trim()),
        durezaMgL: double.tryParse(_durezaController.text.trim()),
        salinidad: double.tryParse(_salinidadController.text.trim()),
        amonioMgL: double.tryParse(_amonioController.text.trim()),
        fosforoMetalesMgL: double.tryParse(_fosforoMetalesController.text.trim()),
        nitratosMgL: double.tryParse(_nitratosController.text.trim()),
        nitritosMgL: double.tryParse(_nitritosController.text.trim()),
        fosfatosMgL: double.tryParse(_fosfatosController.text.trim()),
        clorofilaAUgL: double.tryParse(_clorofilaController.text.trim()),
        sstMgL: double.tryParse(_sstController.text.trim()),
        coliformesFecalesUfc: int.tryParse(_coliformesController.text.trim()),
        observaciones: _observacionesController.text.trim().isEmpty
            ? null
            : _observacionesController.text.trim(),
      );
    } else {
      success = await provider.createMedicion(
        ocurrenciaId: widget.ocurrenciaId,
        oxigenoDisueltoMgL: double.tryParse(_oxigenoController.text.trim()),
        ph: double.tryParse(_phController.text.trim()),
        turbidezNtu: double.tryParse(_turbidezController.text.trim()),
        conductividadUsCm: double.tryParse(_conductividadController.text.trim()),
        tdsMgL: double.tryParse(_tdsController.text.trim()),
        temperaturaC: double.tryParse(_temperaturaController.text.trim()),
        transparenciaSecchiCm: double.tryParse(_transparenciaController.text.trim()),
        nivelEstadoAgua: nivelEstadoAgua,
        orpMv: double.tryParse(_orpController.text.trim()),
        alcalinidadMgL: double.tryParse(_alcalinidadController.text.trim()),
        durezaMgL: double.tryParse(_durezaController.text.trim()),
        salinidad: double.tryParse(_salinidadController.text.trim()),
        amonioMgL: double.tryParse(_amonioController.text.trim()),
        fosforoMetalesMgL: double.tryParse(_fosforoMetalesController.text.trim()),
        nitratosMgL: double.tryParse(_nitratosController.text.trim()),
        nitritosMgL: double.tryParse(_nitritosController.text.trim()),
        fosfatosMgL: double.tryParse(_fosfatosController.text.trim()),
        clorofilaAUgL: double.tryParse(_clorofilaController.text.trim()),
        sstMgL: double.tryParse(_sstController.text.trim()),
        coliformesFecalesUfc: int.tryParse(_coliformesController.text.trim()),
        observaciones: _observacionesController.text.trim().isEmpty
            ? null
            : _observacionesController.text.trim(),
      );
    }

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.isEditMode
                ? 'Medición actualizada correctamente'
                : 'Medición creada correctamente',
          ),
          backgroundColor: Colors.green.shade600,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
        ),
      );

      if (widget.isEditMode) {
        Navigator.pop(context, true);
        return;
      }

      final evidenciaCompleted = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => EvidenciaCreatePage(
            ocurrenciaId: widget.ocurrenciaId,
          ),
        ),
      );

      if (!mounted) return;
      Navigator.pop(context, evidenciaCompleted == true ? true : true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(provider.errorMessage ?? 'Error al guardar medición'),
          backgroundColor: Colors.red.shade600,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) 
  {
    final provider = context.watch<MedicionProvider>();

    return Theme(
      data: Theme.of(context).copyWith(
        textSelectionTheme: const TextSelectionThemeData(
          selectionColor: Colors.transparent, // 👈 elimina azul
          selectionHandleColor: Colors.transparent,
          cursorColor: Colors.black54,
        ),
      ),

    child: Scaffold(
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
                      onPressed: () => Navigator.pop(context,true),
                      icon: const Icon(Icons.arrow_back),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        widget.isEditMode ? 'Editar medición' : 'Registrar medición',
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
              _grayInput(controller: _oxigenoController, hint: 'Oxígeno disuelto (mg/L)'),
              const SizedBox(height: 12),
              _grayInput(controller: _phController, hint: 'pH'),
              const SizedBox(height: 12),
              _grayInput(controller: _turbidezController, hint: 'Turbidez (NTU)'),
              const SizedBox(height: 12),
              _grayInput(controller: _conductividadController, hint: 'Conductividad (uS/cm)'),
              const SizedBox(height: 12),
              _grayInput(controller: _tdsController, hint: 'TDS (mg/L)'),
              const SizedBox(height: 12),
              _grayInput(controller: _temperaturaController, hint: 'Temperatura (°C)'),
              const SizedBox(height: 12),
              _grayInput(controller: _transparenciaController, hint: 'Transparencia Secchi (cm)'),
              const SizedBox(height: 12),
              _dropdownField(
                label: 'Nivel / estado del agua',
                value: nivelEstadoAgua,
                items: nivelEstadoAguaOptions,
                onChanged: (value) => setState(() => nivelEstadoAgua = value),
              ),
              const SizedBox(height: 12),
              _grayInput(controller: _orpController, hint: 'ORP (mV)'),
              const SizedBox(height: 12),
              _grayInput(controller: _alcalinidadController, hint: 'Alcalinidad (mg/L)'),
              const SizedBox(height: 12),
              _grayInput(controller: _durezaController, hint: 'Dureza (mg/L)'),
              const SizedBox(height: 12),
              _grayInput(controller: _salinidadController, hint: 'Salinidad'),
              const SizedBox(height: 12),
              _grayInput(controller: _amonioController, hint: 'Amonio (mg/L)'),
              const SizedBox(height: 12),
              _grayInput(controller: _fosforoMetalesController, hint: 'Fósforo/metales (mg/L)'),
              const SizedBox(height: 12),
              _grayInput(controller: _nitratosController, hint: 'Nitratos (mg/L)'),
              const SizedBox(height: 12),
              _grayInput(controller: _nitritosController, hint: 'Nitritos (mg/L)'),
              const SizedBox(height: 12),
              _grayInput(controller: _fosfatosController, hint: 'Fosfatos (mg/L)'),
              const SizedBox(height: 12),
              _grayInput(controller: _clorofilaController, hint: 'Clorofila A (ug/L)'),
              const SizedBox(height: 12),
              _grayInput(controller: _sstController, hint: 'SST (mg/L)'),
              const SizedBox(height: 12),
              _grayInput(
                controller: _coliformesController,
                hint: 'Coliformes fecales (UFC)',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              _grayInput(
                controller: _observacionesController,
                hint: 'Observaciones',
                keyboardType: TextInputType.text,
                minLines: 4,
                maxLines: 6,
              ),
              const SizedBox(height: 24),
              CustomButton(
                text: 'Guardar medición',
                onPressed: provider.isSaving ? null : _saveMedicion,
                backgroundColor: AppColors.darkOlive,
                width: 240,
                isLoading: provider.isSaving,
              ),
            ],
          ),
        ),
      ),
    ),
    );
  }
}