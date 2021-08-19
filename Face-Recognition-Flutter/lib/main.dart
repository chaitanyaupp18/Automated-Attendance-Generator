import 'dart:io';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:Face_recognition/liveCamera.dart';
import 'package:video_player/video_player.dart';
import 'package:Face_recognition/attendViewer.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.light,
      theme: ThemeData(brightness: Brightness.light),
      home: _MyHomePage(),
      title: "Face Recognition",
      debugShowCheckedModeBanner: false,
    );
  }
}

class _MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<_MyHomePage> {
  VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset("assets/FR_Background.mp4")
      ..initialize().then((_) {
        // Once the video has been loaded we play the video and set looping to true.
        _controller.play();
        _controller.setLooping(true);
        // Ensure the first frame is shown after the video is initialized.
        setState(() {});
      });
  }

  void handleClick(String value) {
    switch (value) {
      case 'View Attendance':
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => AttendViewer()));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Homepage'),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: handleClick,
            itemBuilder: (BuildContext context) {
              return {
                'View Attendance',
              }.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          SizedBox.expand(
            child: FittedBox(
              fit: BoxFit.fitHeight,
              child: SizedBox(
                width: _controller.value.size?.width ?? 400,
                height: _controller.value.size?.height ?? 400,
                child: VideoPlayer(_controller),
              ),
            ),
          ),
          Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Text(
                '\t\tWelcome to Automated\t\t\n       Attendance Maker',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  // fontFamily: 'Helvetica_Neue',
                  fontSize: 35,
                ),
              ),
              color: Colors.black,
            ),
            SizedBox(
              height: 300,
            ),
            FloatingActionButton(
              child: Icon(Icons.add_circle_outlined),
              onPressed: () async {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LiveCamera()));
              },
              foregroundColor: Colors.white,
              backgroundColor: Colors.black,
            ),
            SizedBox(
              height: 10,
            ),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Text(
                '\tGenerate Attendance\t',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
              color: Colors.black,
            ),
          ]),
        ],
      ),
    );
  }
}
