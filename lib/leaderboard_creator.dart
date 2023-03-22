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

String SampleTest = "None";
bool full = true;

List<board_obj> data = [];

String? mainDataKeyDB = "";

bool isEditing = false;

final List<String> event_data_types = [
  "Reps",
  "Reps,Time",
  "Distance,Time",
];

String selectedEventDatatype = "Reps";

class leaderboard_creator extends StatefulWidget {
  static const String route = '/editor';
  final String? got_MainKey;
  final bool got_is_Editing;

  leaderboard_creator(
      {Key? key, this.got_MainKey, required this.got_is_Editing})
      : super(key: key);

  @override
  State<leaderboard_creator> createState() => _leaderboard_creatorState(
      got_MainKey: got_MainKey, got_is_Editing: got_is_Editing);
}

class _leaderboard_creatorState extends State<leaderboard_creator> {
  var got_MainKey;
  var got_is_Editing;

  _leaderboard_creatorState(
      {required this.got_MainKey, required this.got_is_Editing});

  double? deviceWidth;
  double? deviceHeight;

  List<String> listItems = ['USA', "ITM", "IND", "PTG"];

  Map<String, String> countryFlagMap = HashMap();

  List<String> countryNameList = [];
  List<String> countryImgName = [];

  String? Event_Title = "Event Title";

  var teamNameController = new TextEditingController();

  var eventNameController = new TextEditingController();

  @override
  void initState() {
    super.initState();

    data = [];
    teamNameController.text = "Name";
    isEditing = got_is_Editing;
    print(got_MainKey);
    if (!isEditing) {
      mainDataKeyDB = DateTime.now().millisecondsSinceEpoch.toString();
    } else {
      mainDataKeyDB = got_MainKey;
    }

    addAllFlagsData();
    print(mainDataKeyDB);
    if (isEditing) {
      DatabaseReference starCountRef =
          FirebaseDatabase.instance.ref("leaderboard/$mainDataKeyDB");
      //DatabaseReference starCountRef = FirebaseDatabase.instance.ref("leaderboard_test/test");
      starCountRef.onValue.listen((DatabaseEvent event) {
        final data_snap = event.snapshot.child("score_board").value;
        Event_Title = event.snapshot.child("title").value.toString();
        selectedEventDatatype = event.snapshot.child("type").value.toString();

        Iterable childs = event.snapshot.child("score_board").children;

        List<board_obj> BoardObjects = [];

        for (DataSnapshot snap in childs) {
          print(snap.value.toString());
          Map<String, dynamic> temp_map = HashMap();
          snap.children.forEach((element) {
            temp_map[element.key.toString()] = element.value;
          });
          BoardObjects.add(board_obj.fromJson(temp_map));
          // for(DataSnapshot snap_c in snap.children){
          //   print("${snap_c.key.toString()} = ${snap_c.value.toString()}");
          // }
        }

        // print(data_snap.toString());
        // Iterable l = json.decode(data_snap.toString());
        // List<board_obj> BoardObjects = List<board_obj>.from(l.map((model)=> board_obj.fromJson(model)));
        if (mounted) {
          setState(() {
            Event_Title = event.snapshot.child("title").value.toString();
            selectedEventDatatype =
                event.snapshot.child("type").value.toString();
            data = BoardObjects;
            data.sort((a, b) => a.id.compareTo(b.id));
          });
        }
      });
    } else {
      selectedEventDatatype = "Reps";
      board_obj obj = board_obj(
          0, "Name", "USA", 0, 0, 0, 0, 0, 0, false, false, "flag_usa");
      // board_obj obj1 = board_obj(1,"McKeegan", "Ireland", 0, false,false, "flag_ireland");
      // board_obj obj2 = board_obj(2,"Miroshnik", "Russia", 0, false,false, "flag_russia");
      // board_obj obj3 = board_obj(3,"Hughes", "USA", 0, false,false, "flag_usa");
      // board_obj obj4 = board_obj(4,"Maze", "Canada", 0, false,false, "flag_canada");

      data.add(obj);
      // data.add(obj1);
      // data.add(obj2);
      // data.add(obj3);
      // data.add(obj4);
    }
  }

  void addAllFlagsData() {
    countryFlagMap['USA'] = "flag_usa";
    countryFlagMap['Canada'] = "flag_canada";
    countryFlagMap['Russia'] = "flag_russia";
    countryFlagMap['Ireland'] = "flag_ireland";
    countryFlagMap['UK'] = "flag_uk";
    countryFlagMap['Czech Republic'] = "flag_czech_republic";
    countryFlagMap['Norway'] = "flag_norway";
    countryFlagMap['Finland'] = "flag_finland";
    countryFlagMap['Wales'] = "flag_wales";

    countryFlagMap.forEach((k, v) {
      countryNameList.add(k);
      countryImgName.add(v);
    });
  }

  @override
  Widget build(BuildContext context) {
    deviceWidth = MediaQuery.of(context).size.width;
    deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 10,
            ),
            Text(
              isEditing == true ? "Event Editor" : "Create New Event",
              style: TextStyle(fontSize: 25),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    margin: const EdgeInsets.all(25),
                    alignment: Alignment.center,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context, "refresh");
                      },
                      child: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 40,
                      ),
                    )),
                Container(
                  margin: const EdgeInsets.all(25),
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    onPressed: () {
                      board_obj obj4 = board_obj(data.length, "", "Canada", 0,
                          0, 0, 0, 0, 0, false, false, "flag_canada");
                      data.add(obj4);
                      chooseFlag(data.indexOf(obj4), true);
                    },
                    child: const Icon(
                      Icons.add,
                      size: 40,
                    ),
                  ),
                ),
                Container(
                    margin: const EdgeInsets.all(25),
                    alignment: Alignment.center,
                    child: ElevatedButton(
                      onPressed: () {
                        saveToDB();
                      },
                      child: const Icon(
                        Icons.save,
                        size: 40,
                      ),
                    )),
              ],
            ),
            DropdownButton(
              value: selectedEventDatatype,
              items: event_data_types.map((String items) {
                return DropdownMenuItem(
                  value: items,
                  child: Text(items),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  print(newValue);
                  selectedEventDatatype = newValue!;
                });
              },
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  Event_Title!,
                  style: const TextStyle(fontSize: 25),
                ),
                const SizedBox(width: 15),
                InkWell(
                    splashColor: Colors.red,
                    child: const Icon(
                      Icons.edit,
                      size: 25,
                    ),
                    onTap: () {
                      setState(() {
                        eventNameController.text = Event_Title!;
                        editTitle();
                      });
                    }),
              ],
            ),
            const SizedBox(height: 15),
            Expanded(
              child: ImplicitlyAnimatedList<board_obj>(
                  itemData: data,
                  itemBuilder: (context, dataU) {
                    return listOfData(deviceWidth, dataU);
                  }),
            ),
          ],
        ),
      ),
    );
  }

  Widget listOfData(dWidth, board_obj dataObj) {
    double iconSize = 25;
    int index = data.indexOf(dataObj);
    String flagFileName = 'assets/images/${dataObj.flagImgName}.png';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        Container(
          color: Colors.grey,
          padding: const EdgeInsets.all(10),
          width: deviceWidth,
          height: 125,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(
                width: 25,
                child: Text(" ${dataObj.id + 1}", style: TextStyle(fontSize: 17,fontWeight: FontWeight.w600)),
              ),
              const SizedBox(
                width: 0,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    width: 100,
                    height: 65,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(flagFileName), fit: BoxFit.fill),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text("${dataObj.country}", style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500)),
                ],
              ),
              //const SizedBox(width: 5,),
              SizedBox(
                width: iconSize,
                child: InkWell(
                    splashColor: Colors.red,
                    child: Icon(
                      Icons.edit_square,
                      size: iconSize,
                    ),
                    onTap: () {
                      setState(() {
                        chooseFlag(index, false);
                      });
                    }),
              ),
              const SizedBox(
                width: 20,
              ),
              SizedBox(
                  width: 125,
                  child: Text(
                    " ${dataObj.name}",
                      style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500),
                  )),
              InkWell(
                  splashColor: Colors.red,
                  child: Icon(
                    Icons.edit,
                    size: iconSize,
                  ),
                  onTap: () {
                    setState(() {
                      editName(index, false);
                      teamNameController.text = dataObj.name!;
                    });
                  }),
              InkWell(
                  splashColor: Colors.red,
                  child: Icon(
                    Icons.delete_sharp,
                    size: iconSize,
                  ),
                  onTap: () {
                    deleteConfirmation(index);
                    // setState(() {
                    //   data.removeAt(index);
                    // });
                  }),
              data.length == index + 1
                  ? const SizedBox(
                width: 25,
              )
                  : InkWell(
                  splashColor: Colors.red,
                  child: Icon(
                    Icons.arrow_circle_down,
                    size: iconSize,
                  ),
                  onTap: () {
                    setState(() {
                      var tmp1 = data[index]; // 0
                      data[index] = data[index + 1];
                      data[index + 1] = tmp1;
                      reAssignId();
                    });
                  }),
              index == 0
                  ? const SizedBox(
                width: 20,
              )
                  : InkWell(
                  splashColor: Colors.red,
                  child: Icon(
                    Icons.arrow_circle_up,
                    size: iconSize,
                  ),
                  onTap: () {
                    setState(() {
                      var tmp1 = data[index]; // 0
                      data[index] = data[index - 1];
                      data[index - 1] = tmp1;
                      reAssignId();
                    });
                  }),
              const SizedBox(
                width: 5,
              ),
            ],
          ),
        ),
      ],
    );
  }

  void deleteConfirmation(int index) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Confirmation'),
            content: Text("Are you Sure to Delete?"),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    setState(() {
                      data.removeAt(index);
                    });
                  },
                  child: const Text("Delete")),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Cancel")),
            ],
          );
        });
  }

  void editTitle() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Edit Event Name'),
            content: TextField(
              onChanged: (value) {},
              controller: eventNameController,
              decoration: const InputDecoration(hintText: "Enter Event Name"),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    setState(() {
                      Event_Title = eventNameController.text;
                    });
                    Navigator.pop(context);
                  },
                  child: const Text("Save")),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Cancel")),
            ],
          );
        });
  }

  void saveToDB() {
    DatabaseReference ref =
        FirebaseDatabase.instance.ref("leaderboard/$mainDataKeyDB");
    Map<String, dynamic> maptest = HashMap();

    for (board_obj obj_ in data) {
      maptest[obj_.id.toString()] = obj_.toJson();
    }

    Map<dynamic, dynamic> map_to_save = HashMap();

    map_to_save["title"] = Event_Title;
    map_to_save["type"] = selectedEventDatatype;
    map_to_save["score_board"] = maptest;
    map_to_save["compact_mode"] = false;

    ref.set(map_to_save).then((value) {
      setState(() {});
    }).onError((error, stackTrace) {
      ShowSnackBar("Error Data not Saved");
      showAlertDialog(context, 'Error Data not Saved');
    }).whenComplete(() {
      ShowSnackBar("Data Saved");
      showAlertDialog(context, 'Data Saved');
    });

    // ref.child("title").set(Event_Title).then((value) {
    //   Map<String, dynamic> maptest = HashMap();
    //
    //   ref.child("type").set(selectedEventDatatype);
    //
    //   for (board_obj obj_ in data) {
    //     maptest[obj_.id.toString()] = obj_.toJson();
    //   }
    //
    //   //var json = jsonEncode(data.map((e) => e.toJson()).toList());
    //   ref.child("score_board").set(maptest).then((value) {
    //     ShowSnackBar("Data Saved");
    //     showAlertDialog(context, 'Data Saved');
    //   }).onError((error, stackTrace) {
    //     ShowSnackBar("Error Data not Saved");
    //     showAlertDialog(context, 'Error Data not Saved');
    //   });
    // }).onError((error, stackTrace) {
    //   ShowSnackBar("Error Data not Saved");
    //   showAlertDialog(context, 'Error Data not Saved');
    // });

    // var json = jsonEncode(data.map((e) => e.toJson()).toList());
    // ref.set(json).then((value) {
    //   ShowSnackBar("Data Saved");
    //   showAlertDialog(context,'Data Saved');
    // }).onError((error, stackTrace) {
    //   ShowSnackBar("Error Data not Saved");
    //   showAlertDialog(context,'Error Data not Saved');
    // });
  }

  showAlertDialog(BuildContext context, String msg) {
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

  void chooseFlag(int indexS, bool addingNew) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Country List',
              textAlign: TextAlign.center,
            ),
            content: setupAlertDialogContainer(indexS, addingNew),
            actions: [
              TextButton(
                  onPressed: () {
                    if (addingNew) {
                      setState(() {
                        data.removeAt(indexS);
                      });
                    }
                    Navigator.pop(context);
                  },
                  child: Text("Cancel")),
            ],
          );
        });
  }

  void editName(int indexIn, bool addingNew) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Edit Name'),
            content: TextField(
              onChanged: (value) {},
              controller: teamNameController,
              decoration: InputDecoration(hintText: "Enter Name"),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    if (isNameUnique(teamNameController.text, indexIn)) {
                      setState(() {
                        data[indexIn].name = teamNameController.text;
                      });
                      Navigator.pop(context);
                    } else {
                      ShowSnackBar('Name Already Exists');
                    }
                  },
                  child: const Text("Save")),
              TextButton(
                  onPressed: () {
                    if (addingNew) {
                      setState(() {
                        data.removeAt(indexIn);
                      });
                    }
                    Navigator.pop(context);
                  },
                  child: const Text("Cancel")),
            ],
          );
        });
  }

  Widget setupAlertDialogContainer(int indexToChange, bool addingNew) {
    return SizedBox(
      width: double.maxFinite,
      height: double.maxFinite,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: countryNameList.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            margin: EdgeInsets.only(top: 5),
            alignment: Alignment.center,
            color: Colors.grey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                const SizedBox(
                  width: 5,
                ),
                Text('${countryNameList[index]}'),
                InkWell(
                    splashColor: Colors.red,
                    child: Container(
                        width: 150,
                        height: 100,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(
                                  'assets/images/${countryImgName[index]}.png'),
                              fit: BoxFit.fitHeight),
                        )),
                    onTap: () {
                      setState(() {
                        data[indexToChange].flagImgName = countryImgName[index];
                        data[indexToChange].country = countryNameList[index];
                      });
                      Navigator.pop(context);
                      if (addingNew) {
                        editName(indexToChange, addingNew);
                      }
                    }),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void reAssignId() {
    for (board_obj obj in data) {
      obj.id = data.indexOf(obj);
    }
  }

  bool isNameUnique(String nameCheck, int indexAt) {
    for (board_obj obj in data) {
      if (obj.name?.toLowerCase() == nameCheck.toLowerCase()) {
        if (indexAt == data.indexOf(obj)) {
          // If not Changed Name
          return true;
        }
        return false;
      }
    }
    return true;
  }

  void ShowSnackBar(String textToShow) {
    var snackBar = SnackBar(content: Text(textToShow));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
