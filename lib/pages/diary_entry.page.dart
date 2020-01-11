import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_diary/models/diary_entry.model.dart';
import 'package:geolocator/geolocator.dart';

class DiaryEntryPage extends StatelessWidget {

  final DiaryEntry diaryEntry;

  const DiaryEntryPage({Key key, this.diaryEntry}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(title:  Text(diaryEntry.title)),
      body: Center(
      child: Column(
        children: <Widget>[
          Text(diaryEntry.title),
          buildAddress()
          // Text(_coordinatesToAdress(diaryEntry.latitude, diaryEntry.longitude))
        ],
      ),
      ),
    );
  }

  Widget buildAddress() {
    if (diaryEntry.latitude != null && diaryEntry.longitude != null) {
      return FutureBuilder(
        future: _coordinatesToAdress(diaryEntry.latitude, diaryEntry.longitude),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Text(snapshot.data);
          }
          return Container();
        },
      );
    } else {
      return Container();
    }
  }

  Future<String> _coordinatesToAdress(double latitude, double longitude) async {
    List<Placemark> places = await Geolocator().placemarkFromCoordinates(latitude, longitude);
    final address = places.first;
    return "${address.name}\n${address.locality}, ${address.postalCode}\n${address.subAdministrativeArea}, ${address.country}";
  }

}