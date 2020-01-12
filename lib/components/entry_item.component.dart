import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_diary/main.dart';
import 'package:flutter_diary/models/diary_entry.model.dart';
import 'package:flutter_diary/pages/diary_entry.page.dart';

class EntryComponent extends StatelessWidget {

  final DiaryEntry diaryEntry;

  const EntryComponent({Key key, this.diaryEntry}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(16),
      elevation: 16,
      semanticContainer: true,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      color: MyColors.backgroundColor1(MediaQuery.of(context).platformBrightness),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15)
      ),
      child: Container(
        height: 100,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            if (diaryEntry.resourcePath != null) Container(
              width: 100,
              height: 100,
              child: Image.file(File(diaryEntry.resourcePath), fit: BoxFit.cover)
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(diaryEntry.title, 
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: MyColors.textColor(MediaQuery.of(context).platformBrightness)),
                      maxLines: 1,
                      overflow: TextOverflow.fade,
                      softWrap: false,
                    ),
                    Container(height: 8),
                    if (diaryEntry.date != null) Text(DateTime.fromMillisecondsSinceEpoch(diaryEntry.date).toString(),
                      style: TextStyle(fontSize: 14, color: MyColors.textColorAlpha(MediaQuery.of(context).platformBrightness)),
                      maxLines: 1,
                      overflow: TextOverflow.fade,
                      softWrap: false,
                    ),
                    //Text(diaryEntry.description ?? "", style: TextStyle(fontSize: 14, color: Colors.black54),),
                  ],
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.navigate_next),
              onPressed: () => Navigator.of(context).push(new MaterialPageRoute(
                builder: (context) {
                  return new DiaryEntryPage(diaryEntry: diaryEntry);
                }
              )),
            )
          ],
        ),
      ),
    );
  }
}