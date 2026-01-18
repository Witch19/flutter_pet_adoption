import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/pet_model.dart';
import '../../providers/auth_provider.dart';
import '../../core/services/adoption_service.dart';

class AdoptionFormScreen extends StatefulWidget {
  final Pet pet;
  const AdoptionFormScreen({super.key, required this.pet});

  @override
  State<AdoptionFormScreen> createState() => _AdoptionFormScreenState();
}

class _AdoptionFormScreenState extends State<AdoptionFormScreen> {
  final _reasonController = TextEditingController();
  final _userController = TextEditingController();
  final _emailController = TextEditingController();

  final AdoptionService _adoptionService = AdoptionService();
  bool _isLoading = false;

  void _submitAdoption(int userId) async {
    setState(() => _isLoading = true);
    bool success = await _adoptionService.createAdoptionRequest(
      userId,
      widget.pet.id,
    );

    if (mounted) {
      setState(() => _isLoading = false);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("¡Solicitud enviada con éxito!"),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.popUntil(context, (route) => route.isFirst);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Error al enviar la solicitud. Intenta de nuevo."),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final int userId = auth.userData?['id'] ?? 0;

    if (auth.userData != null) {
      _userController.text = auth.userData?['username'] ?? '';
      _emailController.text = auth.userData?['email'] ?? '';
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Formulario de Adopción")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red[50],
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.redAccent.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.pets, color: Colors.redAccent, size: 40),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Estás aplicando para:",
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                      Text(
                        widget.pet.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text("Datos del Solicitante:", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            TextField(
              controller: _userController,
              readOnly: true,
              style: const TextStyle(color: Colors.black87),
              decoration: const InputDecoration(
                labelText: "Nombre de Usuario",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
                filled: true,
                fillColor: Color(0xFFEEEEEE),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _emailController,
              readOnly: true,
              style: const TextStyle(color: Colors.black87),
              decoration: const InputDecoration(
                labelText: "Email de contacto",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email),
                filled: true,
                fillColor: Color(0xFFEEEEEE),
              ),
            ),

            const SizedBox(height: 20),
            const Text("Motivo de adopción:", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            const Text(
              "Cuéntanos brevemente por qué quieres adoptar (Opcional)",
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _reasonController,
              maxLines: 3,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Me encantan los animales y tengo espacio...",
              ),
            ),

            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: _isLoading 
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: userId != 0 
                      ? () => _submitAdoption(userId) 
                      : null,
                    child: const Text("Confirmar Solicitud", style: TextStyle(fontSize: 16)),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}