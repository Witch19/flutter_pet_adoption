import 'package:flutter/material.dart';
import '../../core/services/adoption_service.dart';
import '../../core/services/pet_service.dart';

class AdminRequestsScreen extends StatefulWidget {
  const AdminRequestsScreen({super.key});

  @override
  State<AdminRequestsScreen> createState() => _AdminRequestsScreenState();
}

class _AdminRequestsScreenState extends State<AdminRequestsScreen> {
  final AdoptionService _adoptionService = AdoptionService();
  final PetService _petService = PetService();

  late Future<List<dynamic>> _requestsFuture;

  @override
  void initState() {
    super.initState();
    _loadRequests();
  }

  void _loadRequests() {
    setState(() {
      _requestsFuture = _adoptionService.getAllRequests();
    });
  }

  void _updateStatus(int requestId, int petId, String newRequestStatus) async {
    bool requestSuccess = await _adoptionService.updateRequestStatus(requestId, newRequestStatus);

    if (requestSuccess) {
      String message = "Solicitud actualizada a: $newRequestStatus";
      
      if (newRequestStatus == 'approved') {
        bool petSuccess = await _petService.updatePetStatus(petId, 'Adoptado');
        if (petSuccess) {
          message += " y Mascota marcada como Adoptada.";
        } else {
          message += ", pero falló al actualizar la mascota.";
        }
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
        _loadRequests();
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Error al actualizar la solicitud")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Gestionar Adopciones")),
      body: FutureBuilder<List<dynamic>>(
        future: _requestsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No hay solicitudes pendientes."));
          }

          final requests = snapshot.data!;

          return ListView.builder(
            itemCount: requests.length,
            itemBuilder: (context, index) {
              final req = requests[index];
              final status = req['status'] ?? 'Pendiente';
              final int petId = req['pet'] ?? 0;
              
              Color statusColor = Colors.orange;
              if (status == 'approved') statusColor = Colors.green;
              if (status == 'rejected' || status == 'cancelled') statusColor = Colors.red;

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ListTile(
                  title: Text("Solicitud #${req['id']} - Mascota ID: $petId"),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Usuario Solicitante ID: ${req['user']}"),
                      const SizedBox(height: 5),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: statusColor),
                        ),
                        child: Text(
                          status.toUpperCase(),
                          style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                  trailing: status == 'Pendiente' 
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.check_circle, color: Colors.green),
                            onPressed: () => _updateStatus(req['id'], petId, 'approved'),
                            tooltip: "Aprobar",
                          ),
                          IconButton(
                            icon: const Icon(Icons.cancel, color: Colors.red),
                            onPressed: () => _updateStatus(req['id'], petId, 'rejected'),
                            tooltip: "Rechazar",
                          ),
                        ],
                      )
                    : Icon(
                        status == 'approved' ? Icons.check : Icons.block, 
                        color: statusColor
                      ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}