import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_otp/email_otp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:science/screens/auth/check_screen.dart';
import 'package:science/screens/auth/login_screen.dart';
import 'package:science/screens/auth/verify_opt_screen.dart';
import 'package:science/screens/home/admin/home_screen.dart';
import 'package:science/screens/home/user/home_user_screen.dart';
import 'package:science/screens/splash/block_screen.dart';
import 'package:science/shared/methods.dart';

String? imageURL;

Future registration(
    {String? name,
    String? email,
    String? password,
    XFile? image,
    String? address,
    String? phone,
    String? graduationPlace,
    String? graduationDate,
    BuildContext? context}) async {
  await FirebaseAuth.instance
      .createUserWithEmailAndPassword(
          email: email!.trim(), password: password!.trim())
      .catchError((error) {
    if (error.code == "network-request-failed") {
      showFluttertoastError("Check Network");
    } else if (error.code == "email-already-in-use") {
      showFluttertoastError("Email already in use");
    } else if (error.code == "invalid-email") {
      showFluttertoastError("Email address is not valid");
    } else if (error.code == "operation-not-allowed") {
      showFluttertoastError("Operation not allowed");
    } else if (error.code == "weak-password") {
      showFluttertoastError("Password is not strong enough.");
    } else {
      showFluttertoastError(error.message);
    }
  }).then((auth) {
    uploadMultipleImage(image!, auth.user!.uid).whenComplete(() {
      FirebaseFirestore.instance.collection("users").doc(auth.user!.uid).set({
        "address": address,
        "applications": [],
        "block": false,
        "email": email,
        "graduation_date": graduationDate,
        "graduation_place": graduationPlace,
        "image": imageURL,
        "phone": phone,
        "saved": [],
        "state_applications": [],
        "uid": auth.user!.uid,
        "username": name,
        "password": password,
        "cv": "",
      }).whenComplete(() {
        showFluttertoast("Registration Successful");
        Navigator.push(context!,
            MaterialPageRoute(builder: (context) => const HomeUserScreen()));
      });
    });
  });
}

Future uploadMultipleImage(XFile image, String docId) async {
  Reference reference = FirebaseStorage.instance
      .ref()
      .child("users")
      .child(docId)
      .child(getImageName(image));

  UploadTask uploadTask = reference.putFile(File(image.path));
  await uploadTask.whenComplete(() async {
    await reference.getDownloadURL().then((urlImage) {
      imageURL = urlImage;
    });
  });
}

String getImageName(XFile image) {
  return image.path.split("/").last;
}

Future login(String email, String password, BuildContext context) async {
  User? currentUser;

  await FirebaseAuth.instance
      .signInWithEmailAndPassword(
          email: email.trim(), password: password.trim())
      .then((auth) {
    currentUser = auth.user;
  });

  if (currentUser != null) {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(currentUser!.uid)
        .get()
        .then((snapshot) {
      if (snapshot.exists) {
        if (snapshot.data()!["block"] == false) {
          showFluttertoast("Login Successful");
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (c) => const HomeUserScreen(),
            ),
          );
        }else{
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
            .doc(currentUser!.uid)
            .get()
            .then((snapshot) {
          if (snapshot.exists) {
            if (snapshot.data()!["block"] == false) {
              showFluttertoast("Login Successful");
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (c) => const HomeScreen(
                    isAdmin: true,
                  ),
                ),
              );
            }else{
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
                .doc(currentUser!.uid)
                .get()
                .then((snapshot) {
              if (snapshot.exists) {
                if (snapshot.data()!["block"] == false) {
                  showFluttertoast("Login Successful");
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (c) => const HomeScreen(
                        isAdmin: false,
                      ),
                    ),
                  );
                }else{
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
  }
}

Future forgotPassword(
    String email, String newPassword, BuildContext context) async {
  final list = await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);
  if (list.isNotEmpty) {
    FirebaseFirestore.instance
        .collection("users")
        .where("email", isEqualTo: email)
        .get()
        .then((value) async {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email, password: value.docs[0].data()["password"]);

      var user = FirebaseAuth.instance.currentUser!;

      final cred = EmailAuthProvider.credential(
          email: email, password: value.docs[0].data()["password"]);

      await user.reauthenticateWithCredential(cred).then((value) async {
        await user.updatePassword(newPassword).whenComplete(() async {
          await FirebaseFirestore.instance
              .collection("users")
              .doc(user.uid)
              .update({
            "password": newPassword,
          }).whenComplete(() async {
            await FirebaseAuth.instance.signOut().whenComplete(() {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()));
            });
          });
        });
      }).catchError((err) {
        print(err);
      });
    });
  }
}

Future checkEmail(String email, EmailOTP myauth, BuildContext context) async {
  final list = await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);
  if (list.isNotEmpty) {
    myauth.setConfig(
        appEmail: "sciencejobs2022@gmail.com",
        appName: "Science Jobs",
        userEmail: email,
        otpLength: 6,
        otpType: OTPType.digitsOnly);
    if (await myauth.sendOTP()) {
      showFluttertoast("OTP send, Please check your email");
      // ignore: use_build_context_synchronously
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VerifyOTPScreen(
            myauth: myauth,
            email: email,
          ),
        ),
      );
    } else {
      // ignore: use_build_context_synchronously
      showFluttertoastError("Oops, OTP send failed");
    }
  } else {
    showFluttertoastError("Email is not exists");
  }
}

Future verify(
    String otp, String email, EmailOTP myauth, BuildContext context) async {
  if (await myauth.verifyOTP(otp: otp) == true) {
    showFluttertoast("Valid OTP");
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => CheckScreen(email: email)));
  } else {
    showFluttertoastError("Invalid OTP");
  }
}

Future updateProfile(
    {String? name,
    XFile? image,
    String? address,
    String? phone,
    String? graduationPlace,
    String? imageURL2,
    String? graduationDate,
    BuildContext? context}) async {
  if (image == null) {
    imageURL = imageURL2;
    await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({
      "username": name,
      "image": imageURL,
      "block": false,
      "address": address,
      "phone": phone,
      "graduation_date": graduationDate,
      "graduation_place": graduationPlace
    }).whenComplete(() {
      Navigator.push(context!,
          MaterialPageRoute(builder: (context) => const HomeUserScreen()));
    });
  } else {
    await FirebaseStorage.instance
        .refFromURL(imageURL2!)
        .delete()
        .whenComplete(() {
      uploadMultipleImage(image, FirebaseAuth.instance.currentUser!.uid)
          .whenComplete(() async {
        await FirebaseFirestore.instance
            .collection("users")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .update({
          "username": name,
          "image": imageURL,
          "block": false,
          "address": address,
          "phone": phone,
          "graduation_date": graduationDate,
          "graduation_place": graduationPlace
        }).whenComplete(() {
          Navigator.push(context!,
              MaterialPageRoute(builder: (context) => const HomeUserScreen()));
        });
      });
    });
  }
}

Future<bool> changePassword(
    {required String currentPassword,
    required String newPassword,
    required BuildContext context}) async {
  bool success = false;

  //Create an instance of the current user.
  var user = FirebaseAuth.instance.currentUser!;
  //Must re-authenticate user before updating the password. Otherwise it may fail or user get signed out.

  final cred = EmailAuthProvider.credential(
      email: user.email!, password: currentPassword);
  await user.reauthenticateWithCredential(cred).then((value) async {
    await user.updatePassword(newPassword).then((value) {
      FirebaseFirestore.instance.collection("users").doc(user.uid).update({
        "password": newPassword,
      });
    });
  }).catchError((err) {
    print(err);
  }).whenComplete(() {
    Navigator.pop(context);
  });

  return success;
}

Future deleteAccount(BuildContext context) async {
  try {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .delete()
        .whenComplete(() async {
      await FirebaseAuth.instance.currentUser!.delete().whenComplete(() {
        FirebaseAuth.instance.currentUser!.delete();
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const LoginScreen()));
      });
    });
  } catch (e) {
    print(e);
  }
}
