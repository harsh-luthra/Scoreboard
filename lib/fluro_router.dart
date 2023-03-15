import 'dart:collection';

import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:leaderboard/Grid_Control.dart';
import 'package:leaderboard/Grid_Control_Scores.dart';
import 'package:leaderboard/leaderboard.dart';
import 'package:leaderboard/leaderboard_All_List.dart';
import 'package:leaderboard/leaderboard_control.dart';
import 'package:leaderboard/leaderboard_creator.dart';

class FluroRouterR {
  FluroRouterR({Key? key});
  static final router = FluroRouter();

  static var gridControl = Handler(handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    String myurl = Uri.base.toString(); //get complete url
    Map<String,dynamic> params =  GetMapParams(myurl);
    if(params.containsKey("event_key")){
      String event_key = params["event_key"];
      return GridControlScores(Event_Key: event_key,);
    }else{
      return GridControlScores(Event_Key: "1678891316047",);
    }
  });

  static var allEvents = Handler(handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    return leaderboard_all_list();
  });

  static var editor = Handler(handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    String myurl = Uri.base.toString(); //get complete url
    Map<String,dynamic> params =  GetMapParams(myurl);
    if(params.containsKey("editing")){
      if(params["editing"] == "true"){
        if(params.containsKey("event_key")){
          String event_key = params["event_key"];
          return leaderboard_creator(got_is_Editing: true,got_MainKey: event_key,);
        }
      }else{
        return leaderboard_creator(got_is_Editing: false);
      }
    }else{
      return leaderboard_creator(got_is_Editing: false);
    }
  });

  static var control = Handler(handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    String myurl = Uri.base.toString(); //get complete url
    Map<String,dynamic> params =  GetMapParams(myurl);
        if(params.containsKey("event_key")){
          String event_key = params["event_key"];
          return leaderboard_control(Event_Key: event_key,);
        }else{
          return leaderboard_all_list();
        }
  });

  static var scores = Handler(handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    String myurl = Uri.base.toString(); //get complete url
    Map<String,dynamic> params =  GetMapParams(myurl);
    if(params.containsKey("event_key")){
      String event_key = params["event_key"];
      return leaderboard(Event_Key: event_key,);
    }else{
      return leaderboard_all_list();
    }
  });

  // static var editor_v = Handler(handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
  //   return leaderboard_creator(got_is_Editing: params['editing'][0],got_MainKey: params['key'][0]);
  // });

  static void defineRoutes(FluroRouter router) {
    router.define("allevents", handler: allEvents);
    router.define("editor", handler: editor);
    router.define("control", handler: control);
    router.define("scores", handler: scores);
    router.define("gridControl", handler: gridControl);
  }

  static GetMapParams(String myurl){
    Map<String,dynamic> params = HashMap();
    if(myurl.contains("?")){
      var split = myurl.split("?");
      if(split[1].contains("&")){
        var split_vars = split[1].split("&");
        print(split_vars);
        for(String q_parman in split_vars){
          if(q_parman.contains("=")){
            var split_vars = q_parman.split("=");
            params[split_vars[0]] = split_vars[1];
          }
        }
      }
    }
    return params;
  }

}