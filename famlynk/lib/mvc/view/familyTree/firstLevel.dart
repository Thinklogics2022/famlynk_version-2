import 'dart:async';

import 'package:famlynk/mvc/model/familyTree_model/familyTree_model.dart';
import 'package:famlynk/services/familyTreeService/familyTree_service.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class FirstLevelRelation extends StatefulWidget {
  const FirstLevelRelation({super.key});

  @override
  State<FirstLevelRelation> createState() => _FirstLevelRelationState();
}

class _FirstLevelRelationState extends State<FirstLevelRelation> {
  double _zoomLevel = 0.6;
  String LevelTwo = "firstLevel";
  bool isLoading = true;
  List<FamilyTreeModel> familyTreeDataList = [];

  List<FamilyTreeModel> user = [];
  List<FamilyTreeModel> fathers = [];
  List<FamilyTreeModel> fathersfather = [];
  List<FamilyTreeModel> fathersmother = [];
  List<FamilyTreeModel> motherfathers = [];
  List<FamilyTreeModel> mothermothers = [];
  List<FamilyTreeModel> mothers = [];
  List<FamilyTreeModel> brothers = [];
  List<FamilyTreeModel> sisters = [];
  List<FamilyTreeModel> sons = [];
  List<FamilyTreeModel> daughters = [];
  List<FamilyTreeModel> husband = [];
  List<FamilyTreeModel> wife = [];

  @override
  void initState() {
    super.initState();
    fetchFamilyTreeData();
  }

  Future<void> fetchFamilyTreeData() async {
    setState(() {
      isLoading = true;
    });
    FamilyTreeServices familyTreeServices = FamilyTreeServices();
    try {
      var newDataList = await familyTreeServices.getAllFamilyTree(LevelTwo);
      user =
          newDataList.where((member) => member.relationShip == "user").toList();
      fathers = newDataList
          .where((member) => member.relationShip == "father")
          .toList();
      mothers = newDataList
          .where((member) => member.relationShip == "mother")
          .toList();
      fathersfather = newDataList
          .where((member) =>
              member.relationShip == "grandfather" && member.side == "father")
          .toList();
      fathersmother = newDataList
          .where((member) =>
              member.relationShip == "grandmother" && member.side == "father")
          .toList();
      motherfathers = newDataList
          .where((member) =>
              member.relationShip == "grandfather" && member.side == "mother")
          .toList();
      mothermothers = newDataList
          .where((member) =>
              member.relationShip == "grandmother" && member.side == "mother")
          .toList();
      brothers = newDataList
          .where((member) => member.relationShip == "brother")
          .toList();
      sisters = newDataList
          .where((member) => member.relationShip == "sister")
          .toList();
      brothers = newDataList
          .where((member) => member.relationShip == "brother")
          .toList();
      husband = newDataList
          .where((member) => member.relationShip == "husband")
          .toList();
      wife =
          newDataList.where((member) => member.relationShip == "wife").toList();
      sons =
          newDataList.where((member) => member.relationShip == "son").toList();
      daughters = newDataList
          .where((member) => member.relationShip == "daughter")
          .toList();

      setState(() {
        familyTreeDataList = newDataList;
        isLoading = false;
        print('Data loaded successfully: ${familyTreeDataList.length} items');
      });
    } catch (e) {
      print(e);
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Transform.scale(
              scale: _zoomLevel,
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Text(
                    //   'Zoom: ${(_zoomLevel * 100).toStringAsFixed(0)}%',
                    //   style: TextStyle(fontSize: 18),
                    // ),
                    isLoading
                        ? Container(
                            height: 90,
                            width: 90,
                            child: CircularProgressIndicator(
                              color: Colors.lightBlueAccent,
                            ),
                          )
                        : CustomPaint(
                            size: Size(500, 700),
                            painter: FamilyTreePainter(
                              familyTreeDataList,
                              user,
                              fathers,
                              mothers,
                              fathersfather,
                              fathersmother,
                              motherfathers,
                              mothermothers,
                              brothers,
                              sisters,
                              husband,
                              wife,
                              sons,
                              daughters,
                            ),
                          ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              setState(() {
                _zoomLevel += 0.1;
              });
            },
            child: Icon(Icons.zoom_in),
          ),
          SizedBox(height: 10),
          FloatingActionButton(
            onPressed: () {
              setState(() {
                _zoomLevel -= 0.1;
              });
            },
            child: Icon(Icons.zoom_out),
          ),
        ],
      ),
    );
  }
}

class FamilyTreePainter extends CustomPainter {
  List<FamilyTreeModel> familyTreeDataList;
  List<FamilyTreeModel> fathers;
  List<FamilyTreeModel> user;
  List<FamilyTreeModel> mothers;
  List<FamilyTreeModel> fathersfather;
  List<FamilyTreeModel> fathersmother;
  List<FamilyTreeModel> motherfathers;
  List<FamilyTreeModel> mothermothers;
  List<FamilyTreeModel> brothers;
  List<FamilyTreeModel> sisters;
  List<FamilyTreeModel> husband;
  List<FamilyTreeModel> wife;
  List<FamilyTreeModel> sons;
  List<FamilyTreeModel> daughters;
  final Map<String, ui.Image> imageCache = {};

  FamilyTreePainter(
      this.familyTreeDataList,
      this.user,
      this.fathers,
      this.mothers,
      this.fathersfather,
      this.fathersmother,
      this.motherfathers,
      this.mothermothers,
      this.brothers,
      this.sisters,
      this.husband,
      this.wife,
      this.sons,
      this.daughters);

  @override
  void paint(Canvas canvas, Size size) async {
    for (int i = 0; i < familyTreeDataList.length; i++) {
      if (user.contains(familyTreeDataList[i])) {
        final paint = Paint()..strokeWidth = 2.5;
        final centerX = size.width * 0.5;
        final centerY = size.height * 0.623;
        paint
          ..color = Colors.blue // Change color as needed
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.6;
        canvas.drawCircle(
          Offset(centerX, centerY),
          30,
          paint,
        );
        canvas.drawCircle(
          Offset(centerX, centerY),
          33,
          paint,
        );
        final Paint glowPaint = Paint()
          ..color = Colors.blue.withOpacity(0.3)
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, 12);

        canvas.drawCircle(
          Offset(centerX, centerY),
          35,
          glowPaint,
        );
        final image = imageCache[user[0].image];
        if (image == null) {
          loadImage(user[0].image.toString()).then((loadedImage) {
            if (loadedImage != null) {
              imageCache[user[0].image.toString()] = loadedImage;
              _drawImage(canvas, size, loadedImage, i, centerX, centerY);
            }
          });
        } else {
          _drawImage(canvas, size, image, i, centerX, centerY);
        }

        // Draw the user's name
        TextSpan userTextSpan = TextSpan(
          text: user[0].name!.length > 6
              ? user[0].name!.substring(0, 6)
              : user[0].name,
          style: TextStyle(
              fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black),
        );
        TextPainter userTextPainter = TextPainter(
          text: userTextSpan,
          textDirection: TextDirection.ltr,
        );
        userTextPainter.layout();
        userTextPainter.paint(
          canvas,
          Offset(centerX - 89, centerY-6 ), // Adjust the position as needed
        );
        TextSpan relationTextSpan = TextSpan(
          text: user[0].relationShip,
          style: TextStyle(
              fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
        );
        TextPainter relationTextPainter = TextPainter(
          text: relationTextSpan,
          textDirection: TextDirection.ltr,
        );
        relationTextPainter.layout();
        relationTextPainter.paint(
          canvas,
          Offset(centerX - 85, centerY + 10),
        );
      }

      // Draw father's lines
      if (fathers.contains(familyTreeDataList[i])) {
        final paint = Paint()..strokeWidth = 2.5;
        final centerX = size.width * 0.5;
        final centerY = size.height * 0.200;
        final fatherIndex = fathers.indexOf(familyTreeDataList[i]);
        final fatherX = centerX - 51 - fatherIndex * 70.0;

        canvas.drawLine(
          Offset(fatherX, centerY),
          Offset(centerX, centerY),
          paint,
        );
        canvas.drawLine(
          Offset(size.width * 0.5, size.height * 0.58),
          Offset(centerX, centerY),
          paint,
        );
        // Draw father's circle
        paint
          ..color = Color.fromARGB(134, 3, 20, 252)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1;
        canvas.drawCircle(
          Offset(fatherX - 30, centerY),
          30,
          paint,
        );
        final Paint glowPaint = Paint()
          ..color = Color.fromARGB(134, 3, 20, 252).withOpacity(0.3)
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, 12);

        canvas.drawCircle(
          Offset(fatherX - 30, centerY),
          35,
          glowPaint,
        );
        final image = imageCache[fathers[fatherIndex].image];
        if (image == null) {
          loadImage(fathers[fatherIndex].image.toString()).then((loadedImage) {
            if (loadedImage != null) {
              imageCache[fathers[fatherIndex].image.toString()] = loadedImage;
              _drawImage(canvas, size, loadedImage, i, fatherX - 30, centerY);
            }
          });
        } else {
          _drawImage(canvas, size, image, i, fatherX - 30, centerY);
        }

        // Draw father's name
        TextSpan fatherTextSpan = TextSpan(
          text: fathers[fatherIndex].name,
          style: TextStyle(
              fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black),
        );
        TextPainter fatherTextPainter = TextPainter(
          text: fatherTextSpan,
          textDirection: TextDirection.ltr,
        );
        fatherTextPainter.layout();
        fatherTextPainter.paint(
          canvas,
          Offset(fatherX - 55, centerY + 45),
        );
        TextSpan relationTextSpan = TextSpan(
          text: fathers[fatherIndex].relationShip,
          style: TextStyle(
              fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black),
        );
        TextPainter relationTextPainter = TextPainter(
          text: relationTextSpan,
          textDirection: TextDirection.ltr,
        );
        relationTextPainter.layout();
        relationTextPainter.paint(
          canvas,
          Offset(fatherX - 55, centerY + 56),
        );
      }

      // mother
      if (mothers.contains(familyTreeDataList[i])) {
        final centerX = size.width * 0.5;
        final centerY = size.height * 0.200;
        final paint = Paint()..strokeWidth = 2.5;
        final motherIndex = mothers.indexOf(familyTreeDataList[i]);
        final motherX = centerX + 60 + motherIndex * 80.0;

        // Draw horizontal line to the right
        canvas.drawLine(
          Offset(centerX, centerY),
          Offset(motherX, centerY),
          paint,
        );
        canvas.drawLine(
          Offset(size.width * 0.5, size.height * 0.58),
          Offset(centerX, centerY),
          paint,
        );

        // Draw mother's circle
        paint
          ..color = Colors.pink
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1;
        canvas.drawCircle(
          Offset(motherX + 30, centerY),
          30,
          paint,
        );
        final Paint glowPaint = Paint()
          ..color = Colors.pink.withOpacity(0.3)
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, 12);

        canvas.drawCircle(
          Offset(motherX + 30, centerY),
          35,
          glowPaint,
        );

        // Draw the image inside the circle
        final image = imageCache[mothers[motherIndex].image];
        if (image == null) {
          loadImage(mothers[motherIndex].image.toString()).then((loadedImage) {
            if (loadedImage != null) {
              imageCache[mothers[motherIndex].image.toString()] = loadedImage;
              _drawImage(canvas, size, loadedImage, i, motherX + 30, centerY);
            }
          });
        } else {
          _drawImage(canvas, size, image, i, motherX + 30, centerY);
        }

        TextSpan motherTextSpan = TextSpan(
          text: mothers[motherIndex].name,
          style: TextStyle(
              fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black),
        );
        TextPainter motherTextPainter = TextPainter(
          text: motherTextSpan,
          textDirection: TextDirection.ltr,
        );
        motherTextPainter.layout();
        motherTextPainter.paint(
          canvas,
          Offset(motherX + 20, centerY + 45),
        );
        TextSpan relationTextSpan = TextSpan(
          text: mothers[motherIndex].relationShip,
          style: TextStyle(
              fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black),
        );
        TextPainter relationTextPainter = TextPainter(
          text: relationTextSpan,
          textDirection: TextDirection.ltr,
        );
        relationTextPainter.layout();
        relationTextPainter.paint(
          canvas,
          Offset(motherX + 20, centerY + 56),
        );
      }

      //fathersfather
      if (fathersfather.contains(familyTreeDataList[i])) {
        final paint = Paint()
          ..strokeWidth = 2.5
          ..isAntiAlias = true;
        final centerX = size.width * 0.36;
        final centerY = size.height * 0.150;
        final fathersfatherIndex = fathersfather.indexOf(familyTreeDataList[i]);
        final fathersfatherX = centerX - 34;
        final fathersfatherY = centerY - 130;

        // Draw fathersfather's vertical line
        canvas.drawLine(
          Offset(centerX - 10, fathersfatherY),
          Offset(centerX - 10, centerY + 5),
          paint,
        );
        final horizontalLineLength = 50; // Adjust this length as needed
        canvas.drawLine(
          Offset(centerX - 10 - horizontalLineLength, fathersfatherY),
          Offset(centerX - 10, fathersfatherY),
          paint,
        );

        paint
          ..color = Color.fromARGB(133, 106, 106, 3)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1;

        // Draw fathersfather's circle
        canvas.drawCircle(
          Offset(centerX - 40 - horizontalLineLength, fathersfatherY),
          30,
          paint,
        );
        final Paint glowPaint = Paint()
          ..color = Color.fromARGB(133, 106, 106, 3)
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, 12);
        canvas.drawCircle(
          Offset(centerX - 40 - horizontalLineLength, fathersfatherY),
          35,
          glowPaint,
        );
        final image = imageCache[fathersfather[fathersfatherIndex].image];
        if (image == null) {
          loadImage(fathersfather[fathersfatherIndex].image.toString())
              .then((loadedImage) {
            if (loadedImage != null) {
              imageCache[fathersfather[fathersfatherIndex].image.toString()] =
                  loadedImage;
              _drawImage(canvas, size, loadedImage, i,
                  fathersfatherX - 20 - horizontalLineLength, fathersfatherY);
            }
          });
        } else {
          _drawImage(canvas, size, image, i,
              fathersfatherX - 6 - horizontalLineLength, fathersfatherY);
        }

        // Draw name and relation text
        final fathersfatherTextSpan = TextSpan(
          text: fathersfather[fathersfatherIndex].name,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        );
        final relationTextSpan = TextSpan(
          text: fathersfather[fathersfatherIndex].relationShip,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        );

        final fathersfatherTextPainter = TextPainter(
          text: fathersfatherTextSpan,
          textDirection: TextDirection.ltr,
        );
        final relationTextPainter = TextPainter(
          text: relationTextSpan,
          textDirection: TextDirection.ltr,
        );

        fathersfatherTextPainter.layout();
        relationTextPainter.layout();

        fathersfatherTextPainter.paint(
          canvas,
          Offset(
              fathersfatherX - 20 - horizontalLineLength, fathersfatherY + 40),
        );
        relationTextPainter.paint(
          canvas,
          Offset(
              fathersfatherX - 20 - horizontalLineLength, fathersfatherY + 52),
        );
      }

      //fathersmother
      if (fathersmother.contains(familyTreeDataList[i])) {
        final paint = Paint()
          ..strokeWidth = 2.5
          ..isAntiAlias = true;
        final centerX = size.width * 0.36;
        final centerY = size.height * 0.150;
        final fathersmotherIndex = fathersmother.indexOf(familyTreeDataList[i]);
        final fathersmotherX = centerX - 34;
        final fathersmotherY = centerY - 130;
        // Draw fathersmother's lines and circle
        canvas.drawLine(
          Offset(centerX - 10, fathersmotherY),
          Offset(centerX - 10, centerY + 5),
          paint,
        );
        final horizontalLineLength = 50; // Adjust this length as needed
        canvas.drawLine(
          Offset(centerX - 10 + horizontalLineLength, fathersmotherY),
          Offset(centerX - 10, fathersmotherY),
          paint,
        );
        paint
          ..color = Color.fromARGB(133, 106, 106, 3)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1;
        canvas.drawCircle(
          Offset(centerX + 20 + horizontalLineLength, fathersmotherY),
          30,
          paint,
        );
        final Paint glowPaint = Paint()
          ..color = Color.fromARGB(133, 106, 106, 3)
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, 12);
        canvas.drawCircle(
          Offset(centerX + 20 + horizontalLineLength, fathersmotherY),
          35,
          glowPaint,
        );
        final image = imageCache[fathersmother[fathersmotherIndex].image];
        if (image == null) {
          loadImage(fathersmother[fathersmotherIndex].image.toString())
              .then((loadedImage) {
            if (loadedImage != null) {
              imageCache[fathersmother[fathersmotherIndex].image.toString()] =
                  loadedImage;
              _drawImage(canvas, size, loadedImage, i,
                  centerX + 20 + horizontalLineLength, fathersmotherY);
            }
          });
        } else {
          _drawImage(canvas, size, image, i,
              centerX + 20 + horizontalLineLength, fathersmotherY);
        }

        // Draw name and relation text
        final fathersmotherTextSpan = TextSpan(
          text: fathersmother[fathersmotherIndex].name,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        );
        final relationTextSpan = TextSpan(
          text: fathersmother[fathersmotherIndex].relationShip,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        );

        final fathersmotherTextPainter = TextPainter(
          text: fathersmotherTextSpan,
          textDirection: TextDirection.ltr,
        );
        final relationTextPainter = TextPainter(
          text: relationTextSpan,
          textDirection: TextDirection.ltr,
        );

        fathersmotherTextPainter.layout();
        relationTextPainter.layout();

        fathersmotherTextPainter.paint(
          canvas,
          Offset(
              fathersmotherX + 20 + horizontalLineLength, fathersmotherY + 40),
        );
        relationTextPainter.paint(
          canvas,
          Offset(
              fathersmotherX + 20 + horizontalLineLength, fathersmotherY +52),
        );
      }

      //Mothersfather
      if (motherfathers.contains(familyTreeDataList[i])) {
        final paint = Paint()
          ..strokeWidth = 2.5
          ..isAntiAlias = true;
        final centerX = size.width * 0.5;
        final centerY = size.height * 0.180;
        final motherfathersIndex = motherfathers.indexOf(familyTreeDataList[i]);
        final motherfathersX = centerX + 60;
        final motherfathersY = centerY - 80;

        // Draw vertical line connecting the mother's circle to the horizontal line
        canvas.drawLine(
          Offset(centerX + 90, motherfathersY),
          Offset(centerX + 90, centerY - 15),
          paint,
        );

        canvas.drawLine(
          Offset(motherfathersX - 10, centerY - 80),
          Offset(centerX + 91, centerY - 80),
          paint,
        );

        // Draw a circle at the end of the horizontal line
        paint
          ..color = Color.fromARGB(255, 175, 40, 205)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1;
        canvas.drawCircle(
          Offset(motherfathersX - 40, centerY - 80),
          30,
          paint,
        );
        final Paint glowPaint = Paint()
          ..color = Color.fromARGB(255, 175, 40, 205)
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, 12);
        canvas.drawCircle(
          Offset(motherfathersX - 40, centerY - 80),
          35,
          glowPaint,
        );

        final image = imageCache[motherfathers[motherfathersIndex].image];
        if (image == null) {
          loadImage(motherfathers[motherfathersIndex].image.toString())
              .then((loadedImage) {
            if (loadedImage != null) {
              imageCache[motherfathers[motherfathersIndex].image.toString()] =
                  loadedImage;
              _drawImage(canvas, size, loadedImage, i, motherfathersX - 40,
                  centerY - 80);
            }
          });
        } else {
          _drawImage(canvas, size, image, i, motherfathersX - 40, centerY - 80);
        }

        //Draw name and relation text
        final motherfathersTextSpan = TextSpan(
          text: motherfathers[motherfathersIndex].name!.length > 6
              ? motherfathers[motherfathersIndex].name!.substring(0, 6)
              : motherfathers[motherfathersIndex].name,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        );
        final relationTextSpan = TextSpan(
          text: motherfathers[motherfathersIndex].relationShip,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        );

        final motherfathersTextPainter = TextPainter(
          text: motherfathersTextSpan,
          textDirection: TextDirection.ltr,
        );
        final relationTextPainter = TextPainter(
          text: relationTextSpan,
          textDirection: TextDirection.ltr,
        );

        motherfathersTextPainter.layout();
        relationTextPainter.layout();

        motherfathersTextPainter.paint(
          canvas,
          Offset(motherfathersX - 50, centerY - 40),
        );
        relationTextPainter.paint(
          canvas,
          Offset(motherfathersX - 60, centerY - 26),
        );
      }

      //Mothersmother
      if (mothermothers.contains(familyTreeDataList[i])) {
        final paint = Paint()
          ..strokeWidth = 2.5
          ..isAntiAlias = true;
        final centerX = size.width * 0.5;
        final centerY = size.height * 0.180;
        final mothermothersIndex = mothermothers.indexOf(familyTreeDataList[i]);
        final mothermothersX = centerX + 60;
        final mothermothersY = centerY - 80;

        // Draw vertical line connecting the mother's circle to the horizontal line
        canvas.drawLine(
          Offset(centerX + 90, mothermothersY),
          Offset(centerX + 90, centerY - 15),
          paint,
        );

        canvas.drawLine(
          Offset(mothermothersX + 70, centerY - 80),
          Offset(centerX + 89, centerY - 80),
          paint,
        );

        // Draw a circle at the end of the horizontal line
        paint
          ..color = Color.fromARGB(255, 80, 24, 43)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1;
        canvas.drawCircle(
          Offset(mothermothersX + 100, centerY - 80),
          30,
          paint,
        );
        final Paint glowPaint = Paint()
          ..color = Color.fromARGB(255, 80, 24, 43)
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, 12);
        canvas.drawCircle(
          Offset(mothermothersX + 100, centerY - 80),
          35,
          glowPaint,
        );

        // Draw the image inside the circle
        final image = imageCache[mothermothers[mothermothersIndex].image];
        if (image == null) {
          loadImage(mothermothers[mothermothersIndex].image.toString())
              .then((loadedImage) {
            if (loadedImage != null) {
              imageCache[mothermothers[mothermothersIndex].image.toString()] =
                  loadedImage;
              _drawImage(canvas, size, loadedImage, i, mothermothersX + 100,
                  centerY - 80);
            }
          });
        } else {
          _drawImage(
              canvas, size, image, i, mothermothersX + 100, centerY - 80);
        }

        // Draw name and relation text
        final mothermothersTextSpan = TextSpan(
          text: mothermothers[mothermothersIndex].name!.length > 6
              ? mothermothers[mothermothersIndex].name!.substring(0, 6)
              : mothermothers[mothermothersIndex].name,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        );
        final relationTextSpan = TextSpan(
          text: mothermothers[mothermothersIndex].relationShip,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        );

        final mothermothersTextPainter = TextPainter(
          text: mothermothersTextSpan,
          textDirection: TextDirection.ltr,
        );
        final relationTextPainter = TextPainter(
          text: relationTextSpan,
          textDirection: TextDirection.ltr,
        );

        mothermothersTextPainter.layout();
        relationTextPainter.layout();

        mothermothersTextPainter.paint(
          canvas,
          Offset(mothermothersX + 80, centerY - 40),
        );
        relationTextPainter.paint(
          canvas,
          Offset(mothermothersX + 80, centerY - 26),
        );
      }

      // Brother
      if (brothers.contains(familyTreeDataList[i])) {
        final paint = Paint()
          ..strokeWidth = 2.5
          ..isAntiAlias = true;
        final centerX = size.width * 0.5;
        final centerY = size.height * 0.380;
        final brotherIndex = brothers.indexOf(familyTreeDataList[i]);

        final horizontalLineX = size.width * 0.36 - brotherIndex * 70.0;

        canvas.drawLine(
          Offset(size.width * 0.5, centerY),
          Offset(horizontalLineX, centerY),
          paint,
        );
        canvas.drawLine(
          Offset(size.width * 0.5, size.height * 0.58),
          Offset(centerX, centerY),
          paint,
        );

        // Draw the brother's circle
        final brotherY = centerY;
        final brotherX = horizontalLineX;

        // Draw the horizontal line of the Γ shape
        // canvas.drawLine(
        //   Offset(brotherX + 50, brotherY),
        //   Offset(brotherX, brotherY),
        //   paint,
        // );

        // Draw the bottom line of the Γ shape
        canvas.drawLine(
          Offset(brotherX, brotherY),
          Offset(brotherX, brotherY + 30),
          paint,
        );

        paint
          ..color = Colors.green
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1;

        // Draw the circle at the end of the bottom line
        canvas.drawCircle(
          Offset(brotherX, brotherY + 59),
          29,
          paint,
        );
        final Paint glowPaint = Paint()
          ..color = Colors.green.withOpacity(0.3)
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, 12);

        canvas.drawCircle(
          Offset(brotherX, brotherY + 59),
          32,
          glowPaint,
        );

        final image = imageCache[brothers[brotherIndex].image];
        if (image == null) {
          loadImage(brothers[brotherIndex].image.toString())
              .then((loadedImage) {
            if (loadedImage != null) {
              imageCache[brothers[brotherIndex].image.toString()] = loadedImage;
              _drawImage(canvas, size, loadedImage, i, brotherX, brotherY + 59);
            }
          });
        } else {
          _drawImage(canvas, size, image, i, brotherX, brotherY + 59);
        }
        TextSpan brotherTextSpan = TextSpan(
          text: brothers[brotherIndex].name!.length > 6
              ? brothers[brotherIndex].name!.substring(0, 6)
              : brothers[brotherIndex].name,
          style: TextStyle(
              fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black),
        );
        TextPainter brotherTextPainter = TextPainter(
          text: brotherTextSpan,
          textDirection: TextDirection.ltr,
        );
        brotherTextPainter.layout();
        brotherTextPainter.paint(
          canvas,
          Offset(brotherX - 14, centerY + 95),
        );

        TextSpan relationTextSpan = TextSpan(
          text: brothers[brotherIndex].relationShip,
          style: TextStyle(
              fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black),
        );
        TextPainter relationTextPainter = TextPainter(
          text: relationTextSpan,
          textDirection: TextDirection.ltr,
        );
        relationTextPainter.layout();
        relationTextPainter.paint(
          canvas,
          Offset(brotherX - 14, centerY + 105),
        );
      }

      // Sister
      if (sisters.contains(familyTreeDataList[i])) {
        final paint = Paint()..strokeWidth = 2.5;
        final centerX = size.width * 0.5;
        final centerY = size.height * 0.380;
        final sisterIndex = sisters.indexOf(familyTreeDataList[i]);

        // Draw vertical line to right
        canvas.drawLine(
          Offset(centerX, centerY),
          Offset(size.width * 0.65, centerY),
          paint,
        );

        // Draw horizontal line extending to the right
        final horizontalLineX = size.width * 0.65 + sisterIndex * 70.0;
        canvas.drawLine(
          Offset(size.width * 0.6, centerY),
          Offset(horizontalLineX, centerY),
          paint,
        );
        //Draw vertical line to connect the user circle
        canvas.drawLine(
          Offset(size.width * 0.5, size.height * 0.58),
          Offset(centerX, centerY),
          paint,
        );

        // Draw the sister's circle
        final sisterY = centerY;
        final sisterX = horizontalLineX;

        // Draw the bottom line of the Γ shape
        canvas.drawLine(
          Offset(sisterX, sisterY),
          Offset(sisterX, sisterY + 30),
          paint,
        );

        paint
          ..color = Colors.red
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1;

        // Draw the circle at the end of the bottom line
        canvas.drawCircle(
          Offset(sisterX, sisterY + 59),
          29,
          paint,
        );
        final Paint glowPaint = Paint()
          ..color = Colors.red.withOpacity(0.3)
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, 12);

        canvas.drawCircle(
          Offset(sisterX, sisterY + 59),
          32,
          glowPaint,
        );
        // Draw sister's image inside the circle
        final image = imageCache[sisters[sisterIndex].image];
        if (image == null) {
          loadImage(sisters[sisterIndex].image.toString()).then((loadedImage) {
            if (loadedImage != null) {
              imageCache[sisters[sisterIndex].image.toString()] = loadedImage;
              _drawImage(canvas, size, loadedImage, i, sisterX, sisterY + 59);
            }
          });
        } else {
          _drawImage(canvas, size, image, i, sisterX, sisterY + 59);
        }

        TextSpan sisterTextSpan = TextSpan(
          text: sisters[sisterIndex].name!.length > 6
              ? sisters[sisterIndex].name!.substring(0, 6)
              : sisters[sisterIndex].name,
          style: TextStyle(
              fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black),
        );
        TextPainter sisterTextPainter = TextPainter(
          text: sisterTextSpan,
          textDirection: TextDirection.ltr,
        );
        sisterTextPainter.layout();
        sisterTextPainter.paint(
          canvas,
          Offset(sisterX - 14, centerY + 95),
        );
        TextSpan relationTextSpan = TextSpan(
          text: sisters[sisterIndex].relationShip,
          style: TextStyle(
              fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black),
        );
        TextPainter relationTextPainter = TextPainter(
          text: relationTextSpan,
          textDirection: TextDirection.ltr,
        );
        relationTextPainter.layout();
        relationTextPainter.paint(
          canvas,
          Offset(sisterX - 14, centerY + 105),
        );
      }

      //husband
      if (husband.contains(familyTreeDataList[i])) {
        final paint = Paint()..strokeWidth = 2.5;
        final centerX = size.width * 0.56;
        final centerY = size.height * 0.625;
        final husbandIndex = husband.indexOf(familyTreeDataList[i]);
        final husbandX = centerX;
        final husbandY = centerY + 150;

        canvas.drawLine(
          Offset(centerX, centerY),
          Offset(husbandX, centerY),
          paint,
        );

        paint
          ..color = Colors.purple // Adjust color as needed
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.6;
        canvas.drawCircle(
          Offset(husbandX, husbandY + 29),
          30,
          paint,
        );
        final Paint glowPaint = Paint()
          ..color = Colors.purple.withOpacity(0.3)
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, 12);

        canvas.drawCircle(
          Offset(husbandX, husbandY + 29),
          35,
          glowPaint,
        );

        final image = imageCache[husband[husbandIndex].image];
        if (image == null) {
          loadImage(husband[husbandIndex].image.toString()).then((loadedImage) {
            if (loadedImage != null) {
              imageCache[husband[husbandIndex].image.toString()] = loadedImage;
              _drawImage(canvas, size, loadedImage, i, husbandX, husbandY + 29);
            }
          });
        } else {
          _drawImage(canvas, size, image, i, husbandX, husbandY + 29);
        }

        TextSpan husbandTextSpan = TextSpan(
          text: husband[husbandIndex].name,
          style: TextStyle(
              fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black),
        );
        TextPainter husbandTextPainter = TextPainter(
          text: husbandTextSpan,
          textDirection: TextDirection.ltr,
        );
        husbandTextPainter.layout();
        husbandTextPainter.paint(
          canvas,
          Offset(husbandX - 15, husbandY + 70), // Adjust position as needed
        );

        // Draw husband's relation
        TextSpan husbandRelationTextSpan = TextSpan(
          text: husband[husbandIndex].relationShip,
          style: TextStyle(
              fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black),
        );
        TextPainter husbandRelationTextPainter = TextPainter(
          text: husbandRelationTextSpan,
          textDirection: TextDirection.ltr,
        );
        husbandRelationTextPainter.layout();
        husbandRelationTextPainter.paint(
          canvas,
          Offset(husbandX - 15, husbandY + 81), // Adjust position as needed
        );
      }

      // wife
      if (wife.contains(familyTreeDataList[i])) {
        final paint = Paint()..strokeWidth = 2.5;
        final centerX = size.width * 0.5;
        final centerY = size.height * 0.665;
        final wifeIndex = wife.indexOf(familyTreeDataList[i]);

        final wifeX = centerX;
        final wifeY = centerY + 150;

        canvas.drawLine(
          Offset(centerX, centerY),
          Offset(wifeX, wifeY),
          paint,
        );

        // Draw wife's circle
        paint
          ..color = Colors.purple // Adjust color as needed
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.6;
        canvas.drawCircle(
          Offset(wifeX, wifeY + 29), // Adjust the Y-coordinate for the circle
          30,
          paint,
        );
        final Paint glowPaint = Paint()
          ..color = Colors.purple.withOpacity(0.3)
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, 12);

        canvas.drawCircle(
          Offset(wifeX, wifeY + 29), // Adjust the Y-coordinate for the circle
          35,
          glowPaint,
        );
        final image = imageCache[wife[wifeIndex].image];
        if (image == null) {
          loadImage(wife[wifeIndex].image.toString()).then((loadedImage) {
            if (loadedImage != null) {
              imageCache[wife[wifeIndex].image.toString()] = loadedImage;
              _drawImage(canvas, size, loadedImage, i, wifeX,
                  wifeY + 29); // Adjust the Y-coordinate for the image
            }
          });
        } else {
          _drawImage(canvas, size, image, i, wifeX,
              wifeY + 29); // Adjust the Y-coordinate for the image
        }

        // Draw wife's name
        TextSpan wifeTextSpan = TextSpan(
          text: wife[wifeIndex].name,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        );
        TextPainter wifeTextPainter = TextPainter(
          text: wifeTextSpan,
          textDirection: TextDirection.ltr,
        );
        wifeTextPainter.layout();
        wifeTextPainter.paint(
          canvas,
          Offset(wifeX - 15, wifeY + 70), // Adjust the position as needed
        );

        // Draw wife's relation
        TextSpan wifeRelationTextSpan = TextSpan(
          text: wife[wifeIndex].relationShip,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        );
        TextPainter wifeRelationTextPainter = TextPainter(
          text: wifeRelationTextSpan,
          textDirection: TextDirection.ltr,
        );
        wifeRelationTextPainter.layout();
        wifeRelationTextPainter.paint(
          canvas,
          Offset(wifeX - 15, wifeY + 81), // Adjust the position as needed
        );
      }

      // son
      if (sons.contains(familyTreeDataList[i])) {
        final centerX = size.width * 0.5;
        final centerY = size.height * 0.665;
        final paint = Paint()
          ..strokeWidth = 2.5
          ..isAntiAlias = true;
        final sonsIndex = sons.indexOf(familyTreeDataList[i]);
        final sonX = centerX;
        final sonY = centerY + 80;

        // Draw vertical line to left
        canvas.drawLine(
          Offset(centerX, centerY),
          Offset(sonX, sonY),
          paint,
        );

        // Draw horizontal line to the left
        final horizontalLineLength = size.width * 0.36 - sonsIndex * 70;
        canvas.drawLine(
          Offset(sonX, sonY),
          Offset(horizontalLineLength, sonY),
          paint,
        );
        // Draw vertical line at the end of the horizontal line
        final verticalLineHeight = 30;
        canvas.drawLine(
          Offset(horizontalLineLength, sonY),
          Offset(horizontalLineLength, sonY + verticalLineHeight),
          paint,
        );

        paint
          ..color = const Color.fromARGB(255, 90, 139, 180)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1;

        canvas.drawCircle(
          Offset(horizontalLineLength, sonY + verticalLineHeight + 29),
          29,
          paint,
        );
        final Paint glowPaint = Paint()
          ..color = const Color.fromARGB(255, 90, 139, 180).withOpacity(0.3)
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, 12);

        canvas.drawCircle(
          Offset(horizontalLineLength, sonY + verticalLineHeight + 29),
          32,
          glowPaint,
        );

        final image = imageCache[sons[sonsIndex].image];
        if (image == null) {
          loadImage(sons[sonsIndex].image.toString()).then((loadedImage) {
            if (loadedImage != null) {
              imageCache[sons[sonsIndex].image.toString()] = loadedImage;
              _drawImage(canvas, size, loadedImage, i, horizontalLineLength,
                  sonY + verticalLineHeight + 29);
            }
          });
        } else {
          _drawImage(canvas, size, image, i, horizontalLineLength,
              sonY + verticalLineHeight + 29);
        }

        TextSpan sonTextSpan = TextSpan(
          text: sons[sonsIndex].name!.length > 6
              ? sons[sonsIndex].name!.substring(0, 6)
              : sons[sonsIndex].name,
          style: TextStyle(
              fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black),
        );
        TextPainter sonTextPainter = TextPainter(
          text: sonTextSpan,
          textDirection: TextDirection.ltr,
        );
        sonTextPainter.layout();
        sonTextPainter.paint(
          canvas,
          Offset(horizontalLineLength - 20, sonY + verticalLineHeight + 69),
        );

        TextSpan relationTextSpan = TextSpan(
          text: sons[sonsIndex].relationShip,
          style: TextStyle(
              fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black),
        );
        TextPainter relationTextPainter = TextPainter(
          text: relationTextSpan,
          textDirection: TextDirection.ltr,
        );
        relationTextPainter.layout();
        relationTextPainter.paint(
          canvas,
          Offset(horizontalLineLength - 20, sonY + verticalLineHeight + 79),
        );
      }

      //daughters
      if (daughters.contains(familyTreeDataList[i])) {
        final paint = Paint()
          ..strokeWidth = 2.5
          ..isAntiAlias = true;
        final centerX = size.width * 0.5;
        final centerY = size.height * 0.665;
        final daughterIndex = daughters.indexOf(familyTreeDataList[i]);
        final daughterX = centerX;
        final daughterY = centerY + 80;

        // Draw vertical line to left
        canvas.drawLine(
          Offset(daughterX, centerY),
          Offset(daughterX, daughterY),
          paint,
        );

        // Draw horizontal line to the left
        final horizontalLineLength = size.width * 0.15 + daughterIndex * 70;
        canvas.drawLine(
          Offset(daughterX, daughterY),
          Offset(daughterX + horizontalLineLength, daughterY),
          paint,
        );

        // Draw vertical line at the end of the horizontal line
        final verticalLineHeight = 30;
        canvas.drawLine(
          Offset(daughterX + horizontalLineLength, daughterY),
          Offset(
              daughterX + horizontalLineLength, daughterY + verticalLineHeight),
          paint,
        );
        paint
          ..color = Color.fromRGBO(227, 126, 119, 1)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1;

        canvas.drawCircle(
          Offset(daughterX + horizontalLineLength,
              daughterY + verticalLineHeight + 29),
          29,
          paint,
        );
        final Paint glowPaint = Paint()
          ..color = Color.fromRGBO(227, 126, 119, 1).withOpacity(0.3)
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, 12);

        canvas.drawCircle(
          Offset(daughterX + horizontalLineLength,
              daughterY + verticalLineHeight + 29),
          32,
          glowPaint,
        );

        // Draw daughter's image inside the circle
        final image = imageCache[daughters[daughterIndex].image];
        if (image == null) {
          loadImage(daughters[daughterIndex].image.toString())
              .then((loadedImage) {
            if (loadedImage != null) {
              imageCache[daughters[daughterIndex].image.toString()] =
                  loadedImage;
              _drawImage(
                  canvas,
                  size,
                  loadedImage,
                  i,
                  daughterX + horizontalLineLength,
                  daughterY + verticalLineHeight + 29);
            }
          });
        } else {
          _drawImage(canvas, size, image, i, daughterX + horizontalLineLength,
              daughterY + verticalLineHeight + 29);
        }

        TextSpan daughterTextSpan = TextSpan(
          text: daughters[daughterIndex].name!.length > 6
              ? daughters[daughterIndex].name!.substring(0, 6)
              : daughters[daughterIndex].name,
          style: TextStyle(
              fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black),
        );
        TextPainter daughterTextPainter = TextPainter(
          text: daughterTextSpan,
          textDirection: TextDirection.ltr,
        );
        daughterTextPainter.layout();
        daughterTextPainter.paint(
          canvas,
          Offset(daughterX + horizontalLineLength,
              daughterY + verticalLineHeight + 69),
        );

        TextSpan relationTextSpan = TextSpan(
          text: daughters[daughterIndex].relationShip,
          style: TextStyle(
              fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black),
        );
        TextPainter relationTextPainter = TextPainter(
          text: relationTextSpan,
          textDirection: TextDirection.ltr,
        );
        relationTextPainter.layout();
        relationTextPainter.paint(
          canvas,
          Offset(daughterX + horizontalLineLength,
              daughterY + verticalLineHeight + 79),
        );
      }
    }
  }

  void _drawImage(Canvas canvas, Size size, ui.Image image, int index,
      double centerX, double centerY) {
    final imageSize = Size(55, 55);

    final imageRect = Rect.fromCenter(
      center: Offset(centerX, centerY),
      width: imageSize.width,
      height: imageSize.height,
    );

    // Create a circular clip path
    final clipPath = Path()
      ..addOval(Rect.fromCircle(
          center: imageRect.center, radius: imageSize.width / 2));

    // Clip the canvas before drawing the image
    canvas.save();
    canvas.clipPath(clipPath);

    canvas.drawImageRect(
      image,
      Rect.fromLTRB(0, 0, image.width.toDouble(), image.height.toDouble()),
      imageRect,
      Paint(),
    );

    canvas.restore(); // Restore the canvas to its previous state
  }

  Future<ui.Image?> loadImage(String imageUrl) async {
    final completer = Completer<ui.Image>();

    final image = NetworkImage(imageUrl);
    final stream = image.resolve(ImageConfiguration.empty);
    stream.addListener(ImageStreamListener((info, _) {
      completer.complete(info.image);
    }));

    return completer.future;
  }

  @override
  bool shouldRepaint(FamilyTreePainter oldDelegate) => false;
}
