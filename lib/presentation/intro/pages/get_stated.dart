import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lumuzik/core/configs/assets/app_images.dart';
import 'package:lumuzik/core/configs/assets/app_vectors.dart';
import 'package:lumuzik/core/configs/theme/App_colors.dart';

class GetStated extends StatelessWidget {
  const GetStated({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              vertical: 40,
              horizontal: 40
            ),
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage(
                  AppImages.introBG,
                )
              )
            ),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: SvgPicture.asset(
                    AppVectors.logo
                  ),
                ),
                Spacer(),
                  Text(
                    'Enjoy Listening To music',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 18
                    ),
                  ),
                  SizedBox(height: 21,),

                  Text(
                    'lorem ipsum, lorem ipsum, lorem ipsum,lorem ipsum,lorem ipsum,lorem ipsum,lorem ipsum,lorem ipsum,lorem ipsum,lorem ipsum,lorem ipsum,lorem ipsum',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: AppColors.gray,
                      fontSize: 13
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 21,),
              ],
            ),
          ),
          Container(
            color: Colors.black.withOpacity(0.15),
          )
        ],
      ),
    );
  }
}