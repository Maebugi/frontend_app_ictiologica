import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../ocurrencias/data/models/especie_model.dart';
import '../../../ocurrencias/presentation/providers/ocurrencia_provider.dart';

class SpeciesListPage extends StatefulWidget {
  const SpeciesListPage({super.key});

  @override
  State<SpeciesListPage> createState() => _SpeciesListPageState();
}

class _SpeciesListPageState extends State<SpeciesListPage> {
  List<EspecieModel> especies = [];

  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();

    _cargarEspecies();
  }

  Future<void> _cargarEspecies() async {
    try {
      final provider = context.read<OcurrenciaProvider>();

      await provider.loadSpecies();

      debugPrint(
        'ESPECIE PRUEBA: ${provider.species.isNotEmpty ? provider.species.first.nombreCientifico : 'SIN ESPECIES'}',
      );

      if (provider.species.isNotEmpty) {
        final especie = provider.species.first;

        debugPrint('LONGEVIDAD: ${especie.longevidad}');
        debugPrint('HABITO: ${especie.habitoAlimenticio}');
        debugPrint('PERIODO: ${especie.periodoReproductivo}');
        debugPrint('DESCRIPCION: ${especie.descripcion}');
      }

      if (!mounted) return;

      setState(() {
        especies = provider.species;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        errorMessage = 'No se pudieron cargar las especies.';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0EED6),
      appBar: AppBar(
        title: const Text(
          'Especies registradas',
          style: TextStyle(
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: const Color(0xFFC8D3F0),
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.error_outline,
                size: 50,
                color: Colors.redAccent,
              ),
              const SizedBox(height: 12),
              Text(
                errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    isLoading = true;
                    errorMessage = null;
                  });

                  _cargarEspecies();
                },
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      );
    }

    if (especies.isEmpty) {
      return const Center(
        child: Text(
          'No hay especies registradas.',
          style: TextStyle(
            fontSize: 16,
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: especies.length,
      itemBuilder: (context, index) {
        final especie = especies[index];

        return _SpeciesCard(
          especie: especie,
        );
      },
    );
  }
}

class _SpeciesCard extends StatelessWidget {
  final EspecieModel especie;

  const _SpeciesCard({
    required this.especie,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Nombre científico
          Text(
            especie.nombreCientifico ?? 'Especie sin nombre',
            style: const TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w700,
              fontStyle: FontStyle.italic,
            ),
          ),

          const SizedBox(height: 14),

          // Información principal
          _dato(
            'Nombre común',
            especie.nombreComun,
          ),

          _dato(
            'Orden',
            especie.orden,
          ),

          _dato(
            'Familia',
            especie.familia,
          ),

          _dato(
            'Longevidad',
            especie.longevidad?.toString(),
          ),

          _dato(
            'Hábito alimenticio',
            especie.habitoAlimenticio,
          ),

          _dato(
            'Periodo reproductivo',
            especie.periodoReproductivo,
          ),

          const SizedBox(height: 8),

          const Text(
            'Descripción',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 5),

          Text(
            especie.descripcion?.isNotEmpty == true
                ? especie.descripcion!
                : 'No disponible',
            style: const TextStyle(
              fontSize: 14,
              height: 1.4,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _dato(
    String titulo,
    String? valor,
  ) {
    final tieneValor =
        valor != null && valor.trim().isNotEmpty;

    return Padding(
      padding: const EdgeInsets.only(bottom: 7),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black87,
          ),
          children: [
            TextSpan(
              text: '$titulo: ',
              style: const TextStyle(
                fontWeight: FontWeight.w700,
              ),
            ),
            TextSpan(
              text: tieneValor ? valor : 'No disponible',
            ),
          ],
        ),
      ),
    );
  }
}