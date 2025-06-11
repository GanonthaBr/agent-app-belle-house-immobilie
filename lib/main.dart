import 'package:agent_app_belle_house_immobilier/screens/auth/login.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// Providers
import 'providers/auth_provider.dart';
import 'providers/house_provider.dart';
import 'providers/land_provider.dart';
import 'providers/loading_provider.dart';
// Screens
import 'screens/dashboard/dashboard_screen.dart';
// Utils
import 'utils/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables

  // await dotenv.load(fileName: ".env");

  runApp(const RealEstateAdminApp());
}

class RealEstateAdminApp extends StatelessWidget {
  const RealEstateAdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => HouseProvider()),
        ChangeNotifierProvider(create: (_) => LandProvider()),
        ChangeNotifierProvider(create: (_) => LoadingProvider()),
      ],
      child: MaterialApp(
        title: 'Real Estate Admin',
        // theme: AppTheme.lightTheme,
        debugShowCheckedModeBanner: false,
        initialRoute: AppRoutes.splash,
        routes: AppRoutes.routes,
        home: const AuthWrapper(),
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        // Check if user is logged in
        if (authProvider.isLoggedIn) {
          return const DashboardScreen();
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}
