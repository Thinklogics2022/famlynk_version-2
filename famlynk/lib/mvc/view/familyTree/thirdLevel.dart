import 'dart:async';
import 'package:famlynk/mvc/model/familyTree_model/familyTree_model.dart';
import 'package:famlynk/services/familyTreeService/familyTree_service.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class ThirdLevelRelation extends StatefulWidget {
  const ThirdLevelRelation({super.key});

  @override
  State<ThirdLevelRelation> createState() => _ThirdLevelRelationState();
}

class _ThirdLevelRelationState extends State<ThirdLevelRelation> {
  double _zoomLevel = 0.6;
  String LevelThree = "thirdLevel";
  bool isLoading = true;
  List<FamilyTreeModel> familyTreeDataList = [];

  List<FamilyTreeModel> user = [];
  List<FamilyTreeModel> greatgrandfather = [];
  List<FamilyTreeModel> greatgrandmother = [];
  List<FamilyTreeModel> greatgrandson = [];
  List<FamilyTreeModel> greatgranddaughter = [];
  List<FamilyTreeModel> greatgreatgrandfather = [];
  List<FamilyTreeModel> greatgreatgrandmother = [];
  List<FamilyTreeModel> greatgreatgrandson = [];
  List<FamilyTreeModel> greatgreatgranddaughter = [];

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
      var newDataList = await familyTreeServices.getAllFamilyTree(LevelThree);
      user =
          newDataList.where((member) => member.relationShip == "user").toList();

      greatgrandfather = newDataList
          .where((member) => member.relationShip == "great grandfather")
          .toList();
      greatgrandmother = newDataList
          .where((member) => member.relationShip == "great grandmother")
          .toList();
      greatgrandson = newDataList
          .where((member) => member.relationShip == "great grandson")
          .toList();
      greatgranddaughter = newDataList
          .where((member) => member.relationShip == "great granddaughter")
          .toList();
      greatgreatgrandfather = newDataList
          .where((member) => member.relationShip == "great great grandfather")
          .toList();
      greatgreatgrandmother = newDataList
          .where((member) => member.relationShip == "great great grandmother")
          .toList();
      greatgreatgrandson = newDataList
          .where((member) => member.relationShip == "great great grandson")
          .toList();
      greatgreatgranddaughter = newDataList
        ..where((member) => member.relationShip == "great great granddaughter")
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
                            painter: FamlynkPainter(
                                familyTreeDataList,
                                user,
                                greatgrandfather,
                                greatgrandmother,
                                greatgrandson,
                                greatgranddaughter,
                                greatgreatgrandfather,
                                greatgreatgrandmother,
                                greatgreatgrandson,
                                greatgreatgranddaughter)),
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

class FamlynkPainter extends CustomPainter {
  List<FamilyTreeModel> familyTreeDataList;

  List<FamilyTreeModel> user;

  List<FamilyTreeModel> greatgrandfather;
  List<FamilyTreeModel> greatgrandmother;
  List<FamilyTreeModel> greatgrandson;
  List<FamilyTreeModel> greatgranddaughter;
  List<FamilyTreeModel> greatgreatgrandfather;
  List<FamilyTreeModel> greatgreatgrandmother;
  List<FamilyTreeModel> greatgreatgrandson;
  List<FamilyTreeModel> greatgreatgranddaughter;

  final Map<String, ui.Image> imageCache = {};

  FamlynkPainter(
      this.familyTreeDataList,
      this.user,
      this.greatgrandfather,
      this.greatgrandmother,
      this.greatgrandson,
      this.greatgranddaughter,
      this.greatgreatgrandfather,
      this.greatgreatgrandmother,
      this.greatgreatgrandson,
      this.greatgreatgranddaughter);

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
          Offset(centerX - 40, centerY + 34),
        );
        TextSpan relationTextSpan = TextSpan(
          text: user[0].relationShip,
          style: TextStyle(
              fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black),
        );
        TextPainter relationTextPainter = TextPainter(
          text: relationTextSpan,
          textDirection: TextDirection.ltr,
        );
        relationTextPainter.layout();
        relationTextPainter.paint(
          canvas,
          Offset(centerX - 30, centerY + 47),
        );
      }
      print("greatgrandfather");
      print(greatgrandfather);

      // greatgrandfather
      if (greatgrandfather.contains(familyTreeDataList[i])) {
        final paint = Paint()
          ..strokeWidth = 2.5
          ..isAntiAlias = true;
        final centerX = size.width * 0.5;
        final centerY = size.height * 0.380;
        final greatgrandfatherIndex =
            greatgrandfather.indexOf(familyTreeDataList[i]);

        final horizontalLineX =
            size.width * 0.36 - greatgrandfatherIndex * 70.0;

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
        final greatgrandfatherY = centerY;
        final greatgrandfatherX = horizontalLineX;

        // Draw the bottom line of the Γ shape
        canvas.drawLine(
          Offset(greatgrandfatherX, greatgrandfatherY),
          Offset(greatgrandfatherX, greatgrandfatherY + 30),
          paint,
        );

        paint
          ..color = Colors.green
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1;

        // Draw the circle at the end of the bottom line
        canvas.drawCircle(
          Offset(greatgrandfatherX, greatgrandfatherY + 59),
          29,
          paint,
        );
        final Paint glowPaint = Paint()
          ..color = Colors.green.withOpacity(0.3)
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, 12);

        canvas.drawCircle(
          Offset(greatgrandfatherX, greatgrandfatherY + 59),
          32,
          glowPaint,
        );

        final image = imageCache[greatgrandfather[greatgrandfatherIndex].image];
        if (image == null) {
          loadImage(greatgrandfather[greatgrandfatherIndex].image.toString())
              .then((loadedImage) {
            if (loadedImage != null) {
              imageCache[greatgrandfather[greatgrandfatherIndex]
                  .image
                  .toString()] = loadedImage;
              _drawImage(canvas, size, loadedImage, i, greatgrandfatherX,
                  greatgrandfatherY + 59);
            }
          });
        } else {
          _drawImage(canvas, size, image, i, greatgrandfatherX,
              greatgrandfatherY + 59);
        }
        TextSpan greatgrandfatherTextSpan = TextSpan(
          text: greatgrandfather[greatgrandfatherIndex].name!.length > 6
              ? greatgrandfather[greatgrandfatherIndex].name!.substring(0, 6)
              : greatgrandfather[greatgrandfatherIndex].name,
          style: TextStyle(
              fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black),
        );
        TextPainter greatgrandfatherTextPainter = TextPainter(
          text: greatgrandfatherTextSpan,
          textDirection: TextDirection.ltr,
        );
        greatgrandfatherTextPainter.layout();
        greatgrandfatherTextPainter.paint(
          canvas,
          Offset(greatgrandfatherX - 14, centerY + 95),
        );
        TextSpan relationTextSpan = TextSpan(
          text: greatgrandfather[greatgrandfatherIndex].relationShip!.length > 6
              ? greatgrandfather[greatgrandfatherIndex]
                  .relationShip!
                  .substring(0, 12)
              : greatgrandfather[greatgrandfatherIndex].relationShip,
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
          Offset(greatgrandfatherX - 14, centerY + 105),
        );
      }

// greatgrandmother
      if (greatgrandmother.contains(familyTreeDataList[i])) {
        final paint = Paint()..strokeWidth = 2.5;
        final centerX = size.width * 0.5;
        final centerY = size.height * 0.380;
        final greatgrandmotherIndex =
            greatgrandmother.indexOf(familyTreeDataList[i]);

        // Draw vertical line to right
        canvas.drawLine(
          Offset(centerX, centerY),
          Offset(size.width * 0.65, centerY),
          paint,
        );

        // Draw horizontal line  to the right
        final horizontalLineX =
            size.width * 0.65 + greatgrandmotherIndex * 70.0;
        canvas.drawLine(
          Offset(size.width * 0.6, centerY),
          Offset(horizontalLineX, centerY),
          paint,
        );
        //Draw vertical line to connect the  circle user
        canvas.drawLine(
          Offset(size.width * 0.5, size.height * 0.58),
          Offset(centerX, centerY),
          paint,
        );

        //  sister's circle
        final greatgrandmotherY = centerY;
        final greatgrandmotherX = horizontalLineX;

        //  horizontal line of the Γ shape
        canvas.drawLine(
          Offset(greatgrandmotherX, greatgrandmotherY),
          Offset(greatgrandmotherX, greatgrandmotherY),
          paint,
        );

        // Draw the bottom line of the Γ shape
        canvas.drawLine(
          Offset(greatgrandmotherX, greatgrandmotherY),
          Offset(greatgrandmotherX, greatgrandmotherY + 30),
          paint,
        );

        paint
          ..color = Colors.red
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1;

        // Draw the circle at the end of the bottom line
        canvas.drawCircle(
          Offset(greatgrandmotherX, greatgrandmotherY + 59),
          29,
          paint,
        );
        final Paint glowPaint = Paint()
          ..color = Colors.red.withOpacity(0.3)
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, 12);

        canvas.drawCircle(
          Offset(greatgrandmotherX, greatgrandmotherY + 59),
          32,
          glowPaint,
        );
        // Draw sister's image inside the circle
        final image = imageCache[greatgrandmother[greatgrandmotherIndex].image];
        if (image == null) {
          loadImage(greatgrandmother[greatgrandmotherIndex].image.toString())
              .then((loadedImage) {
            if (loadedImage != null) {
              imageCache[greatgrandmother[greatgrandmotherIndex]
                  .image
                  .toString()] = loadedImage;
              _drawImage(canvas, size, loadedImage, i, greatgrandmotherX,
                  greatgrandmotherY + 59);
            }
          });
        } else {
          _drawImage(canvas, size, image, i, greatgrandmotherX,
              greatgrandmotherY + 59);
        }

        TextSpan greatgrandmotherTextSpan = TextSpan(
          text: greatgrandmother[greatgrandmotherIndex].name!.length > 6
              ? greatgrandmother[greatgrandmotherIndex].name!.substring(0, 6)
              : greatgrandmother[greatgrandmotherIndex].name,
          style: TextStyle(
              fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black),
        );
        TextPainter greatgrandmotherTextPainter = TextPainter(
          text: greatgrandmotherTextSpan,
          textDirection: TextDirection.ltr,
        );
        greatgrandmotherTextPainter.layout();
        greatgrandmotherTextPainter.paint(
          canvas,
          Offset(greatgrandmotherX - 14, centerY + 95),
        );
        TextSpan relationTextSpan = TextSpan(
          text: greatgrandmother[greatgrandmotherIndex].relationShip!.length > 6
              ? greatgrandmother[greatgrandmotherIndex]
                  .relationShip!
                  .substring(0, 12)
              : greatgrandmother[greatgrandmotherIndex].relationShip,
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
          Offset(greatgrandmotherX - 14, centerY + 105),
        );
      }
//great grandson
      if (greatgrandson.contains(familyTreeDataList[i])) {
        final centerX = size.width * 0.5;
        final centerY = size.height * 0.665;
        final paint = Paint()
          ..strokeWidth = 2.5
          ..isAntiAlias = true;
        final greatgrandsonIndex = greatgrandson.indexOf(familyTreeDataList[i]);
        final greatgrandsonIndexX = centerX;
        final greatgrandsonIndexY = centerY + 80;

        // Draw vertical line to left
        canvas.drawLine(
          Offset(centerX, centerY),
          Offset(greatgrandsonIndexX, greatgrandsonIndexY),
          paint,
        );

        // Draw horizontal line to the left
        final horizontalLineLength =
            size.width * 0.36 - greatgrandsonIndex * 70;
        canvas.drawLine(
          Offset(greatgrandsonIndexX, greatgrandsonIndexY),
          Offset(horizontalLineLength, greatgrandsonIndexY),
          paint,
        );
        // Draw vertical line at the end of the horizontal line
        final verticalLineHeight = 30;
        canvas.drawLine(
          Offset(horizontalLineLength, greatgrandsonIndexY),
          Offset(
              horizontalLineLength, greatgrandsonIndexY + verticalLineHeight),
          paint,
        );

        paint
          ..color = const Color.fromARGB(255, 90, 139, 180)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1;

        canvas.drawCircle(
          Offset(horizontalLineLength,
              greatgrandsonIndexY + verticalLineHeight + 29),
          29,
          paint,
        );
        final Paint glowPaint = Paint()
          ..color = const Color.fromARGB(255, 90, 139, 180).withOpacity(0.3)
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, 12);

        canvas.drawCircle(
          Offset(horizontalLineLength,
              greatgrandsonIndexY + verticalLineHeight + 29),
          32,
          glowPaint,
        );

        final image = imageCache[greatgrandson[greatgrandsonIndex].image];
        if (image == null) {
          loadImage(greatgrandson[greatgrandsonIndex].image.toString())
              .then((loadedImage) {
            if (loadedImage != null) {
              imageCache[greatgrandson[greatgrandsonIndex].image.toString()] =
                  loadedImage;
              _drawImage(canvas, size, loadedImage, i, horizontalLineLength,
                  greatgrandsonIndexY + verticalLineHeight + 29);
            }
          });
        } else {
          _drawImage(canvas, size, image, i, horizontalLineLength,
              greatgrandsonIndexY + verticalLineHeight + 29);
        }

        TextSpan greatgrandsonTextSpan = TextSpan(
          text: greatgrandson[greatgrandsonIndex].name!.length > 6
              ? greatgrandson[greatgrandsonIndex].name!.substring(0, 6)
              : greatgrandson[greatgrandsonIndex].name,
          style: TextStyle(
              fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black),
        );
        TextPainter greatgrandsonTextPainter = TextPainter(
          text: greatgrandsonTextSpan,
          textDirection: TextDirection.ltr,
        );
        greatgrandsonTextPainter.layout();
        greatgrandsonTextPainter.paint(
          canvas,
          Offset(horizontalLineLength - 20,
              greatgrandsonIndexY + verticalLineHeight + 69),
        );

        TextSpan relationTextSpan = TextSpan(
          text: greatgrandson[greatgrandsonIndex].relationShip!.length > 6
              ? greatgrandson[greatgrandsonIndex].relationShip!.substring(0, 12)
              : greatgrandson[greatgrandsonIndex].relationShip,
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
          Offset(horizontalLineLength - 20,
              greatgrandsonIndexY + verticalLineHeight + 79),
        );
      }
//great grand daughter
      if (greatgranddaughter.contains(familyTreeDataList[i])) {
        final paint = Paint()
          ..strokeWidth = 2.5
          ..isAntiAlias = true;
        final centerX = size.width * 0.5;
        final centerY = size.height * 0.665;
        final greatgranddaughterIndex =
            greatgranddaughter.indexOf(familyTreeDataList[i]);
        final greatgranddaughterX = centerX;
        final greatgranddaughterY = centerY + 80;

        // Draw vertical line to left
        canvas.drawLine(
          Offset(centerX, centerY),
          Offset(greatgranddaughterX, greatgranddaughterY),
          paint,
        );

        // Draw horizontal line to the left
        final horizontalLineLength =
            size.width * 0.15 + greatgranddaughterIndex * 70;
        canvas.drawLine(
          Offset(greatgranddaughterX, greatgranddaughterY),
          Offset(
              greatgranddaughterX + horizontalLineLength, greatgranddaughterY),
          paint,
        );

        // Draw vertical line at the end of the horizontal line
        final verticalLineHeight = 30;
        canvas.drawLine(
          Offset(
              greatgranddaughterX + horizontalLineLength, greatgranddaughterY),
          Offset(greatgranddaughterX + horizontalLineLength,
              greatgranddaughterY + verticalLineHeight),
          paint,
        );
        paint
          ..color = Color.fromRGBO(227, 126, 119, 1)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1;

        canvas.drawCircle(
          Offset(greatgranddaughterX + horizontalLineLength,
              greatgranddaughterY + verticalLineHeight + 29),
          29,
          paint,
        );
        final Paint glowPaint = Paint()
          ..color = Color.fromRGBO(227, 126, 119, 1).withOpacity(0.3)
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, 12);

        canvas.drawCircle(
          Offset(greatgranddaughterX + horizontalLineLength,
              greatgranddaughterY + verticalLineHeight + 29),
          32,
          glowPaint,
        );

        // Draw daughter's image inside the circle
        final image =
            imageCache[greatgranddaughter[greatgranddaughterIndex].image];
        if (image == null) {
          loadImage(
                  greatgranddaughter[greatgranddaughterIndex].image.toString())
              .then((loadedImage) {
            if (loadedImage != null) {
              imageCache[greatgranddaughter[greatgranddaughterIndex]
                  .image
                  .toString()] = loadedImage;
              _drawImage(
                  canvas,
                  size,
                  loadedImage,
                  i,
                  greatgranddaughterX + horizontalLineLength,
                  greatgranddaughterY + verticalLineHeight + 29);
            }
          });
        } else {
          _drawImage(
              canvas,
              size,
              image,
              i,
              greatgranddaughterX + horizontalLineLength,
              greatgranddaughterY + verticalLineHeight + 29);
        }

        TextSpan greatgranddaughterTextSpan = TextSpan(
          text: greatgranddaughter[greatgranddaughterIndex].name!.length > 6
              ? greatgranddaughter[greatgranddaughterIndex]
                  .name!
                  .substring(0, 6)
              : greatgranddaughter[greatgranddaughterIndex].name,
          style: TextStyle(
              fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black),
        );
        TextPainter greatgranddaughterTextPainter = TextPainter(
          text: greatgranddaughterTextSpan,
          textDirection: TextDirection.ltr,
        );
        greatgranddaughterTextPainter.layout();
        greatgranddaughterTextPainter.paint(
          canvas,
          Offset(greatgranddaughterX + horizontalLineLength,
              greatgranddaughterY + verticalLineHeight + 69),
        );

        TextSpan relationTextSpan = TextSpan(
          text:
              greatgranddaughter[greatgranddaughterIndex].relationShip!.length >
                      6
                  ? greatgranddaughter[greatgranddaughterIndex]
                      .relationShip!
                      .substring(0, 6)
                  : greatgranddaughter[greatgranddaughterIndex].relationShip,
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
            Offset(greatgranddaughterX + horizontalLineLength,
                greatgranddaughterY + verticalLineHeight + 79));
      }

      // great great grandson

      if (greatgreatgrandson.contains(familyTreeDataList[i])) {
        final centerX = size.width * 0.5;
        final centerY = size.height * 0.700;
        final paint = Paint()
          ..strokeWidth = 2.5
          ..isAntiAlias = true;
        final greatgreatgrandsonIndex =
            greatgreatgrandson.indexOf(familyTreeDataList[i]);
        final greatgreatgrandsonIndexX = centerX;
        final greatgreatgrandsonIndexY = centerY + 200;
        canvas.drawLine(
          Offset(centerX, centerY),
          Offset(greatgreatgrandsonIndexX, greatgreatgrandsonIndexY),
          paint,
        );
        final horizontalLineLength =
            size.width * 0.36 - greatgreatgrandsonIndex * 70;
        //left to  right
        canvas.drawLine(
          Offset(greatgreatgrandsonIndexX, greatgreatgrandsonIndexY),
          Offset(horizontalLineLength, greatgreatgrandsonIndexY),
          paint,
        );
        final verticalLineHeight = 30;
        canvas.drawLine(
          Offset(horizontalLineLength, greatgreatgrandsonIndexY),
          Offset(horizontalLineLength,
              greatgreatgrandsonIndexY + verticalLineHeight),
          paint,
        );

        paint
          ..color = Colors.brown
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1;
        canvas.drawCircle(
          Offset(horizontalLineLength,
              greatgreatgrandsonIndexY + verticalLineHeight + 29),
          29,
          paint,
        );
        final Paint glowPaint = Paint()
          ..color = Colors.brown.withOpacity(0.3)
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, 12);

        canvas.drawCircle(
          Offset(horizontalLineLength,
              greatgreatgrandsonIndexY + verticalLineHeight + 29),
          32,
          glowPaint,
        );
        final image = imageCache[greatgrandson[greatgreatgrandsonIndex].image];
        if (image == null) {
          loadImage(greatgrandson[greatgreatgrandsonIndex].image.toString())
              .then((loadedImage) {
            if (loadedImage != null) {
              imageCache[greatgrandson[greatgreatgrandsonIndex]
                  .image
                  .toString()] = loadedImage;
              _drawImage(canvas, size, loadedImage, i, horizontalLineLength,
                  greatgreatgrandsonIndexY + verticalLineHeight + 29);
            }
          });
        } else {
          _drawImage(canvas, size, image, i, horizontalLineLength,
              greatgreatgrandsonIndexY + verticalLineHeight + 29);
        }

        TextSpan greatgrandsonTextSpan = TextSpan(
          text: greatgrandson[greatgreatgrandsonIndex].name!.length > 6
              ? greatgrandson[greatgreatgrandsonIndex].name!.substring(0, 6)
              : greatgrandson[greatgreatgrandsonIndex].name,
          style: TextStyle(
              fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black),
        );
        TextPainter greatgrandsonTextPainter = TextPainter(
          text: greatgrandsonTextSpan,
          textDirection: TextDirection.ltr,
        );
        greatgrandsonTextPainter.layout();
        greatgrandsonTextPainter.paint(
          canvas,
          Offset(horizontalLineLength - 20,
              greatgreatgrandsonIndexY + verticalLineHeight + 69),
        );

        TextSpan relationTextSpan = TextSpan(
          text: greatgrandson[greatgreatgrandsonIndex].relationShip!.length > 6
              ? greatgrandson[greatgreatgrandsonIndex]
                  .relationShip!
                  .substring(0, 12)
              : greatgrandson[greatgreatgrandsonIndex].relationShip,
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
          Offset(horizontalLineLength - 20,
              greatgreatgrandsonIndexY + verticalLineHeight + 79),
        );
      }

      // great great granddaughter

      // if(greatgreatgranddaughter.contains(familyTreeDataList[i])) {
      //   final centerX = size.width * 0.5;
      //   final centerY = size.height * 0.665;
      //   final paint = Paint()
      //     ..strokeWidth = 2.5
      //     ..isAntiAlias = true;
      //   final greatgreatgranddaughterIndex = greatgreatgranddaughter.indexOf(familyTreeDataList[i]);
      //   final sonX = centerX;
      //   final sonY = centerY + 80;
      //    canvas.drawLine(
      //     Offset(centerX, centerY),
      //     Offset(sonX, sonY),
      //     paint,
      //   );
      // }
      if (greatgranddaughter.contains(familyTreeDataList[i])) {
        final paint = Paint()
          ..strokeWidth = 2.5
          ..isAntiAlias = true;
        final centerX = size.width * 0.5;
        final centerY = size.height * 0.700;
        final greatgranddaughterIndex =
            greatgranddaughter.indexOf(familyTreeDataList[i]);
        final greatgranddaughterX = centerX;
        final greatgranddaughterY = centerY + 200;
        canvas.drawLine(
          Offset(centerX, centerY),
          Offset(greatgranddaughterX, greatgranddaughterY),
          paint,
        );
        final horizontalLineLength =
            size.width * 0.65 + greatgranddaughterIndex * 70;
        canvas.drawLine(
          Offset(greatgranddaughterX, greatgranddaughterY),
          Offset(horizontalLineLength, greatgranddaughterY),
          paint,
        );
        final verticalLineHeight = 30;
        canvas.drawLine(
          Offset(horizontalLineLength, greatgranddaughterY),
          Offset(
              horizontalLineLength, greatgranddaughterY + verticalLineHeight),
          paint,
        );
        paint
          ..color = Colors.amber
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1;
        canvas.drawCircle(
          Offset(horizontalLineLength,
              greatgranddaughterY + verticalLineHeight + 29),
          29,
          paint,
        );
        final image =
            imageCache[greatgreatgranddaughter[greatgranddaughterIndex].image];
        if (image == null) {
          loadImage(greatgreatgranddaughter[greatgranddaughterIndex]
                  .image
                  .toString())
              .then((loadedImage) {
            if (loadedImage != null) {
              imageCache[greatgreatgranddaughter[greatgranddaughterIndex]
                  .image
                  .toString()] = loadedImage;
              _drawImage(canvas, size, loadedImage, i, horizontalLineLength,
                  greatgranddaughterY + verticalLineHeight + 29);
            }
          });
        } else {
          _drawImage(canvas, size, image, i, horizontalLineLength,
              greatgranddaughterY + verticalLineHeight + 29);
        }

        TextSpan greatgreatgranddaughterTextSpan = TextSpan(
          text:
              greatgreatgranddaughter[greatgranddaughterIndex].name!.length > 6
                  ? greatgreatgranddaughter[greatgranddaughterIndex]
                      .name!
                      .substring(0, 6)
                  : greatgreatgranddaughter[greatgranddaughterIndex].name,
          style: TextStyle(
              fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black),
        );
        print("object");
        print(greatgreatgranddaughter);
        TextPainter greatgreatgranddaughterTextPainter = TextPainter(
          text: greatgreatgranddaughterTextSpan,
          textDirection: TextDirection.ltr,
        );
        greatgreatgranddaughterTextPainter.layout();
        greatgreatgranddaughterTextPainter.paint(
          canvas,
          Offset(horizontalLineLength - 20,
              greatgranddaughterY + verticalLineHeight + 65),
        );

        TextSpan relationTextSpan = TextSpan(
          text: greatgreatgranddaughter[greatgranddaughterIndex]
                      .relationShip!
                      .length >
                  6
              ? greatgreatgranddaughter[greatgranddaughterIndex]
                  .relationShip!
                  .substring(0, 12)
              : greatgreatgranddaughter[greatgranddaughterIndex].relationShip,
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
          Offset(horizontalLineLength - 20,
              greatgranddaughterY + verticalLineHeight + 77),
        );
      }
      //great great grandfather

      if (greatgreatgrandfather.contains(familyTreeDataList[i])) {
        final paint = Paint()..strokeWidth = 2.5;
        final centerX = size.width * 0.5;
        final centerY = size.height * 0.200;
        final greatgreatgrandfatherIndex =
            greatgreatgrandfather.indexOf(familyTreeDataList[i]);

        final horizontalLineX =
            size.width * 0.36 - greatgreatgrandfatherIndex * 70.0;
// vertical line
        canvas.drawLine(
          Offset(centerX, centerY),
          Offset(horizontalLineX, centerY),
          paint,
        );
        // horizontal line
        canvas.drawLine(
          Offset(size.width * 0.5, size.height * 0.58),
          Offset(centerX, centerY),
          paint,
        );
        final greatgreatgrandfatherY = centerY;
        final greatgreatgrandfatherX = horizontalLineX;
        canvas.drawLine(Offset(greatgreatgrandfatherX, greatgreatgrandfatherY),
            Offset(greatgreatgrandfatherX, greatgreatgrandfatherY + 30), paint);
        paint
          ..color = Colors.purple
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1;
        canvas.drawCircle(
          Offset(greatgreatgrandfatherX, greatgreatgrandfatherY + 59),
          29,
          paint,
        );
        final Paint glowPaint = Paint()
          ..color = Colors.purple.withOpacity(0.3)
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, 12);
        canvas.drawCircle(
          Offset(horizontalLineX, centerY + 59),
          32,
          glowPaint,
        );
        final image =
            imageCache[greatgreatgrandfather[greatgreatgrandfatherIndex].image];
        if (image == null) {
          loadImage(greatgreatgrandfather[greatgreatgrandfatherIndex]
                  .image
                  .toString())
              .then((loadedImage) {
            if (loadedImage != null) {
              imageCache[greatgreatgrandfather[greatgreatgrandfatherIndex]
                  .image
                  .toString()] = loadedImage;
              _drawImage(
                  canvas, size, loadedImage, i, horizontalLineX, centerY + 59);
            }
          });
        } else {
          _drawImage(canvas, size, image, i, horizontalLineX, centerY + 59);
        }
        TextSpan greatgreatgrandfatherTextSpan = TextSpan(
          text:
              greatgreatgrandfather[greatgreatgrandfatherIndex].name!.length > 6
                  ? greatgreatgrandfather[greatgreatgrandfatherIndex]
                      .name!
                      .substring(0, 6)
                  : greatgreatgrandfather[greatgreatgrandfatherIndex].name,
          style: TextStyle(
              fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black),
        );
        TextPainter greatgreatgrandfatherTextPainter = TextPainter(
          text: greatgreatgrandfatherTextSpan,
          textDirection: TextDirection.ltr,
        );
        greatgreatgrandfatherTextPainter.layout();
        greatgreatgrandfatherTextPainter.paint(
          canvas,
          Offset(horizontalLineX - 14, centerY + 95),
        );

        TextSpan relationTextSpan = TextSpan(
          text: greatgreatgrandfather[greatgreatgrandfatherIndex]
                      .relationShip!
                      .length >
                  6
              ? greatgreatgrandfather[greatgreatgrandfatherIndex]
                  .relationShip!
                  .substring(0, 12)
              : greatgreatgrandfather[greatgreatgrandfatherIndex].relationShip,
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
          Offset(horizontalLineX - 14, centerY + 105),
        );
      }

      // great great grand mother
      if (greatgreatgrandmother.contains(familyTreeDataList[i])) {
        final paint = Paint()..strokeWidth = 2.5;
        final centerX = size.width * 0.5;
        final centerY = size.height * 0.200;
        final greatgreatgrandmotherIndex =
            greatgreatgrandmother.indexOf(familyTreeDataList[i]);

        // left to right from center
        canvas.drawLine(
          Offset(centerX, centerY),
          Offset(size.width * 0.65, centerY),
          paint,
        );

        final horizontalLineX =
            size.width * 0.65 + greatgreatgrandmotherIndex * 70;

        canvas.drawLine(
          Offset(size.width * 0.6, centerY),
          Offset(horizontalLineX, centerY),
          paint,
        );
        // line to circle
        canvas.drawLine(
          Offset(size.width * 0.5, size.height * 0.58),
          Offset(centerX, centerY),
          paint,
        );

        final greatgreatgrandmotherX = horizontalLineX;
        final greatgreatgrandmotherY = centerY;
        canvas.drawLine(
          Offset(greatgreatgrandmotherX, greatgreatgrandmotherY),
          Offset(greatgreatgrandmotherX, greatgreatgrandmotherY + 30),
          paint,
        );
        paint
          ..color = Colors.pinkAccent
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1;

        canvas.drawCircle(
          Offset(greatgreatgrandmotherX, greatgreatgrandmotherY + 59),
          29,
          paint,
        );
        final Paint glowPaint = Paint()
          ..color = Colors.pink.withOpacity(0.3)
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, 12);

        canvas.drawCircle(
          Offset(greatgreatgrandmotherX, greatgreatgrandmotherY + 59),
          32,
          glowPaint,
        );
        final image =
            imageCache[greatgreatgrandmother[greatgreatgrandmotherIndex].image];
        if (image == null) {
          loadImage(greatgreatgrandmother[greatgreatgrandmotherIndex]
                  .image
                  .toString())
              .then((loadedImage) {
            if (loadedImage != null) {
              imageCache[greatgreatgrandmother[greatgreatgrandmotherIndex]
                  .image
                  .toString()] = loadedImage;
              _drawImage(canvas, size, loadedImage, i, greatgreatgrandmotherX,
                  greatgreatgrandmotherY + 59);
            }
          });
        } else {
          _drawImage(canvas, size, image, i, greatgreatgrandmotherX,
              greatgreatgrandmotherY + 59);
        }

        TextSpan sisterTextSpan = TextSpan(
          text:
              greatgreatgrandmother[greatgreatgrandmotherIndex].name!.length > 6
                  ? greatgreatgrandmother[greatgreatgrandmotherIndex]
                      .name!
                      .substring(0, 6)
                  : greatgreatgrandmother[greatgreatgrandmotherIndex].name,
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
          Offset(greatgreatgrandmotherX - 14, centerY + 95),
        );
        TextSpan relationTextSpan = TextSpan(
          text: greatgreatgrandmother[greatgreatgrandmotherIndex]
                      .relationShip!
                      .length >
                  6
              ? greatgreatgrandmother[greatgreatgrandmotherIndex]
                  .relationShip!
                  .substring(0, 12)
              : greatgreatgrandmother[greatgreatgrandmotherIndex].relationShip,
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
          Offset(greatgreatgrandmotherX - 14, centerY + 105),
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
  bool shouldRepaint(FamlynkPainter oldDelegate) => false;
}
