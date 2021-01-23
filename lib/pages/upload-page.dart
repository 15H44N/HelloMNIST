import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:hello_mnist/dl_model/classifier.dart';

class UploadImage extends StatefulWidget {
  @override
  _UploadImageState createState() => _UploadImageState();
}

class _UploadImageState extends State<UploadImage> {
  final picker = ImagePicker(); //final makes sure that it is now dynamically typed
  PickedFile image;
  Classifier classifier = Classifier();
  int digit = -1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //parent widget
      backgroundColor: Colors.grey[200],
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          //when pressed what happens, i.e launch image picker
          image = await picker.getImage(source: ImageSource.gallery);
          // digit = 1;
          //we made it an asynchronous function, so the app waits for
          // user to pick the file and then assign it, using 'await' keyword

          digit = await classifier.classifyImage(image);
          setState(() {}); //image is set as, to show in box above
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
                  border: Border.all(color: Colors.black, width: 2),
                  image:  DecorationImage(
                      image: digit == -1 ?
                      AssetImage("assets/white.png") : FileImage(File(image.path)),
                  )
                ),
              ),
              SizedBox(height: 45),
              Text("Current Prediction", style:
                TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
              Text(
              digit == -1? "" : "$digit",
              style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
    );
  }
}
