import 'package:acadly/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:acadly/app/common/theme/colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }


  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Login',
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
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            Row(
              children: [
                Expanded(child: Text(''),),
                TextButton(
                    onPressed: (){},
                    child: Text('Forgot Password?', style: Theme.of(context).textTheme.bodyMedium,)),
              ],
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: isLoading ? null : () async {
                setState(() => isLoading = true);

                if (emailController.text.isEmpty || passwordController.text.isEmpty) {
                  _showSnackBar("Please fill all fields");
                  setState(() => isLoading = false);
                  return;
                }

                try {
                  final res = await ApiService.login(
                    emailController.text.trim(),
                    passwordController.text.trim(),
                  );

                  if (!mounted) return;

                  if (res['success'] == true) {
                    _showSnackBar("Login Successful");
                    Navigator.pushReplacementNamed(context, '/home');
                  } else {
                    _showSnackBar(res['message'] ?? "Invalid email or password!");
                  }
                } catch (e) {
                  String errorMsg = "Something went wrong. Please try again.";
                  if (e.toString().contains("SocketException")) {
                    errorMsg = "No Internet connection. Please check your network.";
                  } else if (e.toString().contains("Timeout")) {
                    errorMsg = "Server is taking too long. Try again later.";
                  }
                  _showSnackBar(errorMsg);
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
              child: Text(
                'Login',
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Don't have an account?"),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/register');
                  },
                  child: Text(
                    'Register',
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
