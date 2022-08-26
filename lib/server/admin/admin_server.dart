import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:science/shared/methods.dart';

String imagesURL = "";

Stream<QuerySnapshot> getAllModerators() {
  return FirebaseFirestore.instance.collection("moderators").snapshots();
}

Future blockModerator({String? idDoc, bool? value}) async {
  await FirebaseFirestore.instance
      .collection("moderators")
      .doc(idDoc)
      .update({"block": value});
}

Stream<QuerySnapshot> getAllUsers() {
  return FirebaseFirestore.instance.collection("users").snapshots();
}

Stream<DocumentSnapshot> getUserById(String? id) {
  return FirebaseFirestore.instance.collection("users").doc(id).snapshots();
}

Stream<QuerySnapshot> getAllJobs() {
  return FirebaseFirestore.instance.collection("jobs").snapshots();
}

Stream<QuerySnapshot> getAllJobTypes() {
  return FirebaseFirestore.instance.collection("job_type").snapshots();
}

Future addJobType({String? name, bool? state, BuildContext? context}) async {
  await FirebaseFirestore.instance.collection("job_type").add({
    "name": name,
    "state": state,
  }).then((value) async {
    await FirebaseFirestore.instance
        .collection("job_type")
        .doc(value.id)
        .update({
      "id": value.id,
    }).whenComplete(() {
      Navigator.pop(context!);
    });
  });
}

Future updateJobType(
    {String? id, String? name, bool? state, BuildContext? context}) async {
  await FirebaseFirestore.instance.collection("job_type").doc(id).update({
    "name": name,
    "state": state,
  }).whenComplete(() {
    Navigator.pop(context!);
  });
}

Future jobState({String? idDoc, bool? value}) async {
  await FirebaseFirestore.instance
      .collection("job_type")
      .doc(idDoc)
      .update({"state": value});
}

Future blockUser({String? idDoc, bool? value}) async {
  await FirebaseFirestore.instance
      .collection("users")
      .doc(idDoc)
      .update({"block": value});
}

Future changeApplicationState({String? idDoc, List? state_applications}) async {
  await FirebaseFirestore.instance
      .collection("users")
      .doc(idDoc)
      .update({"state_applications": state_applications});
}

Future addJob(
    {required String address,
    required String description,
    required String expertise,
    required bool feature_jobs,
    required String job_type,
    required XFile logo,
    required String salary,
    required String salary_refund,
    required String state,
    required String time,
    required String title,
    required BuildContext context}) async {
  await FirebaseFirestore.instance.collection("jobs").add({
    "address": address,
    "description": description,
    "expertise": expertise,
    "feature_jobs": feature_jobs,
    "job_type": job_type,
    "salary": salary,
    "salary_refund": salary_refund,
    "state": state,
    "time": time,
    "title": title,
  }).then((value) {
    uploadImage(logo, value.id).whenComplete(() async {
      await FirebaseFirestore.instance.collection("jobs").doc(value.id).update({
        "id": value.id,
        "logo": imagesURL,
      }).whenComplete(() {
        Navigator.pop(context);
      });
    });
  });
}

Future updateJob(
    {required String id,
    required String address,
    required String description,
    required String expertise,
    required bool feature_jobs,
    required String job_type,
    XFile? logo,
    required String salary,
    required String salary_refund,
    required String state,
    required String time,
    required String title,
    required BuildContext context}) async {
  await FirebaseFirestore.instance.collection("jobs").doc(id).update({
    "id": id,
    "address": address,
    "description": description,
    "expertise": expertise,
    "feature_jobs": feature_jobs,
    "job_type": job_type,
    "salary": salary,
    "salary_refund": salary_refund,
    "state": state,
    "time": time,
    "title": title,
  }).then((value) {
    if (logo != null) {
      uploadImage(logo, id).whenComplete(() async {
        await FirebaseFirestore.instance.collection("jobs").doc(id).update({
          "logo": imagesURL,
        }).whenComplete(() {
          Navigator.pop(context);
        });
      });
    } else {
      Navigator.pop(context);
    }
  });
}

Future closedJob({String? idDoc, String? value}) async {
  await FirebaseFirestore.instance
      .collection("jobs")
      .doc(idDoc)
      .update({"state": value});
}

Future uploadImage(XFile logo, String docId) async {
  Reference reference = FirebaseStorage.instance
      .ref()
      .child("jobs")
      .child(docId)
      .child(getImageName(logo));

  UploadTask uploadTask = reference.putFile(File(logo.path));
  await uploadTask.whenComplete(() async {
    await reference.getDownloadURL().then((urlImage) async {
      imagesURL = urlImage;
    });
  });
}

String getImageName(XFile image) {
  return image.path.split("/").last;
}

Future deleteJob({String? docId, required BuildContext context}) async {
  await FirebaseStorage.instance.ref("jobs/$docId").listAll().then((value) {
    for (var element in value.items) {
      FirebaseStorage.instance
          .ref(element.fullPath)
          .delete()
          .whenComplete(() async {
        await FirebaseFirestore.instance.collection("jobs").doc(docId).delete();
      });
    }
  }).whenComplete(() {
    Navigator.pop(context);
  });
}

Future AddModerator(
    {String? name,
    String? email,
    String? password,
    String? emailAdmin,
    String? passwordAdmin,
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
    FirebaseFirestore.instance
        .collection("moderators")
        .doc(auth.user!.uid)
        .set({
      "email": email,
      "block": false,
      "uid": auth.user!.uid,
      "username": name,
    }).whenComplete(() {
      FirebaseAuth.instance.signOut().whenComplete(() {
        FirebaseAuth.instance.signInWithEmailAndPassword(
            email: emailAdmin!, password: passwordAdmin!);
      });
      Navigator.pop(context!);
    });
  });
}
