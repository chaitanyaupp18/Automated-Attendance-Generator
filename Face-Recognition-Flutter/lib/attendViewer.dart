import 'package:flutter/material.dart';
import 'package:easy_web_view/easy_web_view.dart';

class AttendViewer extends StatefulWidget {
  @override
  AttendViewerState createState() => AttendViewerState();
}

class AttendViewerState extends State<AttendViewer> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Attendance Viewer"),
      ),
      body: Container(
        child: EasyWebView(
          src:
              '<PASTE THE LINK OF GOOGLE SHEET',
          // javascriptMode: JavascriptMode.unrestricted,
        ),
      ),
    );
  }
}
