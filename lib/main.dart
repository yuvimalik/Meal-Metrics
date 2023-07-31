import 'dart:async';
import 'dart:collection';



import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:decimal/decimal.dart';

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:metricsmeal/FoodWasteMassmetrics.dart';
import 'package:metricsmeal/bar_chart.dart';
import 'food_props.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:async/async.dart';
import 'firebase_options.dart';


// ...



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(home:HomePage()));
}




class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

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
  
  var firebasedata;
  var timer;

  List mapvalues = [];
  List mapkeys = [];
  Map<dynamic, dynamic> rankingmaps = {};

  Map<dynamic, Decimal> weightrankingmap ={};

  bool online = true;

  FirebaseFirestore _fireStoreDataBase = FirebaseFirestore.instance;



  getUserList() {
    return _fireStoreDataBase.collection('user')
        .snapshots()
        .map((snapShot) => snapShot.docs
        .map((document) => document.data())
        );
  }

  Future<void> getData() async {
    //Firebase.initializeApp();
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference voting = FirebaseFirestore.instance.collection(
        'food_photos');

    // Get docs from collection reference
    QuerySnapshot querySnapshot = await voting.get();

    // Get data from docs and convert map to List
    setState(() {
      firebasedata = querySnapshot.docs.map((doc) => doc.data()).toList();
      //print(firebasedata);

    });
  }



  var rankingdatafromfirebase;

  var docnames = [];

  var newrankingmaps;


  Map<dynamic, dynamic> sortedsByKeyMap ={};

  Future<void> getrankingData() async {
    //Firebase.initializeApp();
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference voting = FirebaseFirestore.instance.collection('food_family');
    var result = await FirebaseFirestore.instance.collection('food_family').get();


    // Get docs from collection reference
    QuerySnapshot querySnapshot = await voting.get();


    // Get data from docs and convert map to List

    setState(() {
      rankingdatafromfirebase = querySnapshot.docs.map((doc) => doc.data()).toList();

      result.docs.forEach((element) {

        rankingmaps.addAll({element.id:int.parse(element.data()["count"].toString())});

      });

      var sortedKeys = rankingmaps.keys.toList()
        ..sort((key1, key2) => rankingmaps[key2]!.compareTo(rankingmaps[key1]!));

// Create a new LinkedHashMap to maintain the sorted order of the keys
      var sortedMap = LinkedHashMap.fromIterable(sortedKeys,
          key: (key) => key, value: (key) => rankingmaps[key]);

      //print("$rankingmaps this is the ranking map i beggg");


      mapkeys = sortedMap.keys.toList();

      //print("$sortedsByKeyMap this is the sortedkeymap");


      mapvalues = sortedMap.values.toList();
      //print('${sortedByKeyMap.values} + SORTED KEY MAPPPPPP!!!! + ${sortedByKeyMap.keys}');

      //print(sortedByKeyMap + "Sorted by key map displayed");
      //print("${rankingdatafromfirebase}");




    });
  }

  var weightrankingdatafromfirebase;

  List weightmapkeys =[];

  var ingedients = [
    ["Marinara Pasta", "Pasta, Tomatoes, \n Pepper", 0.95],
    ["Beef Stew", "Ground Beef, Pastry, \n Jus, Citrus", 0.89],
    ["Chow Mein", "Flour Noodles, Chicken, \n Asparagus", 0.83]
  ];

  var cumulativeweight;
  bool isdone = false;
  List weightmapvalues =[];

  int currentlength = 0;

  var weightsorted;

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
      //print('${sortedByKeyMap.values} + SORTED KEY MAPPPPPP!!!! + ${sortedByKeyMap.keys}');

      //print(sortedByKeyMap + "Sorted by key map displayed");
      //print("${rankingdatafromfirebase}");




    });
  }

  int count = 0;
        //print(firebasedata);





    //print(allData);
    //print(voting.doc().id);


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
    getrankingData();
    weightrankingData();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    getData();
    getrankingData();
    weightrankingData();



    return Scaffold(
        body: getBody(),
        backgroundColor: background,
    );
  }


  Widget getBody() {
    var size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Welcome Back",
                        style: TextStyle(fontSize: 14, color: black),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "Yuv",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: black),
                      ),
                    ],
                  ),
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                        color: black.withOpacity(0.03),
                        borderRadius: BorderRadius.circular(12)),
                    child: Center(
                      child: Icon(CupertinoIcons.bell),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                width: double.infinity,
                height: 145,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  gradient: LinearGradient(colors: [secondary, primary]),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Flexible(
                        child: Container(
                          width: (size.width),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Food Waste Metrics",
                                style: GoogleFonts.jost(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: white),
                              ),
                              Text(
                                "You are currently operating at normal food waste",
                                style: GoogleFonts.jost(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400,
                                    color: white),
                              ),
                              GestureDetector(
                                child: Container(
                                  width: 95,
                                  height: 35,
                                  decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                          colors: [fourthColor, fourthColor]),
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Center(
                                    child: Text(
                                      "View More",
                                      style:
                                      GoogleFonts.jost(fontSize: 13, color: primary),
                                    ),
                                  ),
                                ),
                                onTap: (){
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => foodwaste()),);

                                },
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient:
                          LinearGradient(colors: [fourthColor, fourthColor]),
                        ),
                        child: Center(
                          child: Text(
                            "${cumulativeweight.toString().substring(0,4)} KG",
                            style: GoogleFonts.jost(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: primary),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                width: double.infinity,
                height: 60,
                decoration: BoxDecoration(
                    color: secondary.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Today's Target",
                        style: GoogleFonts.jost(
                            fontSize: 17,
                            color: white,
                            fontWeight: FontWeight.w600),
                      ),
                      InkWell(
                        onTap: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => foodwaste()),);
                        },
                        child: Container(
                          width: 70,
                          height: 35,
                          decoration: BoxDecoration(
                              gradient:
                              LinearGradient(colors: [secondary, primary]),
                              borderRadius: BorderRadius.circular(20)),
                          child: Center(
                            child: Text(
                              "Check",
                              style: GoogleFonts.jost(fontSize: 13, color: white),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                "Recommended Meal Planning",
                style: GoogleFonts.jost(
                    fontSize: 18, fontWeight: FontWeight.bold, color: black),
              ),
              SizedBox(
                height: 24,
              ),
              Container(
                width: double.infinity,
                height: 150,
                decoration: BoxDecoration(
                    color: secondary.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(30)),
                child: Column(
                  children: [
                    /*Container(
                      width: double.infinity,
                      child: LineChart(activityData()),
                    ),*/
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                      child: Text(
                        "Recent Food Uploads",
                        style: GoogleFonts.jost(
                            fontSize: 15, fontWeight: FontWeight.bold, color: white),
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height/8,
                      width: MediaQuery.of(context).size.width*0.8,
                      child: GridView.builder(

                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 1,
                          childAspectRatio: MediaQuery.of(context).size.width /
                              (MediaQuery.of(context).size.height / 14),
                            crossAxisSpacing: 1, mainAxisSpacing: 4

                        ),
                        itemBuilder: (BuildContext context, int index) {
                          return firebasedata==null?Text("updating", style: TextStyle(color: Colors.black),):
                          UnconstrainedBox(
                            child: Container(
                              height: 30,
                              width: MediaQuery.of(context).size.width*0.80,


                              child: ListTile(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
                                selectedTileColor: Colors.orange[100],
                                leading: Icon(Icons.fastfood, color: white,),
                                title: Text("${firebasedata[index]["food"].toString().capitalize()}  Weight ${firebasedata[index]["weight"].toString().substring(0,4)} KG's", style: GoogleFonts.jost(fontSize: 12, color: white),),
                                trailing: IconButton(onPressed: () { print(firebasedata[index]["probs"]); }, icon: Icon(Icons.info, color: fourthColor,),),

                              ),
                            ),
                          )
                          ;
                        },
                        itemCount: firebasedata!=null?firebasedata.length:0,
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  Container(
                    width: (size.width - 80) / 2,
                    height: 320,

                    decoration: BoxDecoration(
                        color: primary,
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.01),
                              spreadRadius: 20,
                              blurRadius: 10,

                              offset: Offset(0, 10))
                        ],
                        borderRadius: BorderRadius.circular(30)),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        children: [
                          //WateIntakeProgressBar(),
                          SizedBox(
                            width: 5,

                          ),
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Food Rankings",
                                  style: GoogleFonts.jost(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold, color: Colors.white),

                                ),

                                Padding(
                                  padding: const EdgeInsets.fromLTRB(0, 10,0, 0),
                                  child: Container(
                                    height: 230,
                                    width: 220,

                                    decoration: BoxDecoration(
                                        color: primary,
                                        boxShadow: [
                                          BoxShadow(
                                              color: black.withOpacity(0.01),
                                              spreadRadius: 20,
                                              blurRadius: 10,
                                              offset: Offset(0, 10))
                                        ],
                                        borderRadius: BorderRadius.circular(10)),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: GridView.builder(
                                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 1,
                                            childAspectRatio: MediaQuery.of(context).size.width/1.8 /
                                                (MediaQuery.of(context).size.height / 10),
                                            crossAxisSpacing: 1, mainAxisSpacing: 4

                                        ), itemCount: rankingmaps.keys.length,
                                        itemBuilder: (BuildContext context, int index) {
                                          return rankingdatafromfirebase==null?Text("updating", style: TextStyle(color: Colors.black),):
                                          UnconstrainedBox(

                                            child: Container(
                                              width: 110,
                                              height: MediaQuery.of(context).size.height/20,
                                              color: primary,
                                              child: Card(
                                                elevation: 2,
                                                color: primary,
                                                margin: EdgeInsets.fromLTRB(0, 0.6,0, 0),
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                child: ListTile(
                                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),



                                                  title: Column(
                                                    children: [
                                                      Center(child: Text(" ${mapvalues[index]} ~ ${mapkeys[index]}", style: GoogleFonts.jost(fontSize: 14, color: white, height: 1),)),
                                                      Spacer()
                                                    ],
                                                  ),

                                                  //trailing: IconButton(onPressed: () { print(firebasedata[index]["probs"]); }, icon: Icon(Icons.info),)

                                                ),
                                              ),
                                            ),
                                          );


                                        },
                                      ),
                                    ),

                                  ),
                                )




                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Column(
                    children: [
                      Container(
                        width: (size.width - 80) / 2,
                        height: 150,
                        decoration: BoxDecoration(
                            color: primary,
                            boxShadow: [
                              BoxShadow(
                                  color: black.withOpacity(0.01),
                                  spreadRadius: 20,
                                  blurRadius: 10,
                                  offset: Offset(0, 10))
                            ],
                            borderRadius: BorderRadius.circular(30)),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Container(

                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Device Status'",
                                  style: GoogleFonts.jost(
                                      fontSize: 15, fontWeight: FontWeight.bold, color: white),
                                ),
                                SizedBox(
                                  height: 17,
                                ),

                                GestureDetector(
                                  onTap: (){
                                    setState(() {
                                      count%2==0?online=false:online =true;
                                      count++;
                                    });
                                  },
                                  child: Center(
                                    child: Container(
                                      height: 50,
                                      width: 90,
                                      decoration: BoxDecoration(
                                        color: online==true?secondary:Colors.red[600],
                                        borderRadius: BorderRadius.circular(5)
                                      ),
                                      child: Center(child: Text("${online?"Online":"Offline"}", style: GoogleFonts.jost(color: Colors.white),)),
                                    ),
                                  ),
                                )




                                /*Flexible(
                                  child: LineChart(sleepData()),
                                )*/
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                          width: (size.width - 80) / 2,
                          height: 150,
                          decoration: BoxDecoration(
                              color: primary,
                              boxShadow: [
                                BoxShadow(
                                    color: black.withOpacity(0.01),
                                    spreadRadius: 20,
                                    blurRadius: 10,
                                    offset: Offset(0, 10))
                              ],
                              borderRadius: BorderRadius.circular(30)),
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Waste cost",
                                  style: GoogleFonts.jost(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold, color: Colors.white),
                                ),
                                Spacer(),
                                Center(
                                  child: Container(
                                    width: 105,
                                    height: 75,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      gradient:
                                      LinearGradient(colors: [fourthColor.withOpacity(1), fourthColor]),
                                      borderRadius: BorderRadius.circular(7)
                                    ),
                                    child: Center(
                                      child: Text(
                                        "\$${cumulativeweight!=null?((double.parse(cumulativeweight.toString().substring(0,4))*5.32).toString().substring(0,5)):"32.50"}",
                                        style: GoogleFonts.jost(
                                            color: primary,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                )




                              ],
                            ),
                          ))
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Future Meal Planning",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: black),
                  ),
                  Container(
                    width: 95,
                    height: 35,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [secondary, primary]),
                        borderRadius: BorderRadius.circular(20)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Weekly",
                          style: TextStyle(fontSize: 13, color: white),
                        ),
                        Icon(
                          Icons.keyboard_arrow_down,
                          color: white,
                        )
                      ],
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                height: MediaQuery.of(context).size.height/6,
                width: MediaQuery.of(context).size.width*0.8,

                decoration: BoxDecoration(
                    color: background,
                    boxShadow: [
                      BoxShadow(
                          color: black.withOpacity(0.01),
                          spreadRadius: 20,
                          blurRadius: 10,
                          offset: Offset(0, 10))
                    ],
                    borderRadius: BorderRadius.circular(30)),
                  child: Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height/6,
                    decoration: BoxDecoration(
                      color: background,
                      boxShadow: [
                        BoxShadow(
                            color: black.withOpacity(0.01),
                            spreadRadius: 20,
                            blurRadius: 10,
                            offset:Offset(0, 10)
                        )
                      ],
                      borderRadius: BorderRadius.circular(12),

                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        children: [
                          /*Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                  image: DecorationImage(image: AssetImage(latestWorkoutJson[index]['img']))
                              ),
                            ),*/
                          SizedBox(width: 15,),
                          Container(
                            height: MediaQuery.of(context).size.height/6,
                            width: MediaQuery.of(context).size.width/1.8,

                            decoration: BoxDecoration(


                                borderRadius: BorderRadius.circular(30)),
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: 3,
                              itemBuilder: (BuildContext context, int index) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    height: 135,
                                    width: 160,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(colors: [secondary, primary]),
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.01),
                                          blurRadius: 2.0,
                                          spreadRadius: 0.0,
                                          offset: Offset(2.0, 2.0), // shadow direction: bottom right
                                        )
                                      ],
                                    ),
                                    child: Column(

                                      children: [
                                        Row(children: [SizedBox(width: 5,), Text("${ingedients[index][0]}", style: GoogleFonts.jost(color: white, fontWeight: FontWeight.bold),)],),

                                        Row(children: [SizedBox(width: 5,), Text("${ingedients[index][1]}", style: GoogleFonts.jost(color: white),)],),
                                        Spacer(),
                                        Row(children: [SizedBox(width: 5,), Container(height:15, width:15,child: CircularProgressIndicator(value: double.parse(ingedients[index][2].toString()), color: white, semanticsLabel: ingedients[index][2].toString(),)), SizedBox(width: 8,), Text("${double.parse((ingedients[index][2]).toString())*100.0}% Match", style: GoogleFonts.jost(color: white),)], ),
                                        Spacer()
                                      ],
                                    ),
                                  ),
                                );
                              },

                            )

                          ),
                          SizedBox(width: 15,),
                          Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: primary
                                )
                            ),
                            child: Center(
                              child: Icon(Icons.arrow_forward_ios,size:11,color:secondary),
                            ),
                          ),

                        ],
                      ),
                    ),
                  ),

              ),


            ],
          ),
        ),
      ),
    );
  }
}

extension StringExtensions on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}
