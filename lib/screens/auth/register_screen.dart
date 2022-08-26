import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:science/screens/auth/login_screen.dart';
import 'package:science/server/auth/auth.dart';
import 'package:science/shared/color.dart';
import 'package:science/widgets/custom_button.dart';
import 'package:science/widgets/custom_text_form_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController dateGraduationController = TextEditingController();
  TextEditingController graduationPlaceController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool isNull = false;
  XFile? image;
  String? imageURL;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.only(right: 10, left: 10),
        child: ListView(
          children: [
            Text(
              "Science Jobs",
              style: TextStyle(
                color: colorButton,
                fontSize: 22,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(
              height: size.height * 0.02,
            ),
            Text(
              "Registration 👍",
              style: TextStyle(
                color: Theme
                    .of(context)
                    .textTheme
                    .bodyText1!
                    .color,
                fontSize: 25,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(
              height: size.height * 0.02,
            ),
            const Text(
              "Let's Register. Apply to jobs!",
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
            SizedBox(
              height: size.height * 0.05,
            ),
            Form(
              key: formKey,
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: Colors.grey.shade700,
                    ),
                    child: image == null
                        ? SizedBox(
                      height: size.height * 0.2,
                      width: size.width * 0.4,
                      child: IconButton(
                        onPressed: () {
                          chooseImage();
                        },
                        icon: const Icon(
                          Icons.add_photo_alternate_outlined,
                          color: Colors.white,
                        ),
                      ),
                    )
                        : Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        image: DecorationImage(
                            image: FileImage(
                              File(image!.path),
                            ),
                            fit: BoxFit.cover),
                      ),
                      height: size.height * 0.2,
                      width: size.width * 0.4,
                      child: InkWell(
                        onTap: () {
                          chooseImage();
                        },
                      ),
                    ),
                  ),
                  isNull
                      ? const Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: SizedBox(
                      child: Text(
                        "Image is required",
                        style: TextStyle(
                          color: Colors.red,
                        ),
                      ),
                    ),
                  )
                      : const SizedBox(),
                  SizedBox(
                    height: size.height * 0.05,
                  ),
                  CustomTextFormField(
                    controller: nameController,
                    iconData: Icons.person,
                    hintText: "Full name",
                    labelText: "Full name",
                    keyboardType: TextInputType.text,
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return "Full name is required";
                      }

                      return null;
                    },
                  ),
                  SizedBox(
                    height: size.height * 0.03,
                  ),
                  CustomTextFormField(
                    controller: emailController,
                    iconData: Icons.email_outlined,
                    hintText: "user@gmail.com",
                    labelText: "Email",
                    keyboardType: TextInputType.emailAddress,
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return "Email is required";
                      }

                      return null;
                    },
                  ),
                  SizedBox(
                    height: size.height * 0.03,
                  ),
                  CustomTextFormField(
                    controller: phoneController,
                    iconData: Icons.phone,
                    hintText: "01000000000",
                    labelText: "Phone number",
                    keyboardType: TextInputType.phone,
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return "Phone number is required";
                      }

                      return null;
                    },
                  ),
                  SizedBox(
                    height: size.height * 0.03,
                  ),
                  CustomTextFormField(
                    controller: addressController,
                    iconData: Icons.location_on_outlined,
                    hintText: "Giza Egypt",
                    labelText: "Address",
                    keyboardType: TextInputType.text,
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return "Address is required";
                      }

                      return null;
                    },
                  ),
                  SizedBox(
                    height: size.height * 0.03,
                  ),
                  CustomTextFormField(
                    controller: dateGraduationController,
                    iconData: Icons.date_range_rounded,
                    hintText: "2022 Or Present",
                    labelText: "Graduation Date",
                    keyboardType: TextInputType.text,
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return "Graduation Date is required";
                      }

                      return null;
                    },
                  ),
                  SizedBox(
                    height: size.height * 0.03,
                  ),
                  CustomTextFormField(
                    controller: graduationPlaceController,
                    iconData: Icons.assured_workload,
                    hintText: "Faculty of Science Cairo university",
                    labelText: "Graduation Place",
                    keyboardType: TextInputType.text,
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return "Graduation Place Date is required";
                      }

                      return null;
                    },
                  ),
                  SizedBox(
                    height: size.height * 0.03,
                  ),
                  CustomTextFormField(
                    controller: passwordController,
                    iconData: Icons.lock_outline_sharp,
                    hintText: "**********",
                    labelText: "Password",
                    maxLines: 1,
                    obscureText: true,
                    keyboardType: TextInputType.visiblePassword,
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return "Password is required";
                      }

                      return null;
                    },
                  ),
                  SizedBox(
                    height: size.height * 0.03,
                  ),
                  CustomTextFormField(
                    controller: confirmPasswordController,
                    iconData: Icons.lock_outline_sharp,
                    hintText: "**********",
                    labelText: "Confirm Password",
                    maxLines: 1,
                    obscureText: true,
                    keyboardType: TextInputType.visiblePassword,
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return "Confirm Password is required";
                      } else if (passwordController.text !=
                          confirmPasswordController.text) {
                        return "Password don't match";
                      }

                      return null;
                    },
                  ),
                  SizedBox(
                    height: size.height * 0.05,
                  ),
                  isLoading
                      ? CircularProgressIndicator(
                    color: colorButton,
                  )
                      : CustomButton(
                    text: "Register",
                    onPressed: () {
                      if (image != null) {
                        if (formKey.currentState!.validate()) {
                          formKey.currentState!.save();
                          registration(
                            image: image,
                            name: nameController.text,
                            email: emailController.text,
                            password: passwordController.text,
                            context: context,
                            address: addressController.text,
                            phone: phoneController.text,
                            graduationDate: dateGraduationController.text,
                            graduationPlace:
                            graduationPlaceController.text,
                          );
                        } else {
                          setState(() {
                            isLoading = false;
                          });
                        }
                      } else {
                        setState(() {
                          isNull = true;
                        });
                      }
                    },
                  ),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Have an account?",
                        style: TextStyle(color: Colors.grey),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                          );
                        },
                        child: Text(
                          "Log in",
                          style: TextStyle(
                            color: colorButton,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  chooseImage() async {
    image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    setState(() {
      image;
    });
  }
}
