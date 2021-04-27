class ErrorMessage {
  int status;
  String code;
  String message;
  String link;
  String developerMessage;
  int total;

  ErrorMessage({
      this.status, 
      this.code, 
      this.message, 
      this.link, 
      this.developerMessage, 
      this.total});

  ErrorMessage.fromJson(dynamic json) {
    status = json["status"];
    code = json["code"];
    message = json["message"];
    link = json["link"];
    developerMessage = json["developerMessage"];
    total = json["total"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["status"] = status;
    map["code"] = code;
    map["message"] = message;
    map["link"] = link;
    map["developerMessage"] = developerMessage;
    map["total"] = total;
    return map;
  }

}