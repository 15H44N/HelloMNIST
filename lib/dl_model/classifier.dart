import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'dart:io' as io;
import 'package:image/image.dart' as img;
import 'dart:ui' as ui;

class Classifier {
  Classifier();

  classifyImage(PickedFile image) async {
    // this is async becuase when we are doing the inference on our model,
    // we need to wait for some time for the model to perform.

    var _file = io.File(image.path);
    img.Image imageTemp = img.decodeImage(_file.readAsBytesSync());
    img.Image resizedImg = img.copyResize(imageTemp, height: 28, width: 28);
    var imgBytes = resizedImg.getBytes();
    var imgAsList = imgBytes.buffer.asUint8List();

    return getPred(imgAsList);
  }

  classifyDrawing(List<Offset> points) async {
    // ugly BP to get into unit8 list
    final picture = toPicture(points); //convert list to picture
    final image = await picture.toImage(28,28);
    ByteData imgBytes = await image.toByteData(); //Read this image
    var imgAsList = imgBytes.buffer.asUint8List();

    return getPred(imgAsList);
  }

  Future<int> getPred(Uint8List imgAsList) async {
    // as async model, we need to specifty that it returns int on eval complete
    List resultBytes = List(28 * 28);

    // RGB A Image -> Grayscale Image
    // Take avg(channels) for all channels

    int index = 0;

    for (int i = 0; i < imgAsList.lengthInBytes; i += 4) {
      final r = imgAsList[i];
      final g = imgAsList[i + 1];
      final b = imgAsList[i + 2];

      resultBytes[index] = ((r + g + b) / 3.0) / 255.0;
      index++;
    }

    var input = resultBytes.reshape([1, 28, 28, 1]);
    var output = List(1 * 10).reshape([1, 10]);

    InterpreterOptions interpreterOptions =
        InterpreterOptions(); //can be used to run on the phone's GPU

    try {
      Interpreter interpreter = await Interpreter.fromAsset("model.tflite",
          options: interpreterOptions);
      interpreter.run(input, output);
    } catch (e) {
      print("Error Loading Model or Running Model");
    }

    double highestProb = 0;
    int digitPred;

    // return as 1*10 we want 10,
    for (int i = 0; i < output[0].length; i++) {
      if (output[0][i] > highestProb) {
        highestProb = output[0][i];
        digitPred = i;
      }
    }
    return digitPred;
  }
}

ui.Picture toPicture(List<Offset> points) {
  // we have to invert i.e repaint the entire image
  // we will obtain picture obj from a list of points,

  final _whitePaint = Paint()
      ..strokeCap = StrokeCap.round
      ..color = Colors.white
      ..strokeWidth = 16.0;

  final _bgPaint = Paint()..color = Colors.black;
  final _canvasCullRect = Rect.fromPoints(Offset(0,0), Offset(28.0, 28.0));
  final recorder = ui.PictureRecorder();
  
  final canvas = Canvas(recorder, _canvasCullRect)
    ..scale(28.0/300.0);
  
  canvas.drawRect(Rect.fromLTWH(0, 0, 28, 28), _bgPaint);
  for (int i=0; i<points.length -1; i++) {
    if (points[i] != null && points[i+1] != null) {
      canvas.drawLine(points[i], points[i+1], _whitePaint);
    }
  }
  return recorder.endRecording();
}