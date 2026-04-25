import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../../../app/theme/app_colors.dart';
import 'package:frontend/app/shared/widgets/custom_button.dart';
import '../providers/evidencia_provider.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';



class EvidenciaCreatePage extends StatefulWidget {
  final String ocurrenciaId;

  const EvidenciaCreatePage({
    super.key,
    required this.ocurrenciaId,
  });

  @override
  State<EvidenciaCreatePage> createState() => _EvidenciaCreatePageState();
}

class _EvidenciaCreatePageState extends State<EvidenciaCreatePage> {
  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;
  final TextEditingController _observacionesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<EvidenciaProvider>().loadEvidencias(widget.ocurrenciaId);
    });
  }

  @override
  void dispose() {
    _observacionesController.dispose();
    super.dispose();
  }

    Future<File> _copyImageToAppStorage(File originalFile) async {
    final appDir = await getApplicationDocumentsDirectory();
    final evidenciasDir = Directory('${appDir.path}/evidencias');

    if (!await evidenciasDir.exists()) {
      await evidenciasDir.create(recursive: true);
    }

    final fileName =
        'evidencia_${DateTime.now().millisecondsSinceEpoch}${p.extension(originalFile.path)}';

    final newPath = '${evidenciasDir.path}/$fileName';

    return originalFile.copy(newPath);
  }
  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);

    if (pickedFile == null) return;

    final originalFile = File(pickedFile.path);
    final savedFile = await _copyImageToAppStorage(originalFile);

    setState(() {
      _selectedImage = savedFile;
    });
  }
  Future<void> _saveEvidencia() async {
    if (_selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Debes seleccionar una imagen')),
      );
      return;
    }

    final provider = context.read<EvidenciaProvider>();

    final success = await provider.uploadEvidencia(
      ocurrenciaId: widget.ocurrenciaId,
      file: _selectedImage!,
      observaciones: _observacionesController.text.trim().isEmpty
          ? null
          : _observacionesController.text.trim(),
    );

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Evidencia guardada correctamente')),
      );
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(provider.errorMessage ?? 'Error al guardar evidencia'),
        ),
      );
    }
  }

  String _buildImageUrl(String relativePath) {
    return 'http://192.168.0.100:8000/$relativePath';
  }
  Widget _buildEvidenceImage(String? ruta) 
  {
    if (ruta == null || ruta.trim().isEmpty) {
      return Container(
        height: 180,
        width: double.infinity,
        color: Colors.grey.shade300,
        child: const Center(
          child: Text('No hay imagen'),
        ),
      );
    }

    final cleanRuta = ruta.trim();

    // 1. Imagen local del celular
    if (cleanRuta.startsWith('/')) {
      final file = File(cleanRuta);

      if (file.existsSync()) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.file(
            file,
            height: 180,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) {
              return Container(
                height: 180,
                width: double.infinity,
                color: Colors.grey.shade300,
                child: const Center(
                  child: Text('No se pudo cargar la imagen'),
                ),
              );
            },
          ),
        );
      }

      return Container(
        height: 180,
        width: double.infinity,
        color: Colors.grey.shade300,
        child: const Center(
          child: Text('Archivo local no encontrado'),
        ),
      );
    }

    // 2. URL completa remota
    if (cleanRuta.startsWith('http://') || cleanRuta.startsWith('https://')) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.network(
          cleanRuta,
          height: 180,
          width: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) {
            return Container(
              height: 180,
              width: double.infinity,
              color: Colors.grey.shade300,
              child: const Center(
                child: Text('No se pudo cargar la imagen'),
              ),
            );
          },
        ),
      );
    }
  
    // 3. Ruta relativa del backend, por ejemplo: storage/evidencias/foto.jpg
    final remoteUrl = _buildImageUrl(cleanRuta);

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Image.network(
        remoteUrl,
        height: 180,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) {
          return Container(
            height: 180,
            width: double.infinity,
            color: Colors.grey.shade300,
            child: const Center(
              child: Text('No se pudo cargar la imagen'),
            ),
          );
        },
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<EvidenciaProvider>();

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
                      onPressed: () => Navigator.pop(context, true),
                      icon: const Icon(Icons.arrow_back),
                    ),
                    const SizedBox(width: 6),
                    const Expanded(
                      child: Text(
                        'Registrar evidencias',
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

              if (_selectedImage != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(
                    _selectedImage!,
                    height: 240,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                )
              else
                Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD9D9D9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: Text(
                      'Selecciona una imagen para subir',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),

              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _pickImage(ImageSource.camera),
                      child: const Text('Tomar foto'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _pickImage(ImageSource.gallery),
                      child: const Text('Galería'),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: const Color(0xFFD9D9D9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  controller: _observacionesController,
                  minLines: 4,
                  maxLines: 6,
                  decoration: const InputDecoration(
                    hintText: 'Observaciones de la evidencia',
                    border: InputBorder.none,
                  ),
                ),
              ),

              const SizedBox(height: 18),

              CustomButton(
                text: 'Guardar evidencia',
                onPressed: provider.isSaving ? null : _saveEvidencia,
                backgroundColor: AppColors.darkOlive,
                width: 240,
                isLoading: provider.isSaving,
              ),

              const SizedBox(height: 24),

              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Evidencias registradas (${provider.evidencias.length})',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              if (provider.isLoading)
                const Center(child: CircularProgressIndicator())
              else if (provider.evidencias.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: const Color(0xFFD9D9D9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'Aún no has subido evidencias para esta ocurrencia',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                )
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: provider.evidencias.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final evidencia = provider.evidencias[index];

                    return Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFD9D9D9),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (evidencia.ruta != null) _buildEvidenceImage(evidencia.ruta),
                          const SizedBox(height: 10),
                          Text(
                            evidencia.observaciones ?? 'Sin observaciones',
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    );
                  },
                ),

              const SizedBox(height: 24),

              CustomButton(
                text: 'Finalizar',
                onPressed: () {
                  Navigator.pop(context, true);
                },
                backgroundColor: AppColors.loginBlue,
                width: 220,
              ),
            ],
          ),
        ),
      ),
    );
  }
}