import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/services/adoption_service.dart';
import '../../core/services/pet_service.dart';
import '../../models/pet_model.dart';
import '../../providers/auth_provider.dart';

class UserRequestsScreen extends StatefulWidget {
  const UserRequestsScreen({super.key});

  @override
  State<UserRequestsScreen> createState() => _UserRequestsScreenState();
}

class _UserRequestsScreenState extends State<UserRequestsScreen> {
  final AdoptionService _adoptionService = AdoptionService();
  late Future<List<dynamic>> _myRequestsFuture;

  @override
  void initState() {
    super.initState();
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final int userId = auth.userData?['id'] ?? 0;
    
    _myRequestsFuture = _adoptionService.getMyAdoptionRequests(userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mis Solicitudes")),
      body: FutureBuilder<List<dynamic>>(
        future: _myRequestsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.folder_open, size: 60, color: Colors.grey),
                  SizedBox(height: 10),
                  Text("No has realizado ninguna solicitud de adopción."),
                ],
              ),
            );
          }

          final requests = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: requests.length,
            itemBuilder: (context, index) {
              return _RequestCard(request: requests[index]);
            },
          );
        },
      ),
    );
  }
}

class _RequestCard extends StatelessWidget {
  final dynamic request;
  final PetService _petService = PetService();

  _RequestCard({super.key, required this.request});

  @override
  Widget build(BuildContext context) {
    final int petId = request['pet'];
    final String status = request['status'] ?? 'Pendiente';

    Color color = Colors.orange;
    String statusText = "En Revisión";
    IconData icon = Icons.access_time;

    if (status == 'approved') {
      color = Colors.green;
      statusText = "Aprobada";
      icon = Icons.check_circle;
    } else if (status == 'rejected' || status == 'cancelled') {
      color = Colors.red;
      statusText = "Rechazada";
      icon = Icons.cancel;
    }

    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 40),
                const SizedBox(width: 15),
                
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        statusText.toUpperCase(),
                        style: TextStyle(
                          color: color,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 5),
                      FutureBuilder<Pet?>(
                        future: _petService.getPetById(petId),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Text("Cargando mascota...", style: TextStyle(color: Colors.grey));
                          }
                          if (snapshot.hasData) {
                            return Text(
                              "Mascota: ${snapshot.data!.name}",
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            );
                          }
                          return Text("Mascota ID: $petId");
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (status == 'approved')
              Container(
                margin: const EdgeInsets.only(top: 10), 
                padding: const EdgeInsets.all(8),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(5),
                ),
                child: const Text(
                  "¡Felicidades! Acércate al refugio para finalizar el trámite.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.green, fontSize: 12),
                ),
              )
          ],
        ),
      ),
    );
  }
}