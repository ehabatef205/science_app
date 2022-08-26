import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:science/server/auth/auth.dart';
import 'package:science/shared/color.dart';
import 'package:science/widgets/custom_button.dart';
import 'package:science/widgets/custom_text_form_field.dart';

class ViewProfileScreen extends StatefulWidget {
  final data;

  const ViewProfileScreen({required this.data, Key? key}) : super(key: key);

  @override
  State<ViewProfileScreen> createState() => _ViewProfileScreenState();
}

class _ViewProfileScreenState extends State<ViewProfileScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController dateGraduationController = TextEditingController();
  TextEditingController graduationPlaceController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool isNull = false;
  XFile? image;
  String? imageURL;
  bool isUpdate = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nameController.text = widget.data["username"];
    emailController.text = widget.data["email"];
    phoneController.text = widget.data["phone"];
    addressController.text = widget.data["address"];
    dateGraduationController.text = widget.data["graduation_date"];
    graduationPlaceController.text = widget.data["graduation_place"];
    imageURL = widget.data["image"];
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "View Profile",
          style: TextStyle(fontSize: 20),
        ),
        actions: [
          TextButton(
              onPressed: () {
                setState(() {
                  isUpdate = !isUpdate;
                });
              },
              child: Text(
                isUpdate ? "Cancel" : "Edit",
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyText1!.color,
                ),
              ))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: [
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
                        ? Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  image: DecorationImage(
                                      image: NetworkImage(
                                        imageURL!,
                                      ),
                                      fit: BoxFit.cover),
                                ),
                                height: size.height * 0.2,
                                width: size.width * 0.4,
                                child: isUpdate
                                    ? InkWell(
                                        onTap: () {
                                          chooseImage();
                                        },
                                      )
                                    : const SizedBox(),
                              ),
                              isUpdate
                                  ? Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          color: Colors.grey),
                                      child: Icon(
                                        Icons.change_circle_rounded,
                                        color: Theme.of(context)
                                            .textTheme
                                            .bodyText2!
                                            .color,
                                        size: size.width * 0.1,
                                      ),
                                    )
                                  : const SizedBox(),
                            ],
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
                    enabled: isUpdate,
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
                    enabled: false,
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
                    enabled: isUpdate,
                    controller: phoneController,
                    iconData: Icons.phone,
                    hintText: "01000000000",
                    labelText: "Phone number",
                    keyboardType: TextInputType.emailAddress,
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
                    enabled: isUpdate,
                    controller: addressController,
                    iconData: Icons.location_on_outlined,
                    hintText: "Giza Egypt",
                    labelText: "Address",
                    keyboardType: TextInputType.emailAddress,
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
                    enabled: isUpdate,
                    controller: dateGraduationController,
                    iconData: Icons.date_range_rounded,
                    hintText: "2022 Or Present",
                    labelText: "Graduation Date",
                    keyboardType: TextInputType.emailAddress,
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
                    enabled: isUpdate,
                    controller: graduationPlaceController,
                    iconData: Icons.assured_workload,
                    hintText: "Faculty of Science Cairo university",
                    labelText: "Graduation Place",
                    keyboardType: TextInputType.emailAddress,
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
                  isLoading
                      ? CircularProgressIndicator(
                          color: colorButton,
                        )
                      : isUpdate
                          ? CustomButton(
                              text: "Register",
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  formKey.currentState!.save();
                                  setState(() {
                                    isLoading = true;
                                  });
                                  updateProfile(
                                    image: image,
                                    imageURL2: imageURL,
                                    name: nameController.text,
                                    context: context,
                                    address: addressController.text,
                                    phone: phoneController.text,
                                    graduationDate:
                                        dateGraduationController.text,
                                    graduationPlace:
                                        graduationPlaceController.text,
                                  ).catchError((val) {
                                    setState(() {
                                      isLoading = false;
                                    });
                                  });
                                } else {
                                  setState(() {
                                    isLoading = false;
                                  });
                                }
                              },
                            )
                          : const SizedBox(),
                ],
              ),
            )
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
