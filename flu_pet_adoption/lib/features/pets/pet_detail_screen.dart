import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/app_colors.dart';
import '../../models/pet_model.dart';
import '../../providers/auth_provider.dart';
import 'adoption_form_screen.dart';

class PetDetailScreen extends StatelessWidget {
  final Pet pet;

  const PetDetailScreen({super.key, required this.pet});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final bool isLoggedIn = auth.status == AuthStatus.authenticated;
    final bool isAvailable = pet.status == 'Disponible';

    return Scaffold(
      appBar: AppBar(
        title: Text(pet.name),
        backgroundColor: AppColors.primaryPurple,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/fondo_pagina.png'),
              fit: BoxFit.cover,
            ),
          ),

          child: Container(
            color: Colors.white.withOpacity(0.88),

            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    height: 260,
                    alignment: Alignment.center,
                    child: pet.imageUrl != null
                        ? Image.network(
                            pet.imageUrl!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          )
                        : const Icon(
                            Icons.pets,
                            size: 120,
                            color: AppColors.primaryPurple,
                          ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Nombre + Estado
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              pet.name,
                              style: const TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: isAvailable
                                    ? Colors.green.shade100
                                    : AppColors.cardPink,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                isAvailable ? "Disponible" : "Adoptado",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: isAvailable
                                      ? Colors.green.shade800
                                      : AppColors.textPrimary,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        _InfoRow(label: "Especie", value: pet.species),
                        _InfoRow(label: "Raza", value: pet.breed),
                        _InfoRow(label: "Edad", value: "${pet.age} años"),

                        const SizedBox(height: 30),

                        if (!isAvailable)
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColors.cardPink,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              "Esta mascota ya encontró un hogar lleno de amor 💜",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          )
                        else if (isLoggedIn)
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              icon: const Icon(Icons.volunteer_activism),
                              label: const Text("Solicitar Adopción"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    AppColors.primaryPurple,
                                foregroundColor: Colors.white,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        AdoptionFormScreen(pet: pet),
                                  ),
                                );
                              },
                            ),
                          )
                        else
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: AppColors.primaryPurple,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              children: const [
                                Icon(
                                  Icons.lock_outline,
                                  color: AppColors.primaryPurple,
                                  size: 40,
                                ),
                                SizedBox(height: 8),
                                Text(
                                  "Inicia sesión para poder adoptar a esta mascota.",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        "$label: $value",
        style: const TextStyle(
          fontSize: 15,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }
}
