import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lumuzik/common/widgets/appBar/appBar.dart';
import 'package:lumuzik/common/widgets/button/basic_app_button.dart';
import 'package:lumuzik/core/configs/assets/app_images.dart';
import 'package:lumuzik/core/configs/assets/app_vectors.dart';
import 'package:lumuzik/core/configs/theme/App_colors.dart';
import 'package:lumuzik/presentation/auth/pages/signup.dart';
import 'package:lumuzik/presentation/auth/pages/SignInPage.dart';

class SignupOrSigninPage extends StatelessWidget {
  const SignupOrSigninPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
        const AppbarPage(),
          Align(
            alignment: Alignment.topRight,
            child: SvgPicture.asset(
              AppVectors.topPattern
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: SvgPicture.asset(
              AppVectors.bottonPattern
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Image.asset(
              AppImages.authBG
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 40
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    AppVectors.logo
                  ),
                  const SizedBox(
                    height: 55,
                  ),
                  const Text(
                    'Enjoy Listening To Music',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 19
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  const Text(
                    ' Lorem iPsum Lorem iPsum Lorem iPsum Lorem iPsum Lorem iPsum Lorem iPsum Lorem iPsumLorem iPsumLorem iPsumLorem iPsumLorem iPsumLorem iPsumLorem iPsumLorem iPsumLorem iPsum',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                      color: AppColors.gray,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 25,
                  ),
              
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: BasicAppButton(
                        onPressed: (){
                          Navigator.push(
                            context, 
                            MaterialPageRoute(
                              builder: (BuildContext context)=> SignupPage()
                            )
                          );
                        }, 
                        title: 'Register'
                        ),
                      ),

                      const SizedBox(width: 15,),
                      Expanded(
                        flex: 1,
                        child: TextButton(
                          onPressed: (){
                            Navigator.push(
                            context, 
                            MaterialPageRoute(
                              builder: (BuildContext context)=> SignInPage()
                            )
                          );
                          }, 
                          child: const Text(
                            'sign in',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.white
                            ),
                          )
                          ),
                      )
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}