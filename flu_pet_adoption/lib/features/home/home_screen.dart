import 'package:flutter/material.dart';
import 'home_controller.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final HomeController _controller = HomeController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inicio'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _controller.logout(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Bienvenido',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),

            _HomeCard(
              icon: Icons.pets,
              title: 'Registrarse',
              subtitle: 'Crea una cuenta para adoptar una mascota',
              onTap: () {
                Navigator.pushNamed(context, '/register');
              },
            ),

            _HomeCard(
              icon: Icons.assignment,
              title: 'Mis solicitudes',
              subtitle: 'Revisa el estado de tus solicitudes',
              onTap: () => _controller.goToRequests(context),
            ),

            _HomeCard(
              icon: Icons.home_work,
              title: 'Refugios',
              subtitle: 'Conoce los refugios disponibles',
              onTap: () => _controller.goToShelters(context),
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
  final String subtitle;
  final VoidCallback onTap;

  const _HomeCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        leading: Icon(icon, size: 32),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }
}
