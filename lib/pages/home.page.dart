import 'dart:io';

import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_diary/blocs/diary.bloc.dart';
import 'package:flutter_diary/components/map_view.component.dart';
import 'package:flutter_diary/components/today_view.component.dart';
import 'package:flutter_diary/components/week_view.component.dart';
import 'package:flutter_diary/models/diary_entry.model.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {

  int currentPage = 0;
  TabController tabController;
  int _selectedTab = 0; 

  @override
  void initState() {
    tabController = new TabController(
      initialIndex: 0,
      length: 3,
      vsync: this,
    )..addListener(() => setState(() {}));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    if (Platform.isIOS) {
      return CupertinoTabScaffold(
        tabBar: CupertinoTabBar(
          items: [
            BottomNavigationBarItem(
              icon: new Icon(Icons.today),
              title: new Text('Today'),
            ),
            BottomNavigationBarItem(
              icon: new Icon(Icons.view_week),
              title: new Text('Week'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.map),
              title: Text('Maps')
            )
          ],
        ),
        tabBuilder: (context, index) {
          switch (index) {
            case 0:
              return CupertinoPageScaffold(
                navigationBar: CupertinoNavigationBar(
                  middle: Text("Flutter Diary"),
                  trailing: PlatformIconButton(
                    icon: Icon(Icons.add),
                    onPressed: () => Navigator.pushNamed(context, "/add"),
                  ),
                ),
                child: CupertinoTabView(
                  builder: (_) {
                    return TodayView();
                  },
                ),
              );
            case 1:
              return CupertinoTabView(
                builder: (_) {
                  return CupertinoPageScaffold(
                    navigationBar: CupertinoNavigationBar(
                      middle: Text("Flutter Diary"),
                      trailing: PlatformIconButton(
                        icon: Icon(Icons.add),
                        onPressed: () => Navigator.pushNamed(context, "/add"),
                      ),
                    ),
                    child: WeekView()
                  );
                },
              );
            case 2:
              return CupertinoTabView(
                builder: (_) {
                  return CupertinoPageScaffold(
                    navigationBar: CupertinoNavigationBar(
                      middle: Text("Flutter Diary"),
                    ),
                    child: MapView()
                  );
                },
              );
          }
          return null;
        },
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text("Flutter Diary"),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () =>  BlocProvider.of<DiaryBloc>(context).deleteDb(),
            ),
          ],
          bottom: TabBar(
            controller: tabController,
            tabs: <Widget>[
              Tab(
                text: "Today",
              ),
              Tab(
                text: "Week",
              ),
              Tab(
                text: "Map",
              )
            ],
          ),
        ),
        floatingActionButton: tabController.index != 2 
          ? FloatingActionButton(
            onPressed: () => Navigator.pushNamed(context, "/add"),
            tooltip: 'Add Entry',
            child: Icon(Icons.add))
          : Container(),
        body: TabBarView(
          controller: tabController,
          physics: NeverScrollableScrollPhysics(),
          children: [
            TodayView(),
            WeekView(),
            MapView()
          ]
        ),
      );
    }
  }
}