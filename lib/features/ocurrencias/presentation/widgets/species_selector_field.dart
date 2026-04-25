import 'package:flutter/material.dart';

import '../../data/models/especie_model.dart';

class SpeciesSelectorField extends StatelessWidget {
  final EspecieModel? selectedSpecies;
  final VoidCallback onTap;

  const SpeciesSelectorField({
    super.key,
    required this.selectedSpecies,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: const Color(0xFFD9D9D9),
          borderRadius: BorderRadius.circular(12),
        ),
        child: selectedSpecies == null
            ? const Text(
                'Seleccionar especie',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    selectedSpecies!.displayName,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Nombre científico: ${selectedSpecies!.nombreCientifico ?? 'No disponible'}',
                    style: const TextStyle(fontSize: 14),
                  ),
                  Text(
                    'Familia: ${selectedSpecies!.familia ?? 'No disponible'}',
                    style: const TextStyle(fontSize: 14),
                  ),
                  Text(
                    'Estado de conservación: ${selectedSpecies!.estadoConservacion ?? 'No disponible'}',
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
      ),
    );
  }
}