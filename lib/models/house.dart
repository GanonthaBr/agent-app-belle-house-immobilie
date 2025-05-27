class House {
  final int? id;
  final String name;
  final String description;
  final double price;
  final String area;
  final String typeOfContract; // 'sale' or 'rent'
  final List<String> images;
  final int? bedrooms;
  final int? bathrooms;
  final double? size; // in square meters
  final List<String> features;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool isActive;

  House({
    this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.area,
    required this.typeOfContract,
    this.images = const [],
    this.bedrooms,
    this.bathrooms,
    this.size,
    this.features = const [],
    this.createdAt,
    this.updatedAt,
    this.isActive = true,
  });

  // Convert from JSON
  factory House.fromJson(Map<String, dynamic> json) {
    return House(
      id: json['id'],
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: double.tryParse(json['price'].toString()) ?? 0.0,
      area: json['area'] ?? '',
      typeOfContract: json['type_of_contract'] ?? 'sale',
      images: json['images'] != null ? List<String>.from(json['images']) : [],
      bedrooms: json['bedrooms'],
      bathrooms: json['bathrooms'],
      size: json['size'] != null
          ? double.tryParse(json['size'].toString())
          : null,
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
      if (bedrooms != null) 'bedrooms': bedrooms,
      if (bathrooms != null) 'bathrooms': bathrooms,
      if (size != null) 'size': size,
      'features': features,
      'is_active': isActive,
    };
  }

  // Create a copy with updated fields
  House copyWith({
    int? id,
    String? name,
    String? description,
    double? price,
    String? area,
    String? typeOfContract,
    List<String>? images,
    int? bedrooms,
    int? bathrooms,
    double? size,
    List<String>? features,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
  }) {
    return House(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      area: area ?? this.area,
      typeOfContract: typeOfContract ?? this.typeOfContract,
      images: images ?? this.images,
      bedrooms: bedrooms ?? this.bedrooms,
      bathrooms: bathrooms ?? this.bathrooms,
      size: size ?? this.size,
      features: features ?? this.features,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  String toString() {
    return 'House(id: $id, name: $name, price: $price, area: $area)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is House && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
