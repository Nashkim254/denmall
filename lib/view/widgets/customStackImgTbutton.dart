import 'package:flutter/material.dart';
import 'customElevatedButton.dart';
import 'customText.dart';

class CustomStackImgTbutton extends StatelessWidget {
  final String imgUrl;
  final String txt;
  final double imgH;
  final double imgW;
  CustomStackImgTbutton({
    this.imgUrl,
    this.txt,
    this.imgH = 192,
    this.imgW,
  });
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          imgUrl,
          height: imgH,
          width: imgW ?? null,
        ),
        Positioned(
          top: 20,
          left: 35,
          child: CustomText(
            txt: txt,
            fSize: 18,
            txtColor: Colors.white,
            maxLine: 3,
          ),
        ),
        Positioned(
          top: 100,
          left: 25,
          child: Container(
            width: 150,
            child: CustomElevatedButton(
              txt: 'SEE MORE',
              imgUrl: 'assets/auth/right_arrow.png',
            ),
          ),
        )
      ],
    );
  }
}
