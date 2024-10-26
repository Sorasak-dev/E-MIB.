import 'package:flutter/material.dart';

class vegetableTile extends StatelessWidget {
  final String vegetableFlovor;
  //final double vegetablePrice; // ประเภท double
  final MaterialColor vegetableColor;
  final String imageName;
  final String bloodPressureType; // เพิ่มพารามิเตอร์ใหม่

  const vegetableTile({
    super.key,
    required this.vegetableFlovor,
    //required this.vegetablePrice,
    required this.vegetableColor,
    required this.imageName,
    required this.bloodPressureType,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        decoration: BoxDecoration(
            color: vegetableColor[50], borderRadius: BorderRadius.circular(12)),
        child: Column(
          children: [
            //price
            /*Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: vegetableColor[100],
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(12),
                      topRight: Radius.circular(12)
                    ),
                  ),
                    padding: EdgeInsets.all(12.0),
                    child: Text(
                      '\$$vegetablePrice',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),),
                  ), 
              ],
            ),*/

            //vegetable picture
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20),
              child: Image.asset(imageName),
            ),
            //vegetable flavor
            Text(
              vegetableFlovor,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),

            // blood pressure type
            Text(
              _getBloodPressureText(bloodPressureType),
              style: TextStyle(color: Colors.grey[700]),
            ),

            const SizedBox(height: 4),

            //love icon + add button
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //love icon
                  Icon(
                    Icons.favorite,
                    color: Colors.pink[400],
                  ),

                  //plus button
                  Icon(
                    Icons.add,
                    color: Colors.grey[400],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  String _getBloodPressureText(String type) {
    switch (type) {
      case 'low':
        return 'Low blood pressure';
      case 'high':
        return 'High blood pressure';
      case 'both':
        return 'Both blood pressure';
      default:
        return '';
    }
  }
}
