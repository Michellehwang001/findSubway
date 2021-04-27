import 'package:find_subway/models/realtime_arrival_list.dart';

import 'error_message.dart';

class Subway {
  ErrorMessage errorMessage;
  List<RealtimeArrivalList> realtimeArrivalList;

  Subway({
      this.errorMessage, 
      this.realtimeArrivalList});

  Subway.fromJson(dynamic json) {
    errorMessage = json["errorMessage"] != null ? ErrorMessage.fromJson(json["errorMessage"]) : null;
    if (json["realtimeArrivalList"] != null) {
      realtimeArrivalList = [];
      json["realtimeArrivalList"].forEach((v) {
        realtimeArrivalList.add(RealtimeArrivalList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    if (errorMessage != null) {
      map["errorMessage"] = errorMessage.toJson();
    }
    if (realtimeArrivalList != null) {
      map["realtimeArrivalList"] = realtimeArrivalList.map((v) => v.toJson()).toList();
    }
    return map;
  }

}