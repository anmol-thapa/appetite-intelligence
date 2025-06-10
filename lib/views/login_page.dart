import 'package:appetite_intelligence/data/constants.dart';
import 'package:appetite_intelligence/data/notifers.dart';
import 'package:appetite_intelligence/services/auth_service.dart';
import 'package:appetite_intelligence/services/ui_service.dart';
import 'package:appetite_intelligence/widgets/reusables/primary_button_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:validators/validators.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    isLoadingNotifier.value = false;
    super.dispose();
  }

  Future<void> handleLogin() async {
    isLoadingNotifier.value = true;
    FocusScope.of(context).unfocus();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (!isEmail(email) || !isAscii(password) || password.length < 6) {
      showSnackbar(context, 'Please check your fields!');
    }

    try {
      await AuthService().login(email, password);
    } on FirebaseAuthException catch (err) {
      if (mounted) {
        showSnackbar(context, err.toString());
      }
    } finally {
      isLoadingNotifier.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Login',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 32),
              finalTextField(emailController, hint: 'Email'),
              const SizedBox(height: 24),
              finalTextField(
                passwordController,
                hint: 'Password',
                obscure: true,
              ),
              const SizedBox(height: 32),
              PrimaryButton(onClick: handleLogin, text: 'Login'),
            ],
          ),
        ),
      ],
    );
  }

  Widget finalTextField(
    TextEditingController controller, {
    required String hint,
    ValueChanged<String>? onChanged,
    bool obscure = false,
  }) {
    return SizedBox(
      width: 300,
      child: TextField(
        controller: controller,
        obscureText: obscure,
        onChanged: onChanged,
        cursorColor: KColors.primaryColor,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey[600]),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade400),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: KColors.primaryColor, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }
}
