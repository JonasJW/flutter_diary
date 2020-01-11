import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_diary/pages/add_entry.page.dart';
import 'package:flutter_diary/pages/home.page.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import 'blocs/diary.bloc.dart';

class MyColors {

  static Color backgroundColor1(Brightness brightness) {
    if (brightness == Brightness.light) {
      return Colors.white;
    } else {
      return Color.fromRGBO(30, 30, 32, 1);
    }
  }

  static Color backgroundColor0(Brightness brightness) {
    if (brightness == Brightness.light) {
      return Color.fromRGBO(242, 242, 247, 1);
    } else {
      return Color.fromRGBO(0, 0, 0, 1);
    }
  }
}

void main() => runApp(MaterialApp(home: MyApp()));

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final materialLightTheme = ThemeData(
      primaryColor: Colors.blueAccent,
      brightness: Brightness.light,
      scaffoldBackgroundColor: MyColors.backgroundColor0(Brightness.light),
      appBarTheme: AppBarTheme(
        color: MyColors.backgroundColor1(Brightness.light)
      ),
    );


    final materialDarkTheme = ThemeData(
      primaryColor: Colors.blueAccent,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: MyColors.backgroundColor0(Brightness.dark),
      appBarTheme: AppBarTheme(
        color: MyColors.backgroundColor1(Brightness.dark)
      ),
    );

    final cupertinoTheme = new CupertinoThemeData(
      primaryColor: Colors.blueAccent,
      scaffoldBackgroundColor: MyColors.backgroundColor0(Brightness.light),
      barBackgroundColor: MyColors.backgroundColor1(Brightness.light)
    );

    final cupertinoThemeDark = new CupertinoThemeData(
      primaryColor: Colors.blueAccent,
      scaffoldBackgroundColor: MyColors.backgroundColor0(Brightness.dark),
      barBackgroundColor: MyColors.backgroundColor1(Brightness.dark)
    );

    Brightness brightness = MediaQuery.of(context).platformBrightness;

    return BlocProvider<DiaryBloc>(
      creator: (_, __) => DiaryBloc(),
      child: PlatformProvider(
        builder: (_) => PlatformApp(
          title: "Flutter Diary",
          home: HomePage(),
          android: (context) {
            return MaterialAppData(
              darkTheme: materialDarkTheme,
              theme: materialLightTheme
            );
          },
          ios: (_) {
            return CupertinoAppData(
              theme: brightness == Brightness.light
                ? cupertinoTheme
                : cupertinoThemeDark
            );
          },
        ),
      ),
    );

    // return BlocProvider<DiaryBloc>(
    //   creator: (_, __) => DiaryBloc(),
    //   child: MaterialApp(
    //     title: 'Flutter Diary',
    //     theme: ThemeData(
    //       primarySwatch: Colors.blue,
    //     ),
    //     home: HomePage(),
    //     onGenerateRoute: (RouteSettings route) {
    //       final pathElementes = route.name.split("/");
    //       if (pathElementes[1] == "add") {
    //         return new MaterialPageRoute(
    //           builder: (_) {
    //             return AddEntryPage();
    //           }
    //         );
    //       }
    //       return null;
    //     },
    //   ),
    // );
  }
}