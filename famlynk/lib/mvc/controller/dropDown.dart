import 'package:flutter/material.dart';

const List<String> relation = <String>[
  "Select Relation",
  'father',
  'mother',
  'sister',
  'brother',
  'wife',
  'husband',
  'daughter',
  'son',
  'grandfather',
  'grandmother',
];

const List<String> maritalStatus = <String>["Single", "Marrried"];

List<Color> backgroundColors = [
  Color.fromARGB(255, 207, 70, 70),
  Color.fromARGB(255, 96, 183, 100),
  Color.fromARGB(255, 74, 121, 159),
  Color.fromARGB(255, 59, 148, 62),
  Color.fromARGB(255, 210, 155, 72),
  Color.fromARGB(255, 114, 77, 179),
];

class NameAvatar extends StatelessWidget {
  final String? name;
  final double radius;
  final String? img;

  NameAvatar({this.name, this.radius = 30, this.img});

  Color _getRandomColor() {
    final colors = [
      Colors.red,
      Colors.green,
      Colors.blue,
      Colors.orange,
      Colors.purple,
      Colors.pink,
      Colors.teal,
    ];
    return colors[name.hashCode % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    final initials = name!.isNotEmpty ? name![0].toUpperCase() : '?';

    return CircleAvatar(
      radius: radius,
      backgroundColor: _getRandomColor(),
      child: Text(
        initials,
        style: TextStyle(
          color: Colors.white,
          fontSize: radius * 0.6,
        ),
      ),
    );
  }
}


 Widget defaultImage(String image, String name, int index) {
    if (image.isEmpty || image == "null") {
      return CircleAvatar(
        radius: 40,
        backgroundColor: backgroundColors[index % backgroundColors.length],
        child: Text(
          name.isNotEmpty ? name[0].toUpperCase() : "?",
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      );
    } else {
      return CircleAvatar(
        radius: 40,
        backgroundImage: NetworkImage(image),
      );
    }
  }