import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:science/screens/home/admin/view_requests_screen.dart';
import 'package:science/server/admin/admin_server.dart';
import 'package:science/shared/color.dart';
import 'package:science/widgets/custom_text_form_field.dart';

class ViewUserProfileScreen extends StatefulWidget {
  final data;

  const ViewUserProfileScreen({required this.data, Key? key}) : super(key: key);

  @override
  State<ViewUserProfileScreen> createState() => _ViewUserProfileScreenState();
}

class _ViewUserProfileScreenState extends State<ViewUserProfileScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController dateGraduationController = TextEditingController();
  TextEditingController graduationPlaceController = TextEditingController();
  String? imageURL;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.data["username"],
          style: const TextStyle(fontSize: 20),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: StreamBuilder<DocumentSnapshot>(
            stream: getUserById(widget.data.id),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var data = snapshot.data!;
                nameController.text = data["username"];
                emailController.text = data["email"];
                phoneController.text = data["phone"];
                addressController.text = data["address"];
                dateGraduationController.text = data["graduation_date"];
                graduationPlaceController.text = data["graduation_place"];
                imageURL = data["image"];
                return ListView(
                  shrinkWrap: true,
                  children: [
                    Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                          color: Colors.grey.shade700,
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: NetworkImage(imageURL!),
                          )),
                    ),
                    SizedBox(
                      height: size.height * 0.02,
                    ),
                    CustomTextFormField(
                      controller: nameController,
                      iconData: Icons.person,
                      enabled: false,
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
                      enabled: false,
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
                      enabled: false,
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
                      enabled: false,
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
                      enabled: false,
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
                      height: size.height * 0.02,
                    ),
                    Row(
                      children: [
                        Text(
                          "Block: ",
                          style: TextStyle(
                            color: Theme.of(context).textTheme.bodyText1!.color,
                            fontSize: 18,
                          ),
                        ),
                        Theme(
                          data: Theme.of(context).copyWith(
                            unselectedWidgetColor:
                                Theme.of(context).textTheme.bodyText1!.color,
                          ),
                          child: Checkbox(
                            value: data["block"],
                            onChanged: (value) {
                              blockUser(idDoc: widget.data.id, value: value);
                            },
                            activeColor:
                                Theme.of(context).textTheme.bodyText1!.color,
                            checkColor:
                                Theme.of(context).textTheme.bodyText2!.color,
                          ),
                        ),
                      ],
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ViewRequestsScreen(data: data)));
                        },
                        child: Text(
                          "View requests",
                          style: TextStyle(color: colorButton, fontSize: 20),
                        ))
                  ],
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(
                    color: colorButton,
                  ),
                );
              }
            }),
      ),
    );
  }
}
