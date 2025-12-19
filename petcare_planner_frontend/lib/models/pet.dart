class Pet {
  final String id;
  final String petType;
  final String petName;
  final String breed;
  final int age;
  final String gender;
  final String? petImage;

  Pet({
    required this.id,
    required this.petType,
    required this.petName,
    required this.breed,
    required this.age,
    required this.gender,
    this.petImage,
  });

  factory Pet.fromJson(Map<String, dynamic> json) {
    return Pet(
      id: json['_id'],
      petType: json['petType'],
      petName: json['petName'],
      breed: json['breed'],
      age: json['age'],
      gender: json['gender'],
      petImage: json['petImage'],
    );
  }
}
