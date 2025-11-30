import 'package:flutter/material.dart';
import 'register_screen.dart';
import '../theme/app_design.dart';

class LoginScreen extends StatefulWidget {
  final Function(String, String) onLogin;

  const LoginScreen({super.key, required this.onLogin});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      await Future.delayed(const Duration(seconds: 1));
      widget.onLogin(_emailController.text, _passwordController.text);
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: AppDesign.mainGradient,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: screenHeight - MediaQuery.of(context).padding.top,
              ),
              child: IntrinsicHeight(
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: Padding(
                      padding: const EdgeInsets.all(AppDesign.paddingL),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              const SizedBox(height: 40),
                              // Logo animé
                              Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                  boxShadow: AppDesign.shadowLarge,
                                ),
                                child: const Icon(
                                  Icons.school_rounded,
                                  size: 60,
                                  color: AppDesign.primaryGradient1,
                                ),
                              ),
                              const SizedBox(height: 30),
                              // Titre
                              const Text(
                                'EMIAGE',
                                style: TextStyle(
                                  fontSize: 36,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                  letterSpacing: 2,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Bienvenue',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white.withValues(alpha: 0.8),
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              const SizedBox(height: 50),
                              // Formulaire
                              Form(
                                key: _formKey,
                                child: Column(
                                  children: [
                                    // Email
                                    TextFormField(
                                      controller: _emailController,
                                      keyboardType: TextInputType.emailAddress,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      decoration: InputDecoration(
                                        hintText: 'Email ou ID permanent',
                                        hintStyle: TextStyle(
                                          color: Colors.white.withValues(alpha: 0.6),
                                        ),
                                        prefixIcon: Icon(
                                          Icons.mail_rounded,
                                          color: Colors.white.withValues(alpha: 0.7),
                                        ),
                                        filled: true,
                                        fillColor: Colors.white.withValues(alpha: 0.12),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(AppDesign.radiusL),
                                          borderSide: BorderSide(
                                            color: Colors.white.withValues(alpha: 0.2),
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(AppDesign.radiusL),
                                          borderSide: BorderSide(
                                            color: Colors.white.withValues(alpha: 0.2),
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(AppDesign.radiusL),
                                          borderSide: const BorderSide(
                                            color: Colors.white,
                                            width: 2,
                                          ),
                                        ),
                                        contentPadding: const EdgeInsets.symmetric(
                                          horizontal: AppDesign.paddingL,
                                          vertical: AppDesign.paddingM,
                                        ),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Veuillez entrer votre email';
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 16),
                                    // Mot de passe
                                    TextFormField(
                                      controller: _passwordController,
                                      obscureText: _obscurePassword,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      decoration: InputDecoration(
                                        hintText: 'Mot de passe',
                                        hintStyle: TextStyle(
                                          color: Colors.white.withValues(alpha: 0.6),
                                        ),
                                        prefixIcon: Icon(
                                          Icons.lock_rounded,
                                          color: Colors.white.withValues(alpha: 0.7),
                                        ),
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                            _obscurePassword
                                                ? Icons.visibility_off_rounded
                                                : Icons.visibility_rounded,
                                            color: Colors.white.withValues(alpha: 0.7),
                                          ),
                                          onPressed: () {
                                            setState(() =>
                                                _obscurePassword = !_obscurePassword);
                                          },
                                        ),
                                        filled: true,
                                        fillColor: Colors.white.withValues(alpha: 0.12),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(AppDesign.radiusL),
                                          borderSide: BorderSide(
                                            color: Colors.white.withValues(alpha: 0.2),
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(AppDesign.radiusL),
                                          borderSide: BorderSide(
                                            color: Colors.white.withValues(alpha: 0.2),
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(AppDesign.radiusL),
                                          borderSide: const BorderSide(
                                            color: Colors.white,
                                            width: 2,
                                          ),
                                        ),
                                        contentPadding: const EdgeInsets.symmetric(
                                          horizontal: AppDesign.paddingL,
                                          vertical: AppDesign.paddingM,
                                        ),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Veuillez entrer votre mot de passe';
                                        }
                                        if (value.length < 6) {
                                          return 'Minimum 6 caractères';
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 24),
                                    // Bouton de connexion
                                    SizedBox(
                                      width: double.infinity,
                                      height: 56,
                                      child: ElevatedButton(
                                        onPressed: _isLoading ? null : _handleLogin,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.white,
                                          disabledBackgroundColor: Colors.white.withValues(alpha: 0.5),
                                          elevation: 0,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(AppDesign.radiusL),
                                          ),
                                        ),
                                        child: _isLoading
                                            ? const SizedBox(
                                                height: 24,
                                                width: 24,
                                                child: CircularProgressIndicator(
                                                  strokeWidth: 2.5,
                                                  valueColor: AlwaysStoppedAnimation<Color>(
                                                    AppDesign.primaryGradient1,
                                                  ),
                                                ),
                                              )
                                            : const Text(
                                                'Se Connecter',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w700,
                                                  color: AppDesign.primaryGradient1,
                                                  letterSpacing: 0.5,
                                                ),
                                              ),
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    // Divider
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Divider(
                                            color: Colors.white.withValues(alpha: 0.3),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.symmetric(horizontal: 12),
                                          child: Text(
                                            'ou',
                                            style: TextStyle(
                                              color: Colors.white.withValues(alpha: 0.7),
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Divider(
                                            color: Colors.white.withValues(alpha: 0.3),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 20),
                                    // Bouton d'inscription
                                    SizedBox(
                                      width: double.infinity,
                                      height: 56,
                                      child: OutlinedButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const RegisterScreen(),
                                            ),
                                          );
                                        },
                                        style: OutlinedButton.styleFrom(
                                          side: const BorderSide(
                                            color: Colors.white,
                                            width: 2,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(AppDesign.radiusL),
                                          ),
                                        ),
                                        child: const Text(
                                          'Créer un compte',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          // Footer
                          Column(
                            children: [
                              TextButton(
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Fonctionnalité en développement'),
                                    ),
                                  );
                                },
                                child: Text(
                                  'Mot de passe oublié ?',
                                  style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.8),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Test: test@emiage.com / password123',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white.withValues(alpha: 0.5),
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
