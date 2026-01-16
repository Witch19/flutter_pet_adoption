import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Inicio"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bienvenida
            const Text(
              "Bienvenida de nuevo,",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            const Text(
              "¿Qué deseas hacer hoy?",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),

            const SizedBox(height: 24),

            // Opciones principales
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                children: [
                  _HomeCard(
                    icon: Icons.person,
                    title: "Perfil",
                    onTap: () {
                      // Navigator.push(...)
                    },
                  ),
                  _HomeCard(
                    icon: Icons.settings,
                    title: "Configuración",
                    onTap: () {},
                  ),
                  _HomeCard(
                    icon: Icons.list_alt,
                    title: "Registros",
                    onTap: () {},
                  ),
                  _HomeCard(icon: Icons.logout, title: "Salir", onTap: () {}),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _HomeCard({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.blue.shade50,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.blue),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
