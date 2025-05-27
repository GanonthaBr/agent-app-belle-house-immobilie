import 'package:agent_app_belle_house_immobilier/screens/auth/login.dart';
import 'package:agent_app_belle_house_immobilier/screens/houses/create_house_screen.dart';
import 'package:agent_app_belle_house_immobilier/screens/houses/edit_house.dart';
import 'package:agent_app_belle_house_immobilier/screens/houses/house_list.dart';
import 'package:agent_app_belle_house_immobilier/screens/houses/profile/profile_screen.dart';
import 'package:agent_app_belle_house_immobilier/screens/houses/profile/settings_screen.dart';
import 'package:agent_app_belle_house_immobilier/screens/lands/create_land.dart';
import 'package:agent_app_belle_house_immobilier/screens/lands/edit_land.dart';
import 'package:agent_app_belle_house_immobilier/screens/lands/land_list.dart';
import 'package:flutter/material.dart';

// Screens
import '../screens/dashboard/dashboard_screen.dart';

class AppRoutes {
  // Route names
  static const String splash = '/';
  static const String login = '/login';
  static const String dashboard = '/dashboard';
  static const String houses = '/houses';
  static const String addHouse = '/add-house';
  static const String editHouse = '/edit-house';
  static const String lands = '/lands';
  static const String addLand = '/add-land';
  static const String editLand = '/edit-land';
  static const String profile = '/profile';
  static const String settings = '/settings';

  // Routes map
  static Map<String, WidgetBuilder> get routes => {
        login: (context) => const LoginScreen(),
        dashboard: (context) => const DashboardScreen(),
        houses: (context) => const HousesListScreen(),
        addHouse: (context) => const AddHouseScreen(),
        editHouse: (context) => const EditHouseScreen(
              house: null,
            ),
        lands: (context) => const LandsListScreen(),
        addLand: (context) => const AddLandScreen(),
        editLand: (context) => const EditLandScreen(
              land: null,
            ),
        profile: (context) => const ProfileScreen(),
        settings: (context) => const SettingsScreen(),
      };

  // Generate route (for dynamic routes with arguments)
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case editHouse:
        if (settings.arguments is Map<String, dynamic>) {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (context) => EditHouseScreen(house: args['house']),
          );
        }
        return _errorRoute();

      case editLand:
        if (settings.arguments is Map<String, dynamic>) {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (context) => EditLandScreen(land: args['land']),
          );
        }
        return _errorRoute();

      default:
        return null;
    }
  }

  // Error route
  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (context) => Scaffold(
        appBar: AppBar(title: const Text('Erreur')),
        body: const Center(
          child: Text('Page non trouvée'),
        ),
      ),
    );
  }

  // Navigation helper methods
  static Future<void> pushAndClearStack(
      BuildContext context, String routeName) {
    return Navigator.pushNamedAndRemoveUntil(
      context,
      routeName,
      (route) => false,
    );
  }

  static Future<void> pushReplacement(BuildContext context, String routeName) {
    return Navigator.pushReplacementNamed(context, routeName);
  }

  static Future<T?> push<T>(BuildContext context, String routeName,
      {Object? arguments}) {
    return Navigator.pushNamed<T>(context, routeName, arguments: arguments);
  }

  static void pop<T>(BuildContext context, [T? result]) {
    Navigator.pop<T>(context, result);
  }

  static bool canPop(BuildContext context) {
    return Navigator.canPop(context);
  }
}
