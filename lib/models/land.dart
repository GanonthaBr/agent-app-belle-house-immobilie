class Land {
  final int? id;
  final String name;
  final String description;
  final double price;
  final String area;
  final String typeOfContract; // 'sale' or 'rent'
  final List<String> images;
  final double size; // in square meters
  final String landType; // 'residential', 'commercial', 'agricultural', etc.
  final List<String> features;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool isActive;

  Land({
    this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.area,
    required this.typeOfContract,
    this.images = const [],
    required this.size,
    this.landType = 'residential',
    this.features = const [],
    this.createdAt,
    this.updatedAt,
    this.isActive = true,
  });

  // Convert from JSON
  factory Land.fromJson(Map<String, dynamic> json) {
    return Land(
      id: json['id'],
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: double.tryParse(json['price'].toString()) ?? 0.0,
      area: json['area'] ?? '',
      typeOfContract: json['type_of_contract'] ?? 'sale',
      images: json['images'] != null ? List<String>.from(json['images']) : [],
      size: double.tryParse(json['size'].toString()) ?? 0.0,
      landType: json['land_type'] ?? 'residential',
      features:
          json['features'] != null ? List<String>.from(json['features']) : [],
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
      isActive: json['is_active'] ?? true,
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'description': description,
      'price': price,
      'area': area,
      'type_of_contract': typeOfContract,
      'images': images,
      'size': size,
      'land_type': landType,
      'features': features,
      'is_active': isActive,
    };
  }

  // Create a copy with updated fields
  Land copyWith({
    int? id,
    String? name,
    String? description,
    double? price,
    String? area,
    String? typeOfContract,
    List<String>? images,
    double? size,
    String? landType,
    List<String>? features,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
  }) {
    return Land(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      area: area ?? this.area,
      typeOfContract: typeOfContract ?? this.typeOfContract,
      images: images ?? this.images,
      size: size ?? this.size,
      landType: landType ?? this.landType,
      features: features ?? this.features,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  String toString() {
    return 'Land(id: $id, name: $name, price: $price, area: $area, size: ${size}m²)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Land && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
