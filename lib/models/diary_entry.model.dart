class DiaryEntry {
  int id;
  String title;
  String description;
  int tag;
  int date;
  double latitude;
  double longitude;
  String resourcePath;
  String resource;
  String value;

  // Speech

  DiaryEntry({this.title, this.description, this.tag, this.latitude, this.longitude}) {
    date = DateTime.now().millisecondsSinceEpoch;
    tag = 0;
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "title": title,
      "description": description,
      "tag": tag,
      "date": date,
      "latitude": latitude,
      "longitude": longitude,
      "resourcePath": resourcePath,
      "resource": resource,
      "value": value
    };
  }

  DiaryEntry.formMap(Map<String, dynamic> map) {
    id = map["id"];
    title = map["title"];
    description = map["description"];
    tag = map["tag"];
    date = map["date"];
    latitude = map["latitude"];
    longitude = map["longitude"];
    resourcePath = map["resourcePath"];
    resource = map["resource"];
    value = value;
  }
}