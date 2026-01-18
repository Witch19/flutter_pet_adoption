import 'package:flutter/material.dart';
import '../../core/app_colors.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
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
                  'Bienvenidos a Pet Adoption',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryPurple,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // =====================================
              // FOTO GRANDE (perritos)
              // =====================================
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

              // =====================================
              // DESCRIPCIÓN
              // =====================================
              const Text(
                'Pet Adoption es una plataforma web dedicada a ayudar a perritos y gatitos en situación de calle a encontrar un hogar. Trabajamos junto a refugios para promover la adopción responsable.',
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

              _RefugioHorizontal(
                imageRight: true,
                imagePath: 'assets/images/shelters/refugio1.jpg',
                nombre: 'Refugio Huellitas',
                descripcion: 'Rescate y cuidado de perritos abandonados.',
              ),

              const SizedBox(height: 30),

              _RefugioHorizontal(
                imageRight: false,
                imagePath: 'assets/images/shelters/refugio2.jpg',
                nombre: 'Patitas Felices',
                descripcion:
                    'Promovemos la adopción responsable y el bienestar animal.',
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
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final images = [
                      'assets/images/dogs/perro1.png',
                      'assets/images/dogs/perro2.png',
                      'assets/images/dogs/perro3.png',
                      'assets/images/dogs/perro4.png',
                    ];

                    return ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(
                        images[index],
                        width: 120,
                        height: 120,
                        fit: BoxFit.cover,
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
    );
  }
}

// =================================================
// WIDGET REFUGIO
// =================================================
class _RefugioHorizontal extends StatelessWidget {
  final bool imageRight;
  final String imagePath;
  final String nombre;
  final String descripcion;

  const _RefugioHorizontal({
    required this.imageRight,
    required this.imagePath,
    required this.nombre,
    required this.descripcion,
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
        padding: const EdgeInsets.symmetric(horizontal: 14),
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

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: imageRight
          ? [textWidget, const SizedBox(width: 12), imageWidget]
          : [imageWidget, const SizedBox(width: 12), textWidget],
    );
  }
}
