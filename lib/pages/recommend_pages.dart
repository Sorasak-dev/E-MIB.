import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

 class RecommendPages extends StatefulWidget {
  const RecommendPages({Key? key}) :super(key: key);

  @override
  State<RecommendPages> createState() => _RecommendPagesState();
}

class _RecommendPagesState extends State<RecommendPages> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
          
            children: [
        
              //Notification
              Container(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(Icons.notifications,color: Colors.black,),
                  ],
                ),),
        
        
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //Hi
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      
                      Text(
                        'Today',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 24,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      Text('26 August',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),),
                      Text('Low',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 40,
                        fontWeight: FontWeight.bold
                      ),
                      ),
        
                      //meser
                      Container(
          width: 360,  // ความกว้างของสี่เหลี่ยมผืนผ้า
          height: 200, // ความสูงของสี่เหลี่ยมผืนผ้า
          color: Color(0xFFBBE9FF), // สีพื้นหลังของกล่อง
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // จัดข้อความให้อยู่ตรงกลางในแนวตั้ง
            crossAxisAlignment: CrossAxisAlignment.center, // จัดให้อยู่ตรงกลางในแนวนอน
            children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'SYS',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
              ),
            ),
            SizedBox(width: 16), // เว้นระยะห่างระหว่าง SYS กับกล่องสี่เหลี่ยม
            Container(
              width: 100,  // กำหนดความกว้างของกล่องสี่เหลี่ยม
              height: 25, // กำหนดความสูงของกล่องสี่เหลี่ยม
              color: Colors.white, // สีของกล่องสี่เหลี่ยม
            ),
            SizedBox(width: 16), // เว้นระยะห่างระหว่างกล่องกับ mmHg
            Text(
              'mmHg',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
              ),
            ),
          ],
        ),
        SizedBox(height: 8), // เว้นระยะห่างระหว่างบรรทัด SYS และเส้นกั้น
        Divider(
          color: Colors.black, // สีของเส้นกั้น
          thickness: 1, // ความหนาของเส้นกั้น
          indent: 16, // ระยะห่างจากขอบซ้าย
          endIndent: 16, // ระยะห่างจากขอบขวา
        ),
        SizedBox(height: 8), // เว้นระยะห่างระหว่างบรรทัด SYS และ DIA
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'DIA',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
              ),
            ),
            SizedBox(width: 16), // เว้นระยะห่างระหว่าง DIA กับกล่องสี่เหลี่ยม
            Container(
              width: 100,  // กำหนดความกว้างของกล่องสี่เหลี่ยม
              height: 25, // กำหนดความสูงของกล่องสี่เหลี่ยม
              color: Colors.white, // สีของกล่องสี่เหลี่ยม
            ),
            SizedBox(width: 16), // เว้นระยะห่างระหว่างกล่องกับ mmHg
            Text(
              'mmHg',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
              ),
            ),
          ],
        ),
        SizedBox(height: 8), // เว้นระยะห่างระหว่างบรรทัด SYS และเส้นกั้น
        Divider(
          color: Colors.black, // สีของเส้นกั้น
          thickness: 1, // ความหนาของเส้นกั้น
          indent: 16, // ระยะห่างจากขอบซ้าย
          endIndent: 16, // ระยะห่างจากขอบขวา
        ),
        SizedBox(height: 8), // เว้นระยะห่างระหว่างบรรทัด SYS และ DIA
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'PUL',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
              ),
            ),
            SizedBox(width: 16), // เว้นระยะห่างระหว่าง DIA กับกล่องสี่เหลี่ยม
            Container(
              width: 100,  // กำหนดความกว้างของกล่องสี่เหลี่ยม
              height: 25, // กำหนดความสูงของกล่องสี่เหลี่ยม
              color: Colors.white, // สีของกล่องสี่เหลี่ยม
            ),
            SizedBox(width: 16), // เว้นระยะห่างระหว่างกล่องกับ mmHg
            Text(
              'min',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
              ),
            ),
          ],
        ),
            ],
          ),
        ),
            SizedBox(height: 16),
            
                
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const[
                      Text(
                        'Warning',
                        style: TextStyle(
                          color:Color.fromARGB(255, 86, 80, 255),
                          fontSize: 20,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      
                    ],
                  ),
               
            SizedBox(height: 16),
        
              Container(
                width: 350,  // ความกว้างของสี่เหลี่ยมผืนผ้า
                height: 150, // ความสูงของสี่เหลี่ยมผืนผ้า
                decoration: BoxDecoration(
                  color: Colors.white, // สีพื้นหลังของกล่อง
                  borderRadius: BorderRadius.circular(16.0), // กำหนดค่ามุมโค้ง
                  border: Border.all(
                    color: Colors.white, // สีของขอบ
                    width: 2.0, // ความกว้างของขอบ
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5), // สีของเงา (พร้อมความโปร่งใส)
                      spreadRadius: 5, // การกระจายของเงา
                      blurRadius: 7, // ความเบลอของเงา
                      offset: Offset(0, 3), // การเลื่อนของเงา (แนวนอน, แนวตั้ง)
                    ),
                  ],
                ),
                child: ListTile(
                  leading: Padding(
                    padding: const EdgeInsets.only(left: 16.0, top: 1.0,right: 16.0), // ระยะห่างจากขอบซ้ายและขอบบน
                    child: FaIcon(
                      FontAwesomeIcons.pepperHot, 
                      size: 36, // ปรับขนาดของไอคอน
                      color: Color.fromARGB(255, 255, 176, 87), // สีของไอคอน
                    ),
                  ),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start, // จัดข้อความให้อยู่ชิดซ้าย
                    children: [
                      Text(
                        'ระมัดระวังการรับประทานอาหารจำพวกพริก',
                        style: TextStyle(fontSize: 16, color: Colors.black,fontWeight: FontWeight.bold),
                        
                      ),
                      SizedBox(height: 8), // ระยะห่างระหว่างข้อความแรกกับข้อความถัดไป
                      Text(
                        'ข้อมูลเพิ่มเติม: สารในพริกบางชนิดที่อาจทำให้เกิดอาการได้',
                        style: TextStyle(fontSize: 14, color: Colors.grey[900]),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 16),
        
              Container(
                width: 350,  // ความกว้างของสี่เหลี่ยมผืนผ้า
                height: 150, // ความสูงของสี่เหลี่ยมผืนผ้า
                decoration: BoxDecoration(
                  color: Colors.white, // สีพื้นหลังของกล่อง
                  borderRadius: BorderRadius.circular(16.0), // กำหนดค่ามุมโค้ง
                  border: Border.all(
                    color: Colors.white, // สีของขอบ
                    width: 2.0, // ความกว้างของขอบ
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5), // สีของเงา (พร้อมความโปร่งใส)
                      spreadRadius: 5, // การกระจายของเงา
                      blurRadius: 7, // ความเบลอของเงา
                      offset: Offset(0, 3), // การเลื่อนของเงา (แนวนอน, แนวตั้ง)
                    ),
                  ],
                ),


                child: ListTile(
                  leading: Padding(
                    padding: const EdgeInsets.only(left: 16.0, top: 1.0,right: 16.0), // ระยะห่างจากขอบซ้ายและขอบบน
                    child: FaIcon(
                      FontAwesomeIcons.candyCane, 
                      size: 36, // ปรับขนาดของไอคอน
                      color: Colors.pink[300], // สีของไอคอน
                    ),
                  ),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start, // จัดข้อความให้อยู่ชิดซ้าย
                    children: [
                      Text(
                        'Low sweet',
                        style: TextStyle(fontSize: 16, color: Colors.black,fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8), // ระยะห่างระหว่างข้อความแรกกับข้อความถัดไป
                      Text(
                        'ข้อมูลเพิ่มเติม: ทานของหวานมากเกินทำให้เกิดผลเสียมากขึ้น',
                        style: TextStyle(fontSize: 14, color: Colors.grey[800]),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 32),
            
                
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const[
                      Text(
                        'Recomean',
                        style: TextStyle(
                          color: Color.fromARGB(255, 86, 80, 255),
                          fontSize: 20,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      
                    ],
                  ),
        
        
              SizedBox(height: 16),
        
              Container(
                width: 350,  // ความกว้างของสี่เหลี่ยมผืนผ้า
                height: 600, // ความสูงของสี่เหลี่ยมผืนผ้า
                decoration: BoxDecoration(
                  color: Color(0xFFBBE9FF), // สีพื้นหลังของกล่อง
                  borderRadius: BorderRadius.circular(16.0), // กำหนดค่ามุมโค้ง
                ),
              ),
        
        
                    ],
                  ),
                ],
              )
            ],
                  ),
          )),
      ),
    );

  }
}