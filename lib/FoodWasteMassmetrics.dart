import 'dart:async';
import 'dart:collection';




import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:decimal/decimal.dart';
import 'package:fl_chart/fl_chart.dart';

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:metricsmeal/bar_chart.dart';
import 'package:metricsmeal/main.dart';
import 'food_props.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:async/async.dart';
import 'firebase_options.dart';



class foodwaste extends StatefulWidget{


  @override
  foodw createState() => foodw();

}

class foodw extends State<foodwaste>{

  Map<dynamic, Decimal> weightrankingmap ={};



  var weightrankingdatafromfirebase;

  List weightmapkeys = [];
  List weightmapvalues =[];

  Map<dynamic,dynamic> weightsorted ={};

  var cumulativeweight;

  bool isdone = false;

  int currentlength = 0;

  Future<void> weightrankingData() async {
    //Firebase.initializeApp();
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference voting = FirebaseFirestore.instance.collection('food_family');
    var result = await FirebaseFirestore.instance.collection('food_family').get();


    // Get docs from collection reference
    QuerySnapshot querySnapshot = await voting.get();


    // Get data from docs and convert map to List

    setState(() {
      weightrankingdatafromfirebase = querySnapshot.docs.map((doc) => doc.data()).toList();
      result.docs.forEach((element) {
        //print(element.data()["weight"].toString() + "Weight readings");
        weightrankingmap.addAll({element.id:Decimal.parse(element.data()["weight"].toString())});

      });

      //print("$rankingmaps this is the ranking map i beggg");



      weightsorted = SplayTreeMap<dynamic, dynamic>.from(
          weightrankingmap, (keys1, keys2) => weightrankingmap[keys2]!.compareTo(weightrankingmap[keys1]!));


      if(currentlength!=weightmapkeys.length){
        setState(() {
          isdone = false;
        });
      }

      weightmapkeys = weightsorted.keys.toList();
      weightmapvalues = weightsorted.values.toList();


      //print(weightmapkeys);

      if(weightmapvalues.length !=0 && isdone == false){

        cumulativeweight = Decimal.zero;

        for(var i = 0; i<weightmapvalues.length; i++){

          if(cumulativeweight==null){
            cumulativeweight = Decimal.parse(weightmapvalues[i].toString()) ;
          }else{
            cumulativeweight = Decimal.parse(weightmapvalues[i].toString()) + cumulativeweight;
          }

          isdone = true;

        }


      }

      //print(cumulativeweight);


      //print('${sortedByKeyMap.values} + SORTED KEY MAPPPPPP!!!! + ${sortedByKeyMap.keys}');

      //print(sortedByKeyMap + "Sorted by key map displayed");
      //print("${rankingdatafromfirebase}");




    });
  }

  Color white = Color(0xFFFFFFFF);
  Color black = Color(0xFF000000);

  Color background = Color(0xFFE1FAE0);

  Color primary = Color(0xFF5C7457);
  Color secondary = Color(0xFF214E34);
  Color thirdColor = Color(0xFF403233);
  Color fourthColor = Color(0xFFFFD6A0);
  Color bgTextField = Color(0xFFFFFFFF);

  Color facebookColor = Color(0xFF3b5998);
  Color googleColor = Color(0xFFDB4437);



  @override

  void initState() {
    // TODO: implement initState
    super.initState();
    weightrankingData();
  }
  Widget build(BuildContext context) {

    weightrankingData();


    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: background,
        shadowColor: background,

        actions: [
          IconButton(
            icon: Icon(Icons.home),
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
            },
          )
        ],
      ),
        body: Column(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
                child: Container(decoration: BoxDecoration(
                  color: secondary.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(15)
                ),height: MediaQuery.of(context).size.height*0.47, width: MediaQuery.of(context).size.width*0.8,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                    child: Column(
                      children: [
                        weightmapkeys.length!=0?Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [

                            Column(
                              children: [
                                Container(
                                  height: 70,
                                  width: 25,

                                  decoration: BoxDecoration(
                                    color: secondary,
                                    borderRadius: BorderRadius.circular(5)
                                  ),
                                ),
                                Text(
                                  "Protein",
                                  style: GoogleFonts.jost(fontSize: 12),
                                )
                              ],
                            ),
                            Column(
                              children: [
                                Container(
                                  height: 35,

                                  width: 25,

                                  decoration: BoxDecoration(
                                      color: secondary,
                                      borderRadius: BorderRadius.circular(5)
                                  ),
                                ),
                                Text(
                                  "Vegetables",
                                  style: GoogleFonts.jost(fontSize: 12),
                                )
                              ],

                            ),
                            Column(

                              children: [
                                Container(
                                  height: 110,

                                  width: 25,

                                  decoration: BoxDecoration(
                                      color: secondary,
                                      borderRadius: BorderRadius.circular(5)
                                  ),
                                ),
                                Text(
                                  "Dairy",
                                  style: GoogleFonts.jost(fontSize: 12),
                                )
                              ],

                            ),

                            Column(
                              children: [
                                Container(
                                  height: 45,

                                  width: 25,

                                  decoration: BoxDecoration(
                                      color: secondary,
                                      borderRadius: BorderRadius.circular(5)
                                  ),
                                ),
                                Text(
                                  "Beverages",
                                  style: GoogleFonts.jost(fontSize: 12),
                                ),

                              ],
                            ),

                          ],
                        ):Text("data"),

                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Text(
                            "Expense of waste By weight",
                            style: GoogleFonts.jost(
                                fontWeight: FontWeight.bold,
                                fontSize: 15
                            ),
                          ),
                        ),

                        Divider(
                          thickness: 3,
                        ),

                        weightmapkeys.length !=0?Padding(
                          padding: const EdgeInsets.fromLTRB(0, 70, 0, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [

                              Column(
                                children: [
                                  Container(
                                    height: double.parse("1.98")*10.0,
                                    width: 25,

                                    decoration: BoxDecoration(
                                        color: secondary,
                                        borderRadius: BorderRadius.circular(5)
                                    ),
                                  ),
                                  Text(
                                    "Monday",
                                    style: GoogleFonts.jost(fontSize: 12),
                                  )
                                ],
                              ),
                              Column(
                                children: [
                                  Container(
                                    height: double.parse("5.4")*10,
                                    width: 25,

                                    decoration: BoxDecoration(
                                        color: secondary,
                                        borderRadius: BorderRadius.circular(5)
                                    ),
                                  ),
                                  Text(
                                    "Tuesday",
                                    style: GoogleFonts.jost(fontSize: 12),
                                  )
                                ],

                              ),
                              Column(

                                children: [
                                  Container(
                                    height: double.parse("1.04")*16,
                                    width: 25,

                                    decoration: BoxDecoration(
                                        color: secondary,
                                        borderRadius: BorderRadius.circular(5)
                                    ),
                                  ),
                                  Text(
                                    "Wednesday",
                                    style: GoogleFonts.jost(fontSize: 12),
                                  )
                                ],

                              ),

                              Column(
                                children: [
                                  Container(
                                    height: double.parse("1.23")*16.0,
                                    width: 25,

                                    decoration: BoxDecoration(
                                        color: secondary,
                                        borderRadius: BorderRadius.circular(5)
                                    ),
                                  ),
                                  Text(
                                    "Thursday",
                                    style: GoogleFonts.jost(fontSize: 12),
                                  ),

                                ],
                              ),
                              Column(
                                children: [
                                  Container(
                                    height: double.parse(cumulativeweight!=null?cumulativeweight.toString():"17")*2,
                                    width: 25,

                                    decoration: BoxDecoration(
                                        color: secondary,
                                        borderRadius: BorderRadius.circular(5)
                                    ),
                                  ),
                                  Text(
                                    "Today",
                                    style: GoogleFonts.jost(fontSize: 12),
                                  ),

                                ],
                              ),
                            ],
                          ),
                        ):Text("No Data"),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Text(
                            "Food Waste by day",
                            style: GoogleFonts.jost(
                                fontWeight: FontWeight.bold,
                                fontSize: 15
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                ),
              ),
            ),
            SizedBox(height: 15,),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: Container(
                height: (MediaQuery.of(context).size.height*0.3727)-30.382, width: MediaQuery.of(context).size.width,
                child: DraggableScrollableSheet(
                  initialChildSize: 0.9,
                  //maxChildSize: 0.5,

                  builder: (BuildContext context, ScrollController scrollController) {

                    return Container(

                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                        color: primary,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(13.0),
                        child: ListView.builder(
                          controller: scrollController,
                          itemCount: weightsorted.keys.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Center(
                              child: Card(
                                color: primary,

                                child: SizedBox(
                                  width: 300,
                                  height: 50,
                                  child: Center(child: Text('No.${index+1} wasted ~ ${weightmapkeys[index].toString().capitalize()} - ${weightmapvalues[index].toString().substring(0,5)} KGs', style: GoogleFonts.jost(fontSize: 16, color: white),)),

                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      );
  }

}


