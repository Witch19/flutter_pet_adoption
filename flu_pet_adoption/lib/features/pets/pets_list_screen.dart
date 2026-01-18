import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/app_colors.dart';
import '../../core/services/pet_service.dart';
import '../../models/pet_model.dart';
import '../../providers/auth_provider.dart';
import 'pet_detail_screen.dart';

class PetsListScreen extends StatefulWidget {
  const PetsListScreen({super.key});

  @override
  State<PetsListScreen> createState() => _PetsListScreenState();
}

class _PetsListScreenState extends State<PetsListScreen> {
  final PetService _petService = PetService();
  late Future<List<Pet>> _petsFuture;

  @override
  void initState() {
    super.initState();
    _petsFuture = _petService.getPets();
  }

  Future<void> _refreshPets() async {
    setState(() {
      _petsFuture = _petService.getPets();
    });
  }

  void _navigateToDetail(BuildContext context, Pet pet) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PetDetailScreen(pet: pet),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text("Mascotas en Adopción"),
        backgroundColor: AppColors.primaryPurple,
        foregroundColor: Colors.white,
      ),
      body: RefreshIndicator(
        onRefresh: _refreshPets,
        child: FutureBuilder<List<Pet>>(
          future: _petsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(
                child: Text(
                  "Error: ${snapshot.error}",
                  style: const TextStyle(color: AppColors.textPrimary),
                ),
              );
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Text(
                  "No hay mascotas disponibles.",
                  style: TextStyle(color: AppColors.textSecondary),
                ),
              );
            }

            final pets = snapshot.data!;

            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: pets.length,
              itemBuilder: (context, index) {
                final pet = pets[index];
                final disponible = pet.status == 'Disponible';

                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () => _navigateToDetail(context, pet),
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(16),
                          ),
                          child: pet.imageUrl != null
                              ? Image.network(
                                  pet.imageUrl!,
                                  height: 160,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                )
                              : Container(
                                  height: 160,
                                  alignment: Alignment.center,
                                  child: const Icon(
                                    Icons.pets,
                                    size: 64,
                                    color: AppColors.primaryPurple,
                                  ),
                                ),
                        ),

                        ListTile(
                          title: Text(
                            pet.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          subtitle: Text(
                            "${pet.species} - ${pet.breed}",
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                            ),
                          ),

                          trailing: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: disponible
                                  ? Colors.green.shade100
                                  : AppColors.cardPink,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Text(
                              pet.status,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: disponible
                                    ? Colors.green.shade800
                                    : AppColors.textPrimary,
                              ),
                            ),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(
                            right: 12,
                            bottom: 8,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              if (auth.status ==
                                  AuthStatus.notAuthenticated)
                                const Text(
                                  "Toca para ver detalles",
                                  style: TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 12,
                                  ),
                                ),
                              if (auth.status ==
                                      AuthStatus.authenticated &&
                                  auth.role == UserRole.user)
                                TextButton.icon(
                                  icon: const Icon(
                                    Icons.favorite,
                                    color: AppColors.primaryPurple,
                                  ),
                                  label: const Text(
                                    "Adoptar",
                                    style: TextStyle(
                                      color: AppColors.primaryPurple,
                                    ),
                                  ),
                                  onPressed: () =>
                                      _navigateToDetail(context, pet),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
