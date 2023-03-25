import 'package:firebase_core/firebase_core.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:leaderboard/leaderboard.dart';
import 'package:leaderboard/leaderboard_control.dart';

import 'firebase_options.dart';
import 'fluro_router.dart';
import 'leaderboard_All_List.dart';

// const String All_List = '/all';
// const String Editor = '/editor';
// const String Control = '/control';
// const String Scores = '/scores';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // /?event_key=1678711717666&route=scores
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FluroRouterR.defineRoutes(FluroRouterR.router);

  runApp(MyApp_1()); //pass to MyApp class
}

// class MyApp extends StatelessWidget {
//   // String? myurl,event_key,route;
//   // MyApp({required this.myurl, this.event_key, this.route}); //constructor of MyApp class
//
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     // Widget? toShow;
//     // if(kIsWeb){
//     //   //toShow = leaderboard_creator(got_is_Editing: false,);
//     //   toShow = leaderboard_all_list();
//     //   print(myurl);
//     //   print(event_key);
//     //   print(route);
//     //   //toShow = leaderboard_control();
//     // }else{
//     //   toShow = leaderboard_all_list();
//     // }
//     //
//     // if(event_key != null && route == "scores"){
//     //   toShow = leaderboard(Event_Key: event_key!,);
//     // }
//
//     return MaterialApp(
//        //initialRoute: leaderboard_all_list.route,
//         debugShowCheckedModeBanner: false,
//         title: 'LeaderBoard',
//         theme: ThemeData(
//           primarySwatch: Colors.blue,
//         ),
//         initialRoute: '/allevents',
//         onGenerateRoute: FluroRouterR.router.generator);
//       // home: toShow,
//    // );
//   }
// }

class MyApp_1 extends StatelessWidget {
  MyApp_1({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
        // home: leaderboard_all_list(),
        //initialRoute: 'allevents',.
        // initialRoute: 'gridControl',
        initialRoute: 'allevents',
        onGenerateRoute: FluroRouterR.router.generator);
  }
}


