
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

String? EventKey;
String? EventTitle = "";

List<board_obj> data = [];

class leaderboard_control extends StatefulWidget {
  static const String route = '/control';
  final String Event_Key;
  leaderboard_control({Key? key, required this.Event_Key}) : super(key: key);
  @override
  State<leaderboard_control> createState() => _leaderboardControlState(Event_Keygot: Event_Key);
}

class _leaderboardControlState extends State<leaderboard_control> {
   var Event_Keygot;
   _leaderboardControlState({required this.Event_Keygot});
  //List<String> data = ['USA', "ITM", "IND", "PTG"];
  List<String> listItems = ['USA', "ITM", "IND", "PTG"];

  @override
  void initState() {
    super.initState();
    EventKey = Event_Keygot;
    data = [];
    // test_get();
    DatabaseReference starCountRef =
    FirebaseDatabase.instance.ref("leaderboard/$EventKey");
    starCountRef.onValue.listen((DatabaseEvent event) {
      print(event.snapshot.key);
      final data_snap = event.snapshot.child("score_board").value;
      EventTitle = event.snapshot.child("title").value.toString();
      print(data_snap.toString());
      Iterable l = json.decode(data_snap.toString());
      List<board_obj> BoardObjects = List<board_obj>.from(l.map((model)=> board_obj.fromJson(model)));
      if(mounted) {
        setState(() {
          if (data.isEmpty) {
            data = BoardObjects;
            data.sort((a, b) => a.name.toString().compareTo(b.name.toString()));
          }
          test_single_value(BoardObjects);
        });
      }
    });
  }

  void test_single_value(List<board_obj> BoardObjects){
    if(data.length == BoardObjects.length){
      for(board_obj obj_have in data){
        for(board_obj obj_got in BoardObjects){
          if(obj_have.name == obj_got.name){
             if(obj_have.score != obj_got.score){
                setState(() {
                  int indx = data.indexOf(obj_have);
                  data[indx].score = obj_got.score;
                  data.sort((a, b) => a.score.toString().compareTo(b.score.toString()));
                  data = data.reversed.toList();
                });
             }
             if(obj_have.active != obj_got.active){
               setState(() {
                 int indx = data.indexOf(obj_have);
                 data[indx].active = obj_got.active;
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
          width: full ? device_width : device_width *0.6,
          child: Column(
            children: [
              SizedBox(height: 10,),
              Text("Event Score Editor",style: TextStyle(fontSize: 25),),
              SizedBox(height: 10,),
              Container(
                  margin: const EdgeInsets.all(25),
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(Icons.arrow_back_ios_new_rounded,size: 40,),
                  )),
              Text(EventTitle!,style: TextStyle(fontSize: 25),),
              SizedBox(height: 10,),
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

  Widget ScoreData_anim(D_Width, board_obj data_obj) {
    int index = data.indexOf(data_obj);
    double? item_width = D_Width;
    Color? Selected_Color = Colors.grey;
    Color? Active_Color = Color.fromARGB(0, 255, 255, 255);

    if (data_obj.active == true) {
      item_width = 600;
      Active_Color = Color.fromARGB(0, 255, 255, 255);

      if (data_obj.selected == true) {
        Selected_Color = Colors.lightBlue;
      } else {
        Selected_Color = Colors.grey;
      }

    } else {
      item_width = 450;
      Active_Color = Color.fromARGB(150, 255, 255, 255);
    }
    //item_width = full ? D_Width * 0.8 : D_Width;
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          AnimatedContainer(
            duration: Duration(seconds: 1),
            decoration: BoxDecoration(color: Selected_Color),
            margin: EdgeInsets.only(left: 10, right: 10),
            width: item_width,
            height: 100,
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
                        const SizedBox(
                          width: 10,
                        ),
                        Text(" ${index + 1}",style: TextStyle(fontSize: 25),),
                        const SizedBox(
                          width: 20,
                        ),
                        Container(
                            width: 100,
                            height: 60,
                            decoration: BoxDecoration(
                              image:
                              DecorationImage(image: AssetImage('assets/images/${data_obj.flagImgName}.png'), fit: BoxFit.fill),
                            )),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(" ${data_obj.name}",style: TextStyle(fontSize: 25),),
                        const SizedBox(
                          width: 10,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text("${data_obj.score}",textAlign: TextAlign.start),
                        const SizedBox(width: 25,),
                      ],
                    ),
                  ],
                ),
                Container(
                  // width: item_width,
                  height: 100,
                  decoration: BoxDecoration(color: Active_Color),
                ),
              ],
            ),
          ),
          SizedBox(height: 15,),
          Container(
            width: 400,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.max,
              children: [
                ElevatedButton(onPressed: (){
                    bool? active_val = data[index].active;
                    data[index].active = !active_val!;
                    Update_data();
                }, child: Icon(data[index].active == true ? Icons.check_box : Icons.check_box_outline_blank) ),
                ElevatedButton(onPressed: () async {
                  bool? selected_val = data[index].selected;
                  bool? active_val = data[index].active;
                  //if(active_val == false){
                    if(selected_val == true){
                      data[index].selected = false;
                    }else{
                      data[index].selected = true;
                    }
                    data[index].selected = true;
                    data[index].active = true;
                    for(board_obj obj in data){
                      int index_in = data.indexOf(obj);
                      if(index_in != index){
                        data[index_in].selected = false;
                      }else{
                        //data[index_in].selected = true;
                      }
                    }
                  // }else{
                  //   //data[index].selected = !selected_val!;
                  // }
                  Update_data();
                }, child: Text(data[index].selected == true ? "Selected" : "Select")),
                ElevatedButton(onPressed: () async {
                  int? score = data[index].score;
                  data[index].score = (score!+50);
                  Update_data();
                }, child: Text("+50")),
                ElevatedButton(onPressed: () async {
                  int? score = data[index].score;
                  data[index].score = (score!-50);
                  print(data[index].score);
                  if((data[index].score!) < 0){
                    data[index].score = 0;
                  }
                  print(data[index].score);
                  Update_data();
                }, child: Text("-50")),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }
}

Future<bool> Update_data() async{
  DatabaseReference ref = FirebaseDatabase.instance.ref("leaderboard");
  bool success= false;
  var json = jsonEncode(data.map((e) => e.toJson()).toList());
  await ref.child("$EventKey").child("score_board").set(json).then((_) {
     success = true;
  }).catchError((error) {
     success = false;
  });
  if(success){
    return true;
  }else{
    return false;
  }
}

void SET_DATA () async{
  FirebaseDatabase database = FirebaseDatabase.instance;
  DatabaseReference ref = FirebaseDatabase.instance.ref("leaderboard");
  board_obj obj = board_obj("Sharp", "USA", 0, false,false, "flag_usa");
  board_obj obj1 = board_obj("McKeegan", "Ireland", 0, false,false, "flag_ireland");
  board_obj obj2 = board_obj("Miroshnik", "Russia", 0, false,false, "flag_russia");
  board_obj obj3 = board_obj("Hughes", "USA", 0, false,false, "flag_usa");
  board_obj obj4 = board_obj("Maze", "Canada", 0, false,false, "flag_canada");
  List <board_obj> boardObjects = [];
  boardObjects.add(obj);
  boardObjects.add(obj1);
  boardObjects.add(obj2);
  boardObjects.add(obj3);
  boardObjects.add(obj4);
  boardObjects = boardObjects.reversed.toList();
  var json = jsonEncode(boardObjects.map((e) => e.toJson()).toList());
  print(boardObjects.toString());
  // Map<dynamic,dynamic> mapp = new HashMap();
  // mapp[0] = boardObjects[0].toJson();
  // mapp[1] = boardObjects[1].toJson();
  // mapp[2] = boardObjects[2].toJson();

  ref.child("$EventKey").child("score_board").set(json);
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
