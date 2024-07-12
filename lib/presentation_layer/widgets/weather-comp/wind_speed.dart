import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:weather_app/presentation_layer/widgets/commons/info_column.dart';

class WindCompass extends StatelessWidget {
  final double direction;
  final double speed;
  final double gust;

  WindCompass({
    required this.direction,
    required this.speed,
    required this.gust,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "WIND",
            style: TextStyle(
              fontSize: 20,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8), // Space between title and content
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InfoColumn(
                value: '${speed.toStringAsFixed(1)} m/s',
                label: 'Speed',
              ),
              InfoColumn(
                value: '${gust.toStringAsFixed(1)} m/s',
                label: 'Gust',
              ),
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey, width: 2),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    const Positioned(
                      top: 8,
                      child: Text('N', style: TextStyle(color: Colors.black)),
                    ),
                    const Positioned(
                      bottom: 8,
                      child: Text('S', style: TextStyle(color: Colors.black)),
                    ),
                    const Positioned(
                      left: 8,
                      child: Text('W', style: TextStyle(color: Colors.black)),
                    ),
                    const Positioned(
                      right: 8,
                      child: Text('E', style: TextStyle(color: Colors.black)),
                    ),
                    Transform.rotate(
                      angle: direction * (3.141592653589793 / 180),
                      child: const Icon(
                        Icons.arrow_right_alt,
                        color: Colors.green,
                        size: 40,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
