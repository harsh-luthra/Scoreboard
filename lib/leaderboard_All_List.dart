
import 'dart:async';
import 'dart:collection';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:implicitly_animated_list/implicitly_animated_list.dart';
import 'package:leaderboard/Grid_Control_Scores.dart';
import 'package:leaderboard/leaderboard.dart';
import 'package:leaderboard/leaderboard_control.dart';

import 'package:leaderboard/leaderboard_creator.dart';

import 'package:universal_html/html.dart' as html;

import 'board_obj.dart';

final List<String> event_data_types = [
  "Reps",
  "Reps,Time",
  "Distance,Time",
];

class leaderboard_all_list extends StatefulWidget {
  static const String route = '/all_events';
  leaderboard_all_list({Key? key}) : super(key: key);
  @override
  State<leaderboard_all_list> createState() => _leaderboardAllListState();
}

class _leaderboardAllListState extends State<leaderboard_all_list> {
  List<String> All_Event_Titles = [];
  List<String> All_Event_Keys = [];

  @override
  void initState() {
    Load_List_OF_DATA();
    super.initState();
    //Load_List_OF_DATA();
  }

  void Load_List_OF_DATA() async{
    DatabaseReference starCountRef =
    FirebaseDatabase.instance.ref("leaderboard");
    final snapshot = await starCountRef.get();
    if (snapshot.exists){
      All_Event_Titles = [];
      All_Event_Keys = [];
      print(snapshot.key);
      Iterable allData = snapshot.children;
      if(allData.length == 1){
        DataSnapshot dt = allData.first as DataSnapshot;
        if(dt.key == "sample"){
          ShowSnackBar('No data available.');
          print('No data available.');
          return;
        }
      }
      for(DataSnapshot snap in allData){
        if(snap.key! == "sample" || snap.key! == "null"){
          continue;
        }
        All_Event_Keys.add(snap.key!);
        All_Event_Titles.add(snap.child("title").value.toString());
      }
      if(mounted) {
        setState(() {
          All_Event_Titles = All_Event_Titles;
        });
      }
      ShowSnackBar('Data Loaded.');
    } else {
      ShowSnackBar('No data available.');
      print('No data available.');
    }
  }

  @override
  Widget build(BuildContext context) {
    double? deviceWidth = MediaQuery.of(context).size.width;
    double? device_height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: AnimatedContainer(
          alignment: Alignment.center,
          duration: const Duration(seconds: 1),
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
              const SizedBox(height: 50,),
              const Text("ALL EVENTS LIST",style: TextStyle(fontSize: 25)),
              const SizedBox(height: 25,),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        addNewEvent();
                        //Update_data_TEST();
                      },
                      child: const Icon(Icons.add,size: 40,)),
                  const SizedBox(width: 25,),
                  ElevatedButton(
                      onPressed: () {
                        Load_List_OF_DATA();
                      },
                      child: const Icon(Icons.refresh,size: 40,)),
                ],
              ),
              const SizedBox(height: 15,),
              Expanded(
                child: ImplicitlyAnimatedList<String>(
                    itemData: All_Event_Titles,
                    itemBuilder: (context, dataU) {
                      return Show_List_of_Events(deviceWidth, dataU);
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> Update_data_TEST() async{
    DatabaseReference ref = FirebaseDatabase.instance.ref("leaderboard_test");
    bool success= false;
    //var json = jsonEncode(BoardObjects.map((e) => e.toJson()).toList());
    Map<String,dynamic> maptest = HashMap();

    List<board_obj> board_objS = [];

    board_obj obj = board_obj(0,"Harsh", "USA01", 0, 0,0,0,0,0,false, false, "flag_usa");
    board_obj obj1 = board_obj(1,"McKeegan", "Ireland", 0, 0,0,0,0,0,false, false, "flag_ireland");
    board_obj obj2 = board_obj(2,"Miron's", "Russia", 0, 0,0,0,0,0,false, false, "flag_russia");
    board_obj obj3 = board_obj(3,"Hughes", "UK", 0, 0,0,0,0,0,false, false, "flag_uk");
    board_obj obj4 = board_obj(4,"Rahul", "Canada", 0, 0,0,0,0,0,false, false, "flag_czech_republic");
    board_obj obj5 = board_obj(5,"Maze", "Czech_Republic", 0, 0,0,0,0,0,false, false, "flag_canada");

    board_objS.add(obj);
    board_objS.add(obj1);
    board_objS.add(obj2);
    board_objS.add(obj3);
    board_objS.add(obj4);
    board_objS.add(obj5);

    for(board_obj obj_ in board_objS){
      maptest[obj_.flagImgName!] = obj_.toJson();
    }

    await ref.child("test").child("score_board").set(maptest).then((_) {
      success = true;
    }).catchError((error) {
      success = false;
    });
    return true;
  }

  Widget Show_List_of_Events(double deviceWidth, String title){
    int index = All_Event_Titles.indexOf(title);
    print(title);
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
              decoration: BoxDecoration(
                color: Colors.blue,
                border: Border.all(
                  color: Colors.blue,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(20)),
              ),
            //color: Colors.blue,
            alignment: Alignment.center,
            width: 600,
            padding: const EdgeInsets.all(15),
            margin: const EdgeInsets.all(5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(title,style: const TextStyle(fontSize: 25),textAlign: TextAlign.center,),
                SizedBox(height: 10,),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    ElevatedButton(
                    style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.green)),
                      onPressed: () {
                      print(All_Event_Keys[index]);
                        //Navigator.pushNamed(context, leaderboard_creator.route,arguments: {"got_is_Editing":true,"got_MainKey": All_Event_Keys[index]});
                        openEditor(index);
                      },
                      child: const Icon(Icons.edit,size: 25,),
                    ),
                    const SizedBox(width: 5,),
                    ElevatedButton(
                      style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.amber)),
                      onPressed: () {
                        Open_Score_Editor(index);
                      },
                      child: const Icon(Icons.settings,size: 25,),
                    ),

                    const SizedBox(width: 5,),
                    ElevatedButton(
                      style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.purple)),
                      onPressed: () {
                        if(kIsWeb){
                          //html.window.location.href = "#scores?event_key=${All_Event_Keys[index]}&route=scores";
                          html.window.open('${Uri.base.origin}/#gridControl?event_key=${All_Event_Keys[index]}&route=scores',"_blank");
                        }else{
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => GridControlScores(Event_Key: All_Event_Keys[index]),
                              ));
                        }
                      },
                      child: const Icon(Icons.app_registration_rounded,size: 25,),
                    ),
                    const SizedBox(width: 5,),
                    ElevatedButton(
                      style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.purple)),
                      onPressed: () {
                        if(kIsWeb){
                          //html.window.location.href = "#scores?event_key=${All_Event_Keys[index]}&route=scores";
                          html.window.open('${Uri.base.origin}/#scores?event_key=${All_Event_Keys[index]}&route=scores',"_blank");
                        }else{
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => leaderboard(Event_Key: All_Event_Keys[index]),
                              ));
                        }
                      },
                      child: const Icon(Icons.remove_red_eye_sharp,size: 25,),
                    ),
                    const SizedBox(width: 5,),
                    ElevatedButton(
                      style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.red)),
                      onPressed: () {
                        //deleteEventFromDb(index);
                        deleteConfirmation(index);
                      },
                      child: const Icon(Icons.delete_sharp,size: 25,),
                    ),
                  ],
                ),
              ],
            )),
        ],
      ),
    );
  }

  void openEditor(int index) async{
    if(kIsWeb){
      html.window.location.href = "#editor?event_key=${All_Event_Keys[index]}&editing=true";
    }else{
      // scores?event_key=1678711717666&route=scores
      String refresh = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => leaderboard_creator(got_is_Editing: true,got_MainKey: All_Event_Keys[index],),
          ));
      if(refresh == "refresh"){
        Load_List_OF_DATA();
      }
    }
  }

  void deleteConfirmation(int index){
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Confirmation'),
            content: Text(
                "Are you Sure to Delete Event ${All_Event_Titles[index]}?"
            ),
            actions: [
              TextButton(onPressed: (){
                Navigator.pop(context);
                setState(() {
                  deleteEventFromDb(index);
                });
              }, child: const Text("Delete")),
              TextButton(onPressed: (){
                Navigator.pop(context);
              }, child: const Text("Cancel")),
            ],
          );
        });
  }

  void Open_Score_Editor(int index){
    if(kIsWeb){
      html.window.location.href = "#control?event_key=${All_Event_Keys[index]}&route=control";
    }else{
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => leaderboard_control(Event_Key: All_Event_Keys[index]),
          ));
    }

  }

  void addNewEvent(){
    if(kIsWeb){
      html.window.location.href = "#editor?event_key=sample&editing=false";
    }else{
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => leaderboard_creator(got_is_Editing: false),
          ));
    }
  }

  void deleteEventFromDb(int index){
    String key = All_Event_Keys[index];
    String title = All_Event_Titles[index];
    DatabaseReference starCountRef =
    FirebaseDatabase.instance.ref("leaderboard");
    starCountRef.child(key).remove().then((value){
      ShowSnackBar("$title Event Deleted");
      showAlertDialog(context,"$title Event Deleted");
      setState(() {
        All_Event_Titles.removeAt(index);
        All_Event_Keys.removeAt(index);
      });
    }).onError((error, stackTrace){
      ShowSnackBar("Failed to Delete $title ");
      showAlertDialog(context,"$title Event Deleted");
    });
  }

  showAlertDialog(BuildContext context,String msg) {
    // set up the button
    Widget okButton = TextButton(
      child: const Text("OK"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Alert"),
      content: Text(msg),
      actions: [
        okButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void ShowSnackBar(String textToShow){
    var snackBar = SnackBar(content: Text(textToShow));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

}

