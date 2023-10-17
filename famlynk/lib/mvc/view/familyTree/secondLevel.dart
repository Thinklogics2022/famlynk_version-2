import 'dart:async';
import 'dart:ui';

import 'package:famlynk/mvc/model/familyTree_model/familyTree_model.dart';
import 'package:famlynk/services/familyTreeService/familyTree_service.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class SecondLevelRelation extends StatefulWidget {
  const SecondLevelRelation({super.key});

  @override
  State<SecondLevelRelation> createState() => _SecondLevelRelationState();
}

class _SecondLevelRelationState extends State<SecondLevelRelation> {
  double _zoomLevel = 0.6;
  String LevelTwo = "secondLevel";
  bool isLoading = true;
  List<FamilyTreeModel> familyTreeDataList = [];
  List<FamilyTreeModel> mothersSide = [];
  List<FamilyTreeModel> fathersSide = [];
  List<FamilyTreeModel> cousinBrother = [];
  List<FamilyTreeModel> cousinSister = [];
  List<FamilyTreeModel> uncleaunt = [];
  List<FamilyTreeModel> grandSonDaughter = [];
  List<FamilyTreeModel> paternalSonDaughter = [];
  List<FamilyTreeModel> maternalSonDaughter = [];
  List<FamilyTreeModel> son_daughter_in_law = [];
  List<FamilyTreeModel> mother_father_in_law = [];
  List<FamilyTreeModel> brother_sister_in_law = [];
  List<FamilyTreeModel> user = [];

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
      fathersSide = newDataList
          .where((member) =>
              member.relationShip == "paternal father" ||
              member.relationShip == "paternal mother")
          .toList();
      mothersSide = newDataList
          .where((member) =>
              member.relationShip == "maternal mother" ||
              member.relationShip == "maternal father")
          .toList();
      cousinBrother = newDataList
          .where((member) =>
              member.relationShip == "cousin" && member.gender == "male")
          .toList();
      cousinSister = newDataList
          .where((member) =>
              member.relationShip == "cousin" && member.gender == "female")
          .toList();
      uncleaunt = newDataList
          .where((member) =>
              member.relationShip == "uncle" || member.relationShip == "aunt")
          .toList();
      grandSonDaughter = newDataList
          .where((member) =>
              member.relationShip == "grandson" ||
              member.relationShip == "granddaughter")
          .toList();
      paternalSonDaughter = newDataList
          .where((member) =>
              member.relationShip == "paternal son" ||
              member.relationShip == "paternal daughter")
          .toList();
      maternalSonDaughter = newDataList
          .where((member) =>
              member.relationShip == "maternal son" ||
              member.relationShip == "mternal daughter")
          .toList();
      son_daughter_in_law = newDataList
          .where((member) =>
              member.relationShip == "son-in-law" ||
              member.relationShip == "daughter-in-law")
          .toList();
      mother_father_in_law = newDataList
          .where((member) =>
              member.relationShip == "father-in-law" ||
              member.relationShip == "mother-in-law")
          .toList();
      brother_sister_in_law = newDataList
          .where((member) =>
              member.relationShip == "brother-in-law" ||
              member.relationShip == "sister-in-law")
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
                              fathersSide,
                              mothersSide,
                              cousinBrother,
                              cousinSister,
                              uncleaunt,
                              grandSonDaughter,
                              paternalSonDaughter,
                              maternalSonDaughter,
                              son_daughter_in_law,
                              mother_father_in_law,
                              brother_sister_in_law,
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
  List<FamilyTreeModel> user;
  List<FamilyTreeModel> fathersSide;
  List<FamilyTreeModel> mothersSide;
  List<FamilyTreeModel> cousinBrother;
  List<FamilyTreeModel> cousinSister;
  List<FamilyTreeModel> uncleaunt;
  List<FamilyTreeModel> grandSonDaughter;
  List<FamilyTreeModel> paternalSonDaughter;
  List<FamilyTreeModel> maternalSonDaughter;
  List<FamilyTreeModel> son_daughter_in_law;
  List<FamilyTreeModel> mother_father_in_law;
  List<FamilyTreeModel> brother_sister_in_law;
  final Map<String, ui.Image> imageCache = {};

  FamilyTreePainter(
    this.familyTreeDataList,
    this.user,
    this.fathersSide,
    this.mothersSide,
    this.cousinBrother,
    this.cousinSister,
    this.uncleaunt,
    this.grandSonDaughter,
    this.paternalSonDaughter,
    this.maternalSonDaughter,
    this.son_daughter_in_law,
    this.mother_father_in_law,
    this.brother_sister_in_law,
  );

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < familyTreeDataList.length; i++) {
      if (user.contains(familyTreeDataList[i])) {
        final paint = Paint()..strokeWidth = 2.5;
        final centerX = size.width * 0.5;
        final centerY = size.height * 0.4;
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
          Offset(centerX - 89, centerY - 6), // Adjust the position as needed
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
      if (fathersSide.contains(familyTreeDataList[i])) {
        final paint = Paint()..strokeWidth = 2.5;
        final centerX = size.width * 0.5;
        final centerY = size.height * 0.100;
        final fatherIndex = fathersSide.indexOf(familyTreeDataList[i]);
        final fatherX = centerX - 60 - fatherIndex * 80.0;
        final fatherY = centerY - 150;

        canvas.drawLine(
          Offset(size.width * 0.5, size.height * 0.353),
          Offset(centerX, fatherY),
          paint,
        );

        canvas.drawLine(
          Offset(fatherX, fatherY),
          Offset(centerX, fatherY),
          paint,
        );
        canvas.drawLine(
          Offset(fatherX, fatherY),
          Offset(fatherX, size.height * 0.01 - 55),
          paint,
        );

        // Draw father's circle
        paint
          ..color = Color.fromARGB(134, 3, 20, 252)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1;
        canvas.drawCircle(
          Offset(fatherX, size.height * 0.015 - 30),
          30,
          paint,
        );
        final Paint glowPaint = Paint()
          ..color = Color.fromARGB(134, 3, 20, 252).withOpacity(0.3)
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, 12);

        canvas.drawCircle(
          Offset(fatherX, size.height * 0.015 - 30),
          35,
          glowPaint,
        );
        final image = imageCache[fathersSide[fatherIndex].image];
        if (image == null) {
          loadImage(fathersSide[fatherIndex].image.toString())
              .then((loadedImage) {
            if (loadedImage != null) {
              imageCache[fathersSide[fatherIndex].image.toString()] =
                  loadedImage;
              _drawImage(canvas, size, loadedImage, i, fatherX,
                  size.height * 0.015 - 30);
            }
          });
        } else {
          _drawImage(canvas, size, image, i, fatherX, size.height * 0.015 - 30);
        }

        // Draw father's name
        TextSpan fatherTextSpan = TextSpan(
          text: fathersSide[fatherIndex].name,
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
          Offset(fatherX - 21, size.height * 0.07 - 30),
        );
        TextSpan relationTextSpan = TextSpan(
          text: fathersSide[fatherIndex].relationShip!.length > 13
              ? fathersSide[fatherIndex].relationShip!.substring(0, 13)
              : fathersSide[fatherIndex].relationShip,
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
          Offset(fatherX - 25, size.height * 0.09 - 30),
        );
      }

      // mother
      if (mothersSide.contains(familyTreeDataList[i])) {
        final centerX = size.width * 0.5;
        final centerY = size.height * 0.100;
        final paint = Paint()..strokeWidth = 2.5;
        final motherIndex = mothersSide.indexOf(familyTreeDataList[i]);
        final motherX = centerX + 60 + motherIndex * 80.0;
        final motherY = centerY - 150;

        //vertical line
        canvas.drawLine(
          Offset(size.width * 0.5, size.height * 0.353),
          Offset(centerX, motherY),
          paint,
        );

        // Draw horizontal line to the right
        canvas.drawLine(
          Offset(centerX, motherY),
          Offset(motherX, motherY),
          paint,
        );
        canvas.drawLine(
          Offset(motherX, motherY),
          Offset(motherX, size.height * 0.01 - 55),
          paint,
        );

        // Draw mother's circle
        paint
          ..color = Colors.pink
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1;
        canvas.drawCircle(
          Offset(motherX, size.height * 0.015 - 30),
          30,
          paint,
        );
        final Paint glowPaint = Paint()
          ..color = Colors.pink.withOpacity(0.3)
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, 12);

        canvas.drawCircle(
          Offset(motherX, size.height * 0.015 - 30),
          35,
          glowPaint,
        );

        // Draw the image inside the circle
        final image = imageCache[mothersSide[motherIndex].image];
        if (image == null) {
          loadImage(mothersSide[motherIndex].image.toString())
              .then((loadedImage) {
            if (loadedImage != null) {
              imageCache[mothersSide[motherIndex].image.toString()] =
                  loadedImage;
              _drawImage(canvas, size, loadedImage, i, motherX,
                  size.height * 0.015 - 30);
            }
          });
        } else {
          _drawImage(canvas, size, image, i, motherX, size.height * 0.015 - 30);
        }

        TextSpan motherTextSpan = TextSpan(
          text: mothersSide[motherIndex].name,
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
          Offset(motherX - 19, size.height * 0.07 - 30),
        );
        TextSpan relationTextSpan = TextSpan(
          text: mothersSide[motherIndex].relationShip!.length > 13
              ? mothersSide[motherIndex].relationShip!.substring(0, 13)
              : mothersSide[motherIndex].relationShip,
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
          Offset(motherX - 20, size.height * 0.09 - 30),
        );
      }

      //cousinBrother
      if (cousinBrother.contains(familyTreeDataList[i])) {
        final paint = Paint()
          ..strokeWidth = 2.5
          ..isAntiAlias = true;
        final centerX = size.width * 0.5;
        final centerY = size.height * 0.380;
        final cousinBrotherIndex = cousinBrother.indexOf(familyTreeDataList[i]);
        final cousinBrotherX = size.width * 0.37 - cousinBrotherIndex * 70.0;
        final cousinBrotherY = centerY - 180;

        canvas.drawLine(
          Offset(size.width * 0.5, size.height * 0.353),
          Offset(centerX, cousinBrotherY),
          paint,
        );

        canvas.drawLine(
          Offset(size.width * 0.5, cousinBrotherY),
          Offset(cousinBrotherX, cousinBrotherY),
          paint,
        );

        canvas.drawLine(
          Offset(cousinBrotherX, cousinBrotherY),
          Offset(cousinBrotherX, cousinBrotherY + 30),
          paint,
        );
        paint
          ..color = Colors.green
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1;

        // Draw the circle at the end of the bottom line
        canvas.drawCircle(
          Offset(cousinBrotherX, cousinBrotherY + 59),
          29,
          paint,
        );
        final Paint glowPaint = Paint()
          ..color = Colors.green.withOpacity(0.3)
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, 12);

        canvas.drawCircle(
          Offset(cousinBrotherX, cousinBrotherY + 59),
          32,
          glowPaint,
        );
        final image = imageCache[cousinBrother[cousinBrotherIndex].image];
        if (image == null) {
          loadImage(cousinBrother[cousinBrotherIndex].image.toString())
              .then((loadedImage) {
            if (loadedImage != null) {
              imageCache[cousinBrother[cousinBrotherIndex].image.toString()] =
                  loadedImage;
              _drawImage(canvas, size, loadedImage, i, cousinBrotherX,
                  cousinBrotherY + 59);
            }
          });
        } else {
          _drawImage(
              canvas, size, image, i, cousinBrotherX, cousinBrotherY + 59);
        }
        TextSpan cousinBrotherTextSpan = TextSpan(
          text: cousinBrother[cousinBrotherIndex].name!.length > 6
              ? cousinBrother[cousinBrotherIndex].name!.substring(0, 6)
              : cousinBrother[cousinBrotherIndex].name,
          style: TextStyle(
              fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black),
        );
        TextPainter cousinBrotherTextPainter = TextPainter(
          text: cousinBrotherTextSpan,
          textDirection: TextDirection.ltr,
        );
        cousinBrotherTextPainter.layout();
        cousinBrotherTextPainter.paint(
          canvas,
          Offset(cousinBrotherX - 14, cousinBrotherY + 95),
        );

        TextSpan relationTextSpan = TextSpan(
          text: cousinBrother[cousinBrotherIndex].relationShip,
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
          Offset(cousinBrotherX - 14, cousinBrotherY + 105),
        );
      }

      //cousinSister
      if (cousinSister.contains(familyTreeDataList[i])) {
        final paint = Paint()
          ..strokeWidth = 2.5
          ..isAntiAlias = true;
        ;
        final centerX = size.width * 0.5;
        final centerY = size.height * 0.380;
        final cousinSisterIndex = cousinSister.indexOf(familyTreeDataList[i]);
        // Draw horizontal line extending to the right
        final cousinSisterX = size.width * 0.65 + cousinSisterIndex * 70.0;
        final cousinSisterY = centerY - 180;

        //Draw vertical line to connect the user circle
        canvas.drawLine(
          Offset(size.width * 0.5, size.height * 0.353),
          Offset(centerX, cousinSisterY),
          paint,
        );

        // Draw vertical line to right
        canvas.drawLine(
          Offset(centerX, cousinSisterY),
          Offset(size.width * 0.65, cousinSisterY),
          paint,
        );
        canvas.drawLine(
          Offset(size.width * 0.6, cousinSisterY),
          Offset(cousinSisterX, cousinSisterY),
          paint,
        );

        canvas.drawLine(
          Offset(cousinSisterX, cousinSisterY),
          Offset(cousinSisterX, cousinSisterY + 30),
          paint,
        );

        paint
          ..color = Colors.red
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1;

        // Draw the circle at the end of the bottom line
        canvas.drawCircle(
          Offset(cousinSisterX, cousinSisterY + 59),
          29,
          paint,
        );
        final Paint glowPaint = Paint()
          ..color = Colors.red.withOpacity(0.3)
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, 12);

        canvas.drawCircle(
          Offset(cousinSisterX, cousinSisterY + 59),
          32,
          glowPaint,
        );

        final image = imageCache[cousinSister[cousinSisterIndex].image];
        if (image == null) {
          loadImage(cousinSister[cousinSisterIndex].image.toString())
              .then((loadedImage) {
            if (loadedImage != null) {
              imageCache[cousinSister[cousinSisterIndex].image.toString()] =
                  loadedImage;
              _drawImage(canvas, size, loadedImage, i, cousinSisterX,
                  cousinSisterY + 59);
            }
          });
        } else {
          _drawImage(canvas, size, image, i, cousinSisterX, cousinSisterY + 59);
        }

        TextSpan cousinSisterTextSpan = TextSpan(
          text: cousinSister[cousinSisterIndex].name!.length > 6
              ? cousinSister[cousinSisterIndex].name!.substring(0, 6)
              : cousinSister[cousinSisterIndex].name,
          style: TextStyle(
              fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black),
        );
        TextPainter cousinSisterTextPainter = TextPainter(
          text: cousinSisterTextSpan,
          textDirection: TextDirection.ltr,
        );
        cousinSisterTextPainter.layout();
        cousinSisterTextPainter.paint(
          canvas,
          Offset(cousinSisterX - 14, cousinSisterY + 95),
        );
        TextSpan relationTextSpan = TextSpan(
          text: cousinSister[cousinSisterIndex].relationShip,
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
          Offset(cousinSisterX - 14, cousinSisterY + 105),
        );
      }

      // uncleaunt
      if (uncleaunt.contains(familyTreeDataList[i])) {
        final centerX = size.width * 0.5;
        final centerY = size.height * 0.449;
        final paint = Paint()
          ..strokeWidth = 2.5
          ..isAntiAlias = true;
        final uncleauntIndex = uncleaunt.indexOf(familyTreeDataList[i]);
        final uncleauntY = centerY + 80;

        canvas.drawLine(
          Offset(centerX, centerY),
          Offset(centerX, uncleauntY),
          paint,
        );
        // Draw horizontal line to the left
        final horizontalLineLength = size.width * 0.36 - uncleauntIndex * 70;
        canvas.drawLine(
          Offset(centerX, uncleauntY),
          Offset(horizontalLineLength, uncleauntY),
          paint,
        );
        // Draw vertical line at the end of the horizontal line
        final verticalLineHeight = 30;
        canvas.drawLine(
          Offset(horizontalLineLength, uncleauntY),
          Offset(horizontalLineLength, uncleauntY + verticalLineHeight),
          paint,
        );

        paint
          ..color = const Color.fromARGB(255, 90, 139, 180)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1;

        canvas.drawCircle(
          Offset(horizontalLineLength, uncleauntY + verticalLineHeight + 29),
          29,
          paint,
        );
        final Paint glowPaint = Paint()
          ..color = const Color.fromARGB(255, 90, 139, 180).withOpacity(0.3)
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, 12);

        canvas.drawCircle(
          Offset(horizontalLineLength, uncleauntY + verticalLineHeight + 29),
          32,
          glowPaint,
        );

        final image = imageCache[uncleaunt[uncleauntIndex].image];
        if (image == null) {
          loadImage(uncleaunt[uncleauntIndex].image.toString())
              .then((loadedImage) {
            if (loadedImage != null) {
              imageCache[uncleaunt[uncleauntIndex].image.toString()] =
                  loadedImage;
              _drawImage(canvas, size, loadedImage, i, horizontalLineLength,
                  uncleauntY + verticalLineHeight + 29);
            }
          });
        } else {
          _drawImage(canvas, size, image, i, horizontalLineLength,
              uncleauntY + verticalLineHeight + 29);
        }

        TextSpan uncleauntTextSpan = TextSpan(
          text: uncleaunt[uncleauntIndex].name!.length > 6
              ? uncleaunt[uncleauntIndex].name!.substring(0, 6)
              : uncleaunt[uncleauntIndex].name,
          style: TextStyle(
              fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black),
        );
        TextPainter uncleauntTextPainter = TextPainter(
          text: uncleauntTextSpan,
          textDirection: TextDirection.ltr,
        );
        uncleauntTextPainter.layout();
        uncleauntTextPainter.paint(
          canvas,
          Offset(
              horizontalLineLength - 20, uncleauntY + verticalLineHeight + 69),
        );

        TextSpan relationTextSpan = TextSpan(
          text: uncleaunt[uncleauntIndex].relationShip,
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
          Offset(
              horizontalLineLength - 20, uncleauntY + verticalLineHeight + 79),
        );
      }
      //grandSonDaughter
      if (grandSonDaughter.contains(familyTreeDataList[i])) {
        final paint = Paint()..strokeWidth = 2.5;
        final centerX = size.width * 0.5;
        final centerY = size.height * 0.449;
        final grandSonDaughterIndex =
            grandSonDaughter.indexOf(familyTreeDataList[i]);
        final grandSonDaughterY = centerY + 230;

        canvas.drawLine(
          Offset(centerX, centerY),
          Offset(centerX, grandSonDaughterY),
          paint,
        );

        // Draw horizontal line to the left
        final horizontalLineLength =
            size.width * 0.36 - grandSonDaughterIndex * 70;
        canvas.drawLine(
          Offset(centerX, grandSonDaughterY),
          Offset(horizontalLineLength, grandSonDaughterY),
          paint,
        );

        canvas.drawLine(
          Offset(horizontalLineLength, grandSonDaughterY),
          Offset(horizontalLineLength, grandSonDaughterY + 30),
          paint,
        );

        paint
          ..color = Color.fromARGB(255, 4, 102, 69)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1;

        canvas.drawCircle(
          Offset(horizontalLineLength, grandSonDaughterY + 59),
          29,
          paint,
        );
        final Paint glowPaint = Paint()
          ..color = Color.fromARGB(255, 6, 117, 86).withOpacity(0.3)
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, 12);
        canvas.drawCircle(
          Offset(horizontalLineLength, grandSonDaughterY + 59),
          32,
          glowPaint,
        );

        final image = imageCache[grandSonDaughter[grandSonDaughterIndex].image];
        if (image == null) {
          loadImage(grandSonDaughter[grandSonDaughterIndex].image.toString())
              .then((loadedImage) {
            if (loadedImage != null) {
              imageCache[grandSonDaughter[grandSonDaughterIndex]
                  .image
                  .toString()] = loadedImage;
              _drawImage(canvas, size, loadedImage, i, horizontalLineLength,
                  grandSonDaughterY + 59);
            }
          });
        } else {
          _drawImage(canvas, size, image, i, horizontalLineLength,
              grandSonDaughterY + 59);
        }

        TextSpan grandSonDaughterTextSpan = TextSpan(
          text: grandSonDaughter[grandSonDaughterIndex].name!.length > 6
              ? grandSonDaughter[grandSonDaughterIndex].name!.substring(0, 6)
              : grandSonDaughter[grandSonDaughterIndex].name,
          style: TextStyle(
              fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black),
        );
        TextPainter grandSonDaughterTextPainter = TextPainter(
          text: grandSonDaughterTextSpan,
          textDirection: TextDirection.ltr,
        );
        grandSonDaughterTextPainter.layout();
        grandSonDaughterTextPainter.paint(
          canvas,
          Offset(horizontalLineLength - 20, grandSonDaughterY + 99),
        );

        TextSpan relationTextSpan = TextSpan(
          text:
              grandSonDaughter[grandSonDaughterIndex].relationShip!.length > 10
                  ? grandSonDaughter[grandSonDaughterIndex]
                      .relationShip!
                      .substring(0, 10)
                  : grandSonDaughter[grandSonDaughterIndex].relationShip,
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
          Offset(horizontalLineLength - 20, grandSonDaughterY + 109),
        );
      }

      //paternalSonDaughter
      if (paternalSonDaughter.contains(familyTreeDataList[i])) {
        final paint = Paint()..strokeWidth = 2.5;
        final centerX = size.width * 0.5;
        final centerY = size.height * 0.449;
        final paternalSonDaughterIndex =
            paternalSonDaughter.indexOf(familyTreeDataList[i]);
        final paternalSonDaughterY = centerX + 455;

        canvas.drawLine(
          Offset(centerX, centerY),
          Offset(centerX, paternalSonDaughterY),
          paint,
        );

        // Draw horizontal line to the left
        final horizontalLineLength =
            size.width * 0.36 - paternalSonDaughterIndex * 70;
        canvas.drawLine(
          Offset(centerX, paternalSonDaughterY),
          Offset(horizontalLineLength, paternalSonDaughterY),
          paint,
        );

        canvas.drawLine(
          Offset(horizontalLineLength, paternalSonDaughterY),
          Offset(horizontalLineLength, paternalSonDaughterY + 30),
          paint,
        );

        paint
          ..color = Color.fromARGB(255, 102, 63, 4)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1;

        canvas.drawCircle(
          Offset(horizontalLineLength, paternalSonDaughterY + 59),
          29,
          paint,
        );
        final Paint glowPaint = Paint()
          ..color = Color.fromARGB(255, 102, 63, 4).withOpacity(0.3)
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, 12);
        canvas.drawCircle(
          Offset(horizontalLineLength, paternalSonDaughterY + 59),
          32,
          glowPaint,
        );
        final image =
            imageCache[paternalSonDaughter[paternalSonDaughterIndex].image];
        if (image == null) {
          loadImage(paternalSonDaughter[paternalSonDaughterIndex]
                  .image
                  .toString())
              .then((loadedImage) {
            if (loadedImage != null) {
              imageCache[paternalSonDaughter[paternalSonDaughterIndex]
                  .image
                  .toString()] = loadedImage;
              _drawImage(canvas, size, loadedImage, i, horizontalLineLength,
                  paternalSonDaughterY + 59);
            }
          });
        } else {
          _drawImage(canvas, size, image, i, horizontalLineLength,
              paternalSonDaughterY + 59);
        }

        TextSpan paternalSonDaughterTextSpan = TextSpan(
          text: paternalSonDaughter[paternalSonDaughterIndex].name!.length > 6
              ? paternalSonDaughter[paternalSonDaughterIndex]
                  .name!
                  .substring(0, 6)
              : paternalSonDaughter[paternalSonDaughterIndex].name,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        );
        TextPainter paternalSonDaughterTextPainter = TextPainter(
          text: paternalSonDaughterTextSpan,
          textDirection: TextDirection.ltr,
        );
        paternalSonDaughterTextPainter.layout();
        paternalSonDaughterTextPainter.paint(
          canvas,
          Offset(horizontalLineLength - 20, paternalSonDaughterY + 99),
        );

        TextSpan relationTextSpan = TextSpan(
          text: paternalSonDaughter[paternalSonDaughterIndex]
                      .relationShip!
                      .length >
                  12
              ? paternalSonDaughter[paternalSonDaughterIndex]
                  .relationShip!
                  .substring(0, 12)
              : paternalSonDaughter[paternalSonDaughterIndex].relationShip,
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
          Offset(horizontalLineLength - 20, paternalSonDaughterY + 109),
        );
      }

      //mother_father_in_law
      if (mother_father_in_law.contains(familyTreeDataList[i])) {
        final paint = Paint()..strokeWidth = 2.5;
        final centerX = size.width * 0.5;
        final centerY = size.height * 0.449;
        final mother_father_in_lawIndex =
            mother_father_in_law.indexOf(familyTreeDataList[i]);
        final mother_father_in_lawY = centerY + 110;

        canvas.drawLine(
          Offset(centerX, centerY),
          Offset(centerX, mother_father_in_lawY),
          paint,
        );

        // Draw horizontal line to the left
        final horizontalLineLength =
            size.width * 0.16 + mother_father_in_lawIndex * 70;
        canvas.drawLine(
          Offset(centerX, mother_father_in_lawY),
          Offset(centerX + horizontalLineLength, mother_father_in_lawY),
          paint,
        );
        canvas.drawLine(
          Offset(centerX + horizontalLineLength, mother_father_in_lawY),
          Offset(centerX + horizontalLineLength, mother_father_in_lawY + 30),
          paint,
        );

        paint
          ..color = Color.fromRGBO(115, 22, 181, 1)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1;

        canvas.drawCircle(
          Offset(centerX + horizontalLineLength, mother_father_in_lawY + 59),
          29,
          paint,
        );
        final Paint glowPaint = Paint()
          ..color = Color.fromRGBO(115, 22, 181, 1).withOpacity(0.3)
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, 12);
        canvas.drawCircle(
          Offset(centerX + horizontalLineLength, mother_father_in_lawY + 59),
          32,
          glowPaint,
        );
        final image =
            imageCache[mother_father_in_law[mother_father_in_lawIndex].image];
        if (image == null) {
          loadImage(mother_father_in_law[mother_father_in_lawIndex]
                  .image
                  .toString())
              .then((loadedImage) {
            if (loadedImage != null) {
              imageCache[mother_father_in_law[mother_father_in_lawIndex]
                  .image
                  .toString()] = loadedImage;
              _drawImage(
                canvas,
                size,
                loadedImage,
                i,
                centerX + horizontalLineLength,
                mother_father_in_lawY + 59,
              );
            }
          });
        } else {
          _drawImage(
            canvas,
            size,
            image,
            i,
            centerX + horizontalLineLength,
            mother_father_in_lawY + 59,
          );
        }

        TextSpan mother_father_in_lawTextSpan = TextSpan(
          text: mother_father_in_law[mother_father_in_lawIndex].name!.length > 6
              ? mother_father_in_law[mother_father_in_lawIndex]
                  .name!
                  .substring(0, 6)
              : mother_father_in_law[mother_father_in_lawIndex].name,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        );
        TextPainter mother_father_in_lawTextPainter = TextPainter(
          text: mother_father_in_lawTextSpan,
          textDirection: TextDirection.ltr,
        );
        mother_father_in_lawTextPainter.layout();
        mother_father_in_lawTextPainter.paint(
          canvas,
          Offset(
              centerX + horizontalLineLength - 20, mother_father_in_lawY + 99),
        );

        TextSpan relationTextSpan = TextSpan(
          text: mother_father_in_law[mother_father_in_lawIndex]
                      .relationShip!
                      .length >
                  13
              ? mother_father_in_law[mother_father_in_lawIndex]
                  .relationShip!
                  .substring(0, 13)
              : mother_father_in_law[mother_father_in_lawIndex].relationShip,
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
          Offset(
              centerX + horizontalLineLength - 19, mother_father_in_lawY + 112),
        );
      }

      //son_daughter_in_law
      if (son_daughter_in_law.contains(familyTreeDataList[i])) {
        final paint = Paint()..strokeWidth = 2.5;
        final centerX = size.width * 0.5;
        final centerY = size.height * 0.449;
        final son_daughter_in_lawIndex =
            son_daughter_in_law.indexOf(familyTreeDataList[i]);
        final son_daughter_in_lawY = centerY + 260;

        canvas.drawLine(
          Offset(centerX, centerY),
          Offset(centerX, son_daughter_in_lawY),
          paint,
        );

        // Draw horizontal line to the left
        final horizontalLineLength =
            size.width * 0.16 + son_daughter_in_lawIndex * 70;
        canvas.drawLine(
          Offset(centerX, son_daughter_in_lawY),
          Offset(centerX + horizontalLineLength, son_daughter_in_lawY),
          paint,
        );

        canvas.drawLine(
          Offset(centerX + horizontalLineLength, son_daughter_in_lawY),
          Offset(centerX + horizontalLineLength, son_daughter_in_lawY + 30),
          paint,
        );

        paint
          ..color = Color.fromRGBO(181, 22, 149, 1)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1;

        canvas.drawCircle(
          Offset(centerX + horizontalLineLength, son_daughter_in_lawY + 59),
          29,
          paint,
        );
        final Paint glowPaint = Paint()
          ..color = Color.fromRGBO(181, 22, 149, 1).withOpacity(0.3)
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, 12);
        canvas.drawCircle(
          Offset(centerX + horizontalLineLength, son_daughter_in_lawY + 59),
          32,
          glowPaint,
        );

        final image =
            imageCache[son_daughter_in_law[son_daughter_in_lawIndex].image];
        if (image == null) {
          loadImage(son_daughter_in_law[son_daughter_in_lawIndex]
                  .image
                  .toString())
              .then((loadedImage) {
            if (loadedImage != null) {
              imageCache[son_daughter_in_law[son_daughter_in_lawIndex]
                  .image
                  .toString()] = loadedImage;
              _drawImage(
                canvas,
                size,
                loadedImage,
                i,
                centerX + horizontalLineLength,
                son_daughter_in_lawY + 59,
              );
            }
          });
        } else {
          _drawImage(
            canvas,
            size,
            image,
            i,
            centerX + horizontalLineLength,
            son_daughter_in_lawY + 59,
          );
        }

        TextSpan son_daughter_in_lawTextSpan = TextSpan(
          text: son_daughter_in_law[son_daughter_in_lawIndex].name!.length > 6
              ? son_daughter_in_law[son_daughter_in_lawIndex]
                  .name!
                  .substring(0, 6)
              : son_daughter_in_law[son_daughter_in_lawIndex].name,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        );
        TextPainter son_daughter_in_lawTextPainter = TextPainter(
          text: son_daughter_in_lawTextSpan,
          textDirection: TextDirection.ltr,
        );
        son_daughter_in_lawTextPainter.layout();
        son_daughter_in_lawTextPainter.paint(
          canvas,
          Offset(
              centerX + horizontalLineLength - 20, son_daughter_in_lawY + 99),
        );

        TextSpan relationTextSpan = TextSpan(
          text: son_daughter_in_law[son_daughter_in_lawIndex]
                      .relationShip!
                      .length >
                  13
              ? son_daughter_in_law[son_daughter_in_lawIndex]
                  .relationShip!
                  .substring(0, 13)
              : son_daughter_in_law[son_daughter_in_lawIndex].relationShip,
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
          Offset(
              centerX + horizontalLineLength - 19, son_daughter_in_lawY + 112),
        );
      }

      //brother_sister_in_law
      if (brother_sister_in_law.contains(familyTreeDataList[i])) {
        final paint = Paint()..strokeWidth = 2.5;
        final centerX = size.width * 0.5;
        final centerY = size.height * 0.449;
        final brother_sister_in_lawIndex =
            brother_sister_in_law.indexOf(familyTreeDataList[i]);
        final brother_sister_in_lawY = centerX + 490;

        canvas.drawLine(
          Offset(centerX, centerY),
          Offset(centerX, brother_sister_in_lawY),
          paint,
        );

        // Draw horizontal line to the left
        final horizontalLineLength =
            size.width * 0.16 + brother_sister_in_lawIndex * 70;
        canvas.drawLine(
          Offset(centerX, brother_sister_in_lawY),
          Offset(centerX + horizontalLineLength, brother_sister_in_lawY),
          paint,
        );
        canvas.drawLine(
          Offset(centerX + horizontalLineLength, brother_sister_in_lawY),
          Offset(centerX + horizontalLineLength, brother_sister_in_lawY + 30),
          paint,
        );

        paint
          ..color = Color.fromRGBO(181, 51, 22, 1)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1;

        canvas.drawCircle(
          Offset(centerX + horizontalLineLength, brother_sister_in_lawY + 59),
          29,
          paint,
        );
        final Paint glowPaint = Paint()
          ..color = Color.fromRGBO(181, 51, 22, 1).withOpacity(0.3)
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, 12);
        canvas.drawCircle(
          Offset(centerX + horizontalLineLength, brother_sister_in_lawY + 59),
          32,
          glowPaint,
        );

        final image =
            imageCache[brother_sister_in_law[brother_sister_in_lawIndex].image];
        if (image == null) {
          loadImage(brother_sister_in_law[brother_sister_in_lawIndex]
                  .image
                  .toString())
              .then((loadedImage) {
            if (loadedImage != null) {
              imageCache[brother_sister_in_law[brother_sister_in_lawIndex]
                  .image
                  .toString()] = loadedImage;
              _drawImage(
                canvas,
                size,
                loadedImage,
                i,
                centerX + horizontalLineLength,
                brother_sister_in_lawY + 59,
              );
            }
          });
        } else {
          _drawImage(
            canvas,
            size,
            image,
            i,
            centerX + horizontalLineLength,
            brother_sister_in_lawY + 59,
          );

          TextSpan brother_sister_in_lawTextSpan = TextSpan(
            text:
                brother_sister_in_law[brother_sister_in_lawIndex].name!.length >
                        6
                    ? brother_sister_in_law[brother_sister_in_lawIndex]
                        .name!
                        .substring(0, 6)
                    : brother_sister_in_law[brother_sister_in_lawIndex].name,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          );
          TextPainter brother_sister_in_lawTextPainter = TextPainter(
            text: brother_sister_in_lawTextSpan,
            textDirection: TextDirection.ltr,
          );
          brother_sister_in_lawTextPainter.layout();
          brother_sister_in_lawTextPainter.paint(
            canvas,
            Offset(centerX + horizontalLineLength - 20,
                brother_sister_in_lawY + 99),
          );

          TextSpan relationTextSpan = TextSpan(
            text: brother_sister_in_law[brother_sister_in_lawIndex]
                        .relationShip!
                        .length >
                    13
                ? brother_sister_in_law[brother_sister_in_lawIndex]
                    .relationShip!
                    .substring(0, 13)
                : brother_sister_in_law[brother_sister_in_lawIndex]
                    .relationShip,
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
            Offset(centerX + horizontalLineLength - 19,
                brother_sister_in_lawY + 112),
          );
        }
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
