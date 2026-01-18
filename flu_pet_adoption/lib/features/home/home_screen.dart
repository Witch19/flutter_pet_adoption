import 'package:flutter/material.dart';
import '../../core/app_colors.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          // =======================
          // FONDO CON IMAGEN
          // =======================
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/fondo_pagina.png'),
              fit: BoxFit.cover,
            ),
          ),

          // =======================
          // OVERLAY BLANCO
          // =======================
          child: Container(
            color: Colors.white.withOpacity(0.85),

            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // =======================
                  // TÍTULO
                  // =======================
                  const Center(
                    child: Text(
                      'PUPPY FAMILY',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryPurple,
                      ),
                    ),
                  ),

                  const SizedBox(height: 6),

                  // =======================
                  // MENSAJE
                  // =======================
                  const Center(
                    child: Text(
                      'Salvando vidas, un amigo a la vez',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // =======================
                  // FOTO PRINCIPAL
                  // =======================
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      'assets/images/dogs/street_dogs.png',
                      height: 220,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // =======================
                  // DESCRIPCIÓN
                  // =======================
                  const Text(
                    'Puppy Family es una plataforma dedicada a ayudar a perritos y gatitos en situación de calle a encontrar un hogar. Trabajamos junto a refugios para promover la adopción responsable.',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.textSecondary,
                    ),
                  ),

                  const SizedBox(height: 30),

                  // =======================
                  // REFUGIOS
                  // =======================
                  const Text(
                    'Refugios asociados',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),

                  const SizedBox(height: 20),

                  _RefugioCard(
                    imageRight: true,
                    imagePath: 'assets/images/shelters/refugio1.jpg',
                    nombre: 'Refugio Huellitas',
                    descripcion: 'Rescate y cuidado de perritos abandonados.',
                    backgroundColor: AppColors.cardOrange,
                  ),

                  const SizedBox(height: 24),

                  _RefugioCard(
                    imageRight: false,
                    imagePath: 'assets/images/shelters/refugio2.jpg',
                    nombre: 'Patitas Felices',
                    descripcion:
                        'Promovemos la adopción responsable y el bienestar animal.',
                    backgroundColor: AppColors.cardPink,
                  ),

                  const SizedBox(height: 40),

                  // =======================
                  // ADOPTADOS
                  // =======================
                  const Text(
                    'Encuentra a tu mejor amigo',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    'Con nosotros',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.textSecondary,
                    ),
                  ),

                  const SizedBox(height: 20),

                  SizedBox(
                    height: 120,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: 4,
                      separatorBuilder: (_, __) =>
                          const SizedBox(width: 12),
                      itemBuilder: (context, index) {
                        final images = [
                          'assets/images/dogs/perro1.png',
                          'assets/images/dogs/perro2.png',
                          'assets/images/dogs/perro3.png',
                          'assets/images/dogs/perro4.png',
                        ];

                        return Container(
                          decoration: BoxDecoration(
                            color:
                                AppColors.primaryPink.withOpacity(0.15),
                            borderRadius:
                                BorderRadius.circular(16),
                          ),
                          child: ClipRRect(
                            borderRadius:
                                BorderRadius.circular(16),
                            child: Image.asset(
                              images[index],
                              width: 120,
                              height: 120,
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// =================================================
// CARD DE REFUGIO
// =================================================
class _RefugioCard extends StatelessWidget {
  final bool imageRight;
  final String imagePath;
  final String nombre;
  final String descripcion;
  final Color backgroundColor;

  const _RefugioCard({
    required this.imageRight,
    required this.imagePath,
    required this.nombre,
    required this.descripcion,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final imageWidget = ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Image.asset(
        imagePath,
        width: 120,
        height: 120,
        fit: BoxFit.cover,
      ),
    );

    final textWidget = Expanded(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              nombre,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              descripcion,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: imageRight
            ? [textWidget, imageWidget]
            : [imageWidget, textWidget],
      ),
    );
  }
}
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pet Adoption Home")),
      body: const Center(
        child: Text("Bienvenido a Pet Adoption"),
      ),
    );
  }
}