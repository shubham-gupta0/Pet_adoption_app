import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'pet.g.dart';

@HiveType(typeId: 0)
@JsonSerializable()
class Pet extends Equatable {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String breed;

  @HiveField(3)
  final int age;

  @HiveField(4)
  final String gender;

  @HiveField(5)
  final String size;

  @HiveField(6)
  final String color;

  @HiveField(7)
  final String description;

  @HiveField(8)
  final List<String> images;

  @HiveField(9)
  final String location;

  @HiveField(10)
  final bool isAdopted;

  @HiveField(11)
  final String? contactEmail;

  @HiveField(12)
  final String? contactPhone;

  @HiveField(13)
  final DateTime? createdAt;

  @HiveField(14)
  final double? cost;

  const Pet({
    required this.id,
    required this.name,
    required this.breed,
    required this.age,
    required this.gender,
    required this.size,
    required this.color,
    required this.description,
    required this.images,
    required this.location,
    this.isAdopted = false,
    this.contactEmail,
    this.contactPhone,
    this.createdAt,
    this.cost,
  });

  Pet copyWith({
    String? id,
    String? name,
    String? breed,
    int? age,
    String? gender,
    String? size,
    String? color,
    String? description,
    List<String>? images,
    String? location,
    bool? isAdopted,
    String? contactEmail,
    String? contactPhone,
    DateTime? createdAt,
    double? cost,
  }) {
    return Pet(
      id: id ?? this.id,
      name: name ?? this.name,
      breed: breed ?? this.breed,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      size: size ?? this.size,
      color: color ?? this.color,
      description: description ?? this.description,
      images: images ?? this.images,
      location: location ?? this.location,
      isAdopted: isAdopted ?? this.isAdopted,
      contactEmail: contactEmail ?? this.contactEmail,
      contactPhone: contactPhone ?? this.contactPhone,
      createdAt: createdAt ?? this.createdAt,
      cost: cost ?? this.cost,
    );
  }

  factory Pet.fromJson(Map<String, dynamic> json) {
    return Pet(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      breed: json['breeds']?['primary'] ?? json['breed'] ?? 'Mixed',
      age: _parseAge(json['age']),
      gender: json['gender'] ?? 'Unknown',
      size: json['size'] ?? 'Medium',
      color: json['colors']?['primary'] ?? json['color'] ?? 'Mixed',
      description: json['description'] ?? '',
      images: _parseImages(json),
      location: _parseLocation(json),
      isAdopted: json['status'] == 'adopted' || json['isAdopted'] == true,
      contactEmail: json['contact']?['email'],
      contactPhone: json['contact']?['phone'],
      createdAt: json['published_at'] != null
          ? DateTime.tryParse(json['published_at'])
          : DateTime.now(),
      cost:
          json['cost']?.toDouble() ??
          (100.0 +
              (json['id']?.hashCode ?? 0) %
                  101), // Generate random cost between 100-200 if not provided
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'breed': breed,
      'age': age,
      'gender': gender,
      'size': size,
      'color': color,
      'description': description,
      'images': images,
      'location': location,
      'isAdopted': isAdopted,
      'contactEmail': contactEmail,
      'contactPhone': contactPhone,
      'createdAt': createdAt?.toIso8601String(),
      'cost': cost,
    };
  }

  static int _parseAge(dynamic age) {
    if (age is int) return age;
    if (age is String) {
      // Handle cases like "Adult", "Young", "Senior"
      switch (age.toLowerCase()) {
        case 'baby':
        case 'young':
          return 1;
        case 'adult':
          return 3;
        case 'senior':
          return 8;
        default:
          return int.tryParse(age) ?? 3;
      }
    }
    return 3; // Default to adult
  }

  static List<String> _parseImages(Map<String, dynamic> json) {
    final List<String> images = [];

    // Handle Petfinder API photos structure
    if (json['photos'] is List) {
      for (var photo in json['photos']) {
        if (photo['large'] != null) {
          images.add(photo['large']);
        } else if (photo['medium'] != null) {
          images.add(photo['medium']);
        } else if (photo['small'] != null) {
          images.add(photo['small']);
        }
      }
    }

    // Handle simple images array
    if (json['images'] is List) {
      images.addAll(List<String>.from(json['images']));
    }

    // Handle single image
    if (json['image'] is String) {
      images.add(json['image']);
    }

    // Default placeholder if no images
    if (images.isEmpty) {
      images.add('https://dog.ceo/api/breeds/image/random');
    }

    return images;
  }

  static String _parseLocation(Map<String, dynamic> json) {
    if (json['contact']?['address'] != null) {
      final address = json['contact']['address'];
      return '${address['city'] ?? ''}, ${address['state'] ?? ''}'.trim();
    }
    return json['location'] ?? 'Unknown Location';
  }

  @override
  List<Object?> get props => [
    id,
    name,
    breed,
    age,
    gender,
    size,
    color,
    description,
    images,
    location,
    isAdopted,
    contactEmail,
    contactPhone,
    createdAt,
    cost,
  ];
}
