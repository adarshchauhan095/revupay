// lib/main.dart
// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:get/get.dart';
// import 'models/user_model.dart';
// import 'screens/admin/admin_panel.dart';
// import 'screens/auth/login_screen.dart';
// import 'screens/user/user_dashboard.dart';
// import 'screens/company/company_dashboard.dart';
// import 'controllers/auth_controller.dart';
// import 'utils/constants.dart';
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   // await Firebase.initializeApp();
//
//   // Initialize controllers
//   Get.put(AuthController());
//
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp(
//       title: 'Review Marketplace',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         useMaterial3: true,
//         colorScheme: ColorScheme.fromSeed(
//           seedColor: AppColors.primary,
//           brightness: Brightness.light,
//         ),
//       ),
//       darkTheme: ThemeData(
//         useMaterial3: true,
//         colorScheme: ColorScheme.fromSeed(
//           seedColor: AppColors.primary,
//           brightness: Brightness.dark,
//         ),
//       ),
//       themeMode: ThemeMode.system,
//       home: AuthWrapper(),
//       getPages: [
//         GetPage(name: '/login', page: () => LoginScreen()),
//         GetPage(name: '/user-dashboard', page: () => UserDashboard()),
//         GetPage(name: '/company-dashboard', page: () => CompanyDashboard()),
//       ],
//     );
//   }
// }
//
// class AuthWrapper extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return GetX<AuthController>(
//       builder: (controller) {
//         if (controller.isLoading) {
//           return Scaffold(
//             body: Center(
//               child: CircularProgressIndicator(),
//             ),
//           );
//         }
//
//         if (controller.currentUser == null) {
//           return LoginScreen();
//         }
//
//         // Route based on user role
//         final userRole = controller.currentUserData?.role;
//         switch (userRole) {
//           case UserRole.company:
//             return CompanyDashboard();
//           case UserRole.admin:
//             return AdminPanel();
//           default:
//             return UserDashboard();
//         }
//       },
//     );
//   }
// }

// lib/main.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'models/user_model.dart';
import 'screens/admin/admin_panel.dart';
import 'screens/auth/login_screen.dart';
import 'screens/user/user_dashboard.dart';
import 'screens/company/company_dashboard.dart';
import 'controllers/auth_controller.dart';
import 'services/storage_service.dart';
import 'utils/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize storage service
  await StorageService.init();

  // Initialize controllers
  Get.put(AuthController());

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Review Marketplace',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          brightness: Brightness.light,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          brightness: Brightness.dark,
        ),
      ),
      themeMode: ThemeMode.system,
      home: AuthWrapper(),
      getPages: [
        GetPage(name: '/login', page: () => LoginScreen()),
        GetPage(name: '/user-dashboard', page: () => UserDashboard()),
        GetPage(name: '/company-dashboard', page: () => CompanyDashboard()),
        GetPage(name: '/admin-dashboard', page: () => AdminPanel()),
      ],
    );
  }
}

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetX<AuthController>(
      builder: (controller) {
        if (controller.isLoading) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: AppColors.primary,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Loading...',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
          );
        }

        if (!controller.isLoggedIn) {
          return LoginScreen();
        }

        // Route based on user role
        final userRole = controller.currentUser?.role;
        switch (userRole) {
          case UserRole.company:
            return CompanyDashboard();
          case UserRole.admin:
            return AdminPanel();
          default:
            return UserDashboard();
        }
      },
    );
  }
}
