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
    

    final List<Widget> _pages = [
      TodayView(),
      WeekView(),
      MapView()
      // Container(
      //   color: Colors.red,
      // ),
      // Container(
      //   color: Colors.blue,
      // )
    ];

    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: Text("Flutter Diary"),
        ios: (_) => CupertinoNavigationBarData(
          
        ),
        android: (_) => MaterialAppBarData(
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
      ),
      // body: TabBarView(
      //   controller: tabController,
      //   physics: NeverScrollableScrollPhysics(),
      //   children: <Widget>[
      //     TodayView(),
      //     WeekView(),
      //     MapView()
      //   ],
      // ),
      body: Platform.isIOS
        ? _pages[_selectedTab]
        : TabBarView(
            controller: tabController,
            physics: NeverScrollableScrollPhysics(),
            children: _pages
          ),
      android: (_) => MaterialScaffoldData(
        floatingActionButton: tabController.index != 2 
          ? FloatingActionButton(
            onPressed: () => Navigator.pushNamed(context, "/add"),
            tooltip: 'Add Entry',
            child: Icon(Icons.add))
          : Container()
      ),
      bottomNavBar: PlatformNavBar(
        ios: (_) => CupertinoTabBarData(
          currentIndex: _selectedTab,
          itemChanged: (index) {
            setState(() {
              _selectedTab = index; 
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: new Icon(CupertinoIcons.home),
              title: new Text('Home'),
            ),
            BottomNavigationBarItem(
              icon: new Icon(CupertinoIcons.bell),
              title: new Text('Statistics'),
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.person),
              title: Text('Profile')
            )
          ] 
        ),
        items: [
          BottomNavigationBarItem(
              icon: new Icon(CupertinoIcons.home),
              title: new Text('Home'),
            ),
            BottomNavigationBarItem(
              icon: new Icon(CupertinoIcons.bell),
              title: new Text('Statistics'),
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.person),
              title: Text('Profile')
            )
        ],
      ),
    );
  }

  // _handleTabChanges() {
  //   setState(() {
  //     currentPage = 
  //   });
  // }
}