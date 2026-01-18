class Pet {
  final int id;
  final String name;
  final String species;
  final String breed;
  final int age;
  final String gender;
  final String status;
  final DateTime? admissionDate;
  final int shelterId;
  
  final String? imageUrl; 

  Pet({
    required this.id,
    required this.name,
    required this.species,
    required this.breed,
    required this.age,
    required this.gender,
    required this.status,
    this.admissionDate,
    required this.shelterId,
    this.imageUrl,
  });

  factory Pet.fromJson(Map<String, dynamic> json) {
    return Pet(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'Sin nombre',
      species: json['species'] ?? 'Desconocido',
      breed: json['breed'] ?? 'Mestizo',
      age: json['age'] ?? 0,
      gender: json['gender'] ?? 'Desconocido',
      status: json['status'] ?? 'Adoptado',
      admissionDate: json['admission_date'] != null 
          ? DateTime.tryParse(json['admission_date']) 
          : null,
      shelterId: json['shelter'] ?? 0,
      imageUrl: null, 
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'species': species,
      'breed': breed,
      'age': age,
      'gender': gender,
      'status': status,
      'admission_date': admissionDate?.toIso8601String().split('T')[0],
      'shelter': shelterId,
    };
  }
}