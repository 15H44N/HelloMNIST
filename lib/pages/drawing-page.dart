import 'package:flutter/material.dart';
import 'package:hello_mnist/dl_model/classifier.dart';

class DrawPage extends StatefulWidget {
  @override
  _DrawPageState createState() => _DrawPageState();
}

class _DrawPageState extends State<DrawPage> {
  Classifier classifier = Classifier();
  List<Offset> points = List<Offset>(); // values in this list is offset type, to get the points
  int digit = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            points.clear();
            digit = -1;
            setState(() {});
          },
          backgroundColor: Colors.orange,
          child: Icon(Icons.close),
        ),
        appBar: AppBar(
            backgroundColor: Colors.orange,
            title: Text("Best Digit Recognizer")),
        body: Center(
          child: Column(
            children: [
              SizedBox(
                height: 40,
              ),
              Text(
                "Draw digit Inside the Box",
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 10),
              Container(
                  height: 300+4.0,
                  width: 300+4.0,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.black, width: 2.0),
                  ),
                child: GestureDetector(
                  onPanUpdate: (DragUpdateDetails details) { // when we touch and drag in container
                    Offset localPosition = details.localPosition;
                    setState(() {
                      if (localPosition.dx >= 0 && localPosition.dx <=300 &&
                          localPosition.dy >= 0 && localPosition.dy <=300) {
                           points.add(localPosition);
                      }
                      // print(points);
                    });
                  },
                  onPanEnd: (DragEndDetails details) async {
                    points.add(null);
                    digit = await classifier.classifyDrawing(points);
                    setState(() {});
                  },
                  child: CustomPaint(
                    painter: Painter(points: points),
                  )
                ),
              ),
              SizedBox(height: 45),
              Text("Current Prediction",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
              Text(digit == -1 ? "" : "$digit",
                  style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold)),
            ],
          ),
        ));
  }
}

class Painter extends CustomPainter {
  final List<Offset> points;
  Painter({this.points}); //sending the points we have gathered so far

  final Paint paintDetails = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 4.0
    ..color = Colors.black;


  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i< points.length -1 ; i++) {
      if (points[i] != null && points[i+1] != null) {
        canvas.drawLine(points[i], points[i + 1], paintDetails);
      }
    }
  }

  @override
  bool shouldRepaint(Painter oldDelegate) {
    return true;
  }

}