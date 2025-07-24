import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odc_mobile_template/business/models/user/registerUser.dart';
import 'package:odc_mobile_template/main.dart';
import 'package:odc_mobile_template/utils/navigationUtils.dart';

import 'RegisterCtrl.dart';
import 'RegisterState.dart';


class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final NavigationUtils navigation = getIt.get<NavigationUtils>();

  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _passwordCtrl = TextEditingController();
  final TextEditingController _confirmPasswordCtrl = TextEditingController();

  String? _selectedSexe;
  String? _selectedType;

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  final List<String> _genres = ['masculin', 'féminin', 'autre'];
  final List<String> _typesUtilisateurs = ['patient', 'proche'];

  @override
  void dispose() {
    ref.read(RegisterCtrlProvider.notifier).resetMessages();
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmPasswordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(RegisterCtrlProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      _buildHeader(),
                      Expanded(
                        child: _buildForm(state),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
      child: Column(
        children: [
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
            'Créer un compte',
            style: TextStyle(
              color: Color(0xFF201446),
              fontSize: 32,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Rejoignez notre communauté',
            style: TextStyle(color: const Color(0xFF59398C).withOpacity(0.8), fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildForm(RegisterState state) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        boxShadow: [BoxShadow(color: Color(0x0A000000), blurRadius: 10)],
      ),
      child: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (state.errorMessage != null)
              _buildMessageCard(state.errorMessage!, Icons.error_outline, Colors.red.shade600, true),
            if (state.successMessage != null)
              _buildMessageCard(state.successMessage!, Icons.check_circle_outline, Colors.green.shade600, false),

            _buildModernTextField(
              controller: _nameCtrl,
              label: 'Nom complet',
              icon: Icons.person_outline,
              validator: (value) => value!.isEmpty ? 'Veuillez entrer votre nom' : null,
            ),
            const SizedBox(height: 20),

            _buildModernTextField(
              controller: _emailCtrl,
              label: 'Adresse email',
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              validator: (value) =>
              !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value!) ? 'Email invalide' : null,
            ),
            const SizedBox(height: 20),

            _buildModernTextField(
              controller: _passwordCtrl,
              label: 'Mot de passe',
              icon: Icons.lock_outline,
              obscureText: _obscurePassword,
              suffixIcon: _togglePasswordIcon(
                    () => setState(() => _obscurePassword = !_obscurePassword),
                _obscurePassword,
              ),
              validator: (value) => value!.length < 6 ? 'Minimum 6 caractères' : null,
            ),
            const SizedBox(height: 20),

            _buildModernTextField(
              controller: _confirmPasswordCtrl,
              label: 'Confirmer le mot de passe',
              icon: Icons.lock_outline,
              obscureText: _obscureConfirmPassword,
              suffixIcon: _togglePasswordIcon(
                    () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                _obscureConfirmPassword,
              ),
              validator: (value) =>
              value != _passwordCtrl.text ? 'Les mots de passe ne correspondent pas' : null,
            ),
            const SizedBox(height: 20),

            DropdownButtonFormField<String>(
              value: _selectedSexe,
              decoration: _dropdownDecoration('Genre'),
              items: _genres.map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
              onChanged: (value) => setState(() => _selectedSexe = value),
              validator: (value) => value == null ? "Veuillez choisir un genre" : null,
            ),
            const SizedBox(height: 20),

            DropdownButtonFormField<String>(
              value: _selectedType,
              decoration: _dropdownDecoration("Vous êtes ?"),
              items:
              _typesUtilisateurs.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
              onChanged: (value) => setState(() => _selectedType = value),
              validator: (value) => value == null ? "Veuillez choisir un type d'utilisateur" : null,
            ),
            const SizedBox(height: 30),

            _buildSubmitButton(state),
            const SizedBox(height: 24),
            _buildLoginRedirect(),
          ],
        ),
      ),
    );
  }

  Widget _togglePasswordIcon(VoidCallback onTap, bool obscure) {
    return IconButton(
      icon: Icon(obscure ? Icons.visibility : Icons.visibility_off, color: Colors.grey.shade600),
      onPressed: onTap,
    );
  }

  InputDecoration _dropdownDecoration(String label) => InputDecoration(
    labelText: label,
    filled: true,
    fillColor: Colors.grey.shade50,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: Colors.grey.shade300),
    ),
  );

  Widget _buildSubmitButton(RegisterState state) {
    return SizedBox(
      height: 56,
      child: ElevatedButton(
        onPressed: state.isSubmited == true
            ? null
            : () async {
          FocusScope.of(context).unfocus();
          if (_formKey.currentState!.validate()) {
            final newUser = RegisterUser(
              name: _nameCtrl.text.trim(),
              email: _emailCtrl.text.trim(),
              password: _passwordCtrl.text.trim(),
              passwordConfirmation: _confirmPasswordCtrl.text.trim(),
              sexe: _selectedSexe ?? '',
              typeUtilisateur: _selectedType ?? '',
            );
            final result = await ref.read(RegisterCtrlProvider.notifier).register(newUser);
            if (result) {
              Future.delayed(const Duration(seconds: 2), () {
                navigation.replace('/public/auth/loginPage');
              });
            }
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF59398C), // couleur principale harmonisée
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        child: state.isSubmited == true
            ? const CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
            : const Text('S’inscrire', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildLoginRedirect() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Déjà un compte ? ', style: TextStyle(color: const Color(0xFF987FBA))),
        TextButton(
          onPressed: () {
            ref.read(RegisterCtrlProvider.notifier).resetMessages();
            navigation.replace('/public/auth/loginPage');
          },
          child: const Text('Se connecter', style: TextStyle(color: Color(0xFF201446))),
        ),
      ],
    );
  }

  Widget _buildModernTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscureText = false,
    Widget? suffixIcon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0xFF59398C)),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: const Color(0xFFF4F1FA),
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

  Widget _buildMessageCard(String message, IconData icon, Color color, bool isError) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        border: Border.all(color: color),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 8),
          Expanded(child: Text(message, style: TextStyle(color: color))),
          IconButton(
            icon: Icon(Icons.close, color: color),
            onPressed: () => ref.read(RegisterCtrlProvider.notifier).resetMessages(),
          ),
        ],
      ),
    );
  }
}
