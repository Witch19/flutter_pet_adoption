import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: const [
          Text(
            'Configuración',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),

          ListTile(
            leading: Icon(Icons.notifications),
            title: Text('Notificaciones'),
          ),
          ListTile(
            leading: Icon(Icons.lock),
            title: Text('Privacidad'),
          ),
          ListTile(
            leading: Icon(Icons.help_outline),
            title: Text('Ayuda'),
          ),
        ],
      ),
    );
  }
}
