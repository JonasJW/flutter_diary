import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_diary/blocs/diary.bloc.dart';
import 'package:flutter_diary/components/entry_item.component.dart';
import 'package:flutter_diary/components/timeline/timeline.dart';
import 'package:flutter_diary/components/timeline/timeline_model.dart';
import 'package:flutter_diary/main.dart';
import 'package:flutter_diary/models/diary_entry.model.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class WeekView extends StatefulWidget {

  @override
  _WeekViewState createState() => _WeekViewState();
}

class _WeekViewState extends State<WeekView> {
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
                children: diaryBloc.getEntriesFromWeek(selectedDay).map((entry) {
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
              child: buildWeekNavigator(),
            ),
          ],
        );
      }
    );
  }

  Widget buildWeekNavigator() {
    return Container(
      color: MyColors.backgroundColor1(MediaQuery.of(context).platformBrightness).withOpacity(0.7),
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
          PlatformIconButton(
            onPressed: prevDay,
            iosIcon: Icon(Icons.navigate_next),
            androidIcon: Icon(Icons.navigate_next),
          ),
          // IconButton(
          //   icon: Icon(Icons.navigate_next),
          //   onPressed: prevDay,
          // )
        ],
      ),
    );
  }

  prevDay() {
    setState(() {
      selectedDay = selectedDay.subtract(Duration(days: 7));
    });
  }

  nextDay() {
    setState(() {
      selectedDay = selectedDay.add(Duration(days: 7));
    });
  }
}