
import 'dart:collection';
import 'dart:convert';
import 'package:universal_html/html.dart' as html;
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:implicitly_animated_list/implicitly_animated_list.dart';

import 'package:leaderboard/board_obj.dart';

String SampleTest = "None";
bool full = true;
bool compact_mode = false;

List<board_obj> data = [];

final List<String> event_data_types = [
  "Reps",
  "Reps,Time",
  "Distance,Time",
];

String selectedEventDatatype = "Reps";

int data_type = 0;

class leaderboard extends StatefulWidget {
  static const String route = '/scores';
  final String Event_Key;
  leaderboard({Key? key, required this.Event_Key}) : super(key: key);
  @override
  State<leaderboard> createState() => _leaderboardState(EventKey: Event_Key);
}

class _leaderboardState extends State<leaderboard> {
  var EventKey;
  _leaderboardState({required this.EventKey});
  //List<String> data = ['USA', "ITM", "IND", "PTG"];
  List<String> listItems = ['USA', "ITM", "IND", "PTG"];

  @override
  void initState() {
    super.initState();
    // /?event_key=1678711717666&route=scores
    // String myurl = Uri.base.toString(); //get complete url
    // String? event_key = Uri.base.queryParameters["event_key"]; //get parameter with attribute "para1"
    // String? route = Uri.base.queryParameters["route"]; //get parameter with attribute "para2"
    // print(myurl);
    // print(event_key);
    // print(route);
    //html.window.location.href = "/?event_key=$EventKey&route=scores";
    // test_get();

    data = [];

    DatabaseReference starCountRef =
    //FirebaseDatabase.instance.ref("leaderboard/003");
    FirebaseDatabase.instance.ref("leaderboard/$EventKey");
    starCountRef.onValue.listen((DatabaseEvent event) {

      Iterable childs = event.snapshot.child("score_board").children;

      List<board_obj> BoardObjects = [];
      for(DataSnapshot snap in childs){
        print(snap.value.toString());
        Map<String,dynamic> temp_map = HashMap();
        snap.children.forEach((element) {
          temp_map[element.key.toString()] = element.value;
        });
        BoardObjects.add(board_obj.fromJson(temp_map));
        for(DataSnapshot snap_c in snap.children){
          print("${snap_c.key.toString()} = ${snap_c.value.toString()}");
        }
      }

      if(mounted) {
        setState(() {
          if (data.isEmpty) {
            selectedEventDatatype = event.snapshot.child("type").value.toString();
            Replace_data_to_New(BoardObjects);
            sort_active();
            data.sort((a, b) => b.reps.compareTo(a.reps));
            sortByDataType();
            //data.sort((a, b) => a.name.toString().compareTo(b.name.toString()));
            //data = data.reversed.toList();
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
          if(obj_have.id == obj_got.id){
             if(obj_have.reps != obj_got.reps){
                setState(() {
                  int indx = data.indexOf(obj_have);
                  data[indx].reps = obj_got.reps;
                  //data.sort((a, b) => a.score.toString().compareTo(b.score.toString()));.
                  //sort_active();
                  //data.sort((a, b) => b.reps.compareTo(a.reps));
                  sortByDataType();
                  //data = data.reversed.toList();
                });
             }
             if(obj_have.distance != obj_got.distance){
               setState(() {
                 int indx = data.indexOf(obj_have);
                 data[indx].distance = obj_got.distance;
                 sortByDataType();
                 //data.sort((a, b) => b.reps.compareTo(a.reps));
               });
             }
             if(obj_have.time != obj_got.time){
               setState(() {
                 int indx = data.indexOf(obj_have);
                 data[indx].time = obj_got.time;
                 sortByDataType();
                 //data.sort((a, b) => b.reps.compareTo(a.reps));
               });
             }
             if(obj_have.score != obj_got.score){
               setState(() {
                 int indx = data.indexOf(obj_have);
                 data[indx].score = obj_got.score;
                 //data.sort((a, b) => b.reps.compareTo(a.reps));
               });
             }
             if(obj_have.total != obj_got.total){
               setState(() {
                 int indx = data.indexOf(obj_have);
                 data[indx].total = obj_got.total;
               });
             }
             if(obj_have.place != obj_got.place){
               setState(() {
                 int indx = data.indexOf(obj_have);
                 data[indx].place = obj_got.place;
               });
             }
             if(obj_have.active != obj_got.active){
               setState(() {
                 int indx = data.indexOf(obj_have);
                 data[indx].active = obj_got.active;
                 data.sort((a, b) => b.reps.compareTo(a.reps));
                 sort_active();
               });
             }
             if(obj_have.selected != obj_got.selected){
               setState(() {
                 int indx = data.indexOf(obj_have);
                 data[indx].selected = obj_got.selected;
               });
             }
          }else{
            //Replace_data_to_New(BoardObjects);
          }
        }
      }
    }else{
      //Replace_data_to_New(BoardObjects);
    }
  }

  void sortByDataType(){
    // Need to Fix Sort By with Time Logic
    if(selectedEventDatatype == event_data_types[1]){ // REPS TIME
      data.sort((a, b) => b.reps.compareTo(a.reps));
      data.sort((a, b) => b.time.compareTo(a.time));
      data_type = 1;
    }else if(selectedEventDatatype == event_data_types[2]){  // DISTANCE TIME
      data.sort((a, b) => b.distance.compareTo(a.distance));
      data.sort((a, b) => b.time.compareTo(a.time));
      data_type = 2;
    }else{ // REPS
      data.sort((a, b) => b.reps.compareTo(a.reps));
      data_type = 0;
    }
  }

  void Replace_data_to_New(List<board_obj>  BoardObjects){
    setState(() {
      data = BoardObjects;
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

  void sort_active(){
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
          width: !compact_mode ? device_width*0.8 : device_width *0.6,
          child: Column(
            children: [
              SizedBox(height: 50,),
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
      //data_obj.reps == 0 ?
      AnimatedContainer(
        duration: Duration(seconds: data_obj.active == true ? 1 : 0 ),
        decoration: BoxDecoration(color: Selected_Color),
        margin: EdgeInsets.only(left: 10, right: 10),
        width: item_width,
        height: 50,
        child: Stacked_Score_Data(index,data_obj,Active_Color),
      )
      //     : Container(
      //   decoration: BoxDecoration(color: Selected_Color),
      //   margin: EdgeInsets.only(left: 10, right: 10),
      //   width: item_width,
      //   height: 50,
      //   child: Stacked_Score_Data(index,data_obj,Active_Color),
      // )
      ,
      const SizedBox(
        height: 10,
      )
    ],
  );
}

Widget Stacked_Score_Data(index,board_obj data_obj, Color Active_Color){
  String to_show = "";
  print("DATA TYPE: $data_type");
  if(data_obj.active == true){
    if(data_type == 0){
      to_show = "${data_obj.reps}";
    }else if(data_type == 1){
      to_show = "${data_obj.reps} - ${data_obj.time}Sec";
    }else if(data_type == 2){
      if(data_obj.time > 0){
        to_show = "${data_obj.time}Sec";
      }else{
        to_show = "${data_obj.distance}Ft";
      }
    }
  }else{
    to_show = "";
  }

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
                    DecorationImage(image: AssetImage('assets/images/${data_obj.flagImgName}.png'), fit: BoxFit.scaleDown),
                  )),
              const SizedBox(
                width: 10,
              ),
              Text(compact_mode != true ? " ${data_obj.name}" : " ${data_obj.country}"),
              const SizedBox(
                width: 10,
              ),
            ],
          ),
          Row(
            children: [
              Text(to_show,textAlign: TextAlign.start),
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
  board_obj obj = board_obj(0,"Sharp", "USA", 0, 0,0,0,0,0,false,false, "flag_usa");
  board_obj obj1 = board_obj(1,"McKeegan", "Ireland", 0, 0,0,0,0,0,false,false, "flag_ireland");
  board_obj obj2 = board_obj(2,"Miroshnik", "Russia", 0, 0,0,0,0,0, false,false, "flag_russia");
  board_obj obj3 = board_obj(3,"Hughes", "USA", 0, 0,0,0,0,0,false,false, "flag_usa");
  board_obj obj4 = board_obj(4,"Maze", "Canada", 0, 0,0,0,0,0,false,false, "flag_canada");
  List <board_obj> boardObjects = [];
  boardObjects.add(obj);
  boardObjects.add(obj1);
  boardObjects.add(obj2);
  boardObjects.add(obj3);
  boardObjects.add(obj4);
  //boardObjects = boardObjects.reversed.toList();
  var json = jsonEncode(boardObjects.map((e) => e.toJson()).toList());
  print(boardObjects.toString());
  // Map<dynamic,dynamic> mapp = new HashMap();
  // mapp[0] = boardObjects[0].toJson();
  // mapp[1] = boardObjects[1].toJson();
  // mapp[2] = boardObjects[2].toJson();

  ref.set(json);
}
