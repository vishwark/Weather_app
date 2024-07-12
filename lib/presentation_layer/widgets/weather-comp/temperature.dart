import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Temperature extends StatelessWidget {
  String tempMin, tempMax, tempAvg;
  Temperature(
      {super.key,
      required this.tempMin,
      required this.tempAvg,
      required this.tempMax});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            temp('assets/temp-min.svg', tempMin, "Temp min"),
            temp('assets/feel.svg', tempAvg, "Real feel"),
            temp('assets/temp-max.svg', tempMax, "Temp max"),
          ],
        )
      ],
    );
  }

  Widget temp(String asset, String temp, String label) {
    return Column(
      children: [
        SvgPicture.asset(
          asset,
          width: 100,
          height: 50,
        ),
        SizedBox(height: 10),
        Text(
          temp,
          style: TextStyle(fontSize: 20),
        ),
        SizedBox(height: 10),
        Text(
          label,
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}
