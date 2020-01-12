import 'dart:io';

import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_diary/blocs/diary.bloc.dart';
import 'package:flutter_diary/main.dart';
import 'package:flutter_diary/models/diary_entry.model.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class AddEntryPage extends StatefulWidget {

  final LatLng latLng;

  const AddEntryPage({Key key, this.latLng}) : super(key: key);

  @override
  _AddEntryPageState createState() => _AddEntryPageState();
}

class _AddEntryPageState extends State<AddEntryPage> {
  final _formKey = GlobalKey<FormState>();
  final DiaryEntry entry = DiaryEntry();

  DiaryBloc diaryBloc;

  @override
  void initState() {
    diaryBloc = BlocProvider.of<DiaryBloc>(context);
    if (widget.latLng != null) {
      entry.latitude = widget.latLng.latitude;
      entry.longitude = widget.latLng.longitude;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: Text("Add Diary Entry"),
        ios: (_) => CupertinoNavigationBarData(
          trailing: PlatformIconButton(
            icon: Icon(Icons.done),
            onPressed: () {
              BlocProvider.of<DiaryBloc>(context).addEntry(entry);
              Navigator.pop(context);
            },
          )
        ),
      ),
      body: SingleChildScrollView(
        child: entryForm(),
      ),
      android: (_) => MaterialScaffoldData(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            BlocProvider.of<DiaryBloc>(context).addEntry(entry);
            Navigator.pop(context);
          },
          backgroundColor: Colors.green,
          child: Icon(Icons.done),
        ),
      ),
    );
    // return Scaffold(
    //   appBar: AppBar(
    //     title: Text("Add Diary Entry"),
    //   ),
    //   body: SingleChildScrollView(
    //     child: entryForm(),
    //   ),
    //   floatingActionButton: FloatingActionButton(
    //     onPressed: () {
    //       BlocProvider.of<DiaryBloc>(context).addEntry(entry);
    //       Navigator.pop(context);
    //     },
    //     backgroundColor: Colors.green,
    //     child: Icon(Icons.done),
    //   ),
    // );
  }

  Widget entryForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          titleInput(),
          descriptionInput(),
          tagInput(),
          resourceInput(),
          dateInput(),
          imageInput(),
        ],
      ),
    );
  }

  Widget descriptionInput() {
    return MyFormField(
      label: "Description",
      child: PlatformTextField(
        onChanged: (value) => entry.description = value,
        // decoration: InputDecoration(
        //   hintText: "Enter a Description"
        // ),
      ),
    );
  }

  Widget titleInput() {
    return MyFormField(
      label: "Title",
      child: PlatformTextField(
        onChanged: (value) => entry.title = value,
        keyboardType: TextInputType.multiline,
        maxLines: null,
        ios: (_) => CupertinoTextFieldData(
          // decoration: BoxDecoration(
          //   color: MyColors.backgroundColor1(MediaQuery.of(context).platformBrightness),
          //   border: Border.all(color: MyColors.backgroundColor0(MediaQuery.of(context).platformBrightness)),
          //   borderRadius: BorderRadius.all(Radius.circular(5))
          // )
        ),
        // decoration: InputDecoration(
        //   hintText: "Title"
        // ),
      ),
    );
  }

  Widget resourceInput() {

    final children = diaryBloc.resources.map((resource) {
      return DropdownMenuItem(
        child: Text(resource),
        value: resource,
      );
    }).toList();

    return MyFormField(
      label: "Add a Resource",
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: PlatformTextField(
              // initialValue: entry.value,
              onChanged: (value) => entry.value = value,
            ),
          ),
          Container(width: 16),
          Expanded(
            child: Container(
              child: Platform.isIOS
                ? Container(
                    height: 100,
                    child: CupertinoPicker(
                      backgroundColor: Colors.transparent,
                      children: children,
                      onSelectedItemChanged: (index) {
                        setState(() {
                          entry.resource = children[index].value;
                        });
                      },
                      itemExtent: 50,
                    ),
                  )
                : DropdownButton<String>(
                    isExpanded: true,
                    value: entry.resource,
                    onChanged: (resource) {
                      setState(() {
                        entry.resource = resource;
                      });
                    },
                    items: children
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget imageInput() {
    return MyFormField(
      label: "Image",
      disablePadding: true,
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                FlatButton(
                  child: Text("Select Image...", style: TextStyle(color: MyColors.textColor(MediaQuery.of(context).platformBrightness))),
                  onPressed: () async {
                    final file = await ImagePicker.pickImage(source: ImageSource.gallery);
                    setState(() {
                      entry.resourcePath = file.path;
                    });
                  },
                ),
                FlatButton(
                  child: Text("Record Image...", style: TextStyle(color: MyColors.textColor(MediaQuery.of(context).platformBrightness))),
                  onPressed: () async {
                    final file = await ImagePicker.pickImage(source: ImageSource.camera);
                    setState(() {
                      entry.resourcePath = file.path;
                    });
                  },
                ),
              ],
            ),
            if (entry.resourcePath != null) ClipRRect(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(10.0)),
              child: Image.file(File(entry.resourcePath))
            ),
          ],
        ),
      ),
    );
  }

  Widget dateInput() {
    return MyFormField(
      label: "Entry Time",
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: FlatButton(
          child: Text("${DateTime.fromMillisecondsSinceEpoch(entry.date).toString()}...", style: TextStyle(color: MyColors.textColor(MediaQuery.of(context).platformBrightness))), // TODO:
          onPressed: () {
            if (Platform.isIOS) {
              showCupertinoModalPopup(
                context: context,
                builder: (_) {
                  return Container(
                    height: 300,
                    child: CupertinoDatePicker(
                      initialDateTime: DateTime.fromMillisecondsSinceEpoch(entry.date),
                      onDateTimeChanged: (date) => setState(() {entry.date = date.millisecondsSinceEpoch; }),
                      mode: CupertinoDatePickerMode.dateAndTime,
                    ),
                  );
                }
              );
            } else {
              DatePicker.showDateTimePicker(context,
                onConfirm: (date) => setState(() {entry.date = date.millisecondsSinceEpoch; }),
                currentTime: DateTime.fromMillisecondsSinceEpoch(entry.date)
              );
            }
          },
        ),
      ),
    );
  }

  Widget tagInput() {
    final children = diaryBloc.tags.map((value, tag) {
      return MapEntry(value, DropdownMenuItem(
        value: value,
        child: Row(
          children: <Widget>[
            Container(
              width: 30,
              height: 30,
              padding: EdgeInsets.all(0),
              decoration: BoxDecoration(
                color: tag.color,
                borderRadius: BorderRadius.all(Radius.circular(100)),
                boxShadow: [
                  // BoxShadow(
                  //   color: Colors.black.withOpacity(0.3),
                  //   blurRadius: 2,
                  //   offset: Offset(2, 2)
                  // )
                ]
              ),
              child: Icon(tag.icon, color: Colors.white, size: 20,),
            ),
            Container(width: 16),
            Expanded(child: Text(tag.name)),
          ],
        ),
      ));
    }).values.toList();

    return MyFormField(
      label: "Choose a Tag",
      child: Platform.isIOS 
        ? Container(
          height: 100,
          child: CupertinoPicker(
            backgroundColor: Colors.transparent,
            children: children,
            onSelectedItemChanged: (value) {
              setState(() {
                if (value < diaryBloc.tags.length) {
                  setState(() { entry.tag = value; });
                } else {
                  showDialog(
                    context: context,
                    builder: (_) {
                      return new AlertDialog(
                        title: Text("TODO"),
                      );
                    }
                  );
                }
              });
            },
            itemExtent: 50,
          ),
        )
        : DropdownButton<int>(
            isExpanded: true,
            onChanged: (value) {
              if (value < diaryBloc.tags.length) {
                setState(() { entry.tag = value; });
              } else {
                showDialog(
                  context: context,
                  builder: (_) {
                    return new AlertDialog(
                      title: Text("TODO"),
                    );
                  }
                );
              }
            },
            value: entry.tag,
            items: children
          ),
    );
  }

  String _toDateString(int timestamp) {
    return DateFormat("dd.MM.yyyy").format(DateTime.fromMillisecondsSinceEpoch(timestamp));
  }

  String _toTimeString(int timestamp) {

    
    // if (seconds == null) {
    //   return '00:00';
    // }
    // int min = seconds ~/ 60;
    // int sec = seconds % 60;
    // String s = sec > 9 ? sec.toString() : '0' + sec.toString();
    // String m = min > 9 ? min.toString() : '0' + min.toString();   
    // return m + ':' + s; 
  }
}

class MyFormField extends StatelessWidget {

  final Widget child;
  final String label;
  final bool disablePadding;

  const MyFormField({Key key, this.label, this.child, this.disablePadding}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16),
      // padding: disablePadding == false || disablePadding == null ? EdgeInsets.only(left: 16, right: 16, bottom: 10, top: 8) : EdgeInsets.only(top: 8),
      decoration: BoxDecoration(
        color: MyColors.backgroundColor1(MediaQuery.of(context).platformBrightness),
        borderRadius: BorderRadius.all(Radius.circular(10.0))
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 4, top: 8),
            child: Text(label, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: MyColors.textColorAlpha(MediaQuery.of(context).platformBrightness))),
          ),
          Padding(
            padding: disablePadding == false || disablePadding == null ? EdgeInsets.only(left: 16, right: 16, bottom: 10, top: 0) : EdgeInsets.only(top: 8),
            child: child,
          ),
          // child
        ],
      ),
    );
  }
}