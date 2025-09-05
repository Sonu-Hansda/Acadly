import 'package:flutter/material.dart';
import 'package:acadly/app/common/theme/colors.dart';
import '../../../services/api_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  bool isLoading = false;
  void showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating , backgroundColor: AppColors.primary,),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Register',
          style: Theme.of(
            context,
          ).textTheme.displayMedium?.copyWith(color: AppColors.accent),
        ),
        backgroundColor: AppColors.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            const SizedBox(height: 16),
            TextFormField(
              obscureText: true,
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            const SizedBox(height: 16),
            TextFormField(
              obscureText: true,
              controller: confirmPasswordController,
              decoration: const InputDecoration(labelText: 'Confirm Password'),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: isLoading? null
              : ()async{
                setState(() => isLoading = true);

                if (usernameController.text.isEmpty ||
                    emailController.text.isEmpty ||
                    passwordController.text.isEmpty ||
                    confirmPasswordController.text.isEmpty) {
                  showSnack("All fields are required!");
                  setState(() => isLoading = false);
                  return;
                }

                if (passwordController.text != confirmPasswordController.text) {
                  showSnack("Passwords do not match!");
                  setState(() => isLoading = false);
                  return;
                }

                try {
                  final res = await ApiService.register(
                    usernameController.text.trim(),
                    emailController.text.trim(),
                    passwordController.text.trim(),
                  );

                  if (res['success'] == true) {
                    showSnack("Account created successfully!");
                    Navigator.pushReplacementNamed(context, '/home');
                  } else {
                    showSnack(res['message'] ?? "Registration failed!");
                  }
                } catch (e) {
                  showSnack("Error: $e");
                }

                setState(() => isLoading = false);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 50,
                  vertical: 15,
                ),
              ),
              child: isLoading
                  ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.primary,
                ),
              )
                  : Text(
                'Register',
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Already have an account?"),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Login',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
