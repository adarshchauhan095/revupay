// lib/app/modules/auth/views/login_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../controllers/auth_controller.dart';

class LoginView extends GetView<AuthController> {
  final _formKey = GlobalKey<FormState>();
  final _identifierController = TextEditingController();
  final _passwordController = TextEditingController();

  LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final role = Get.arguments as String;

    return Scaffold(
      appBar: AppBar(
        title: Text('${role.capitalize} Login'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _getRoleIcon(role),
                    size: 80,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 32),
                  TextFormField(
                    controller: _identifierController,
                    decoration: const InputDecoration(
                      labelText: 'Email or Phone',
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value?.isEmpty == true) {
                        return 'Please enter email or phone';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      prefixIcon: Icon(Icons.lock),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value?.isEmpty == true) {
                        return 'Please enter password';
                      }
                      return null;
                    },
                    onFieldSubmitted: (v) {
                      _handleLogin(role);
                    },
                  ),
                  const SizedBox(height: 24),
                  Obx(
                    () => SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: controller.isLoading.value
                            ? null
                            : () => _handleLogin(role),
                        child: controller.isLoading.value
                            ? const CircularProgressIndicator()
                            : const Text('Login'),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: TextButton(
                      onPressed: () {
                        Get.toNamed(Routes.REGISTER, arguments: role);
                      },
                      child: const Text("Don't have an account? Register here"),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Test Credentials:\n${_getTestCredentials(role)}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withOpacity(0.6),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  IconData _getRoleIcon(String role) {
    switch (role) {
      case 'company':
        return Icons.business;
      case 'user':
        return Icons.person;
      case 'admin':
        return Icons.admin_panel_settings;
      default:
        return Icons.person;
    }
  }

  String _getTestCredentials(String role) {
    switch (role) {
      case 'company':
        return 'Email: company@gmail.com\nPassword: Yopmail@123';
      case 'user':
        return 'Email: user@gmail.com\nPassword: Yopmail@123';
      case 'admin':
        return 'Email: admin@gmail.com\nPassword: Yopmail@123';
      default:
        return '';
    }
  }

  void _handleLogin(String role) {
    if (_formKey.currentState?.validate() == true) {
      controller.login(
        _identifierController.text,
        _passwordController.text,
        role,
      );
    }
  }
}
