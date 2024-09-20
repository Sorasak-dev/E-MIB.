import 'package:flutter/material.dart';
import 'package:emib_hospital/tab/drink_tab.dart';
import 'package:emib_hospital/tab/exercise_tab.dart';
import 'package:emib_hospital/tab/food_tab.dart';
import 'package:emib_hospital/tab/fruit_tab.dart';
import 'package:emib_hospital/tab/vegetable_tab.dart';
import 'package:emib_hospital/util/my_tab.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
 class NewsPages extends StatefulWidget {
  const NewsPages({super.key});

  @override
  State<NewsPages> createState() => _NewsPagesState();
}

class _NewsPagesState extends State<NewsPages> {

  // my tabs
  List<Widget> myTabs =const[
    //vegetable tab
    MyTab(
      iconPath: 'lib/icons/vegetable.png',
      ),
    // exercise
    MyTab(
      iconPath: 'lib/icons/heart-rate.png',
      ),
    //fruit
    MyTab(
      iconPath: 'lib/icons/fruit.png',
      ),
    //drink
    MyTab(
      iconPath: 'lib/icons/drink.png',
      ),
    //food
    MyTab(
      iconPath: 'lib/icons/5TypesOfFood.png',
      ),
  ];


  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: myTabs.length,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
                /*leading: Padding(
                  padding: const EdgeInsets.only(left: 24.0),
                  child: Icon(
                    Icons.menu,
                    color: Colors.grey[800],
                  ),
                ),*/
          actions: [
            Padding(
              padding: const EdgeInsets.only(right:24.0),
              child: IconButton(
                icon:  Icon(
                Icons.notifications,
                color: Colors.grey[800],
                size: 36,
                ),
                onPressed:(){
                  //open noti
                },
                ),
              ),
          ],
      
        ),
      
      body: Column(children: [
        // i want to eat
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 36.0, vertical: 18),
          child: Row(
            children: const[
              Text(
                'Healthy on the ',
                style: TextStyle(fontSize: 24),
              ),
              Text(
                'Inside',
                style: TextStyle(fontSize: 32,fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      
        const SizedBox( height: 24,),
        //tab bar
      TabBar(tabs: myTabs,
      indicatorColor: Color(0xFFB1AFFF),),
        // tab bar view
      Expanded(
        child: TabBarView(
          children: [
            //vegetable tab
            VegetableTab(),
            // exercise
            ExerciseTab(),
            //fruit
            FruitTab(),
            //drink
            DrinkTab(),
            //food
            FoodTab(),
    
          ]
          ),
      ),
      ],),
      ),
    );

  }
}