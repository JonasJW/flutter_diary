import 'dart:developer';

import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_diary/blocs/diary.bloc.dart';
import 'package:flutter_diary/components/entry_item.component.dart';
import 'package:flutter_diary/components/timeline/timeline.dart';
import 'package:flutter_diary/components/timeline/timeline_model.dart';
import 'package:flutter_diary/models/diary_entry.model.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class TodayView extends StatefulWidget {

  @override
  _TodayViewState createState() => _TodayViewState();
}

class _TodayViewState extends State<TodayView> {
  DateTime selectedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    DiaryBloc diaryBloc = BlocProvider.of<DiaryBloc>(context);
    return StreamBuilder<List<DiaryEntry>>(
      stream: diaryBloc.entryStream,
      builder: (context, snapshot) {
        return Stack(
          children: <Widget>[
            if (snapshot.hasData) Container(
              child: Timeline(
                shrinkWrap: true,
                position: TimelinePosition.Left,
                children: diaryBloc.getEntriesFromDay(selectedDay).map((entry) {
                  return TimelineModel(
                    EntryComponent(diaryEntry: entry),
                    icon: Icon(diaryBloc.tags[entry.tag].icon, color: Colors.white, size: 15,),
                    iconBackground: diaryBloc.tags[entry.tag].color
                  );
                }).toList(),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              top: 0,
              child: buildDateNavigator(),
            ),
          ],
        );
      }
    );
  }

  Widget buildDateNavigator() {
    return Container(
      color: Colors.white.withOpacity(0.8),
      child: Row(
        children: <Widget>[
          // IconButton(
          //   icon: Icon(Icons.navigate_before),
          //   onPressed: nextDay,
          // ),
          PlatformIconButton(
            onPressed: nextDay,
            iosIcon: Icon(Icons.navigate_before),
            androidIcon: Icon(Icons.navigate_before),
          ),
          Expanded(child: Text(selectedDay.toIso8601String(), 
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          )),
          // IconButton(
          //   icon: Icon(Icons.navigate_next),
          //   onPressed: prevDay,
          // )
          PlatformIconButton(
            onPressed: prevDay,
            iosIcon: Icon(Icons.navigate_next),
            androidIcon: Icon(Icons.navigate_next),
          )
        ],
      ),
    );
  }

  prevDay() {
    setState(() {
      selectedDay = selectedDay.subtract(Duration(days: 1));
    });
  }

  nextDay() {
    setState(() {
      selectedDay = selectedDay.add(Duration(days: 1));
    });
  }
}