import 'dart:async';

import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_diary/models/diary_entry.model.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/subjects.dart';
import 'package:sqflite/sqflite.dart';

class TagItem {
  final String name;
  final Color color;
  final IconData icon;

  TagItem(this.name, this.color, this.icon);
}

class DiaryBloc extends Bloc {
  List<DiaryEntry> _entries;
  Map<int, TagItem> tags = {
    0: TagItem("Sport", Colors.red, Icons.directions_run),
    1: TagItem("Work", Colors.blue, Icons.work),
  };
  Set<String> resources = {
    "Money",
    "Time",
    "Other Things"
  };
  Database db;

  BehaviorSubject<List<DiaryEntry>> _entryStreamController = new BehaviorSubject();
  
  DiaryBloc() {
    // _createDummyData();
    initDb();
  }

  initDb() async {
    db = await openDatabase(
      'db.db',
      version: 2,
      onCreate: (db, version) async {
        await db.execute(
          """
            CREATE TABLE Entries (
              id INTEGER PRIMARY KEY,
              title TEXT NOT NULL,
              description TEXT,
              tag INTEGER,
              date INTEGER,
              latitude REAL,
              longitude REAL,
              resourcePath STRING,
              resource STRING,
              value STRING)
          """
        );
      }
    );
    _fetchEntries();
  }

  _fetchEntries() async {
     List<Map> query = await db.query("Entries",
      // columns: ["title, description, tag"],
    );
     _entries = query.map((map) {
      return DiaryEntry.formMap(map);
    }).toList();
    _entryStreamController.add(_entries);

  }

  addEntry(DiaryEntry entry) async {
    entry.id = await db.insert('Entries', entry.toMap());
    _entries.add(entry);
    _entryStreamController.sink.add(_entries);
  }

  deleteDb() {
    deleteDatabase('db.db');
  }

  @override
  void dispose() {
    _entryStreamController.close();
  }

  List<DiaryEntry> getEntriesFromDay(DateTime dateTime) {
    return _entries.where((entry) {
      final entryDate = DateTime.fromMillisecondsSinceEpoch(entry.date);
      return (entryDate.day == dateTime.day && entryDate.month == dateTime.month && entryDate.year == dateTime.year);
    }).toList();
  }

  List<DiaryEntry> getEntriesFromWeek(DateTime dateTime) {
    return _entries.where((entry) {
      final entryDate = DateTime.fromMillisecondsSinceEpoch(entry.date);
      return (_weekNumber(dateTime) == _weekNumber(entryDate) && entryDate.month == dateTime.month && entryDate.year == dateTime.year);
    }).toList();
  }

  // Source: https://stackoverflow.com/a/54129275/9547658
  int _weekNumber(DateTime date) {
    int dayOfYear = int.parse(DateFormat("D").format(date));
    return ((dayOfYear - date.weekday + 10) / 7).floor();
  }

  Stream<List<DiaryEntry>> get entryStream => _entryStreamController.stream;
  List<DiaryEntry> get entries  => _entries; // TODO: Prob delete this
}