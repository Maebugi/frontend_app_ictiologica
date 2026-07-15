import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';

import '../../../../app/theme/app_colors.dart';
import 'package:frontend/app/shared/widgets/custom_button.dart';
import '../../data/models/especie_model.dart';
import '../providers/ocurrencia_provider.dart';
import '../widgets/species_selector_field.dart';
import '../../../mediciones/presentation/pages/medicion_create_page.dart';
import '../../data/models/ocurrencia_detail_model.dart';

class OcurrenciaCreatePage extends StatefulWidget {
  final String salidaId;
  final OcurrenciaDetailModel? ocurrencia;

  const OcurrenciaCreatePage({
    super.key,
    required this.salidaId,
    this.ocurrencia,
  });

  bool get isEditMode => ocurrencia != null;

  @override
  State<OcurrenciaCreatePage> createState() => _OcurrenciaCreatePageState();
}

class _OcurrenciaCreatePageState extends State<OcurrenciaCreatePage> {
  final _coordenadasController = TextEditingController();
  final _latitudController = TextEditingController();
  final _longitudController = TextEditingController();
  final _altitudController = TextEditingController();
  final _esfuerzoController = TextEditingController();
  final _cpueController = TextEditingController();
  final _longitudPezController = TextEditingController();
  final _pesoController = TextEditingController();
  final _estadoOntogeneticoController = TextEditingController();
  final _nivelCertezaController = TextEditingController();
  final _comportamientoController = TextEditingController();
  final _anomaliasController = TextEditingController();
  final _anchoCauceController = TextEditingController();
  final _profundidadMediaController = TextEditingController();
  final _profundidadMaximaController = TextEditingController();
  final _caudalVelocidadController = TextEditingController();
  final _coberturaDoselController = TextEditingController();
  final _codigoMuestreoController = TextEditingController();
  final _observacionesController = TextEditingController();
  final _vouchersController = TextEditingController();

  DateTime? fechaHora;
  EspecieModel? selectedSpecies;

  String? sexo;
  String? estadioVida;
  String? condicionReproductiva;
  String? metodoCaptura;
  String? datum;
  String? tipoHabitat;
  String? dinamicaAgua;
  String? microhabitat;
  String? usoSueloRibereno;
  String? estabilidadOrillas;
  String? sustrato;
  String? clima;
  String? artePesca;

  String? mortalidad;
  

  final List<String> sexos = ['Macho', 'Hembra', 'Indeterminado'];
  final List<String> estadiosVida = ['Larva', 'Alevino', 'Juvenil', 'Adulto'];
  final List<String> estadosReproductivos = ['Activo', 'Inactivo', 'Indeterminado'];
  final List<String> metodosCaptura = [
    'Red de arrastre',
    'Atarraya',
    'Anzuelo',
    'Trampa',
    'Observación directa',
  ];
  final List<String> datumOptions = ['WGS84', 'MAGNA-SIRGAS'];
  final List<String> tipoHabitatOptions = [
                                            'Río',
                                            'Quebrada',
                                            'Caño',
                                            'Laguna',
                                            'Ciénaga',
                                            'Embalse',
                                            'Humedal',
                                            'Estuario',
                                            'Morichal',
                                            'Jagüey',
                                            'Pozo',
                                            'Aljibe',
                                          ];
  final List<String> dinamicaAguaOptions = [
    'Lótico',
    'Léntico',
    'Transicional'
  ];
  final List<String> microhabitatOptions = [
                                             'Canal principal',
                                             'Margen izquierda',
                                             'Margen derecha',
                                             'Poza',
                                             'Remanso',
                                             'Corredera',
                                             'Rápidos',
                                             'Riffle',
                                             'Run',
                                             'Zona inundada',
                                             'Vegetación sumergida',
                                             'Vegetación marginal',
                                             'Acumulación de hojarasca',
                                             'Troncos o material leñoso'
                                           ];
  final List<String> usoSueloOptions = ['Bosque', 'Agrícola', 'Ganadero', 'Urbano'];
  final List<String> estabilidadOrillasOptions = ['Alta', 'Media', 'Baja'];
  final List<String> sustratoOptions = ['Arena', 'Lodo', 'Roca', 'Grava', 'Mixto'];
  final List<String> climaOptions = ['Soleado', 'Lluvioso', 'Nublado'];
  final List<String> artePescaOptions = ['Red', 'Anzuelo', 'Atarraya', 'Trampa'];
  final List<String> mortalidadOptions = ['Liberado vivo','Retenido','Muerto'];
  @override
  void initState() {
    super.initState();

    if (widget.ocurrencia != null) {
      final o = widget.ocurrencia!;
      selectedSpecies = EspecieModel(
        especieId: o.idEspecie,
        nombreComun: o.nombreComun,
        nombreCientifico: o.nombreCientifico,
        familia: o.familia,
        orden: null,
        estadoConservacion: null,
      );
      fechaHora = o.fechaHora;
      _coordenadasController.text = o.coordenadas ?? '';
      _latitudController.text =o.latitud?.toString() ?? '';
      _longitudController.text = o.longitud?.toString() ?? '';
      _altitudController.text = o.altitud?.toString() ?? '';
      _esfuerzoController.text = o.esfuerzo?.toString() ?? '';
      _cpueController.text = o.cpue?.toString() ?? '';
      _longitudPezController.text = o.longitudPez?.toString() ?? '';
      _pesoController.text = o.peso?.toString() ?? '';
      _estadoOntogeneticoController.text = o.estadoOntogenetico ?? '';
      _nivelCertezaController.text = o.nivelCerteza?.toString() ?? '';
      _comportamientoController.text = o.comportamiento ?? '';
      _anomaliasController.text = o.anomalias ?? '';
      _vouchersController.text = o.vouchers ?? '';
      _anchoCauceController.text = o.anchoCauce?.toString() ?? '';
      _profundidadMediaController.text = o.profundidadMedia?.toString() ?? '';
      _profundidadMaximaController.text = o.profundidadMaxima?.toString() ?? '';
      _caudalVelocidadController.text = o.caudalVelocidad?.toString() ?? '';
      _coberturaDoselController.text = o.coberturaDosel?.toString() ?? '';
      _codigoMuestreoController.text = o.codigoMuestreo ?? '';
      _observacionesController.text = o.observaciones ?? '';

      sexo = o.sexo;
      estadioVida = o.estadioVida;
      condicionReproductiva = o.condicionReproductiva;
      metodoCaptura = o.metodoCaptura;
      datum = o.datum;
      tipoHabitat = o.tipoHabitat;
      dinamicaAgua = o.dinamicaAgua;
      microhabitat = o.microhabitat;
      usoSueloRibereno = o.usoSueloRibereno;
      estabilidadOrillas = o.estabilidadOrillas;
      sustrato = o.sustrato;
      clima = o.clima;
      artePesca = o.artePesca;
      mortalidad = o.mortalidad;
    } else {
      _loadCurrentLocation();
    }
  }
  @override
  void dispose() {
    _coordenadasController.dispose();
    _latitudController.dispose();
    _longitudController.dispose();
    _altitudController.dispose();
    _esfuerzoController.dispose();
    _cpueController.dispose();
    _longitudPezController.dispose();
    _pesoController.dispose();
    _estadoOntogeneticoController.dispose();
    _nivelCertezaController.dispose();
    _comportamientoController.dispose();
    _anomaliasController.dispose();
    _anchoCauceController.dispose();
    _profundidadMediaController.dispose();
    _profundidadMaximaController.dispose();
    _caudalVelocidadController.dispose();
    _coberturaDoselController.dispose();
    _codigoMuestreoController.dispose();
    _observacionesController.dispose();
    _vouchersController.dispose();
    super.dispose();
  }

  Future<void> _loadCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return;

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return;
      }

      final position = await Geolocator.getCurrentPosition();

      _coordenadasController.text =
          '${position.latitude.toStringAsFixed(6)}, ${position.longitude.toStringAsFixed(6)}';
      _latitudController.text =
          position.latitude.toStringAsFixed(6);

      _longitudController.text =
          position.longitude.toStringAsFixed(6);
      if (position.altitude != 0) {
        _altitudController.text =
              position.altitude.toStringAsFixed(2);
      }

      if (mounted) {
        setState(() {});
      }
    } catch (_) {}
  }

 bool _validarFormulario() {

   // Especie
   if (selectedSpecies == null) {
     _mostrarError("Debe seleccionar una especie.");
     return false;
   }

   // Fecha
   if (fechaHora == null) {
     _mostrarError("Debe seleccionar la fecha y la hora.");
     return false;
   }

   // Latitud
   if (_latitudController.text.trim().isEmpty) {
     _mostrarError("La latitud es obligatoria.");
     return false;
   }

   final latitud = double.tryParse(_latitudController.text.trim());

   if (latitud == null) {
     _mostrarError("La latitud debe ser un número.");
     return false;
   }

   if (latitud < -90 || latitud > 90) {
     _mostrarError("La latitud debe estar entre -90 y 90.");
     return false;
   }

   // Longitud
   if (_longitudController.text.trim().isEmpty) {
     _mostrarError("La longitud es obligatoria.");
     return false;
   }

   final longitud = double.tryParse(_longitudController.text.trim());

   if (longitud == null) {
     _mostrarError("La longitud debe ser un número.");
     return false;
   }

   if (longitud < -180 || longitud > 180) {
     _mostrarError("La longitud debe estar entre -180 y 180.");
     return false;
   }

   // Tipo de hábitat
   if (tipoHabitat == null) {
     _mostrarError("Seleccione el tipo de hábitat.");
     return false;
   }

   // Dinámica del agua
   if (dinamicaAgua == null) {
     _mostrarError("Seleccione la dinámica del agua.");
     return false;
   }

   // Método de captura
   if (metodoCaptura == null) {
     _mostrarError("Seleccione el método de captura.");
     return false;
   }

   // Mortalidad
   if (mortalidad == null) {
     _mostrarError("Seleccione el estado del individuo.");
     return false;
   }

   // Nivel de certeza
   if (_nivelCertezaController.text.trim().isNotEmpty) {
     final certeza = int.tryParse(_nivelCertezaController.text.trim());

     if (certeza == null) {
       _mostrarError("El nivel de certeza debe ser un número.");
       return false;
     }

     if (certeza < 0 || certeza > 100) {
       _mostrarError("El nivel de certeza debe estar entre 0 y 100.");
       return false;
     }
   }

   // Campos numéricos que no aceptan negativos
   final controles = [
     _altitudController,
     _esfuerzoController,
     _cpueController,
     _longitudPezController,
     _pesoController,
     _anchoCauceController,
     _profundidadMediaController,
     _profundidadMaximaController,
     _caudalVelocidadController,
     _coberturaDoselController,
   ];

   for (final controller in controles) {

     if (controller.text.trim().isEmpty) continue;

     final valor = double.tryParse(controller.text.trim());

     if (valor == null) {
       _mostrarError("Uno de los campos numéricos contiene un valor inválido.");
       return false;
     }

     if (valor < 0) {
       _mostrarError("No se permiten valores negativos.");
       return false;
     }
   }

   // Profundidad máxima >= profundidad media
   if (_profundidadMediaController.text.isNotEmpty &&
       _profundidadMaximaController.text.isNotEmpty) {

     final media = double.parse(_profundidadMediaController.text);
     final maxima = double.parse(_profundidadMaximaController.text);

     if (maxima < media) {
       _mostrarError(
         "La profundidad máxima no puede ser menor que la profundidad media.",
       );
       return false;
     }
   }

   return true;
 }

  void _mostrarError(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
      ),
    );
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


  String _formatDateTime(DateTime? date) {
    if (date == null) return 'Seleccionar fecha y hora';
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year} - '
        '${date.hour.toString().padLeft(2, '0')}:'
        '${date.minute.toString().padLeft(2, '0')}';
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(
        color: Colors.black45,
        fontSize: 16,
      ),
      border: InputBorder.none,
      enabledBorder: InputBorder.none,
      focusedBorder: InputBorder.none,
      filled: false,
      contentPadding: EdgeInsets.zero,
      isDense: true,
    );
  }

  Widget _grayInput({
    required TextEditingController controller,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
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
          color: Colors.black87,
          fontSize: 16,
        ),
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
        isExpanded: true,
        dropdownColor: Colors.white,

        // 👇 CLAVE
        focusColor: Colors.transparent,

        style: const TextStyle(
          color: Colors.black54,
          fontSize: 16,
        ),

        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(
            color: Colors.black54,
            fontWeight: FontWeight.w600,
          ),

          // 👇 ESTO ELIMINA EL AZUL
          filled: true,
          fillColor: Colors.transparent,

          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
        ),

        iconEnabledColor: Colors.black87,

        items: items.map((item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(
              item,
              style: const TextStyle(color: Colors.black87),
            ),
          );
        }).toList(),

        onChanged: onChanged,
      ),
    );
  }

  Future<void> _selectSpecies() async {
    final provider = context.read<OcurrenciaProvider>();
    await provider.loadSpecies();

    if (!mounted) return;

    final result = await showSearch<EspecieModel?>(
      context: context,
      delegate: _SpeciesSearchDelegate(provider.species, provider.searchSpecies),
    );

    if (result != null) {
      setState(() {
        selectedSpecies = result;
      });
    }
  }

  Future<void> _saveOcurrencia() async {
    if (!_validarFormulario()) return;

    final provider = context.read<OcurrenciaProvider>();

    if (widget.isEditMode) {
      final success = await provider.updateOcurrencia(
        ocurrenciaId: widget.ocurrencia!.idOcurrencia,
        idEspecie: selectedSpecies?.especieId ?? widget.ocurrencia!.idEspecie,
        fechaHora: fechaHora,
        coordenadas: _coordenadasController.text.trim().isEmpty
            ? null
            : _coordenadasController.text.trim(),
        latitud: double.tryParse(
          _latitudController.text.trim(),
        ),

        longitud: double.tryParse(
          _longitudController.text.trim(),
        ),
        altitud: double.tryParse(_altitudController.text.trim()),
        esfuerzo: double.tryParse(_esfuerzoController.text.trim()),
        cpue: double.tryParse(_cpueController.text.trim()),
        longitudPez: double.tryParse(_longitudPezController.text.trim()),
        peso: double.tryParse(_pesoController.text.trim()),
        sexo: sexo,
        estadoOntogenetico: _estadoOntogeneticoController.text.trim().isEmpty
            ? null
            : _estadoOntogeneticoController.text.trim(),
        estadioVida: estadioVida,
        condicionReproductiva: condicionReproductiva,
        comportamiento: _comportamientoController.text.trim().isEmpty
            ? null
            : _comportamientoController.text.trim(),
        anomalias: _anomaliasController.text.trim().isEmpty
            ? null
            : _anomaliasController.text.trim(),
        mortalidad: mortalidad,
        vouchers: _vouchersController.text.trim().isEmpty
            ? null
            : _vouchersController.text.trim(),
        nivelCerteza: int.tryParse(_nivelCertezaController.text.trim()),
        anchoCauce: double.tryParse(_anchoCauceController.text.trim()),
        profundidadMedia: double.tryParse(_profundidadMediaController.text.trim()),
        profundidadMaxima: double.tryParse(_profundidadMaximaController.text.trim()),
        caudalVelocidad: double.tryParse(_caudalVelocidadController.text.trim()),
        tipoHabitat: tipoHabitat,
        dinamicaAgua: dinamicaAgua,
        microhabitat: microhabitat,
        coberturaDosel: double.tryParse(_coberturaDoselController.text.trim()),
        usoSueloRibereno: usoSueloRibereno,
        estabilidadOrillas: estabilidadOrillas,
        sustrato: sustrato,
        clima: clima,
        metodoCaptura: metodoCaptura,
        artePesca: artePesca,
        codigoMuestreo: _codigoMuestreoController.text.trim().isEmpty
            ? null
            : _codigoMuestreoController.text.trim(),
        datum: datum,
        observaciones: _observacionesController.text.trim().isEmpty
            ? null
            : _observacionesController.text.trim(),
      );

      if (!mounted) return;

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Ocurrencia actualizada correctamente'),
            backgroundColor: Colors.green.shade600,
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(16),
          ),
        );
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(provider.errorMessage ?? 'Error al actualizar ocurrencia'),
            backgroundColor: Colors.red.shade600,
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(16),
          ),
        );
      }

      return;
    }

    final createdOcurrenciaId = await provider.createOcurrencia(
      salidaId: widget.salidaId,
      idEspecie: selectedSpecies!.especieId,
      latitud: double.tryParse(
        _latitudController.text.trim(),
      ),

      longitud: double.tryParse(
        _longitudController.text.trim(),
      ),
      fechaHora: fechaHora,
      coordenadas: _coordenadasController.text.trim().isEmpty
          ? null
          : _coordenadasController.text.trim(),
      altitud: double.tryParse(_altitudController.text.trim()),
      esfuerzo: double.tryParse(_esfuerzoController.text.trim()),
      cpue: double.tryParse(_cpueController.text.trim()),
      longitudPez: double.tryParse(_longitudPezController.text.trim()),
      peso: double.tryParse(_pesoController.text.trim()),
      sexo: sexo,
      estadoOntogenetico: _estadoOntogeneticoController.text.trim().isEmpty
          ? null
          : _estadoOntogeneticoController.text.trim(),
      estadioVida: estadioVida,
      condicionReproductiva: condicionReproductiva,
      comportamiento: _comportamientoController.text.trim().isEmpty
          ? null
          : _comportamientoController.text.trim(),
      anomalias: _anomaliasController.text.trim().isEmpty
          ? null
          : _anomaliasController.text.trim(),
      mortalidad: mortalidad,
      vouchers: _vouchersController.text.trim().isEmpty
          ? null
          : _vouchersController.text.trim(),
      nivelCerteza: int.tryParse(_nivelCertezaController.text.trim()),
      anchoCauce: double.tryParse(_anchoCauceController.text.trim()),
      profundidadMedia: double.tryParse(_profundidadMediaController.text.trim()),
      profundidadMaxima: double.tryParse(_profundidadMaximaController.text.trim()),
      caudalVelocidad: double.tryParse(_caudalVelocidadController.text.trim()),
      tipoHabitat: tipoHabitat,
      dinamicaAgua : dinamicaAgua,
      microhabitat: microhabitat,
      coberturaDosel: double.tryParse(_coberturaDoselController.text.trim()),
      usoSueloRibereno: usoSueloRibereno,
      estabilidadOrillas: estabilidadOrillas,
      sustrato: sustrato,
      clima: clima,
      metodoCaptura: metodoCaptura,
      artePesca: artePesca,
      codigoMuestreo: _codigoMuestreoController.text.trim().isEmpty
          ? null
          : _codigoMuestreoController.text.trim(),
      datum: datum,
      observaciones: _observacionesController.text.trim().isEmpty
          ? null
          : _observacionesController.text.trim(),
      nombreComun: selectedSpecies?.nombreComun,
      nombreCientifico: selectedSpecies?.nombreCientifico,
      familia: selectedSpecies?.familia
    );

    if (!mounted) return;

    if (createdOcurrenciaId != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Ocurrencia creada correctamente'),
          backgroundColor: Colors.green.shade600,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
        ),
      );
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(provider.errorMessage ?? 'Error al crear ocurrencia'),
          backgroundColor: Colors.red.shade600,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<OcurrenciaProvider>();

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
                    Expanded(
                      child: Text(
                        widget.isEditMode ? 'Editar ocurrencia' : 'Registrar ocurrencia',
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

              SpeciesSelectorField(
                selectedSpecies: selectedSpecies,
                onTap: _selectSpecies,
              ),

              const SizedBox(height: 14),

              GestureDetector(
                onTap: () async {
                  final value = await _pickDateTime();
                  if (value != null) {
                    setState(() {
                      fechaHora = value;
                    });
                  }
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFD9D9D9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Fecha/Hora\n${_formatDateTime(fechaHora)}',
                    style: const TextStyle(fontSize: 16, height: 1.5),
                  ),
                ),
              ),

              const SizedBox(height: 12),
              _grayInput(controller: _coordenadasController, hint: 'Coordenadas'),
              const SizedBox(height: 12),

              _grayInput(
                controller: _latitudController,
                hint: 'Latitud',
                keyboardType: TextInputType.number,
              ),

              const SizedBox(height: 12),

              _grayInput(
                controller: _longitudController,
                hint: 'Longitud',
                keyboardType: TextInputType.number,
              ),

              const SizedBox(height: 12),
              _grayInput(
                controller: _altitudController,
                hint: 'Altitud',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              _grayInput(
                controller: _esfuerzoController,
                hint: 'Esfuerzo',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              _grayInput(
                controller: _cpueController,
                hint: 'CPUE',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              _grayInput(
                controller: _longitudPezController,
                hint: 'Longitud del pez',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              _grayInput(
                controller: _pesoController,
                hint: 'Peso',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),

              _dropdownField(
                label: 'Sexo del individuo',
                value: sexo,
                items: sexos,
                onChanged: (value) => setState(() => sexo = value),
              ),
              const SizedBox(height: 12),

              _grayInput(
                controller: _estadoOntogeneticoController,
                hint: 'Estado ontogenético',
              ),
              const SizedBox(height: 12),

              _dropdownField(
                label: 'Estadio de vida',
                value: estadioVida,
                items: estadiosVida,
                onChanged: (value) => setState(() => estadioVida = value),
              ),
              const SizedBox(height: 12),

              _dropdownField(
                label: 'Estado reproductivo',
                value: condicionReproductiva,
                items: estadosReproductivos,
                onChanged: (value) => setState(() => condicionReproductiva = value),
              ),
              const SizedBox(height: 12),

              _dropdownField(
                label: 'Método de captura',
                value: metodoCaptura,
                items: metodosCaptura,
                onChanged: (value) => setState(() => metodoCaptura = value),
              ),
              const SizedBox(height: 12),

              _dropdownField(
                label: 'Datum',
                value: datum,
                items: datumOptions,
                onChanged: (value) => setState(() => datum = value),
              ),
              const SizedBox(height: 12),

              _grayInput(
                controller: _nivelCertezaController,
                hint: 'Nivel de certeza',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),

              _grayInput(
                controller: _comportamientoController,
                hint: 'Comportamiento',
              ),
              const SizedBox(height: 12),

              _grayInput(
                controller: _anomaliasController,
                hint: 'Anomalías',
                minLines: 2,
                maxLines: 3,
              ),
              const SizedBox(height: 12),

              _dropdownField(
                label: 'Estado del individuo(Mortalidad)',
                value: mortalidad,
                items: mortalidadOptions,
                onChanged: (value) => setState(() => mortalidad = value),
              ),
              const SizedBox(height: 12),

              _grayInput(
                controller: _vouchersController,
                hint: 'Código voucher / muestra física',
              ),
              const SizedBox(height: 12),

              _grayInput(
                controller: _anchoCauceController,
                hint: 'Ancho del cauce',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              _grayInput(
                controller: _profundidadMediaController,
                hint: 'Profundidad media',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              _grayInput(
                controller: _profundidadMaximaController,
                hint: 'Profundidad máxima',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              _grayInput(
                controller: _caudalVelocidadController,
                hint: 'Caudal / velocidad',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),

              _dropdownField(
                label: 'Tipo de hábitat',
                value: tipoHabitat,
                items: tipoHabitatOptions,
                onChanged: (value) => setState(() => tipoHabitat = value),
              ),
              const SizedBox(height: 12),
              _dropdownField(
                              label: 'Dinámica del agua',
                              value: dinamicaAgua,
                              items: dinamicaAguaOptions,
                              onChanged: (value) {
                                setState(() {
                                  dinamicaAgua = value;
                                });
                              },
                            ),
              const SizedBox(height: 12),

              _dropdownField(
                label: 'Microhábitat',
                value: microhabitat,
                items: microhabitatOptions,
                onChanged: (value) => setState(() => microhabitat = value),
              ),
              const SizedBox(height: 12),

              _grayInput(
                controller: _coberturaDoselController,
                hint: 'Cobertura dosel',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),

              _dropdownField(
                label: 'Uso de suelo ribereño',
                value: usoSueloRibereno,
                items: usoSueloOptions,
                onChanged: (value) => setState(() => usoSueloRibereno = value),
              ),
              const SizedBox(height: 12),

              _dropdownField(
                label: 'Estabilidad de orillas',
                value: estabilidadOrillas,
                items: estabilidadOrillasOptions,
                onChanged: (value) => setState(() => estabilidadOrillas = value),
              ),
              const SizedBox(height: 12),

              _dropdownField(
                label: 'Sustrato',
                value: sustrato,
                items: sustratoOptions,
                onChanged: (value) => setState(() => sustrato = value),
              ),
              const SizedBox(height: 12),

              _dropdownField(
                label: 'Clima',
                value: clima,
                items: climaOptions,
                onChanged: (value) => setState(() => clima = value),
              ),
              const SizedBox(height: 12),


              _dropdownField(
                label: 'Arte de pesca',
                value: artePesca,
                items: artePescaOptions,
                onChanged: (value) => setState(() => artePesca = value),
              ),
              const SizedBox(height: 12),

              _grayInput(
                controller: _codigoMuestreoController,
                hint: 'Código del muestreo',
              ),
              const SizedBox(height: 12),

              _grayInput(
                controller: _observacionesController,
                hint: 'Observaciones',
                minLines: 4,
                maxLines: 6,
              ),

              const SizedBox(height: 24),

              CustomButton(
                text: 'Guardar ocurrencia',
                onPressed: provider.isSaving ? null : _saveOcurrencia,
                backgroundColor: AppColors.darkOlive,
                width: 240,
                isLoading: provider.isSaving,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SpeciesSearchDelegate extends SearchDelegate<EspecieModel?> {
  final List<EspecieModel> initialSpecies;
  final Future<List<EspecieModel>> Function(String) searchFunction;

  _SpeciesSearchDelegate(this.initialSpecies, this.searchFunction);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () => query = '',
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () => close(context, null),
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder<List<EspecieModel>>(
      future: query.trim().isEmpty ? Future.value(initialSpecies) : searchFunction(query),
      builder: (context, snapshot) {
        final results = snapshot.data ?? [];

        return ListView.builder(
          itemCount: results.length,
          itemBuilder: (context, index) {
            final especie = results[index];

            return ListTile(
              title: Text(especie.nombreCientifico ?? 'Sin nombre científico',),
              subtitle: Text(
                '${especie.nombreComun ?? 'Sin nombre comun'}\n'
                'Familia: ${especie.familia ?? 'No disponible'}',
              ),
              isThreeLine: true,
              onTap: () => close(context, especie),
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final filtered = query.trim().isEmpty
        ? initialSpecies
        : initialSpecies.where((item) {
            final q = query.toLowerCase();
            return (item.nombreComun ?? '').toLowerCase().contains(q) ||
                (item.nombreCientifico ?? '').toLowerCase().contains(q);
          }).toList();

    return ListView.builder(
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        final especie = filtered[index];

        return ListTile(
          title: Text(especie.displayName),
          subtitle: Text(
            '${especie.nombreComun ?? 'Sin nombre comun'}\n'
            'Familia: ${especie.familia ?? 'No disponible'}',
          ),
          isThreeLine: true,
          onTap: () => close(context, especie),
        );
      },
    );
  }
}