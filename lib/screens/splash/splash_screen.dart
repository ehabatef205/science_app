import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:science/screens/auth/login_screen.dart';
import 'package:science/screens/home/admin/home_screen.dart';
import 'package:science/screens/home/user/home_user_screen.dart';
import 'package:science/screens/splash/block_screen.dart';
import 'package:science/shared/color.dart';
import 'package:science/shared/methods.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(const Duration(seconds: 5), () async {
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        String idUser = FirebaseAuth.instance.currentUser!.uid;
        await FirebaseFirestore.instance
            .collection("users")
            .doc(idUser)
            .get()
            .then((snapshot) {
          if (snapshot.exists) {
            if (snapshot.data()!["block"] == false) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (c) => const HomeUserScreen(),
                ),
              );
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (c) => const BlockScreen(),
                ),
              );
            }
          } else {
            FirebaseFirestore.instance
                .collection("admins")
                .doc(idUser)
                .get()
                .then((snapshot) {
              if (snapshot.exists) {
                if (snapshot.data()!["block"] == false) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (c) =>
                      const HomeScreen(
                        isAdmin: true,
                      ),
                    ),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (c) => const BlockScreen(),
                    ),
                  );
                }
              } else {
                FirebaseFirestore.instance
                    .collection("moderators")
                    .doc(idUser)
                    .get()
                    .then((snapshot) {
                  if (snapshot.exists) {
                    if (snapshot.data()!["block"] == false) {
                      showFluttertoast("Login Successful");
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (c) =>
                          const HomeScreen(
                            isAdmin: false,
                          ),
                        ),
                      );
                    }
                    else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (c) => const BlockScreen(),
                        ),
                      );
                    }
                  }
                });
              }
            });
          }
        });
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (c) => const LoginScreen(),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.grey.shade600,
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Center(
            child: Image.asset(
              "assets/logo.png",
              height: size.height * 0.4,
              width: size.width * 0.8,
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(10),
            child: Text(
              "By X-Code",
                style: TextStyle(
                    color: Colors.white, fontSize: 20),
            ),
          )
        ],
      ),
    );
  }
}
