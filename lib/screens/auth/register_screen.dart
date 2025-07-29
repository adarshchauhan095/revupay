// lib/screens/auth/register_screen.dart
import 'package:flutter/material.dart';

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
//                       return 'Name is required';
//                     }
//                     if (value!.length < 2) {
//                       return 'Name must be at least 2 characters';
//                     }
//                     return null;
//                   },
//                 ),
//
//                 SizedBox(height: 20),
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
// }


// lib/screens/auth/register_screen.dart
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import '../../models/user_model.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../../utils/constants.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final AuthController _authController = Get.find();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  UserRole _selectedRole = UserRole.user;

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
                SizedBox(height: 20),

                // Header
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
                          Icons.person_add,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                      SizedBox(height: 24),
                      Text(
                        'Create Account',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Join our review marketplace community',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 32),

                // Role Selection
                Text(
                  'Account Type',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 12),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: UserRole.values.map((role) {
                      return RadioListTile<UserRole>(
                        title: Text(_getRoleTitle(role)),
                        subtitle: Text(_getRoleDescription(role)),
                        value: role,
                        groupValue: _selectedRole,
                        onChanged: (value) {
                          setState(() {
                            _selectedRole = value!;
                          });
                        },
                        activeColor: AppColors.primary,
                      );
                    }).toList(),
                  ),
                ),

                SizedBox(height: 24),

                // Name Field
                CustomTextField(
                  controller: _nameController,
                  label: 'Full Name',
                  hint: 'Enter your full name',
                  prefixIcon: Icons.person_outline,
                  validator: (value) {
                    if (value?.isEmpty == true) {
                      return 'Name is required';
                    }
                    if (value!.length < 2) {
                      return 'Name must be at least 2 characters';
                    }
                    return null;
                  },
                ),

                SizedBox(height: 16),

                // Email Field
                CustomTextField(
                  controller: _emailController,
                  label: 'Email Address',
                  hint: 'Enter your email',
                  prefixIcon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value?.isEmpty == true) {
                      return 'Email is required';
                    }
                    if (!GetUtils.isEmail(value!)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),

                SizedBox(height: 16),

                // Phone Field (Optional)
                CustomTextField(
                  controller: _phoneController,
                  label: 'Phone Number (Optional)',
                  hint: 'Enter your phone number',
                  prefixIcon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value?.isNotEmpty == true && value!.length < 10) {
                      return 'Please enter a valid phone number';
                    }
                    return null;
                  },
                ),

                SizedBox(height: 16),

                // Password Field
                CustomTextField(
                  controller: _passwordController,
                  label: 'Password',
                  hint: 'Enter your password',
                  prefixIcon: Icons.lock_outline,
                  obscureText: _obscurePassword,
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
                ),

                SizedBox(height: 16),

                // Confirm Password Field
                CustomTextField(
                  controller: _confirmPasswordController,
                  label: 'Confirm Password',
                  hint: 'Confirm your password',
                  prefixIcon: Icons.lock_outline,
                  obscureText: _obscureConfirmPassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirmPassword ? Icons.visibility : Icons.visibility_off,
                      color: AppColors.textSecondary,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      });
                    },
                  ),
                  validator: (value) {
                    if (value?.isEmpty == true) {
                      return 'Please confirm your password';
                    }
                    if (value != _passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),

                SizedBox(height: 32),

                // Register Button
                Obx(() => CustomButton(
                  text: 'Create Account',
                  isLoading: _authController.isLoading,
                  onPressed: _register,
                )),

                SizedBox(height: 24),

                // Sign In Link
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an account? ',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      TextButton(
                        onPressed: () => Get.to(() => LoginScreen()),
                        child: Text(
                          'Sign In',
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
                      text: 'By creating an account, you agree to our ',
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

  String _getRoleTitle(UserRole role) {
    switch (role) {
      case UserRole.user:
        return 'Regular User';
      case UserRole.company:
        return 'Business/Company';
      case UserRole.admin:
        return 'Administrator';
    }
  }

  String _getRoleDescription(UserRole role) {
    switch (role) {
      case UserRole.user:
        return 'Write reviews and earn money';
      case UserRole.company:
        return 'Get reviews for your business';
      case UserRole.admin:
        return 'Manage platform operations';
    }
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    final success = await _authController.register(
      email: _emailController.text.trim(),
      password: _passwordController.text,
      name: _nameController.text.trim(),
      role: _selectedRole,
      phone: _phoneController.text.trim().isEmpty ? null : _phoneController.text.trim(),
    );

    if (success) {
      // Navigate based on role after successful registration
      _navigateBasedOnRole();
    }
  }

  void _navigateBasedOnRole() {
    switch (_selectedRole) {
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

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
}