class Validators {
  // Email validation
  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return 'L\'email est requis';
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Veuillez entrer un email valide';
    }

    return null;
  }

  // Password validation
  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Le mot de passe est requis';
    }

    if (value.length < 6) {
      return 'Le mot de passe doit contenir au moins 6 caractères';
    }

    return null;
  }

  // Required field validation
  static String? required(String? value, {String? fieldName}) {
    if (value == null || value.trim().isEmpty) {
      return '${fieldName ?? 'Ce champ'} est requis';
    }
    return null;
  }

  // Name validation
  static String? name(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Le nom est requis';
    }

    if (value.trim().length < 2) {
      return 'Le nom doit contenir au moins 2 caractères';
    }

    return null;
  }

  // Phone number validation
  static String? phone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Le numéro de téléphone est requis';
    }

    // Remove spaces and special characters
    final cleanPhone = value.replaceAll(RegExp(r'[\s\-\(\)]+'), '');

    if (cleanPhone.length < 8) {
      return 'Numéro de téléphone invalide';
    }

    return null;
  }

  // Price validation
  static String? price(String? value) {
    if (value == null || value.isEmpty) {
      return 'Le prix est requis';
    }

    final price = double.tryParse(value);
    if (price == null) {
      return 'Veuillez entrer un prix valide';
    }

    if (price <= 0) {
      return 'Le prix doit être supérieur à 0';
    }

    return null;
  }

  // Size validation (for land/house size)
  static String? size(String? value) {
    if (value == null || value.isEmpty) {
      return 'La superficie est requise';
    }

    final size = double.tryParse(value);
    if (size == null) {
      return 'Veuillez entrer une superficie valide';
    }

    if (size <= 0) {
      return 'La superficie doit être supérieure à 0';
    }

    return null;
  }

  // Number validation (for bedrooms, bathrooms, etc.)
  static String? number(String? value,
      {String? fieldName, int? min, int? max}) {
    if (value == null || value.isEmpty) {
      return '${fieldName ?? 'Ce champ'} est requis';
    }

    final number = int.tryParse(value);
    if (number == null) {
      return 'Veuillez entrer un nombre valide';
    }

    if (min != null && number < min) {
      return '${fieldName ?? 'La valeur'} doit être au moins $min';
    }

    if (max != null && number > max) {
      return '${fieldName ?? 'La valeur'} ne peut pas dépasser $max';
    }

    return null;
  }

  // Description validation
  static String? description(String? value, {int? minLength, int? maxLength}) {
    if (value == null || value.trim().isEmpty) {
      return 'La description est requise';
    }

    final trimmedValue = value.trim();

    if (minLength != null && trimmedValue.length < minLength) {
      return 'La description doit contenir au moins $minLength caractères';
    }

    if (maxLength != null && trimmedValue.length > maxLength) {
      return 'La description ne peut pas dépasser $maxLength caractères';
    }

    return null;
  }

  // Area/Location validation
  static String? area(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'La zone/quartier est requis';
    }

    if (value.trim().length < 2) {
      return 'La zone doit contenir au moins 2 caractères';
    }

    return null;
  }

  // Custom validation with custom message
  static String? custom(
      String? value, bool Function(String?) validator, String errorMessage) {
    if (value == null || !validator(value)) {
      return errorMessage;
    }
    return null;
  }

  // Combine multiple validators
  static String? combine(
      String? value, List<String? Function(String?)> validators) {
    for (final validator in validators) {
      final result = validator(value);
      if (result != null) {
        return result;
      }
    }
    return null;
  }

  // URL validation (for image URLs)
  static String? url(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Optional field
    }

    final urlRegex = RegExp(
        r'^https?:\/\/(?:www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b(?:[-a-zA-Z0-9()@:%_\+.~#?&=]*)$');

    if (!urlRegex.hasMatch(value)) {
      return 'Veuillez entrer une URL valide';
    }

    return null;
  }

  // Contract type validation
  static String? contractType(String? value) {
    if (value == null || value.isEmpty) {
      return 'Le type de contrat est requis';
    }

    final allowedTypes = ['sale', 'rent'];
    if (!allowedTypes.contains(value)) {
      return 'Type de contrat invalide';
    }

    return null;
  }
}
