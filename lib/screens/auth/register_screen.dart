// // lib/screens/auth/register_screen.dart
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../controllers/auth_controller.dart';
// import '../../models/user_model.dart';
// import '../../widgets/custom_text_field.dart';
// import '../../widgets/custom_button.dart';
// import '../../utils/constants.dart';
//
// class RegisterScreen extends StatefulWidget {
//   @override
//   _RegisterScreenState createState() => _RegisterScreenState();
// }
//
// class _RegisterScreenState extends State<RegisterScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final AuthController _authController = Get.find();
//
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _phoneController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   final TextEditingController _confirmPasswordController = TextEditingController();
//
//   UserRole _selectedRole = UserRole.user;
//   bool _obscurePassword = true;
//   bool _obscureConfirmPassword = true;
//   bool _agreeToTerms = false;
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
//                 SizedBox(height: 20),
//
//                 // Header
//                 Row(
//                   children: [
//                     IconButton(
//                       onPressed: () => Get.back(),
//                       icon: Icon(Icons.arrow_back),
//                     ),
//                     Expanded(
//                       child: Center(
//                         child: Text(
//                           'Create Account',
//                           style: Theme.of(context).textTheme.headlineSmall?.copyWith(
//                             fontWeight: FontWeight.bold,
//                             color: AppColors.textPrimary,
//                           ),
//                         ),
//                       ),
//                     ),
//                     SizedBox(width: 48), // To balance the back button
//                   ],
//                 ),
//
//                 SizedBox(height: 32),
//
//                 // Account Type Selection
//                 Text(
//                   'I want to:',
//                   style: Theme.of(context).textTheme.titleMedium?.copyWith(
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//                 SizedBox(height: 16),
//
//                 Row(
//                   children: [
//                     Expanded(
//                       child: _buildRoleCard(
//                         role: UserRole.user,
//                         title: 'Earn Money',
//                         subtitle: 'Write reviews and get paid',
//                         icon: Icons.person,
//                         isSelected: _selectedRole == UserRole.user,
//                       ),
//                     ),
//                     SizedBox(width: 12),
//                     Expanded(
//                       child: _buildRoleCard(
//                         role: UserRole.company,
//                         title: 'Get Reviews',
//                         subtitle: 'Get reviews for your business',
//                         icon: Icons.business,
//                         isSelected: _selectedRole == UserRole.company,
//                       ),
//                     ),
//                   ],
//                 ),
//
//                 SizedBox(height: 32),
//
//                 // Name Field
//                 CustomTextField(
//                   controller: _nameController,
//                   label: _selectedRole == UserRole.company ? 'Business Name' : 'Full Name',
//                   hint: _selectedRole == UserRole.company ? 'Enter your business name' : 'Enter your full name',
//                   prefixIcon: _selectedRole == UserRole.company ? Icons.business : Icons.person_outline,
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
//                 // Phone Field
//                 CustomTextField(
//                   controller: _phoneController,
//                   label: 'Phone Number',
//                   hint: 'Enter your phone number',
//                   prefixIcon: Icons.phone_outlined,
//                   keyboardType: TextInputType.phone,
//                   validator: (value) {
//                     if (value?.isEmpty == true) {
//                       return 'Phone number is required';
//                     }
//                     if (value!.length < 10) {
//                       return 'Please enter a valid phone number';
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
//                   hint: 'Create a strong password',
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
//                     if (!RegExp(r'^(?=.*[a-zA-Z])(?=.*\d)').hasMatch(value)) {
//                       return 'Password must contain letters and numbers';
//                     }
//                     return null;
//                   },
//                 ),
//
//                 SizedBox(height: 20),
//
//                 // Confirm Password Field
//                 CustomTextField(
//                   controller: _confirmPasswordController,
//                   label: 'Confirm Password',
//                   hint: 'Re-enter your password',
//                   prefixIcon: Icons.lock_outline,
//                   obscureText: _obscureConfirmPassword,
//                   suffixIcon: IconButton(
//                     icon: Icon(
//                       _obscureConfirmPassword ? Icons.visibility : Icons.visibility_off,
//                       color: AppColors.textSecondary,
//                     ),
//                     onPressed: () {
//                       setState(() {
//                         _obscureConfirmPassword = !_obscureConfirmPassword;
//                       });
//                     },
//                   ),
//                   validator: (value) {
//                     if (value?.isEmpty == true) {
//                       return 'Please confirm your password';
//                     }
//                     if (value != _passwordController.text) {
//                       return 'Passwords do not match';
//                     }
//                     return null;
//                   },
//                 ),
//
//                 SizedBox(height: 24),
//
//                 // Terms and Conditions
//                 Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Checkbox(
//                       value: _agreeToTerms,
//                       onChanged: (value) {
//                         setState(() {
//                           _agreeToTerms = value ?? false;
//                         });
//                       },
//                       activeColor: AppColors.primary,
//                     ),
//                     Expanded(
//                       child: Text.rich(
//                         TextSpan(
//                           text: 'I agree to the ',
//                           style: Theme.of(context).textTheme.bodySmall,
//                           children: [
//                             TextSpan(
//                               text: 'Terms of Service',
//                               style: TextStyle(
//                                 color: AppColors.primary,
//                                 decoration: TextDecoration.underline,
//                               ),
//                             ),
//                             TextSpan(text: ' and '),
//                             TextSpan(
//                               text: 'Privacy Policy',
//                               style: TextStyle(
//                                 color: AppColors.primary,
//                                 decoration: TextDecoration.underline,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//
//                 SizedBox(height: 32),
//
//                 // Register Button
//                 Obx(() => CustomButton(
//                   text: 'Create Account',
//                   isLoading: _authController.isLoading,
//                   onPressed: _agreeToTerms ? _register : null,
//                 )),
//
//                 SizedBox(height: 24),
//
//                 // Login Link
//                 Center(
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Text(
//                         'Already have an account? ',
//                         style: Theme.of(context).textTheme.bodyMedium,
//                       ),
//                       TextButton(
//                         onPressed: () => Get.back(),
//                         child: Text(
//                           'Sign In',
//                           style: TextStyle(
//                             color: AppColors.primary,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                       ),
//                     ],
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
//   Widget _buildRoleCard({
//     required UserRole role,
//     required String title,
//     required String subtitle,
//     required IconData icon,
//     required bool isSelected,
//   }) {
//     return InkWell(
//       onTap: () {
//         setState(() {
//           _selectedRole = role;
//         });
//       },
//       child: Container(
//         padding: EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: isSelected ? AppColors.primary.withOpacity(0.1) : Colors.grey[100],
//           border: Border.all(
//             color: isSelected ? AppColors.primary : Colors.grey[300]!,
//             width: isSelected ? 2 : 1,
//           ),
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: Column(
//           children: [
//             Icon(
//               icon,
//               size: 32,
//               color: isSelected ? AppColors.primary : Colors.grey[600],
//             ),
//             SizedBox(height: 8),
//             Text(
//               title,
//               style: TextStyle(
//                 fontWeight: FontWeight.w600,
//                 color: isSelected ? AppColors.primary : Colors.grey[800],
//               ),
//             ),
//             SizedBox(height: 4),
//             Text(
//               subtitle,
//               style: TextStyle(
//                 fontSize: 12,
//                 color: Colors.grey[600],
//               ),
//               textAlign: TextAlign.center,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Future<void> _register() async {
//     if (!_formKey.currentState!.validate()) return;
//
//     if (!_agreeToTerms) {
//       Get.snackbar('Error', 'Please agree to the terms and conditions');
//       return;
//     }
//
//     final success = await _authController.register(
//       email: _emailController.text.trim(),
//       password: _passwordController.text,
//       name: _nameController.text.trim(),
//       role: _selectedRole,
//       phone: _phoneController.text.trim(),
//     );
//
//     if (success) {
//       Get.snackbar(
//         'Success',
//         _selectedRole == UserRole.company
//             ? 'Business account created successfully!'
//             : 'Account created successfully!',
//         backgroundColor: Colors.green,
//         colorText: Colors.white,
//       );
//     }
//   }
//
//   @override
//   void dispose() {
//     _nameController.dispose();
//     _emailController.dispose();
//     _phoneController.dispose();
//     _passwordController.dispose();
//     _confirmPasswordController.dispose();
//     super.dispose();
//   }
// }) {
// if (value?.isEmpty == true) {
// return 'Name is required';
// }
// if (value!.length < 2) {
// return 'Name must be at least 2 characters';
// }
// return null;
// },
// ),
//
// SizedBox(height: 20),
//
// // Email Field
// CustomTextField(
// controller: _emailController,
// label: 'Email Address',
// hint: 'Enter your email',
// prefixIcon: Icons.email_outlined,
// keyboardType: TextInputType.emailAddress,
// validator: (value