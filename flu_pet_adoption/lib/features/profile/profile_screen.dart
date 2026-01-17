import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../admin/admin_requests_screen.dart';
import '../admin/admin_pets_screen.dart';
import 'user_requests_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final username = auth.userData?['username'] ?? 'Usuario';
    final isUser = auth.role == UserRole.user;
    final isAdmin = auth.role == UserRole.admin;

    return Scaffold(
      appBar: AppBar(title: const Text("Mi Perfil")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.account_circle, size: 100, color: Colors.grey),
            const SizedBox(height: 20),
            Text("Hola, $username", style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 20),
            
            if (isUser)
              ElevatedButton.icon(
                icon: const Icon(Icons.track_changes),
                label: const Text("Seguimiento de Adopciones"),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (_) => const UserRequestsScreen()
                  ));
                },
              ),

            if (isAdmin)
              ElevatedButton.icon(
                icon: const Icon(Icons.edit),
                label: const Text("Administrar Mascotas"),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (_) => const AdminPetsScreen()
                  ));
                },
              ),
            if (isAdmin)
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.assignment_ind),
                  label: const Text("Gestionar Solicitudes"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (_) => const AdminRequestsScreen()
                    ));
                  },
                ),
              ),

            const SizedBox(height: 40),
            TextButton(
              onPressed: () => auth.logout(),
              child: const Text("Cerrar Sesión", style: TextStyle(color: Colors.red)),
            )
          ],
        ),
      ),
    );
  }
}