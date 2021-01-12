import 'package:flutter/material.dart';
import 'package:hello_mnist/pages/upload-page.dart';

void main() {
  runApp(MyApp());
}

//class myapp which is a stateless widget
//everything is built on a widget
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(),

    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currentIndex = 0;
  List tabs = [
    UploadImage(),
    Center(child: Text("Drawing page"))
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: tabs[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        selectedFontSize: 14.0,
        unselectedFontSize: 14.0,

        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey[400],
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.image),
          label: "Image"),
          BottomNavigationBarItem(icon: Icon(Icons.album),
          label: "Draw")
        ],
          onTap: (index) {
          setState(() {
            currentIndex = index;
          });
    },
      ),
    );
  }
}
