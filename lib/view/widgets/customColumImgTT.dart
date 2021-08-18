import 'package:flutter/material.dart';
import '../../const.dart';
import 'customText.dart';

class CustomColumImgTT extends StatelessWidget {
  final String imgUrl;
  final String txt1;
  final String txt2;

  CustomColumImgTT({
    this.imgUrl,
    this.txt1,
    this.txt2,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          imgUrl.startsWith('a')
              ? Expanded(
                  child: Image.asset(
                    imgUrl,
                    fit: BoxFit.fitHeight,
                  ),
                )
              : Expanded(
                  child: Image.network(
                    imgUrl,
                    fit: BoxFit.fitHeight,
                  ),
                ),
          CustomText(
            txt: txt1,
            txtColor: swatchColor,
            fWeight: FontWeight.normal,
          ),
          CustomText(
            txt: txt2,
            txtColor: swatchColor,
            fWeight: FontWeight.bold,
          ),
        ],
      ),
    );
  }
}
