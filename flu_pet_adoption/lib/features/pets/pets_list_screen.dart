import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
        builder: (context) => PetDetailScreen(pet: pet),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Mascotas en Adopción")),
      body: RefreshIndicator(
        onRefresh: _refreshPets,
        child: FutureBuilder<List<Pet>>(
          future: _petsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text("No hay mascotas disponibles."));
            }

            final pets = snapshot.data!;

            return ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: pets.length,
              itemBuilder: (context, index) {
                final pet = pets[index];
                return Card(
                  clipBehavior: Clip.antiAlias,
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: InkWell(
                    onTap: () => _navigateToDetail(context, pet),
                    child: Column(
                      children: [
                        // Imagen
                        Container(
                          height: 150,
                          width: double.infinity,
                          color: Colors.grey[300],
                          child: pet.imageUrl != null
                              ? Image.network(pet.imageUrl!, fit: BoxFit.cover)
                              : const Icon(Icons.pets, size: 60, color: Colors.grey),
                        ),
                        ListTile(
                          title: Text(
                            pet.name,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          subtitle: Text("${pet.species} - ${pet.breed}"),
                          trailing: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: pet.status == 'Disponible' ? Colors.green[100] : Colors.red[100],
                            borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              pet.status,
                              style: TextStyle(
                                color: pet.status == 'Disponible' ? Colors.green[800] : Colors.red[800],
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              if (auth.status == AuthStatus.notAuthenticated)
                                const Text(
                                  "Toca para ver detalles",
                                  style: TextStyle(color: Colors.grey, fontSize: 12),
                                ),
                              if (auth.status == AuthStatus.authenticated && auth.role == UserRole.user)
                                TextButton.icon(
                                  icon: const Icon(Icons.touch_app),
                                  label: const Text("Adoptar"),
                                  onPressed: () => _navigateToDetail(context, pet),
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