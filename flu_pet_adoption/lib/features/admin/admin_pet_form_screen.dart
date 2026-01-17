import 'package:flutter/material.dart';
import '../../core/services/pet_service.dart';
import '../../models/pet_model.dart';

class AdminPetFormScreen extends StatefulWidget {
  final Pet? pet;

  const AdminPetFormScreen({super.key, this.pet});

  @override
  State<AdminPetFormScreen> createState() => _AdminPetFormScreenState();
}

class _AdminPetFormScreenState extends State<AdminPetFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final PetService _petService = PetService();
  bool _isLoading = false;

  final _nameController = TextEditingController();
  final _speciesController = TextEditingController();
  final _breedController = TextEditingController();
  final _ageController = TextEditingController();

  final List<String> _genderOptions = ['Macho', 'Hembra'];
  final List<String> _statusOptions = ['Disponible', 'Adoptado', 'Pendiente'];
  
  String _gender = 'Macho';
  String _status = 'Disponible';

  @override
  void initState() {
    super.initState();
    if (widget.pet != null) {
      _nameController.text = widget.pet!.name;
      _speciesController.text = widget.pet!.species;
      _breedController.text = widget.pet!.breed;
      _ageController.text = widget.pet!.age.toString();
      if (_genderOptions.contains(widget.pet!.gender)) {
        _gender = widget.pet!.gender;
      } else {
        _gender = _genderOptions.first;
      }

      if (_statusOptions.contains(widget.pet!.status)) {
        _status = widget.pet!.status;
      } else {
        _status = _statusOptions.first;
      }
    }
  }

  void _savePet() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final Map<String, dynamic> data = {
      "name": _nameController.text,
      "species": _speciesController.text,
      "breed": _breedController.text,
      "age": int.parse(_ageController.text),
      "gender": _gender,
      "status": _status,
      "shelter": 1,
      "admission_date": DateTime.now().toString().substring(0, 10),
    };

    bool success;
    if (widget.pet == null) {
      success = await _petService.createPet(data);
    } else {
      success = await _petService.updatePet(widget.pet!.id, data);
    }

    if (mounted) {
      setState(() => _isLoading = false);
      if (success) {
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Error al guardar la mascota")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.pet != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? "Editar Mascota" : "Nueva Mascota")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Nombre"),
                validator: (v) => v!.isEmpty ? "Campo obligatorio" : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _speciesController,
                decoration: const InputDecoration(labelText: "Especie (Perro, Gato...)"),
                validator: (v) => v!.isEmpty ? "Campo obligatorio" : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _breedController,
                decoration: const InputDecoration(labelText: "Raza"),
                validator: (v) => v!.isEmpty ? "Campo obligatorio" : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _ageController,
                decoration: const InputDecoration(labelText: "Edad"),
                keyboardType: TextInputType.number,
                validator: (v) => v!.isEmpty ? "Campo obligatorio" : null,
              ),
              const SizedBox(height: 20),
              
              DropdownButtonFormField<String>(
                value: _gender,
                decoration: const InputDecoration(labelText: "Género"),
                items: _genderOptions.map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
                onChanged: (v) => setState(() => _gender = v!),
              ),
               const SizedBox(height: 10),
              
              DropdownButtonFormField<String>(
                value: _status,
                decoration: const InputDecoration(labelText: "Estado"),
                items: _statusOptions.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                onChanged: (v) => setState(() => _status = v!),
              ),

              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15)
                  ),
                  onPressed: _isLoading ? null : _savePet,
                  child: Text(_isLoading ? "Guardando..." : "Guardar Mascota"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}