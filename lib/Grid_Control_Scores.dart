import 'dart:collection';
import 'dart:convert';

import 'package:cross_scroll/cross_scroll.dart';
import 'package:file_saver/file_saver.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:pluto_grid_export/pluto_grid_export.dart' as pluto_grid_export;
import 'package:universal_html/html.dart';

import 'board_obj.dart';

String eventTitle = "Event Title";
String? EventKey;

bool Compact_Mode = false;

final List<String> event_data_types = [
  "Reps",
  "Reps,Time",
  "Distance,Time",
];

List<String> selectActivePLayerList = ["0 - NONE",];

String CurrenSelectedActivePlayer = "0 - NONE";

String selectedEventDatatype = "Reps";

bool autoUpdate = true;

class GridControlScores extends StatefulWidget {
  final String Event_Key;
  const GridControlScores({Key? key, required this.Event_Key}) : super(key: key);

  @override
  State<GridControlScores> createState() => _GridControlScoresState(Event_Keygot: Event_Key);
}
class _GridControlScoresState extends State<GridControlScores> {
  var Event_Keygot;
  _GridControlScoresState({required this.Event_Keygot});

  List<board_obj> BoardObjects = [];

  @override
  void initState() {
    super.initState();
    //createDummyScoreData();
    //addColumnsDataFromList();
    LOAD_ALL_DATA();
  }

  @override
  Future<void> load() async {
  }

  LOAD_ALL_DATA() async {


    // createColumnsFromData();


    EventKey = Event_Keygot;

    setState(() {
      BoardObjects= [];
    });

    DatabaseReference starCountRef = FirebaseDatabase.instance.ref("leaderboard/$EventKey");
    await starCountRef.onValue.listen((DatabaseEvent event) {
      final dataSnap = event.snapshot.child("score_board").value;
      Iterable childs = event.snapshot.child("score_board").children;
      if(BoardObjects.isEmpty) {
        setState(() {
          eventTitle = event.snapshot.child("title").value.toString();
          selectedEventDatatype = event.snapshot.child("type").value.toString();
          Compact_Mode = event.snapshot.child("compact_mode").value as bool;
        });
        createColumnsFromData();
      }
      List<board_obj> tempBoardobjects = [];
      for(DataSnapshot snap in childs){
        print(snap.value.toString());
        Map<String,dynamic> tempMap = HashMap();
        snap.children.forEach((element) {
          tempMap[element.key.toString()] = element.value;
        });
        tempBoardobjects.add(board_obj.fromJson(tempMap));
        // for(DataSnapshot snap_c in snap.children){
        //   print("${snap_c.key.toString()} = ${snap_c.value.toString()}");
        // }
      }
      if(mounted){
        print("GRID ALL LOADED AGAINA");
        setState(() {
          Compact_Mode = event.snapshot.child("compact_mode").value as bool;
          if(BoardObjects.isEmpty) {
            BoardObjects = tempBoardobjects;
            addDataToSelectCurrentPlayerList();
            print(BoardObjects);
            addColumnsDataFromList();
          }
        });
      }
    });
  }

  final List<String> columnsNames = [
    "id",
    "name",
    "country",
    "reps",
    "distance",
    "time",
    "score",
    "total",
    "place",
    "active",
    "selected",
    "icon_name",
  ];

  List<PlutoColumn> allColumns = <PlutoColumn>[];

  List<PlutoRow> allRows = <PlutoRow>[];

  late final PlutoGridStateManager stateManager;

  bool IsBlackThemeMode = true;

  Color? TextColorTheme = Colors.black;

  void addDataToSelectCurrentPlayerList(){
    selectActivePLayerList = ["0 - NONE"];
    for(board_obj obj in BoardObjects){
      String toAdd = "${BoardObjects.indexOf(obj) + 1} - ${obj.name}";
      selectActivePLayerList.add(toAdd);
      if(obj.selected == true && obj.active == true){
        CurrenSelectedActivePlayer = toAdd;
      }
    }

  }

  void createDummyScoreData() {
    board_obj obj = board_obj(0,"Harsh", "USA", 0, 0,0,0,0,0,false, false, "flag_usa");
    board_obj obj1 = board_obj(1,"McKeegan", "Ireland", 0, 0,0,0,0,0,false, false, "flag_ireland");
    board_obj obj2 = board_obj(2,"Miron's", "Russia", 0, 0,0,0,0,0,false, false, "flag_russia");
    board_obj obj3 = board_obj(3,"Hughes", "UK", 0, 0,0,0,0,0,false, false, "flag_uk");
    board_obj obj4 = board_obj(4,"Rahul", "Canada", 0, 0,0,0,0,0,false, false, "flag_canada");
    board_obj obj5 = board_obj(5,"Maze", "Czech_Republic", 0, 0,0,0,0,0,false, false, "flag_czech_republic");

    BoardObjects.add(obj);
    BoardObjects.add(obj1);
    BoardObjects.add(obj2);
    BoardObjects.add(obj3);
    BoardObjects.add(obj4);
    BoardObjects.add(obj5);
  }

  void createColumnsFromData() {
    allColumns = [
      PlutoColumn(
        title: 'id',
        field: 'id',
        type: PlutoColumnType.number(),
        enableColumnDrag: false,
        enableRowDrag: false,
        readOnly: true,
        enableSorting: false,
        enableContextMenu: false,
        enableDropToResize: false,
        enableAutoEditing: true,
        enableEditingMode: true,
        renderer: (rendererContext) {
          return (Container(
            color: IsBlackThemeMode == true ? Colors.black : Colors.white,
            child: Text(rendererContext.stateManager.refRows[rendererContext.rowIdx].cells["id"]!.value.toString(),
            style: TextStyle( color: (selectActivePLayerList.indexOf(CurrenSelectedActivePlayer)-1 == rendererContext.rowIdx
            ) ? Colors.green : TextColorTheme
            ,fontSize: 18),),
          ));
        }
      ),
      // PlutoColumn(
      //   title: 'Selected',
      //   field: 'selected',
      //   type: PlutoColumnType.select(<String>[
      //   'true',
      //   'false',
      //   ]),
      //   enableColumnDrag: false,
      //   enableRowDrag: false,
      //   readOnly: false,
      //   enableSorting: false,
      //   enableContextMenu: false,
      //   enableDropToResize: false,
      //   enableAutoEditing: true,
      //   enableEditingMode: true,
      //   //enableRowChecked: true,
      // ),
      // PlutoColumn(
      //   title: 'Flag',
      //   field: 'flag',
      //   type: PlutoColumnType.text(),
      //   enableColumnDrag: false,
      //   enableRowDrag: false,
      //   readOnly: true,
      //   enableSorting: false,
      //   enableContextMenu: false,
      //   enableDropToResize: false,
      //   renderer: (rendererContext) {
      //     String flagName = "flag_usa";
      //     if (rendererContext.cell.value == 'flag_usa') {
      //       flagName = "flag_usa";
      //     } else if (rendererContext.cell.value == 'flag_ireland') {
      //       flagName = "flag_ireland";
      //     } else if (rendererContext.cell.value == 'flag_russia') {
      //       flagName = "flag_russia";
      //     } else if (rendererContext.cell.value == 'flag_uk') {
      //       flagName = "flag_uk";
      //     } else if (rendererContext.cell.value == 'flag_canada') {
      //       flagName = "flag_canada";
      //     } else if (rendererContext.cell.value == 'flag_czech_republic') {
      //       flagName = "flag_czech_republic";
      //     }
      //     return Container(
      //         margin: const EdgeInsets.all(2.5), decoration: BoxDecoration(color: Colors.black, image:DecorationImage(image: AssetImage('assets/images/$flagName.png'), fit: BoxFit.contain),));
      //     //return Image.asset('assets/images/$flag_name.png');
      //   },
      // ),
      PlutoColumn(
        title: 'Country',
        field: 'country',
        type: PlutoColumnType.text(),
        enableColumnDrag: false,
        enableRowDrag: false,
        readOnly: true,
        enableSorting: false,
        enableContextMenu: false,
        enableDropToResize: false,
        enableAutoEditing: true,
        enableEditingMode: true,
          renderer: (rendererContext) {
            return (Container(
              color: IsBlackThemeMode == true ? Colors.black : Colors.white,
              child: Text(rendererContext.stateManager.refRows[rendererContext.rowIdx].cells["country"]!.value.toString(),
                style: TextStyle( color: (selectActivePLayerList.indexOf(CurrenSelectedActivePlayer)-1 == rendererContext.rowIdx
                ) ? Colors.green : TextColorTheme
                    ,fontSize: 16),),
            ));
          }
      ),
      PlutoColumn(
        title: 'Name',
        field: 'name',
        type: PlutoColumnType.text(),
        enableColumnDrag: false,
        enableRowDrag: false,
        readOnly: true,
        enableSorting: false,
        enableContextMenu: false,
        enableDropToResize: false,
        enableAutoEditing: true,
        enableEditingMode: true,
          renderer: (rendererContext) {
            return (Container(
              color: IsBlackThemeMode == true ? Colors.black : Colors.white,
              child: Text(rendererContext.stateManager.refRows[rendererContext.rowIdx].cells["name"]!.value.toString(),
                style: TextStyle( color: (selectActivePLayerList.indexOf(CurrenSelectedActivePlayer)-1 == rendererContext.rowIdx
                ) ? Colors.green : TextColorTheme
                    ,fontSize: 16),),
            ));
          }
      ),
      PlutoColumn(
        title: 'Score',
        field: 'score',
        type: PlutoColumnType.number(),
        enableColumnDrag: false,
        enableRowDrag: false,
        readOnly: false,
        enableSorting: false,
        enableContextMenu: false,
        enableDropToResize: false,
        enableAutoEditing: false,
        enableEditingMode: true,
        titleTextAlign: PlutoColumnTextAlign.center,
        textAlign: PlutoColumnTextAlign.center,
          renderer: (rendererContext) {
            return (Container(
              color: IsBlackThemeMode == true ? Colors.black : Colors.white,
              child: Text(rendererContext.stateManager.refRows[rendererContext.rowIdx].cells["score"]!.value.toString(),
                style: TextStyle( color: (selectActivePLayerList.indexOf(CurrenSelectedActivePlayer)-1 == rendererContext.rowIdx
                ) ? Colors.green : TextColorTheme
                    ,fontSize: 16),textAlign: TextAlign.center,),
            ));
          }
      ),
      PlutoColumn(
        title: 'Total',
        field: 'total',
        type: PlutoColumnType.number(),
        enableColumnDrag: false,
        enableRowDrag: false,
        readOnly: false,
        enableSorting: false,
        enableContextMenu: false,
        enableDropToResize: false,
        enableAutoEditing: false,
        enableEditingMode: true,
        titleTextAlign: PlutoColumnTextAlign.center,
        textAlign: PlutoColumnTextAlign.center,
          renderer: (rendererContext) {
            return (Container(
              color: IsBlackThemeMode == true ? Colors.black : Colors.white,
              child: Text(
                rendererContext.stateManager.refRows[rendererContext.rowIdx]
                    .cells["total"]!.value.toString(),
                style: TextStyle(color: (selectActivePLayerList.indexOf(
                    CurrenSelectedActivePlayer) - 1 == rendererContext.rowIdx
                ) ? Colors.green : TextColorTheme
                    , fontSize: 16),textAlign: TextAlign.center,),
            ));
          }
      ),
      PlutoColumn(
        title: 'Place',
        field: 'place',
        type: PlutoColumnType.number(),
        enableColumnDrag: false,
        enableRowDrag: false,
        readOnly: false,
        enableSorting: false,
        enableContextMenu: false,
        enableDropToResize: false,
        enableAutoEditing: false,
        enableEditingMode: true,
        titleTextAlign: PlutoColumnTextAlign.center,
        textAlign: PlutoColumnTextAlign.center,
          renderer: (rendererContext) {
            return (Container(
              color: IsBlackThemeMode == true ? Colors.black : Colors.white,
              child: Text(rendererContext.stateManager.refRows[rendererContext.rowIdx].cells["place"]!.value.toString(),
                style: TextStyle( color: (selectActivePLayerList.indexOf(CurrenSelectedActivePlayer)-1 == rendererContext.rowIdx
                ) ? Colors.green : TextColorTheme
                    ,fontSize: 16),textAlign: TextAlign.center,),
            ));
          }
      ),

    ];

    PlutoColumn reps_col = PlutoColumn(
      title: 'Reps',
      field: 'reps',
      type: PlutoColumnType.number(),
      enableColumnDrag: false,
      enableRowDrag: false,
      readOnly: false,
      enableSorting: false,
      enableContextMenu: false,
      enableDropToResize: false,
      enableAutoEditing: false,
      enableEditingMode: true,
      titleTextAlign: PlutoColumnTextAlign.center,
      textAlign: PlutoColumnTextAlign.center,
        renderer: (rendererContext) {
          return (Container(
            color: IsBlackThemeMode == true ? Colors.black : Colors.white,
            child: Text(rendererContext.stateManager.refRows[rendererContext.rowIdx].cells["reps"]!.value.toString(),
              style: TextStyle( color: (selectActivePLayerList.indexOf(CurrenSelectedActivePlayer)-1 == rendererContext.rowIdx
              ) ? Colors.green : TextColorTheme
                  ,fontSize: 16),textAlign: TextAlign.center,),
          ));
        }
    );

    PlutoColumn distance_col = PlutoColumn(
        title: 'Distance',
        field: 'distance',
        type: PlutoColumnType.number(),
        enableColumnDrag: false,
        enableRowDrag: false,
        readOnly: false,
        enableSorting: false,
        enableContextMenu: false,
        enableDropToResize: false,
        enableAutoEditing: false,
        enableEditingMode: true,
        titleTextAlign: PlutoColumnTextAlign.center,
        textAlign: PlutoColumnTextAlign.center,
        renderer: (rendererContext) {
          return (Container(
            color: IsBlackThemeMode == true ? Colors.black : Colors.white,
            child: Text(rendererContext.stateManager.refRows[rendererContext.rowIdx].cells["distance"]!.value.toString(),
              style: TextStyle( color: (selectActivePLayerList.indexOf(CurrenSelectedActivePlayer)-1 == rendererContext.rowIdx
              ) ? Colors.green : TextColorTheme
                  ,fontSize: 16),textAlign: TextAlign.center,),
          ));
        }
      );

    PlutoColumn time_col = PlutoColumn(
      title: 'Time',
      field: 'time',
      type: PlutoColumnType.number(format: '#,###.##'),
      enableColumnDrag: false,
      enableRowDrag: false,
      readOnly: false,
      enableSorting: false,
      enableContextMenu: false,
      enableDropToResize: false,
      enableAutoEditing: false,
      enableEditingMode: true,
      titleTextAlign: PlutoColumnTextAlign.center,
      textAlign: PlutoColumnTextAlign.center,
        renderer: (rendererContext) {
          return (Container(
            color: IsBlackThemeMode == true ? Colors.black : Colors.white,
            child: Text(rendererContext.stateManager.refRows[rendererContext.rowIdx].cells["time"]!.value.toString(),
              style: TextStyle( color: (selectActivePLayerList.indexOf(CurrenSelectedActivePlayer)-1 == rendererContext.rowIdx
              ) ? Colors.green : TextColorTheme
                  ,fontSize: 16),textAlign: TextAlign.center,),
          ));
        }
    );

      if(selectedEventDatatype == event_data_types[1]){ // REPS TIME
        allColumns.insert(3, reps_col);
        allColumns.insert(4, time_col);
        setState(() {
          autoUpdate = false;
        });
      }else if(selectedEventDatatype == event_data_types[2]){  // DISTANCE TIME
        allColumns.insert(3, distance_col);
        allColumns.insert(4, time_col);
      }else{ // REPS
        allColumns.insert(3, reps_col);
      }
  }

  void addColumnsDataFromList() {
    allRows.clear();
    for (board_obj obj in BoardObjects) {
      PlutoRow tempRow = PlutoRow(
        cells: {
          'id': PlutoCell(value: '${BoardObjects.indexOf(obj)+1}'),
          // 'selected': PlutoCell(value: '${obj.selected}'),
          // 'flag': PlutoCell(value: '${obj.flagImgName}'),
          'country': PlutoCell(value: '${obj.country}'),
          'name': PlutoCell(value: '${obj.name}'),
          'reps': PlutoCell(value: '${obj.reps}'),
          'distance': PlutoCell(value: '${obj.distance}'),
          'time': PlutoCell(value: '${obj.time}'),
          'score': PlutoCell(value: '${obj.score}'),
          'total': PlutoCell(value: '${obj.total}'),
          'place': PlutoCell(value: '${obj.place}'),
        },
      );
      allRows.add(tempRow);
    }
  }

  @override
  Widget build(BuildContext context) {
    double? deviceWidth = MediaQuery.of(context).size.width;
    double? deviceHeight = MediaQuery.of(context).size.height;
    TextColorTheme = (IsBlackThemeMode == true) ? Colors.white : Colors.black;

    if(BoardObjects.isEmpty){
      return Scaffold(
          backgroundColor: IsBlackThemeMode == true ? Colors.black : Colors.white,
          body: SafeArea(
          child: Center(
            child: Container(
              width: 250,
              height: 250,
              child: Column(
                children: [
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
                  CircularProgressIndicator(),
                ],
              ),
           ),
          ),
        ),
      );
    }else{
      return Scaffold(
        backgroundColor: IsBlackThemeMode == true ? Colors.black : Colors.white,
        body: SafeArea(
          child: Container(
            padding: const EdgeInsets.only(left: 50,right: 50,bottom: 25,top: 5),
            width: deviceWidth,
            height: deviceHeight,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                    margin: const EdgeInsets.only(left: 25,right: 25,bottom: 25,top: 5),
                    alignment: Alignment.center,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(Icons.arrow_back_ios_new_rounded,size: 40,),
                    )),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  onPressed: () {
                    _defaultExportGridAsCSV();
                  },
                  child: const Icon(Icons.download,size: 40,),
                ),
                const SizedBox(
                  height: 15,
                ),
                SingleChildScrollView(
                  physics: ClampingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("Black Theme",style:
                      TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: TextColorTheme),),
                      const SizedBox(
                        width: 15,
                      ),
                      Container(
                        color: IsBlackThemeMode == true ? Colors.black : Colors.white,
                        child: Checkbox(value: IsBlackThemeMode, onChanged: (b){
                          //print("STR CurrenSelectedActivePlayer");
                          setState(() {
                            IsBlackThemeMode = b!;
                            //TextColorTheme = IsBlackThemeMode == true ? Colors.white : Colors.black;
                          });
                        }),
                      ),
                      const SizedBox(
                        width: 50,
                      ),
                      Column(
                        children: [
                          Text("Select Current Active Player", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.green),),
                          DropdownButton(
                            value: CurrenSelectedActivePlayer,
                            items: selectActivePLayerList.map((String items) {
                              return DropdownMenuItem(
                                value: items,
                                child: Text(items, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green),),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                print(newValue);
                                CurrenSelectedActivePlayer = newValue!;
                                upDateCurrentActiveSelectedPlayer();
                              });
                            },
                          ),
                        ],
                      ),
                      const SizedBox(
                        width: 50,
                      ),
                      Column(
                        children: [
                          Text("Toggle Auto Update Data", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.green),),
                          const SizedBox(
                            height: 10,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              UpdateDBData();
                            },
                            child: const Text(
                              "UPDATE"
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Container(
                        color: autoUpdate == true ? Colors.black : Colors.white,
                        child: Checkbox(value: autoUpdate, onChanged: (b){
                          setState(() {
                            autoUpdate = b!;
                            //TextColorTheme = IsBlackThemeMode == true ? Colors.white : Colors.black;
                          });
                        }),
                      ),
                      const SizedBox(width: 50,),
                      Column(
                        children: [
                          Text("Toggle Compact Mode", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.green),),
                          const SizedBox(
                            height: 10,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              toggleCompactMode();
                            },
                            child: Text( Compact_Mode == true ? "Compact Mode" : "Normal Mode"
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Text(
                  eventTitle,
                  style:
                  TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: TextColorTheme),
                ),
                const SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: PlutoGrid(
                    columns: allColumns,
                    rows: allRows,
                    onLoaded: (PlutoGridOnLoadedEvent event) {
                      stateManager = event.stateManager;
                      print("data loaded");
                    },
                    onChanged: (PlutoGridOnChangedEvent event) {
                      // print(event);
                      // print(allColumns[event.columnIdx].title.toLowerCase());
                      //if(event.columnIdx == 3){
                      if(allColumns[event.columnIdx].title.toLowerCase() == "reps"){
                        OnDataValuesChanged(event,"reps");
                      }else if(allColumns[event.columnIdx].title.toLowerCase() == "distance"){
                        OnDataValuesChanged(event,"distance");
                      }else if(allColumns[event.columnIdx].title.toLowerCase() == "time"){
                        OnDataValuesChanged(event,"time");
                      }else if(allColumns[event.columnIdx].title.toLowerCase() == "score"){
                        OnDataValuesChanged(event,"score");
                      }else if(allColumns[event.columnIdx].title.toLowerCase() == "total"){
                        OnDataValuesChanged(event,"total");
                      }else if(allColumns[event.columnIdx].title.toLowerCase() == "place"){
                        OnDataValuesChanged(event,"place");
                      }
                      // if(event.columnIdx == 1){
                      //   OnSelectionChanged(event);
                      // }
                      // if(event.columnIdx == 1){
                      //   setState(() {
                      //     stateManager.refColumns[1].title = "1000";
                      //     if(event.value == "true"){
                      //       stateManager.refRows[event.rowIdx].setChecked(true);
                      //       stateManager.refRows[event.rowIdx].setChecked(true);
                      //     }else{
                      //       stateManager.refRows[event.rowIdx].setChecked(false);
                      //     }
                      //   });
                      // }
                    },
                    onSelected: (PlutoGridOnSelectedEvent event){
                      print(event);
                    },
                    onRowDoubleTap: (PlutoGridOnRowDoubleTapEvent event){
                    },
                    configuration: PlutoGridConfiguration(
                      enableMoveDownAfterSelecting: false,
                      enableMoveHorizontalInEditing: false,
                      enterKeyAction: PlutoGridEnterKeyAction.toggleEditing,
                      // Enter will Stop edit and set value
                      style: IsBlackThemeMode == true ? const PlutoGridStyleConfig(
                        columnTextStyle: TextStyle(color: Colors.white),
                        cellTextStyle : TextStyle(color: Colors.white),
                        gridBackgroundColor: Colors.black,
                        cellColorInEditState: Colors.black,
                        activatedColor: Colors.black,
                        cellColorInReadOnlyState: Colors.black,
                        rowColor: Colors.black,
                        // evenRowColor: Colors.red,
                      ) : const PlutoGridStyleConfig(),
                      columnSize: PlutoGridColumnSizeConfig(
                          autoSizeMode: PlutoAutoSizeMode.scale // FITS Columns to Screen Size
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

  void upDateCurrentActiveSelectedPlayer(){
    int index = selectActivePLayerList.indexOf(CurrenSelectedActivePlayer);

    if(index == 0){
      for(board_obj obj in BoardObjects){
        int index_in = BoardObjects.indexOf(obj);
          BoardObjects[index_in].selected = false;
      }
      UpdateDBData();
    }else{
      index = index-1; // We added 0 None so we reduce one index to macth our list of objects
      for(board_obj obj in BoardObjects){
        int index_in = BoardObjects.indexOf(obj);
        if(index_in != index){
          BoardObjects[index_in].selected = false;
        }else{
          BoardObjects[index_in].active = true;
          BoardObjects[index_in].selected = true;
        }
      }
      UpdateDBData();
    }

  }

  void toggleCompactMode(){
    setState(() {
      Compact_Mode = !Compact_Mode;
    });

    DatabaseReference ref = FirebaseDatabase.instance.ref("leaderboard/$EventKey");
    ref.child("compact_mode").set(Compact_Mode).then((value) {
    }).onError((error, stackTrace){
      ShowSnackBar("Error Data not Saved");
    }).whenComplete(() {
      ShowSnackBar("Mode Changed");
    });

  }

  void UpdateDBData(){
    DatabaseReference ref = FirebaseDatabase.instance.ref("leaderboard/$EventKey");
    Map<String, dynamic> maptest = HashMap();

    for (board_obj obj_ in BoardObjects) {
      maptest[obj_.id.toString()] = obj_.toJson();
    }

    ref.child("score_board").set(maptest).then((value) {

    }).onError((error, stackTrace){
      ShowSnackBar("Error Data not Saved");
    }).whenComplete(() {
      ShowSnackBar("Data Saved");
    });

  }

  void OnDataValuesChanged(PlutoGridOnChangedEvent event,String changed_value_key) async{
    //Map <String,PlutoCell> gotMap = stateManager.refRows[event.rowIdx].cells;
    WidgetsBinding.instance.addPostFrameCallback((_) =>  setState((){
      if(allColumns[event.columnIdx].title.toLowerCase() == "reps"){
        BoardObjects[event.rowIdx].reps = event.value as int;
      }else if(allColumns[event.columnIdx].title.toLowerCase() == "distance"){
        BoardObjects[event.rowIdx].distance = event.value as int;
      }else if(allColumns[event.columnIdx].title.toLowerCase() == "time"){
        BoardObjects[event.rowIdx].time = event.value as double;
      }else if(allColumns[event.columnIdx].title.toLowerCase() == "score"){
        BoardObjects[event.rowIdx].score = event.value as int;
      }else if(allColumns[event.columnIdx].title.toLowerCase() == "total"){
        BoardObjects[event.rowIdx].total = event.value as int;
      }else if(allColumns[event.columnIdx].title.toLowerCase() == "place"){
        BoardObjects[event.rowIdx].place = event.value as int;
      }
      if(autoUpdate == true) {
        Update_Data_Values(event, changed_value_key);
      }
    }));
  }

  Future<bool> Update_Data_Values(PlutoGridOnChangedEvent event,String changed_value_key) async{
    bool success= false;
    DatabaseReference ref = FirebaseDatabase.instance.ref("leaderboard");
    await ref.child("$EventKey").child("score_board").child(BoardObjects[event.rowIdx].id.toString()).child(changed_value_key).set(event.value).then((_) {
      success = true;
    }).catchError((error) {
      success = false;
    });
    if(success){
      ShowSnackBar("$changed_value_key Updated");
      return true;
    }else{
      return false;
    }
  }

  void OnSelectionChanged(PlutoGridOnRowDoubleTapEvent event){
    //Map <String,PlutoCell> gotMap = stateManager.refRows[event.rowIdx].cells;
    print(BoardObjects[event.rowIdx!].selected);
    WidgetsBinding.instance
        .addPostFrameCallback((_) =>  setState(() {
      BoardObjects[event.rowIdx!].active = true;
      BoardObjects[event.rowIdx!].selected = true;
      Update_Selected(event);
    }));
  }

  Future<bool> Update_Selected(PlutoGridOnRowDoubleTapEvent event) async{
    bool success= false;
    DatabaseReference ref = FirebaseDatabase.instance.ref("leaderboard");
    await ref.child("$EventKey").child("score_board").child(BoardObjects[event.rowIdx!].id.toString()).child("active").set(true);
    await ref.child("$EventKey").child("score_board").child(BoardObjects[event.rowIdx!].id.toString()).child("selected").set(true).then((_) {
      success = true;
    }).catchError((error) {
      success = false;
    });
    if(success){
      ShowSnackBar("Scores Updated");
      return true;
    }else{
      return false;
    }
  }

  Future<bool> Update_data() async{
    DatabaseReference ref = FirebaseDatabase.instance.ref("leaderboard");

    Map<String,dynamic> maptest = HashMap();

    for(board_obj obj_ in BoardObjects){
      maptest[obj_.id.toString()] = obj_.toJson();
    }

     bool success= false;
    // var json = jsonEncode(BoardObjects.map((e) => e.toJson()).toList());
    await ref.child("$EventKey").child("score_board").set(maptest).then((_) {
      success = true;
    }).catchError((error) {
      success = false;
    });
    if(success){
      ShowSnackBar("Scores Updated");
      return true;
    }else{
      return false;
    }
  }

  void _defaultExportGridAsCSV() async {
    // PlutoGridStateManager exportStateManager = stateManager;
    // List<PlutoColumn> allColumns_to_remove = <PlutoColumn>[];
    // allColumns_to_remove.add(allColumns[1]);
    // allColumns_to_remove.add(allColumns[2]);
    //
    String title = "${eventTitle}_${Current_Date()}";
    //exportStateManager.removeColumns(allColumns_to_remove);


    List<PlutoRow> RowsToAdd = <PlutoRow>[];
    //
    // RowsToAdd.add(allRows[0]);

    // THIS WILL CHANGE CELL VALUE IF WE CHANGE IT
    // Map <String,PlutoCell> gotMap = allRows[0].cells;
    // gotMap["flag"] = PlutoCell(value: 'flag_usa');
    // stateManager.notifyListeners();

    // RowsToAdd.add(PlutoRow(
    //   cells: {
    //     'id': PlutoCell(value: '0'),
    //     // 'selected': PlutoCell(value: '${obj.selected}'),
    //     // 'flag': PlutoCell(value: '${obj.flagImgName}'),
    //     'country': PlutoCell(value: 'ALGS 2023'),
    //     'name': PlutoCell(value: ''),
    //     'score': PlutoCell(value: ''),
    //   },
    // ));
    //
    // //RowsToAdd[0].cells = gotMap;
    //
    // setState(() {
    //   stateManager.insertRows(0, RowsToAdd,notify: true);
    //   stateManager.notifyListeners();
    // });

    var exported = const Utf8Encoder().convert(
        pluto_grid_export.PlutoGridExport.exportCSV(stateManager));
    await FileSaver.instance.saveFile("$title.csv", exported, ".csv");

  }

  void ShowSnackBar(String textToShow){
    var snackBar = SnackBar(content: Text(textToShow),duration: Duration(seconds: 1));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

   Current_Date(){
    var now = DateTime.now();
    String today = "${now.day}-${now.month}-${now.year}";
    return today;
  }

}
