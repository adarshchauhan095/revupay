// lib/screens/auth/login_screen.dart
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../controllers/auth_controller.dart';
// import '../../widgets/custom_text_field.dart';
// import '../../widgets/custom_button.dart' hide IconButton;
// import '../../utils/constants.dart';
// import 'register_screen.dart';
//
// class LoginScreen extends StatefulWidget {
//   @override
//   _LoginScreenState createState() => _LoginScreenState();
// }
//
// class _LoginScreenState extends State<LoginScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final AuthController _authController = Get.find();
//
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//
//   bool _obscurePassword = true;
//   bool _rememberMe = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _loadSavedCredentials();
//   }
//
//   void _loadSavedCredentials() async {
//     // Load saved email if remember me was checked
//     // Implementation depends on SharedPreferences
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: EdgeInsets.all(24),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 SizedBox(height: 40),
//
//                 // Logo and Header
//                 Center(
//                   child: Column(
//                     children: [
//                       Container(
//                         height: 80,
//                         width: 80,
//                         decoration: BoxDecoration(
//                           color: AppColors.primary,
//                           borderRadius: BorderRadius.circular(20),
//                         ),
//                         child: Icon(
//                           Icons.rate_review,
//                           color: Colors.white,
//                           size: 40,
//                         ),
//                       ),
//                       SizedBox(height: 24),
//                       Text(
//                         'Welcome Back!',
//                         style: Theme.of(context).textTheme.headlineMedium?.copyWith(
//                           fontWeight: FontWeight.bold,
//                           color: AppColors.textPrimary,
//                         ),
//                       ),
//                       SizedBox(height: 8),
//                       Text(
//                         'Sign in to continue earning from reviews',
//                         style: Theme.of(context).textTheme.bodyLarge?.copyWith(
//                           color: AppColors.textSecondary,
//                         ),
//                         textAlign: TextAlign.center,
//                       ),
//                     ],
//                   ),
//                 ),
//
//                 SizedBox(height: 48),
//
//                 // Email Field
//                 CustomTextField(
//                   controller: _emailController,
//                   label: 'Email Address',
//                   hint: 'Enter your email',
//                   prefixIcon: Icons.email_outlined,
//                   keyboardType: TextInputType.emailAddress,
//                   validator: (value) {
//                     if (value?.isEmpty == true) {
//                       return 'Email is required';
//                     }
//                     if (!GetUtils.isEmail(value!)) {
//                       return 'Please enter a valid email';
//                     }
//                     return null;
//                   },
//                 ),
//
//                 SizedBox(height: 20),
//
//                 // Password Field
//                 CustomTextField(
//                   controller: _passwordController,
//                   label: 'Password',
//                   hint: 'Enter your password',
//                   prefixIcon: Icons.lock_outline,
//                   obscureText: _obscurePassword,
//                   suffixIcon: IconButton(
//                     icon: Icon(
//                       _obscurePassword ? Icons.visibility : Icons.visibility_off,
//                       color: AppColors.textSecondary,
//                     ),
//                     onPressed: () {
//                       setState(() {
//                         _obscurePassword = !_obscurePassword;
//                       });
//                     },
//                   ),
//                   validator: (value) {
//                     if (value?.isEmpty == true) {
//                       return 'Password is required';
//                     }
//                     if (value!.length < 6) {
//                       return 'Password must be at least 6 characters';
//                     }
//                     return null;
//                   },
//                 ),
//
//                 SizedBox(height: 16),
//
//                 // Remember Me & Forgot Password
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Row(
//                       children: [
//                         Checkbox(
//                           value: _rememberMe,
//                           onChanged: (value) {
//                             setState(() {
//                               _rememberMe = value ?? false;
//                             });
//                           },
//                           activeColor: AppColors.primary,
//                         ),
//                         Text(
//                           'Remember me',
//                           style: Theme.of(context).textTheme.bodyMedium,
//                         ),
//                       ],
//                     ),
//                     TextButton(
//                       onPressed: _showForgotPasswordDialog,
//                       child: Text(
//                         'Forgot Password?',
//                         style: TextStyle(
//                           color: AppColors.primary,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//
//                 SizedBox(height: 32),
//
//                 // Login Button
//                 Obx(() => CustomButton(
//                   text: 'Sign In',
//                   isLoading: _authController.isLoading,
//                   onPressed: _login,
//                 )),
//
//                 SizedBox(height: 24),
//
//                 // Divider
//                 Row(
//                   children: [
//                     Expanded(child: Divider()),
//                     Padding(
//                       padding: EdgeInsets.symmetric(horizontal: 16),
//                       child: Text(
//                         'OR',
//                         style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//                           color: AppColors.textSecondary,
//                         ),
//                       ),
//                     ),
//                     Expanded(child: Divider()),
//                   ],
//                 ),
//
//                 SizedBox(height: 24),
//
//                 // Phone Login Button
//                 OutlinedButton.icon(
//                   onPressed: _showPhoneLoginDialog,
//                   icon: Icon(Icons.phone, color: AppColors.primary),
//                   label: Text(
//                     'Continue with Phone',
//                     style: TextStyle(color: AppColors.primary),
//                   ),
//                   style: OutlinedButton.styleFrom(
//                     side: BorderSide(color: AppColors.primary),
//                     minimumSize: Size(double.infinity, 50),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                   ),
//                 ),
//
//                 SizedBox(height: 32),
//
//                 // Sign Up Link
//                 Center(
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Text(
//                         "Don't have an account? ",
//                         style: Theme.of(context).textTheme.bodyMedium,
//                       ),
//                       TextButton(
//                         onPressed: () => Get.to(() => RegisterScreen()),
//                         child: Text(
//                           'Sign Up',
//                           style: TextStyle(
//                             color: AppColors.primary,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//
//                 SizedBox(height: 20),
//
//                 // Terms & Privacy
//                 Center(
//                   child: Text.rich(
//                     TextSpan(
//                       text: 'By continuing, you agree to our ',
//                       style: Theme.of(context).textTheme.bodySmall?.copyWith(
//                         color: AppColors.textSecondary,
//                       ),
//                       children: [
//                         TextSpan(
//                           text: 'Terms of Service',
//                           style: TextStyle(
//                             color: AppColors.primary,
//                             decoration: TextDecoration.underline,
//                           ),
//                         ),
//                         TextSpan(text: ' and '),
//                         TextSpan(
//                           text: 'Privacy Policy',
//                           style: TextStyle(
//                             color: AppColors.primary,
//                             decoration: TextDecoration.underline,
//                           ),
//                         ),
//                       ],
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Future<void> _login() async {
//     if (!_formKey.currentState!.validate()) return;
//
//     final success = await _authController.login(
//       email: _emailController.text.trim(),
//       password: _passwordController.text,
//     );
//
//     if (success && _rememberMe) {
//       // Save credentials if remember me is checked
//       // Implementation depends on SharedPreferences
//     }
//   }
//
//   void _showForgotPasswordDialog() {
//     final TextEditingController emailController = TextEditingController();
//
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text('Reset Password'),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Text('Enter your email address to receive a password reset link.'),
//             SizedBox(height: 16),
//             TextField(
//               controller: emailController,
//               decoration: InputDecoration(
//                 labelText: 'Email Address',
//                 border: OutlineInputBorder(),
//               ),
//               keyboardType: TextInputType.emailAddress,
//             ),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Get.back(),
//             child: Text('Cancel'),
//           ),
//           ElevatedButton(
//             onPressed: () async {
//               if (emailController.text.trim().isEmpty) {
//                 Get.snackbar('Error', 'Please enter your email address');
//                 return;
//               }
//
//               Get.back();
//               await _authController.resetPassword(emailController.text.trim());
//             },
//             child: Text('Send Reset Link'),
//           ),
//         ],
//       ),
//     );
//   }
//
//   void _showPhoneLoginDialog() {
//     final TextEditingController phoneController = TextEditingController();
//
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text('Phone Login'),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Text('Enter your phone number to receive an OTP.'),
//             SizedBox(height: 16),
//             TextField(
//               controller: phoneController,
//               decoration: InputDecoration(
//                 labelText: 'Phone Number',
//                 border: OutlineInputBorder(),
//                 prefixText: '+91 ',
//               ),
//               keyboardType: TextInputType.phone,
//               maxLength: 10,
//             ),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Get.back(),
//             child: Text('Cancel'),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               Get.back();
//               Get.snackbar('Info', 'Phone authentication coming soon!');
//             },
//             child: Text('Send OTP'),
//           ),
//         ],
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     _emailController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }
// }


// lib/screens/auth/login_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import '../../models/user_model.dart';
import '../../services/storage_service.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/custom_button.dart';
import '../../utils/constants.dart';
import 'register_screen.dart';
// lib/screens/auth/login_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import '../../models/user_model.dart';
import '../../services/storage_service.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/custom_button.dart';
import '../../utils/constants.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final AuthController _authController = Get.find();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _rememberMe = false;

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
  }

  void _loadSavedCredentials() async {
    final rememberMe = await StorageService.getRememberMe();
    final email = await StorageService.getRememberedEmail();

    if (rememberMe && email != null) {
      setState(() {
        _emailController.text = email;
        _rememberMe = rememberMe;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 40),

                // Logo and Header
                Center(
                  child: Column(
                    children: [
                      Container(
                        height: 80,
                        width: 80,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Icon(
                          Icons.rate_review,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                      SizedBox(height: 24),
                      Text(
                        'Welcome Back!',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Sign in to continue earning from reviews',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 48),

                // Email Field with proper validation
                CustomTextField(
                  controller: _emailController,
                  label: 'Email Address',
                  hint: 'Enter your email',
                  prefixIcon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value?.isEmpty == true) {
                      return 'Email is required';
                    }
                    if (!GetUtils.isEmail(value!)) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                ),

                SizedBox(height: 20),

                // Password Field
                CustomTextField(
                  controller: _passwordController,
                  label: 'Password',
                  hint: 'Enter your password',
                  prefixIcon: Icons.lock_outline,
                  obscureText: _obscurePassword,
                  textInputAction: TextInputAction.done,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility : Icons.visibility_off,
                      color: AppColors.textSecondary,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                  validator: (value) {
                    if (value?.isEmpty == true) {
                      return 'Password is required';
                    }
                    if (value!.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                  onFieldSubmitted: (_) => _login(),
                ),

                SizedBox(height: 16),

                // Remember Me & Forgot Password
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Checkbox(
                          value: _rememberMe,
                          onChanged: (value) {
                            setState(() {
                              _rememberMe = value ?? false;
                            });
                          },
                          activeColor: AppColors.primary,
                        ),
                        Text(
                          'Remember me',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                    TextButton(
                      onPressed: _showForgotPasswordDialog,
                      child: Text(
                        'Forgot Password?',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 32),

                // Login Button
                Obx(() => CustomButton(
                  text: 'Sign In',
                  isLoading: _authController.isLoading,
                  onPressed: _login,
                )),

                SizedBox(height: 24),

                // Divider
                Row(
                  children: [
                    Expanded(child: Divider()),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'OR',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                    Expanded(child: Divider()),
                  ],
                ),

                SizedBox(height: 24),

                // Phone Login Button
                OutlinedButton.icon(
                  onPressed: _showPhoneLoginDialog,
                  icon: Icon(Icons.phone, color: AppColors.primary),
                  label: Text(
                    'Continue with Phone',
                    style: TextStyle(color: AppColors.primary),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: AppColors.primary),
                    minimumSize: Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),

                SizedBox(height: 24),

                // Debug button to show all users
                if (true) // Set to false in production
                  OutlinedButton(
                    onPressed: () async {
                      await StorageService.debugPrintAllUsers();
                      final emails = await StorageService.getAllRegisteredEmails();
                      Get.snackbar('Debug', 'Registered emails: ${emails.join(', ')}');
                    },
                    child: Text('Debug: Show All Users'),
                  ),

                SizedBox(height: 32),

                // Sign Up Link
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account? ",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      TextButton(
                        onPressed: () => Get.to(() => RegisterScreen()),
                        child: Text(
                          'Sign Up',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 20),

                // Terms & Privacy
                Center(
                  child: Text.rich(
                    TextSpan(
                      text: 'By continuing, you agree to our ',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      children: [
                        TextSpan(
                          text: 'Terms of Service',
                          style: TextStyle(
                            color: AppColors.primary,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                        TextSpan(text: ' and '),
                        TextSpan(
                          text: 'Privacy Policy',
                          style: TextStyle(
                            color: AppColors.primary,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    final success = await _authController.login(
      email: _emailController.text.trim(),
      password: _passwordController.text,
      rememberMe: _rememberMe,
    );

    if (success) {
      _navigateBasedOnUserRole();
    }
  }

  void _navigateBasedOnUserRole() {
    final user = _authController.currentUser;
    if (user == null) return;

    switch (user.role) {
      case UserRole.user:
        Get.offAllNamed('/user-dashboard');
        break;
      case UserRole.company:
        Get.offAllNamed('/company-dashboard');
        break;
      case UserRole.admin:
        Get.offAllNamed('/admin-dashboard');
        break;
    }
  }

  void _showForgotPasswordDialog() {
    final TextEditingController emailController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Reset Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Enter your email address to reset your password.'),
            SizedBox(height: 16),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email Address',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email_outlined),
              ),
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.done,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              String email = emailController.text.trim();

              if (email.isEmpty) {
                Get.snackbar('Error', 'Please enter your email address');
                return;
              }

              if (!GetUtils.isEmail(email)) {
                Get.snackbar('Error', 'Please enter a valid email address');
                return;
              }

              Get.back();
              bool success = await _authController.resetPassword(email);

              if (success) {
                // Show dialog with temporary password
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Password Reset'),
                    content: Text('Your password has been reset to: temp123\n\nPlease use this to login and change your password.'),
                    actions: [
                      ElevatedButton(
                        onPressed: () {
                          Get.back();
                          _emailController.text = email;
                          _passwordController.text = 'temp123';
                        },
                        child: Text('OK'),
                      ),
                    ],
                  ),
                );
              }
            },
            child: Text('Reset Password'),
          ),
        ],
      ),
    );
  }

  void _showPhoneLoginDialog() {
    final TextEditingController phoneController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Phone Login'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Enter your phone number to receive an OTP.'),
            SizedBox(height: 16),
            TextField(
              controller: phoneController,
              decoration: InputDecoration(
                labelText: 'Phone Number',
                border: OutlineInputBorder(),
                prefixText: '+91 ',
                prefixIcon: Icon(Icons.phone),
              ),
              keyboardType: TextInputType.phone,
              maxLength: 10,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (phoneController.text.length != 10) {
                Get.snackbar('Error', 'Please enter a valid 10-digit phone number');
                return;
              }
              Get.back();
              Get.snackbar('Info', 'Phone authentication coming soon!');
            },
            child: Text('Send OTP'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}