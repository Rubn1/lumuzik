import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:shared_preferences.dart';
import 'package:lumuzik/common/widgets/button/basic_app_button.dart';
import 'package:lumuzik/core/configs/assets/app_images.dart';
// import 'package:lumuzik/core/configs/assets/app_vectors.dart';
import 'package:lumuzik/core/configs/theme/App_colors.dart';
import 'package:lumuzik/presentation/choose_mode.js/pages/choose_mode.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GetStarted extends StatelessWidget {
  const GetStarted({super.key});

  Future<void> _setHasSeenIntro() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasSeenIntro', true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: 40,
              horizontal: 40
            ),
            decoration: const BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage(
                  AppImages.introBG,
                )
              )
            ),
          ),
          Container(
            color: Colors.black.withOpacity(0.15),
          ),
          
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 30,
              horizontal: 30
            ),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Image.asset(
                    AppImages.splash3,
                    width: 200,
                    height: 200,
                  ),
                ),
                const Spacer(),
                const Text(
                  'Enjoy Listening To Music',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 18
                  ),
                ),
                const SizedBox(height: 21),
                const Text(
                  'lorem ipsum, lorem ipsum, lorem ipsum,lorem ipsum,lorem ipsum,lorem ipsum,lorem ipsum,lorem ipsum,lorem ipsum,lorem ipsum,lorem ipsum,lorem ipsum',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: AppColors.gray,
                    fontSize: 13
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                BasicAppButton(
                  onPressed: () async {
                    // Sauvegarder que l'utilisateur a vu l'intro
                    await _setHasSeenIntro();
                    if (!context.mounted) return;
                    
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => const ChooseModePage()
                      )
                    );
                  },
                  title: 'Get Started'
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }
}