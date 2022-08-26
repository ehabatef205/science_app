import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:science/shared/methods.dart';

Stream<DocumentSnapshot> getData() {
  return FirebaseFirestore.instance
      .collection("users")
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .snapshots();
}

Stream<QuerySnapshot> getFeatureJobs() {
  return FirebaseFirestore.instance
      .collection("jobs")
      .where("feature_jobs", isEqualTo: true)
      .snapshots();
}

Stream<QuerySnapshot> getFeatureJobsByFilter(String? filter) {
  return FirebaseFirestore.instance
      .collection("jobs")
      .where("feature_jobs", isEqualTo: true)
      .where("time", isEqualTo: filter)
      .snapshots();
}

Stream<DocumentSnapshot> getJobById(String? id) {
  return FirebaseFirestore.instance.collection("jobs").doc(id).snapshots();
}

Stream<QuerySnapshot> getJobType() {
  return FirebaseFirestore.instance
      .collection("job_type")
      .where("state", isEqualTo: true)
      .snapshots();
}

Stream<QuerySnapshot> getJobOfType(String? job_type) {
  return FirebaseFirestore.instance
      .collection("jobs")
      .where("job_type", isEqualTo: job_type)
      .snapshots();
}

Stream<QuerySnapshot> getJobOfTypeByFilter(String? job_type, String? filter) {
  return FirebaseFirestore.instance
      .collection("jobs")
      .where("job_type", isEqualTo: job_type)
      .where("time", isEqualTo: filter)
      .snapshots();
}

Stream<DocumentSnapshot> getDetails(String? id) {
  return FirebaseFirestore.instance.collection("jobs").doc(id).snapshots();
}

Stream<DocumentSnapshot> getAllApplications() {
  return FirebaseFirestore.instance
      .collection("users")
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .snapshots();
}

Stream<DocumentSnapshot> getApplication(String? id) {
  return FirebaseFirestore.instance.collection("jobs").doc(id).snapshots();
}

Future addApplication({
  required List<dynamic> applications,
  required List<dynamic> state_applications,
}) async {
  await FirebaseFirestore.instance
      .collection("users")
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .update({
    "applications": applications,
    "state_applications": state_applications,
  }).catchError((error) {
    if (error.message == "network-request-failed") {
      showFluttertoastError("Check Network");
    }
  }).whenComplete(() {
    showFluttertoast("Apply");
  });
}

Future removeApplication({
  List<dynamic>? applications,
  required List<dynamic> state_applications,
}) async {
  await FirebaseFirestore.instance
      .collection("users")
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .update({
    "applications": applications,
    "state_applications": state_applications,
  }).catchError((error) {
    if (error.message == "network-request-failed") {
      showFluttertoastError("Check Network");
    }
  }).whenComplete(() {
    showFluttertoast("Cancel Apply");
  });
}

Stream<DocumentSnapshot> getAllSaved() {
  return FirebaseFirestore.instance
      .collection("users")
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .snapshots();
}

Stream<DocumentSnapshot> getSave(String? id) {
  return FirebaseFirestore.instance.collection("jobs").doc(id).snapshots();
}

Future addSave({
  required List<dynamic> saved,
}) async {
  await FirebaseFirestore.instance
      .collection("users")
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .update({
    "saved": saved,
  }).catchError((error) {
    if (error.message == "network-request-failed") {
      showFluttertoastError("Check Network");
    }
  }).whenComplete(() {
    showFluttertoast("Saved");
  });
}

Future removeSave({
  String? id,
  List<dynamic>? saved,
}) async {
  await FirebaseFirestore.instance
      .collection("users")
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .update({
    "saved": saved,
  }).catchError((error) {
    if (error.message == "network-request-failed") {
      showFluttertoastError("Check Network");
    }
  }).whenComplete(() {
    showFluttertoast("Unsaved");
  });
}
