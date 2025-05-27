# BELLE HOUSE IMMOBILIER Agent App - Structure

```
real_estate_admin/
│
├── lib/
│   ├── main.dart                     # App entry point
│   │
│   ├── config/
│   │   ├── app_config.dart           # App configuration
│   │   └── api_config.dart           # API endpoints
│   │
│   ├── models/
│   │   ├── user_model.dart           # Agent/User model
│   │   ├── house_model.dart          # House model
│   │   ├── land_model.dart           # Land model
│   │   └── api_response_model.dart   # API response wrapper
│   │
│   ├── services/
│   │   ├── api_service.dart          # HTTP API calls
│   │   ├── auth_service.dart         # Authentication service
│   │   ├── image_service.dart        # Image upload/handling
│   │   └── storage_service.dart      # Local storage
│   │
│   ├── providers/
│   │   ├── auth_provider.dart        # Authentication state
│   │   ├── house_provider.dart       # Houses management
│   │   ├── land_provider.dart        # Lands management
│   │   └── loading_provider.dart     # Loading states
│   │
│   ├── screens/
│   │   ├── auth/
│   │   │   ├── login_screen.dart
│   │   │   └── widgets/
│   │   │       └── login_form.dart
│   │   │
│   │   ├── dashboard/
│   │   │   ├── dashboard_screen.dart
│   │   │   └── widgets/
│   │   │       ├── stats_card.dart
│   │   │       └── quick_actions.dart
│   │   │
│   │   ├── houses/
│   │   │   ├── houses_list_screen.dart
│   │   │   ├── add_house_screen.dart
│   │   │   ├── edit_house_screen.dart
│   │   │   └── widgets/
│   │   │       ├── house_card.dart
│   │   │       ├── house_form.dart
│   │   │       └── image_picker_widget.dart
│   │   │
│   │   ├── lands/
│   │   │   ├── lands_list_screen.dart
│   │   │   ├── add_land_screen.dart
│   │   │   ├── edit_land_screen.dart
│   │   │   └── widgets/
│   │   │       ├── land_card.dart
│   │   │       └── land_form.dart
│   │   │
│   │   └── profile/
│   │       ├── profile_screen.dart
│   │       └── settings_screen.dart
│   │
│   ├── widgets/
│   │   ├── custom_app_bar.dart
│   │   ├── custom_button.dart
│   │   ├── custom_text_field.dart
│   │   ├── loading_widget.dart
│   │   ├── error_widget.dart
│   │   ├── image_picker.dart
│   │   └── confirmation_dialog.dart
│   │
│   ├── utils/
│   │   ├── constants.dart            # App constants
│   │   ├── colors.dart              # App colors
│   │   ├── validators.dart          # Form validation
│   │   ├── helpers.dart             # Helper functions
│   │   └── routes.dart              # App routes
│   │
│   └── theme/
│       └── app_theme.dart           # App theme configuration
│
├── assets/
│   ├── images/
│   │   ├── logo.png
│   │   ├── placeholder_house.png
│   │   └── placeholder_land.png
│   │
│   └── icons/
│       ├── house_icon.png
│       └── land_icon.png
│
├── android/                         # Android platform files
├── ios/                            # iOS platform files
│
├── .env                            # Environment variables
├── .gitignore
├── pubspec.yaml                    # Dependencies
├── pubspec.lock
└── README.md
```

## Key Files Structure

### 1. **Models** (Data Structure)

- Simple data classes for API responses
- House and Land property models
- User/Agent model

### 2. **Services** (Business Logic)

- API communication
- Authentication handling
- Image upload functionality
- Local storage management

### 3. **Providers** (State Management)

- Using Provider pattern for state management
- Separate providers for different features
- Loading states management

### 4. **Screens** (UI)

- Feature-based screen organization
- Login and authentication
- Dashboard with overview
- Houses and Lands CRUD operations
- Profile management

### 5. **Widgets** (Reusable Components)

- Common UI components
- Form elements
- Custom buttons and inputs

### 6. **Utils** (Utilities)

- Constants and configurations
- Validation logic
- Helper functions
- Routing

This simplified structure focuses on:

- **Essential features only** (Authentication, Houses, Lands, Dashboard)
- **Provider for state management** (simple and effective)
- **Clear separation of concerns**
- **Minimal dependencies**
- **Easy to understand and maintain**
- **Scalable for future additions**
