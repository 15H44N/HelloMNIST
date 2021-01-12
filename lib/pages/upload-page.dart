import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UploadImage extends StatefulWidget {
  @override
  _UploadImageState createState() => _UploadImageState();
}

class _UploadImageState extends State<UploadImage> {
  ImagePicker picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //parent widget
      backgroundColor: Colors.grey[200],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //when pressed what happens, i.e launch image picker

        },
        backgroundColor: Colors.orange,
        child: Icon(Icons.camera),
      ),
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text("Best Digit Recognizer")
      ),
        body: Center(
          child: Column(
            children: [
              SizedBox(height: 40),
              Text("Image Will be  Shown Below", style: TextStyle(fontSize: 20)),
              SizedBox(height: 10), //creating some space
              Container(
                height: 300,
                width: 300,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black, width: 2)
                ),
              ),
              SizedBox(height: 45),
              Text("Current Prediction", style:
                TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
              Text("5", style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
    );
  }
}
