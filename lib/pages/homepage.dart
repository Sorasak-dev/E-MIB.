import 'package:flutter/material.dart';
import 'package:emib_hospital/pages/exercise_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'att_screen.dart'; // นำเข้า AttractionsScreen

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyHomePage',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // Number of tabs
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                backgroundColor: Colors.lightBlue[100],
                expandedHeight: 500.0, // Adjust the height of the SliverAppBar
                floating: false,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  titlePadding: EdgeInsets.only(bottom: 70.0), // Adjust title position
                  background: Stack(
                    children: [
                      ClipPath(
                        clipper: CurvedClipper(),
                        child: Container(
                          color: Colors.purple[100],
                          child: Padding(
                            padding: const EdgeInsets.only(top: 30.0), // Adjust content position
                            child: Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Today',
                                    style: TextStyle(
                                      fontSize: 24,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'Normal',
                                    style: TextStyle(
                                      fontSize: 40,
                                      color: Colors.blueAccent,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Container(
                                    width: 200,
                                    height: 200,
                                    decoration: BoxDecoration(
                                      color: Color(0xFFA6E1A1),
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 2,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.4),
                                          spreadRadius: 3,
                                          blurRadius: 7,
                                          offset: Offset(6, 12),
                                        ),
                                      ],
                                    ),
                                    child: Center(
                                      child: Text(
                                        '${DateTime.now().day}',
                                        style: TextStyle(
                                          fontSize: 90,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                bottom: PreferredSize(
                  preferredSize: Size.fromHeight(50.0), // TabBar height
                  child: TabBar(
                    labelColor: Colors.blue,
                    unselectedLabelColor: Colors.grey,
                    indicatorColor: Colors.blue,
                    tabs: [
                      Tab(icon: FaIcon(FontAwesomeIcons.carrot), text: "HealthFood for you"),
                      Tab(icon: FaIcon(FontAwesomeIcons.dumbbell), text: "Health inside"),
                    ],
                  ),
                ),
              ),
            ];
          },
          body: TabBarView(
            children: [
              AttractionsScreen(), // AttractionsScreen for "HealthFood for you"
              ExerciseScreen(), // ExerciseScreen for "Health inside"
              // Other tab content can go here
            ],
          ),
        ),
      ),
    );
  }
}


class CurvedClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0.0, size.height - 120);
    path.quadraticBezierTo(size.width / 2, size.height, size.width, size.height - 120);
    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
