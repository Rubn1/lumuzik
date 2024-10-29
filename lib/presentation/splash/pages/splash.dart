import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lumuzik/core/configs/assets/app_vectors.dart';
import 'package:lumuzik/presentation/intro/pages/get_stated.dart';


class SpashPage extends StatefulWidget {
  const SpashPage({super.key});

  @override
  State<SpashPage> createState() => _SpashPageState();
}

class _SpashPageState extends State<SpashPage> {
  @override
  void initState(){
    super.initState();
    redirect();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SvgPicture.asset(
          AppVectors.logo
        )
      ),
    );
  }
  Future<void> redirect() async{
    await Future.delayed(const Duration(seconds: 3));
    Navigator.pushReplacement(
      context, 
      MaterialPageRoute(
        builder: (BuildContext context) => const GetStated()
        )
        );
  }
}