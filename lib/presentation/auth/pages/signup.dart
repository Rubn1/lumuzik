import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lumuzik/common/widgets/appBar/appBar.dart';
import 'package:lumuzik/common/widgets/button/basic_app_button.dart';
import 'package:lumuzik/core/configs/assets/app_vectors.dart';
import 'package:lumuzik/presentation/auth/pages/SignInPage.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: _signText(context),
      appBar: AppbarPage(
        title: SvgPicture.asset(
          AppVectors.logo,
          height: 20,
          width: 20,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 50,
            horizontal: 30
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _registerText(),
              const SizedBox(height: 40),
              _buildTextField(context, 'Full Name'),
              const SizedBox(height: 20),
              _buildTextField(context, 'Your Email'),
              const SizedBox(height: 20),
              _buildTextField(context, 'Your Password', isPassword: true),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: BasicAppButton(
                  onPressed: (){},
                  title: 'Create Account'
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _registerText(){
    return const Text(
      'Register',
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 25,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildTextField(BuildContext context, String hintText, {bool isPassword = false}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.transparent,
        border: Border.all(
          color: Colors.grey.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: TextField(
        obscureText: isPassword,
        decoration: InputDecoration(
          hintText: hintText,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 15,
          ),
          hintStyle: TextStyle(
            color: Colors.grey.withOpacity(0.7),
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _signText(BuildContext context){
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Do you have an account?',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
          TextButton(
            onPressed: (){
              Navigator.pushReplacement(
                context, 
                  MaterialPageRoute(
                    builder: (BuildContext context)=> const SignInPage()
                  )
              );
            },
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 8),
            ),
            child: const Text(
              'Sign In',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}