import 'package:flutter/material.dart';
import 'package:famlynk/mvc/model/familyMembers/individualUserModel.dart';
import 'package:famlynk/services/familySevice/individulaUserService.dart';

class About extends StatefulWidget {
  About({
    required this.name,
    required this.gender,
    required this.dateOfBirth,
    required this.email,
    required this.uniqueUserId,
    required this.image,
    required this.userId,
  });

  final String name;
  final String gender;
  final String dateOfBirth;
  final String userId;
  final String uniqueUserId;
  final String email;
  final String image;

  @override
  State<About> createState() => _AboutState();
}

class _AboutState extends State<About> with SingleTickerProviderStateMixin {
  var isLoaded = true;

  IndividualUserModel individualUserModel = IndividualUserModel();
  IndividulaUserService individulaUserService = IndividulaUserService();
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.bounceInOut,
    );
    _animationController.forward();

    _loadDataWithDelay();
  }

  void _loadDataWithDelay() async {
    await Future.delayed(Duration(microseconds: 10));
    fetchFamilyMembers(widget.uniqueUserId);
  }

  fetchFamilyMembers(String uniqueUserID) async {
    try {
      individualUserModel = await individulaUserService
          .individulaUserService(widget.uniqueUserId);
      setState(() {
        isLoaded = false;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 231, 238, 243),
      body: isLoaded
          ? Center(
              child: CircularProgressIndicator(),
            )
          : AnimatedContainer(
              duration: Duration(milliseconds: 800),
              decoration: BoxDecoration(),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 60, 20, 10),
                  child: Column(
                    children: [
                      AnimatedBuilder(
                        animation: _animation,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _animation.value,
                            child: CircleAvatar(
                              radius: 65,
                              backgroundImage: widget.image.isNotEmpty
                                  ? NetworkImage(widget.image.toString())
                                  : null,
                              child: widget.image.isNotEmpty
                                  ? null
                                  : Container(
                                      width: 130,
                                      height: 130,
                                      decoration: BoxDecoration(
                                        color: Color.fromARGB(255, 140, 170, 195), 
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: Text(
                                          widget.name.isNotEmpty
                                              ? widget.name[0].toUpperCase()
                                              : "?",
                                          style: TextStyle(
                                            fontSize: 50,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 20),
                      Text(
                        "${widget.name.toString()}",
                        style: TextStyle(
                            fontSize: 27,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic),
                      ),
                      SizedBox(height: 16),
                      Card(
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 20, 0, 30),
                          child: Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (widget.dateOfBirth.isNotEmpty)
                                  Text(
                                    widget.dateOfBirth,
                                    style: TextStyle(fontSize: 17),
                                  ),
                                SizedBox(height: 12),
                                if (widget.email.isNotEmpty)
                                  Text(
                                    widget.email,
                                    style: TextStyle(fontSize: 17),
                                  ),
                                SizedBox(height: 12),
                                if (widget.gender.isNotEmpty)
                                  Text(
                                    widget.gender,
                                    style: TextStyle(fontSize: 17),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
