import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/transaction_provider.dart';
import 'providers/category_provider.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/home_screen.dart';
import 'screens/transaction_form_screen.dart';
import 'screens/category_management_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => TransactionProvider()),
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
      ],
      child: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          return MaterialApp(
            title: 'Finance Tracker',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.teal,
                brightness: Brightness.light,
              ),
              useMaterial3: true,
              appBarTheme: const AppBarTheme(
                centerTitle: true,
                elevation: 0,
              ),
            ),
            // Set initial route based on authentication state (Requirements 1.5, 2.1, 2.4)
            initialRoute: authProvider.currentUser != null ? '/home' : '/login',
            // Define named routes for all screens
            routes: {
              '/login': (context) => const LoginScreen(),
              '/register': (context) => const RegisterScreen(),
              '/home': (context) => const HomeScreen(),
              '/transaction-form': (context) => const TransactionFormScreen(),
              '/category-management': (context) => const CategoryManagementScreen(),
            },
            // Route guard for authentication
            onGenerateRoute: (settings) {
              // Check if user is trying to access protected routes
              if (settings.name == '/home' ||
                  settings.name == '/transaction-form' ||
                  settings.name == '/category-management') {
                // If not authenticated, redirect to login
                if (authProvider.currentUser == null) {
                  return MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  );
                }
              }
              
              // If user is authenticated and trying to access login/register, redirect to home
              if (settings.name == '/login' || settings.name == '/register') {
                if (authProvider.currentUser != null) {
                  return MaterialPageRoute(
                    builder: (context) => const HomeScreen(),
                  );
                }
              }
              
              return null; // Let the default routes handle it
            },
          );
        },
      ),
    );
  }
}
