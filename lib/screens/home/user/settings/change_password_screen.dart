import 'package:flutter/material.dart';
import 'package:science/server/auth/auth.dart';
import 'package:science/shared/color.dart';
import 'package:science/widgets/custom_button.dart';
import 'package:science/widgets/custom_text_form_field.dart';

class ChangePasswordScreen extends StatefulWidget {
  final String userId;

  const ChangePasswordScreen({required this.userId, Key? key})
      : super(key: key);

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmNewPasswordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Change Password",
          style: TextStyle(fontSize: 20),
        ),
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
                  controller: oldPasswordController,
                  iconData: Icons.lock_outline_sharp,
                  hintText: "**********",
                  maxLines: 1,
                  labelText: "Old password",
                  obscureText: true,
                  keyboardType: TextInputType.visiblePassword,
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return "Old password is required";
                    }

                    return null;
                  },
                ),
                SizedBox(
                  height: size.height * 0.05,
                ),
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
                isLoading
                    ? Center(
                      child: CircularProgressIndicator(
                          color: colorButton,
                        ),
                    )
                    : CustomButton(
                        text: "Change Password",
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            formKey.currentState!.save();
                            setState(() {
                              isLoading = true;
                            });
                            changePassword(
                              currentPassword: oldPasswordController.text,
                              newPassword: newPasswordController.text,
                              context: context,
                            ).catchError((val) {
                              setState(() {
                                isLoading = false;
                              });
                            });
                            ;
                          } else {
                            setState(() {
                              isLoading = false;
                            });
                          }
                        },
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
