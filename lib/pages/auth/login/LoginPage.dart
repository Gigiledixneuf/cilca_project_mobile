import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odc_mobile_template/pages/ui/mainNavigation/mainNavigation.dart';

import '../../../business/models/user/authentication.dart';
import '../../../main.dart';
import '../../../utils/navigationUtils.dart';
import '../../home/homePage.dart';
import 'LoginContrl.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final TextEditingController _username = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    final loginState = ref.watch(LoginCtrlProvider);
    final isLoading = loginState.isLoading;
    final navigation = getIt.get<NavigationUtils>();

    if (loginState.user != null && loginState.successMessage != null) {
      Future.delayed(Duration.zero, () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MainNavigationPage()),
        );
      });
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF4F1FA), // Violet très clair
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Form(
                      key: _formKey,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 32),

                          // Logo de l'entreprise
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF59398C), Color(0xFF987FBA)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF201446).withOpacity(0.3),
                                  blurRadius: 20,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Image.asset('assets/orange_logo.png'),
                          ),
                          const SizedBox(height: 24),

                          const Text(
                            'Connectez-vous',
                            style: TextStyle(
                              color: Color(0xFF201446),
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 8),

                          Text(
                            'Entrez vos informations pour continuer',
                            style: TextStyle(
                              color: const Color(0xFF59398C).withOpacity(0.8),
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 32),

                          if (loginState.errorMessage != null)
                            _buildMessageBox(
                              loginState.errorMessage!,
                              Colors.red.shade600,
                                  () => ref.read(LoginCtrlProvider.notifier).resetMessages(),
                            ),

                          if (loginState.successMessage != null)
                            _buildMessageBox(
                              loginState.successMessage!,
                              Colors.green.shade600,
                                  () => ref.read(LoginCtrlProvider.notifier).resetMessages(),
                            ),

                          _buildModernTextField(
                            controller: _username,
                            label: "Nom d'utilisateur",
                            icon: Icons.person_outline,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return "Le nom d'utilisateur est requis";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),

                          _buildModernTextField(
                            controller: _passwordController,
                            label: 'Mot de passe',
                            icon: Icons.lock_outline,
                            obscureText: _obscurePassword,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword ? Icons.visibility : Icons.visibility_off,
                                color: const Color(0xFF987FBA),
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return "Le mot de passe est requis";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 30),

                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              onPressed: isLoading
                                  ? null
                                  : () async {
                                FocusScope.of(context).unfocus();
                                if (_formKey.currentState!.validate()) {
                                  final ctrl = ref.read(LoginCtrlProvider.notifier);

                                  final data = Authentication(
                                    username: _username.text.trim(),
                                    password: _passwordController.text.trim(),
                                  );
                                  final res = await ctrl.loginUser(data);

                                  if (res == true) {
                                    Future.delayed(const Duration(seconds: 2), () {
                                      navigation.replace('/public/ui/mainNavigation');
                                    });
                                  }
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF59398C),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                elevation: 0,
                              ),
                              child: isLoading
                                  ? const CircularProgressIndicator(color: Colors.white)
                                  : const Text(
                                'Se connecter',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),

                          TextButton(
                            onPressed: () {
                              navigation.replace('/public/auth/registerPage');
                            },
                            child: const Text.rich(
                              TextSpan(
                                text: "Vous n'avez pas de compte ? ",
                                style: TextStyle(color: Color(0xFF201446)),
                                children: [
                                  TextSpan(
                                    text: 'S\'inscrire',
                                    style: TextStyle(
                                      color: Color(0xFF59398C),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 32),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  /// Message d'erreur ou succès
  Widget _buildMessageBox(String msg, Color color, VoidCallback onClose) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color),
      ),
      child: Row(
        children: [
          Icon(
            color == Colors.red.shade600
                ? Icons.error_outline
                : Icons.check_circle_outline,
            color: color,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(msg, style: TextStyle(color: color)),
          ),
          IconButton(
            icon: Icon(Icons.close, color: color),
            onPressed: onClose,
          ),
        ],
      ),
    );
  }

  /// Champ de saisie stylisé
  Widget _buildModernTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscureText = false,
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0xFF59398C)),
        filled: true,
        fillColor: const Color(0xFFF4F1FA),
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFD9D0E3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFD9D0E3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFF59398C), width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.red.shade400, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.red.shade400, width: 2),
        ),
      ),
    );
  }
}
