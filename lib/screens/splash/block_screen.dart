import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:science/widgets/custom_button.dart';

class BlockScreen extends StatefulWidget {
  const BlockScreen({Key? key}) : super(key: key);

  @override
  State<BlockScreen> createState() => _BlockScreenState();
}

class _BlockScreenState extends State<BlockScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();

        return await true;
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            "Block Screen",
            style: TextStyle(fontSize: 20),
          ),
          leading: const SizedBox(),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ListView(
              shrinkWrap: true,
              children: [
                CustomButton(text: "Support", onPressed: send),
                const SizedBox(
                  height: 50,
                ),
                CustomButton(
                    text: "Logout",
                    onPressed: () {
                      FirebaseAuth.instance.signOut();
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> send() async {
    final Email email = Email(
      recipients: ["sciencejobs2022@gmail.com"],
    );

    String platformResponse;

    try {
      await FlutterEmailSender.send(email);
      platformResponse = 'success';
    } catch (error) {
      print(error);
      platformResponse = error.toString();
    }

    if (!mounted) return;
  }
}
