import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
      appBar: AppBar(title: Text(pet.name)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
             Container(
              height: 250,
              color: isAvailable ? Colors.grey[300] : Colors.red[100],
              child: pet.imageUrl != null 
                ? Image.network(pet.imageUrl!, fit: BoxFit.cover)
                : Icon(
                    isAvailable ? Icons.pets : Icons.home,
                    size: 100, 
                    color: isAvailable ? Colors.white : Colors.redAccent
                  ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        pet.name,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: isAvailable ? Colors.green : Colors.red,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          isAvailable ? "Disponible" : "Adoptado",
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text("Especie: ${pet.species}"),
                  Text("Raza: ${pet.breed}"),
                  Text("Edad: ${pet.age} años"),
                  const SizedBox(height: 20),
                  const SizedBox(height: 30),
                  if (!isAvailable)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.red[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.redAccent),
                      ),
                      child: Row(
                        children: const [
                          Icon(Icons.sentiment_very_satisfied, color: Colors.redAccent),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              "¡Esta mascota ya encontró un hogar! No es posible enviar más solicitudes.",
                              style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    )
                  else if (isLoggedIn) 
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.volunteer_activism),
                        label: const Text("Llenar Formulario de Adopción"),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: Colors.redAccent,
                          foregroundColor: Colors.white
                        ),
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (_) => AdoptionFormScreen(pet: pet)
                          ));
                        },
                      ),
                    )
                  else
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: const [
                          Icon(Icons.lock_outline, color: Colors.grey, size: 40),
                          SizedBox(height: 8),
                          Text(
                            "Debes iniciar sesión para adoptar a esta mascota.",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.black54),
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
    );
  }
}