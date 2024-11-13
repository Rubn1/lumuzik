import 'package:flutter/material.dart';
import 'package:lumuzik/presentation/auth/pages/AuthService.dart';
import 'package:lumuzik/core/configs/theme/app_theme.dart';
import 'package:lumuzik/core/configs/theme/app_colors.dart';
import 'package:lumuzik/presentation/auth/pages/HomePag.dart';
import 'package:lumuzik/presentation/auth/pages/signup.dart';

class SignInPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  void _login(BuildContext context) async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    var user = await _authService.signInWithEmailAndPassword(email, password);

    if (user != null) {
      if (user.emailVerified) {
        // User is verified, navigate to the home page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MusicLibraryPage()),
        );
      } else {
        // User is not verified, show a snackbar and send a verification email
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please verify your email to continue.")),
        );
        await _authService.sendEmailVerification();
        // Navigate to the sign-in page after email verification
        Navigator.pushReplacementNamed(context, '/SignInPage');
      }
    } else {
      // Login failed, show an error snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Login failed. Please check your credentials.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final backgroundColor = brightness == Brightness.light 
        ? Colors.white 
        : AppColors.darkBackground;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 60),
            Text('Login', style: AppTheme.headingStyle),
            const SizedBox(height: 8),
            Text(
              'Please sign in to continue.',
              style: AppTheme.subheadingStyle
            ),
            const SizedBox(height: 40),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(
                  Icons.email_outlined,
                  color: brightness == Brightness.light 
                      ? Colors.grey 
                      : Colors.grey[400]
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                prefixIcon: Icon(
                  Icons.lock_outline,
                  color: brightness == Brightness.light 
                      ? Colors.grey 
                      : Colors.grey[400]
                ),
                suffixText: 'FORGOT',
                suffixStyle: TextStyle(color: AppColors.primary),
              ),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _login(context),
                child: Text('LOGIN', style: AppTheme.buttonTextStyle),
              ),
            ),
            const Spacer(),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account?",
                    style: AppTheme.subheadingStyle
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => SignupPage()),
                   );
                      
                    },
                    child: Text(
                      'Sign up',
                      style: TextStyle(color: AppColors.primary)
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}