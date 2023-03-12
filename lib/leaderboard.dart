
import 'dart:collection';
import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:implicitly_animated_list/implicitly_animated_list.dart';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart' as fb;
import 'package:leaderboard/board_obj.dart';

List<String> FlagImages = ['assets/images/flag_1.png','assets/images/flag_2.png','assets/images/flag_3.png','assets/images/flag_5.png'];
String SampleTest = "None";
bool full = true;
bool compact_mode = false;

List<board_obj> data = [];

class leaderboard extends StatefulWidget {
  leaderboard({Key? key}) : super(key: key);
  @override
  State<leaderboard> createState() => _leaderboardState();
}

class _leaderboardState extends State<leaderboard> {
  //List<String> data = ['USA', "ITM", "IND", "PTG"];
  List<String> listItems = ['USA', "ITM", "IND", "PTG"];

  void initState() {
    // test_get();
    DatabaseReference starCountRef =
    FirebaseDatabase.instance.ref("leaderboard/002");
    starCountRef.onValue.listen((DatabaseEvent event) {
      final data_snap = event.snapshot.value;
      print(data_snap.toString());
      Iterable l = json.decode(data_snap.toString());
      List<board_obj> BoardObjects = List<board_obj>.from(l.map((model)=> board_obj.fromJson(model)));
      setState(() {
        if(data.isEmpty){
          data = BoardObjects;
          data.sort((a, b) => a.full_name.toString().compareTo(b.full_name.toString()));

          data.sort((a, b) {
            if (a.active == true && b.active == false) {
              return -1;
            } else if (a.active == false && b.active == true) {
              return 1;
            } else {
              return 0;
            }
          });

          //data = data.reversed.toList();
        }
        // Map<dynamic,dynamic> mapp = new HashMap();
        // mapp = data as Map<dynamic,dynamic>;
        // board_obj obj = mapp[0];
        //  SampleTest = BoardObjects[0].full_name!;
         test_single_value(BoardObjects);
      });
    });
  }

  void test_single_value(List<board_obj> BoardObjects){
    if(data.length == BoardObjects.length){
      for(board_obj obj_have in data){
        for(board_obj obj_got in BoardObjects){
          if(obj_have.full_name == obj_got.full_name){
             if(obj_have.score != obj_got.score){
                setState(() {
                  int indx = data.indexOf(obj_have);
                  data[indx].score = obj_got.score;
                  //data.sort((a, b) => a.score.toString().compareTo(b.score.toString()));.
                  data.sort((a, b) => b.score.compareTo(a.score));

                  data.sort((a, b) {
                      if(a.active == true && b.active == false){
                        return -1;
                      }else if(a.active == false && b.active == true){
                        return 1;
                      }else{
                        return 0;
                      }
                      print(1.compareTo(2)); // => -1
                      print(2.compareTo(1)); // => 1
                      print(1.compareTo(1)); // => 0
                  });

                  //data = data.reversed.toList();
                });
             }
             if(obj_have.active != obj_got.active){
               setState(() {
                 int indx = data.indexOf(obj_have);
                 data[indx].active = obj_got.active;

                 data.sort((a, b) {
                   if (a.active == true && b.active == false) {
                     return -1;
                   } else if (a.active == false && b.active == true) {
                     return 1;
                   } else {
                     return 0;
                   }
                 });

               });
             }
             if(obj_have.selected != obj_got.selected){
               setState(() {
                 int indx = data.indexOf(obj_have);
                 data[indx].selected = obj_got.selected;
               });
             }
          }
        }
      }
    }

    // if(data.isNotEmpty){
    //   if(data[0].active == true){
    //     setState(() {
    //       data[0].active = false;
    //     });
    //   }else{
    //     setState(() {
    //       data[0].active = true;
    //     });
    //   }
    // }
  }

  void test_get(){
    DatabaseReference starCountRef =
    FirebaseDatabase.instance.ref('data/');
    starCountRef.onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.value;
      setState(() {
        SampleTest = data as String;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double? device_width = MediaQuery.of(context).size.width;
    double? device_height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: AnimatedContainer(
          duration: Duration(seconds: 1),
          width: compact_mode ? device_width*0.8 : device_width *0.6,
          child: Column(
            children: [
              SizedBox(height: 200,),
              ElevatedButton(
                  onPressed: () {
                    //SET_DATA();
                    setState(() {
                      compact_mode = !compact_mode;
                      // data.sort((a, b) => a.score.toString().compareTo(b.score.toString()));
                      //data = data.reversed.toList();
                      //full = !full;
                      //data.shuffle();
                    });
                  },
                  child: Text("Toogle Mode")),
              // ElevatedButton(
              //     onPressed: () {
              //       //SET_DATA();
              //       setState(() {
              //         //data.sort((a, b) => a.toString().compareTo(b.toString()));
              //         //data = data.reversed.toList();
              //         //full = !full;
              //         //data.shuffle();
              //       });
              //     },
              //     child: Text("GET DATA")),
              Expanded(
                child: ImplicitlyAnimatedList<board_obj>(
                    itemData: data,
                    itemBuilder: (context, dataU) {
                      return ScoreData_anim(device_width, dataU);
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget ScoreData_anim(D_Width, board_obj data_obj) {
  int index = data.indexOf(data_obj);
  double? item_width = D_Width;
  Color? Selected_Color = Colors.grey;
  Color? Active_Color = Color.fromARGB(0, 255, 255, 255);

  if (data_obj.active == true) {
    item_width = D_Width * 0.8;
    Active_Color = Color.fromARGB(0, 255, 255, 255);

    if (data_obj.selected == true) {
      Selected_Color = Colors.lightBlue;
    } else {
      Selected_Color = Colors.grey;
    }

  } else {
    item_width = D_Width * 0.6;
    Active_Color = Color.fromARGB(150, 255, 255, 255);
  }

  //item_width = full ? D_Width * 0.8 : D_Width;
  return Column(
    children: [
      data_obj.score == 0 ? AnimatedContainer(
        duration: Duration(seconds: data_obj.active == true ? 1 : 0 ),
        decoration: BoxDecoration(color: Selected_Color),
        margin: EdgeInsets.only(left: 10, right: 10),
        width: item_width,
        height: 50,
        child: Stacked_Score_Data(index,data_obj,Active_Color),
      ) : Container(
        decoration: BoxDecoration(color: Selected_Color),
        margin: EdgeInsets.only(left: 10, right: 10),
        width: item_width,
        height: 50,
        child: Stacked_Score_Data(index,data_obj,Active_Color),
      )
      ,
      SizedBox(
        height: 10,
      )
    ],
  );
}

Widget Stacked_Score_Data(index,board_obj data_obj, Color Active_Color){
  return Stack(
    alignment: Alignment.center,
    children: [
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(" ${index + 1}"),
              const SizedBox(
                width: 10,
              ),
              Container(
                  width: 30,
                  height: 40,
                  decoration: BoxDecoration(
                    image:
                    DecorationImage(image: AssetImage(FlagImages[0]), fit: BoxFit.scaleDown),
                  )),
              const SizedBox(
                width: 10,
              ),
              Text(compact_mode == true ? " ${data_obj.full_name}" : " ${data_obj.small_name}"),
              const SizedBox(
                width: 10,
              ),
            ],
          ),
          Row(
            children: [
              Text(data_obj.active == true ? " ${data_obj.score}" : "",textAlign: TextAlign.start),
              const SizedBox(width: 25,),
            ],
          ),
        ],
      ),
      Container(
        // width: item_width,
        height: 50,
        decoration: BoxDecoration(color: Active_Color),
      ),
    ],
  );
}

void SET_DATA () async{
  FirebaseDatabase database = FirebaseDatabase.instance;
  DatabaseReference ref = FirebaseDatabase.instance.ref("leaderboard/002");
  board_obj obj = board_obj("HARSH0", "HSH", 100, true,true, "icon_name");
  board_obj obj1 = board_obj("HARSH1", "HSH", 100, false,false, "icon_name");
  board_obj obj2 = board_obj("HARSH2", "HSH", 100, false,false, "icon_name");
  board_obj obj3 = board_obj("HARSH3", "HSH", 100, false,false, "icon_name");
  board_obj obj4 = board_obj("HARSH4", "HSH", 100, false,false, "icon_name");
  board_obj obj5 = board_obj("HARSH5", "HSH", 100, false,false, "icon_name");
  board_obj obj6 = board_obj("HARSH6", "HSH", 100, false,false, "icon_name");
  board_obj obj7 = board_obj("HARSH7", "HSH", 100, false,false, "icon_name");
  List <board_obj> boardObjects = [];
  boardObjects.add(obj);
  boardObjects.add(obj1);
  boardObjects.add(obj2);
  boardObjects.add(obj3);
  boardObjects.add(obj4);
  boardObjects.add(obj5);
  boardObjects.add(obj6);
  boardObjects.add(obj7);
  //boardObjects = boardObjects.reversed.toList();
  var json = jsonEncode(boardObjects.map((e) => e.toJson()).toList());
  print(boardObjects.toString());
  // Map<dynamic,dynamic> mapp = new HashMap();
  // mapp[0] = boardObjects[0].toJson();
  // mapp[1] = boardObjects[1].toJson();
  // mapp[2] = boardObjects[2].toJson();

  ref.set(json);
  // await ref.set({
  //   obj.toJson()
  // });
  // await ref.set({
  //   "name": "John",
  //   "age": 18,
  //   "address": {
  //     "line1": "100 Mountain View"
  //   }
  // });
}

Widget ScoreData(D_Width, Score, data, active) {
  int index = data.indexOf(Score);
  double? item_width = D_Width;
  Color? Active_Color = Colors.grey;
  Color? Not_Played_Color = Color.fromARGB(0, 255, 255, 255);
  if (Score == "5") {
    item_width = D_Width * 0.8;
    Active_Color = Colors.lightBlue;
  } else {
    item_width = D_Width;
    Not_Played_Color = Color.fromARGB(150, 255, 255, 255);
  }
  return Column(
    children: [
      Container(
        decoration: BoxDecoration(color: Active_Color),
        margin: EdgeInsets.only(left: 10, right: 10),
        width: item_width,
        height: 50,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(" ${index + 1}"),
                    const SizedBox(
                      width: 10,
                    ),
                    Container(
                        width: D_Width! * 0.08,
                        height: D_Width! * 0.04,
                        decoration: BoxDecoration(
                          image:
                          DecorationImage(image: AssetImage(FlagImages[index]), fit: BoxFit.scaleDown),
                        )),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(" $Score"),
                    const SizedBox(
                      width: 10,
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(" $Score'",textAlign: TextAlign.start),
                    const SizedBox(width: 25,),
                  ],
                ),
              ],
            ),
            Container(
              width: item_width,
              height: 50,
              decoration: BoxDecoration(color: Not_Played_Color),
            ),
          ],
        ),
      ),
      SizedBox(
        height: 10,
      )
    ],
  );
}
