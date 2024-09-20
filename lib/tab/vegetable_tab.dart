import 'package:flutter/material.dart';
import 'package:emib_hospital/util/vegetable_tile.dart';

class VegetableTab extends StatelessWidget {
  // List of vegetables with additional blood pressure information
  List<Map<String, dynamic>> vegetablesType = [
    // [vegetableFlovor, vegetablePrice, vegetableColor, imageName, bloodPressureType]
    {
      "vegetableFlovor": "Leafy Greens",
      "vegetablePrice": 5.99,
      "vegetableColor": Colors.green,
      "imageName": 'lib/images/leafy_greens.png',
      "bloodPressureType": 'low',
    },
    {
      "vegetableFlovor": "Beets",
      "vegetablePrice": 3.99,
      "vegetableColor": Colors.purple,
      "imageName": 'lib/images/beet.png',
      "bloodPressureType": 'high',
    },
    {
      "vegetableFlovor": "Tomato",
      "vegetablePrice": 2.99,
      "vegetableColor": Colors.red,
      "imageName": 'lib/images/tomato.png',
      "bloodPressureType": 'both',
    },
    {
      "vegetableFlovor": "Spinach",
      "vegetablePrice": 4.99,
      "vegetableColor": Colors.green,
      "imageName": 'lib/images/spinach.png',
      "bloodPressureType": 'low',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: vegetablesType.length,
      padding: EdgeInsets.all(12),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1 / 1.4,
      ),
      itemBuilder: (context, index) {
        final vegetable = vegetablesType[index];
        return vegetableTile(
          vegetableFlovor: vegetable['vegetableFlovor'],
          //vegetablePrice: vegetable['vegetablePrice'],
          vegetableColor: vegetable['vegetableColor'],
          imageName: vegetable['imageName'],
          bloodPressureType: vegetable['bloodPressureType'],
        );
      },
    );
  }
}
