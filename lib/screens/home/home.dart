import 'dart:async';
import 'dart:io';

import 'package:animated_button/animated_button.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:project_quizz/components/menu.dart';
import 'package:project_quizz/screens/home/history.dart';
import 'package:project_quizz/screens/home/ranking.dart';
import 'package:project_quizz/screens/multiplayer/multiplayer_wait.dart';
import 'package:project_quizz/screens/singleplayer/singleplayer.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final fabKey = GlobalKey<FabCircularMenuState>();

  bool isTapped = false;

  final user = FirebaseAuth.instance.currentUser!;
  String? name;
  int exp = 1;

  // getId
  Future getId() async {
    await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: user.email)
        .get()
        .then((snapshot) => snapshot.docs.forEach((document) {
              final r = document.data();
              try {
                setState(() {
                  name = r['username'];
                  exp = r['exp'];
                });
              } catch (e) {
                print(e.toString());
              }
            }));
  }

  //Disable Back Button
  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Are you sure?'),
            content: Text('Do you want to exit an App?'),
            actions: <Widget>[
              ElevatedButton(
                  child: Text('Yes'),
                  onPressed: () {
                    if (Platform.isAndroid) {
                      SystemNavigator.pop();
                    } else {
                      exit(0);
                    }
                  }),
              ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(Colors.red)),
                  child: Text('No'),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  }),
            ],
          ),
        )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    getId();
    Size size = MediaQuery.of(context).size;

    //===================================
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [
              Color(0xFF09031D),
              Color(0xFF1B1E44),
            ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                tileMode: TileMode.clamp)),
        child: Scaffold(
          //menu
          floatingActionButton: Builder(
            builder: (context) => Menu(fabKey: fabKey),
          ),
          backgroundColor: Colors.transparent,
          body: Padding(
            padding: EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                //username + time
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Xin Ch??o ',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20)),
                          Text('$name',
                              style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 30,
                                  overflow: TextOverflow.ellipsis)),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Container(
                        padding: EdgeInsets.all(5.0),
                        decoration: BoxDecoration(
                            border: Border.all(width: 2, color: Colors.red),
                            borderRadius: BorderRadius.circular(5)),
                        child: Text(
                          DateFormat('hh:mm:ss a').format(DateTime.now()),
                          style: TextStyle(
                            color: Colors.white.withOpacity(.8),
                            fontSize: 18,
                          ),
                        ),
                      ),
                    )
                  ],
                ),

                //image
                Image.asset(
                  'assets/images/avatar.png',
                  width: size.width / 2,
                  height: size.width / 2,
                  fit: BoxFit.cover,
                ),

                //playgame
                //choidon
                AnimatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => SinglePlayerScreen(),
                    ));
                  },
                  child: Text(
                    'Ch??i ????n',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                //daudoi
                AnimatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => MultiplayerScreen(),
                    ));
                  },
                  child: Text(
                    '?????u ????i',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                //lichsu
                AnimatedButton(
                  color: Colors.orange,
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => HistoryScreen(),
                    ));
                  },
                  child: Text(
                    'L???ch S??? Ch??i',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                //bxh
                AnimatedButton(
                  color: Colors.orange,
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => RankingScreen(),
                    ));
                  },
                  child: Text(
                    'B???ng X???p H???ng',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                //thoat
                AnimatedButton(
                  width: size.width / 4,
                  color: Colors.red,
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Tho??t Tr?? Ch??i'),
                          content: Text('B???n c?? ch???c mu???n tho??t Tr?? Ch??i?'),
                          actions: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStatePropertyAll(
                                      Colors.red,
                                    ),
                                  ),
                                  onPressed: () {
                                    if (Platform.isAndroid) {
                                      SystemNavigator.pop();
                                    } else {
                                      exit(0);
                                    }
                                  },
                                  child: Text('C??'),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Kh??ng'),
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Text(
                    'Tho??t',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
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
