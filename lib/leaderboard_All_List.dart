
import 'dart:async';
import 'dart:collection';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
    DatabaseReference starCountRef = FirebaseDatabase.instance.ref("leaderboard");
    //final snapshot = await starCountRef.get();
    //final snapshot = await starCountRef.get();
    await starCountRef.onValue.listen((DatabaseEvent event) {
      final snapshot = event.snapshot;
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
    });
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
            Text("ALL EVENTS LIST",style: TextStyle(fontSize: 25,fontWeight: FontWeight.w600)),
              // Text("ALL EVENTS LIST",style: GoogleFonts.montserrat(
              //     fontSize: 25,
              //     fontWeight: FontWeight.w600,
              //     fontStyle: FontStyle.normal,
              // ),),
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
            All_Event_Titles.length > 0 ? Expanded(
                child: ImplicitlyAnimatedList<String>(
                    itemData: All_Event_Titles,
                    itemBuilder: (context, dataU) {
                      return Show_List_of_Events(deviceWidth, dataU);
                    }),
              ) : Text("No Events Added Press + to add."),
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
                      style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.red)),
                      onPressed: () {
                        //deleteEventFromDb(index);
                        copyEvent(index);
                      },
                      child: const Icon(Icons.copy_all,size: 25,),
                    ),
                    const SizedBox(width: 5,),
                    ElevatedButton(
                      style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.amber)),
                      onPressed: () {
                        openScoreEditor(index);
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
    print("EDIT ${index} : ${All_Event_Keys[index]}");
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

  void openScoreEditor(int index){
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

  void copyEvent(int index){
    String key = All_Event_Keys[index];
    String title = All_Event_Titles[index];

    String copiedEventKey = mainDataKeyDB = DateTime.now().millisecondsSinceEpoch.toString();

    List<board_obj> tempCopiedData = [];

    DatabaseReference starCountRef = FirebaseDatabase.instance.ref("leaderboard/$key");

    starCountRef.get().then((value){
      Iterable childs = value.child("score_board").children;
      String title = value.child("title").value as String;
      title = "${title}_Copied";
      String data_type = value.child("type").value as String;
      for(DataSnapshot snap in childs){
        print(snap.value.toString());
        Map<String,dynamic> tempMap = HashMap();
        snap.children.forEach((element) {
          tempMap[element.key.toString()] = element.value;
        });
        tempCopiedData.add(board_obj.fromJson(tempMap));
      }

      if(tempCopiedData.isNotEmpty){

        for(board_obj obj in tempCopiedData){
          obj.reps = 0;
          obj.distance = 0;
          obj.time = 0;
          obj.score = 0;
          obj.total = 0;
          obj.place = 0;
        }

        saveCopiedToDB(tempCopiedData,title,data_type,copiedEventKey);
      }

    });

  }

  void saveCopiedToDB(List<board_obj> data,String Event_Title,String selectedEventDatatype,String newEventKey) {
    DatabaseReference ref = FirebaseDatabase.instance.ref("leaderboard/$newEventKey");
    Map<String, dynamic> maptest = HashMap();

    for (board_obj obj_ in data) {
      maptest[obj_.id.toString()] = obj_.toJson();
    }

    Map<dynamic, dynamic> map_to_save = HashMap();

    map_to_save["title"] = Event_Title;
    map_to_save["type"] = selectedEventDatatype;
    map_to_save["score_board"] = maptest;
    map_to_save["compact_mode"] = false;

    ref.set(map_to_save).then((value) {}).onError((error, stackTrace) {})
        .whenComplete(() {
      if(kIsWeb){
        html.window.location.href = "#editor?event_key=${newEventKey}&editing=true";
      }else{
        // scores?event_key=1678711717666&route=scores
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => leaderboard_creator(got_is_Editing: true,got_MainKey: newEventKey,),
            ));
      }
    });
  }

  void deleteEventFromDb(int index){
    String key = All_Event_Keys[index];
    String title = All_Event_Titles[index];
    DatabaseReference starCountRef =
    FirebaseDatabase.instance.ref("leaderboard");
    starCountRef.child(key).remove().then((value){
      print('TestWidget: ${ModalRoute.of(context)?.isCurrent}');
      // ShowSnackBar("$title Event Deleted");
      // showAlertDialog(context,"$title Event Deleted");
      setState(() {
        // All_Event_Titles.removeAt(index);
        // All_Event_Keys.removeAt(index);
      });
    }).onError((error, stackTrace){
      print(stackTrace.toString());
      ShowSnackBar("Failed to Delete $title ");
      showAlertDialog(context,"Failed to Delete $title Event.");
    }).whenComplete(() {
      ShowSnackBar("$title Event Deleted");
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
    if(ModalRoute.of(context)?.isCurrent == true){
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

}

