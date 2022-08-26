import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:science/screens/home/user/home_user_screen.dart';
import 'package:science/shared/color.dart';
import 'package:science/widgets/custom_button.dart';

class UploadCvScreen extends StatefulWidget {
  const UploadCvScreen({Key? key}) : super(key: key);

  @override
  State<UploadCvScreen> createState() => _UploadCvScreenState();
}

class _UploadCvScreenState extends State<UploadCvScreen> {
  PlatformFile? platformFile;
  UploadTask? uploadTask;
  bool isDone = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Upload Cv",
          style: TextStyle(fontSize: 20),
        ),
      ),
      body: ListView(
        children: [
          Center(
            child: InkWell(
              onTap: () async {
                FilePickerResult? result = await FilePicker.platform.pickFiles(
                  type: FileType.custom,
                  allowedExtensions: ['pdf', 'doc'],
                );

                if (result == null) {
                  return;
                }
                setState(() {
                  platformFile = result.files.first;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey.shade500),
                height: size.height * 0.2,
                width: size.width * 0.4,
                child: Center(
                  child: platformFile == null
                      ? Icon(
                          Icons.add,
                          color: Colors.grey.shade900,
                          size: size.width * 0.1,
                        )
                      : Text(
                          platformFile!.name,
                          style: const TextStyle(
                            color: Colors.black,
                          ),
                        ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: size.height * 0.1,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.2),
            child: isDone
                ? Container(
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(10)),
                    child: buildProgress())
                : SizedBox(
                    child: CustomButton(
                      text: "Upload Cv",
                      onPressed: () async {
                        final path =
                            "users/${FirebaseAuth.instance.currentUser!.uid}/${platformFile!.name}";
                        final file = File(platformFile!.path!);

                        final ref = FirebaseStorage.instance.ref().child(path);
                        uploadTask = ref.putFile(file);
                        await uploadTask!.whenComplete(() async {
                          setState(() {
                            isDone = true;
                          });
                          await ref.getDownloadURL().then((urlImage) {
                            FirebaseFirestore.instance
                                .collection("users")
                                .doc(FirebaseAuth.instance.currentUser!.uid)
                                .update({
                              "cv": urlImage,
                            }).whenComplete(() {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const HomeUserScreen()));
                            });
                          });
                        });
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget buildProgress() => StreamBuilder<TaskSnapshot>(
        stream: uploadTask?.snapshotEvents,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data!;
            double progress = data.bytesTransferred / data.totalBytes;
            return SizedBox(
              height: 50,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.grey,
                    color: colorButton,
                  ),
                  Center(
                    child: Text(
                      "${(100 * progress).roundToDouble()}%",
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
            );
          } else {
            return const SizedBox(
              height: 50,
            );
          }
        },
      );
}
