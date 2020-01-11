import 'dart:async';

import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_diary/blocs/diary.bloc.dart';
import 'package:flutter_diary/components/entry_item.component.dart';
import 'package:flutter_diary/models/diary_entry.model.dart';
import 'package:flutter_diary/pages/add_entry.page.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapView extends StatefulWidget {

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {

  GoogleMapController _controller;
  DiaryEntry selectedEntry;
  String enteredAddress;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<DiaryEntry>>(
      stream: BlocProvider.of<DiaryBloc>(context).entryStream,
      builder: (context, snapshot) {
        Set<Marker> markers = new Set();
        if (snapshot.hasData) {
          snapshot.data.forEach((entry) {
            if (entry.latitude != null && entry.longitude != null) {
              markers.add(Marker(
                markerId: MarkerId(entry.id.toString()),
                position: LatLng(entry.latitude, entry.longitude),
                onTap: () => setState(() { selectedEntry = entry; })
              ));
            }
          });
        }

        return Stack(
          children: <Widget>[
            GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: MapView._kGooglePlex,
              onMapCreated: (GoogleMapController controller) {
                _controller = controller;
              },
              scrollGesturesEnabled: true,
              tiltGesturesEnabled: true,
              rotateGesturesEnabled: true,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              trafficEnabled: false,
              zoomGesturesEnabled: true,
              markers: markers,
              onLongPress: (LatLng latLng) {
                Navigator.push(context, new MaterialPageRoute(
                  builder: (context) {
                    return AddEntryPage(latLng: latLng,);
                  }
                ));
              },
              onTap: (context) {
                setState(() {
                  selectedEntry = null;
                });
              },
            ),
            if (selectedEntry != null) Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: EntryComponent(diaryEntry: selectedEntry),
            ),
            Positioned(
              left: 0,
              right: 0,
              top: 0,
              child: buildSeachbar()
            ),
          ],
        );
      }
    );
  }

  Widget buildSeachbar() {
    return Card(
      margin: EdgeInsets.all(16),
      elevation: 16,
      color: Colors.white70,
      semanticContainer: true,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15)
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
        child: Row(
          children: <Widget>[
            Expanded(
              child: TextField(
                decoration: InputDecoration(hintText: "Enter Location"),
                onChanged: (value) {
                  enteredAddress = value;
                },
                onSubmitted: (value) {
                  _goToLocation();
                },
              ),
            ),
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () => _goToLocation(),
            )
          ],
        ),
      ),
    );
  }

  _goToLocation() async {
    if (enteredAddress != null) {
      List<Placemark> places = await Geolocator().placemarkFromAddress(enteredAddress);
      _controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(places.first.position.latitude, places.first.position.longitude), zoom: 15.0)));
    }
  }
}