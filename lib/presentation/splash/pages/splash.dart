import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lumuzik/presentation/intro/pages/get_stated.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lumuzik/core/configs/assets/app_vectors.dart';
// import 'package:lumuzik/presentation/intro/pages/get_started.dart';
import 'package:lumuzik/presentation/auth/pages/SignInPage.dart';
import 'package:lumuzik/presentation/auth/pages/HomePag.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  static const String userLoggedInKey = 'isUserLoggedIn';

  @override
  void initState() {
    super.initState();
    redirect();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SvgPicture.asset(
          AppVectors.logo,
        ),
      ),
    );
  }

  Future<void> redirect() async {
    // Attendre 2 secondes pour afficher le splash screen
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool hasSeenIntro = prefs.getBool('hasSeenIntro') ?? false;
    bool isLoggedIn = prefs.getBool(userLoggedInKey) ?? false;
    User? currentUser = _auth.currentUser;

    Widget nextPage;
    if (!hasSeenIntro) {
      nextPage = const GetStarted();
    } else if (currentUser != null && isLoggedIn && currentUser.emailVerified) {
      nextPage = const MusicLibraryPage();
    } else {
      nextPage = SignInPage();
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => nextPage,
      ),
    );
  }
}