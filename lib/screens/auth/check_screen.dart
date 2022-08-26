import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:science/screens/auth/login_screen.dart';
import 'package:science/server/auth/auth.dart';
import 'package:science/widgets/custom_button.dart';
import 'package:science/widgets/custom_text_form_field.dart';

class CheckScreen extends StatefulWidget {
  final String email;

  const CheckScreen({required this.email, Key? key}) : super(key: key);

  @override
  State<CheckScreen> createState() => _CheckScreenState();
}

class _CheckScreenState extends State<CheckScreen> {
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmNewPasswordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();

        return await true;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: const SizedBox(),
          title: const Text(
            "Science Jobs",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w500,
            ),
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: Form(
            key: formKey,
            child: Center(
              child: ListView(
                shrinkWrap: true,
                children: [
                  CustomTextFormField(
                    controller: newPasswordController,
                    iconData: Icons.lock_outline_sharp,
                    hintText: "**********",
                    maxLines: 1,
                    labelText: "New password",
                    obscureText: true,
                    keyboardType: TextInputType.visiblePassword,
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return "New password is required";
                      }

                      return null;
                    },
                  ),
                  SizedBox(
                    height: size.height * 0.05,
                  ),
                  CustomTextFormField(
                    controller: confirmNewPasswordController,
                    iconData: Icons.lock_outline_sharp,
                    hintText: "**********",
                    maxLines: 1,
                    labelText: "Confirm new password",
                    obscureText: true,
                    keyboardType: TextInputType.visiblePassword,
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return "Confirm new password is required";
                      } else if (confirmNewPasswordController.text !=
                          newPasswordController.text) {
                        return "Password don't match";
                      }

                      return null;
                    },
                  ),
                  SizedBox(
                    height: size.height * 0.05,
                  ),
                  CustomButton(
                    text: "Reset Password",
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        formKey.currentState!.save();
                        forgotPassword(
                            widget.email, newPasswordController.text, context);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
