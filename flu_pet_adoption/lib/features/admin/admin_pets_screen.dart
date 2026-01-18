import 'package:flutter/material.dart';
import '../../core/services/pet_service.dart';
import '../../models/pet_model.dart';
import 'admin_pet_form_screen.dart';

class AdminPetsScreen extends StatefulWidget {
  const AdminPetsScreen({super.key});

  @override
  State<AdminPetsScreen> createState() => _AdminPetsScreenState();
}

class _AdminPetsScreenState extends State<AdminPetsScreen> {
  final PetService _petService = PetService();
  late Future<List<Pet>> _petsFuture;

  @override
  void initState() {
    super.initState();
    _loadPets();
  }

  void _loadPets() {
    setState(() {
      _petsFuture = _petService.getPets();
    });
  }

  void _deletePet(int id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Confirmar"),
        content: const Text("¿Estás seguro de eliminar esta mascota?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text("Cancelar")),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text("Eliminar", style: TextStyle(color: Colors.red))),
        ],
      ),
    );

    if (confirm == true) {
      bool success = await _petService.deletePet(id);
      if (success) {
        _loadPets();
        if (mounted) {
           ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Mascota eliminada")));
        }
      }
    }
  }

  void _navigateToForm({Pet? pet}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AdminPetFormScreen(pet: pet)),
    );

    if (result == true) {
      _loadPets();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Administrar Mascotas")),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToForm(),
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder<List<Pet>>(
        future: _petsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No hay mascotas registradas."));
          }

          final pets = snapshot.data!;

          return ListView.separated(
            itemCount: pets.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (context, index) {
              final pet = pets[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.blue[50],
                  child: Text(pet.name[0]),
                ),
                title: Text(pet.name),
                subtitle: Text("${pet.species} - ${pet.status}"),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () => _navigateToForm(pet: pet),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deletePet(pet.id),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}