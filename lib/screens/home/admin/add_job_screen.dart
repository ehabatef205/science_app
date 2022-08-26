import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:science/server/admin/admin_server.dart';
import 'package:science/shared/color.dart';
import 'package:science/widgets/custom_button.dart';
import 'package:science/widgets/custom_text_form_field.dart';

class AddJobScreen extends StatefulWidget {
  final bool isUpdate;
  final data;

  const AddJobScreen({required this.isUpdate, required this.data, Key? key})
      : super(key: key);

  @override
  State<AddJobScreen> createState() => _AddJobScreenState();
}

class _AddJobScreenState extends State<AddJobScreen> {
  TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController salary = TextEditingController();
  TextEditingController expertise = TextEditingController();
  bool feature_jobs = false;
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;
  var cities = [
    'Cairo',
    'Giza',
    'Alexandria',
    'Matrouh',
    'Beheira',
    'Kafr Al sheikh',
    'Dakahlia',
    'Damietta',
    'Port Said',
    'North Sinai',
    'Gharbiya',
    'Menoufia',
    'Qalyubia',
    'Sharqia',
    'Ismailia',
    'Fayoum',
    'Suez',
    'South Sinai',
    'Beni Suef',
    'Minya',
    'New Valley',
    'Assiut',
    'Red Sea',
    'Sohag',
    'Qena',
    'Luxor',
    'Aswan'
  ];
  var city;

  var salary_refunds = [
    'Year',
    'Month',
  ];
  var salary_refund;

  var states = [
    'Open',
    'Closed',
  ];
  var state;

  var times = [
    'Full-Time',
    'Part-Time',
  ];
  var time;

  var jobTypes = [];
  var jobType;

  XFile? image;
  String imagesURL = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseFirestore.instance.collection("job_type").get().then((value) {
      for (int i = 0; i < value.size; i++) {
        jobTypes.add(value.docs[i]["name"]);
      }
      print(jobTypes);
      setState(() {});
    });

    if (widget.isUpdate) {
      title.text = widget.data["title"];
      description.text = widget.data["description"];
      expertise.text = widget.data["expertise"];
      salary.text = widget.data["salary"];
      city = widget.data["address"];
      salary_refund = widget.data["salary_refund"];
      state = widget.data["state"];
      time = widget.data["time"];
      jobType = widget.data["job_type"];
      feature_jobs = widget.data["feature_jobs"];
      imagesURL = widget.data["logo"];
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.isUpdate ? "Update job" : "Add job",
          style: TextStyle(fontSize: 20),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: [
            Form(
              key: formKey,
              child: Column(
                children: [
                  imagesURL != ""
                      ? Center(
                          child: InkWell(
                            onTap: () async {
                              image = await chooseImage();
                              if (image != null) {
                                imagesURL = "";
                                setState(() {});
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.grey.shade700,
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    image: NetworkImage(imagesURL),
                                  )),
                              height: 100,
                              width: 100,
                            ),
                          ),
                        )
                      : image == null
                          ? Center(
                              child: Container(
                                height: 100,
                                width: 100,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.grey.shade700,
                                ),
                                child: IconButton(
                                  onPressed: () async {
                                    image = await chooseImage();
                                    if (image != null) {
                                      setState(() {});
                                    }
                                  },
                                  icon: const Icon(
                                    Icons.add_photo_alternate_outlined,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            )
                          : Center(
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.grey.shade700,
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      image: FileImage(File(image!.path)),
                                    )),
                                height: 100,
                                width: 100,
                              ),
                            ),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  CustomTextFormField(
                    controller: title,
                    keyboardType: TextInputType.text,
                    iconData: Icons.title,
                    hintText: "Title",
                    labelText: "Title",
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return "Title is required";
                      }

                      return null;
                    },
                  ),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  CustomTextFormField(
                    controller: description,
                    keyboardType: TextInputType.text,
                    iconData: Icons.description,
                    hintText: "Description",
                    labelText: "Description",
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return "Description is required";
                      }

                      return null;
                    },
                  ),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  CustomTextFormField(
                    controller: expertise,
                    keyboardType: TextInputType.text,
                    iconData: Icons.category,
                    hintText: "Expertise",
                    labelText: "Expertise",
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return "Expertise is required";
                      }

                      return null;
                    },
                  ),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  CustomTextFormField(
                    controller: salary,
                    keyboardType: TextInputType.number,
                    iconData: Icons.monetization_on,
                    hintText: "Salary",
                    labelText: "Salary",
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return "Salary is required";
                      }

                      return null;
                    },
                  ),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "City: ",
                        style: TextStyle(
                          fontSize: 18,
                          color: Theme.of(context).textTheme.bodyText1!.color,
                        ),
                      ),
                      DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              color:
                                  Theme.of(context).textTheme.bodyText1!.color!,
                              width: 1),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: DropdownButton(
                            underline: const SizedBox(),
                            dropdownColor:
                                Theme.of(context).scaffoldBackgroundColor,
                            items: cities.map((item) {
                              return DropdownMenuItem(
                                value: item,
                                child: Text(
                                  item,
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyText1!
                                        .color,
                                  ),
                                ),
                              );
                            }).toList(),
                            value: city == null ? null : city,
                            hint: const Text(
                              "Select city",
                              style: TextStyle(color: Colors.grey),
                            ),
                            onChanged: (newValue) {
                              setState(() {
                                city = newValue;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "Salary refund: ",
                        style: TextStyle(
                          fontSize: 18,
                          color: Theme.of(context).textTheme.bodyText1!.color,
                        ),
                      ),
                      DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              color:
                                  Theme.of(context).textTheme.bodyText1!.color!,
                              width: 1),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: DropdownButton(
                            underline: const SizedBox(),
                            dropdownColor:
                                Theme.of(context).scaffoldBackgroundColor,
                            items: salary_refunds.map((item) {
                              return DropdownMenuItem(
                                value: item,
                                child: Text(
                                  item,
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyText1!
                                        .color,
                                  ),
                                ),
                              );
                            }).toList(),
                            value: salary_refund == null ? null : salary_refund,
                            hint: const Text(
                              "Select salary refund",
                              style: TextStyle(color: Colors.grey),
                            ),
                            onChanged: (newValue) {
                              setState(() {
                                salary_refund = newValue;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "State: ",
                        style: TextStyle(
                          fontSize: 18,
                          color: Theme.of(context).textTheme.bodyText1!.color,
                        ),
                      ),
                      DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              color:
                                  Theme.of(context).textTheme.bodyText1!.color!,
                              width: 1),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: DropdownButton(
                            underline: const SizedBox(),
                            dropdownColor:
                                Theme.of(context).scaffoldBackgroundColor,
                            items: states.map((item) {
                              return DropdownMenuItem(
                                value: item,
                                child: Text(
                                  item,
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyText1!
                                        .color,
                                  ),
                                ),
                              );
                            }).toList(),
                            value: state == null ? null : state,
                            hint: const Text(
                              "Select state",
                              style: TextStyle(color: Colors.grey),
                            ),
                            onChanged: (newValue) {
                              setState(() {
                                state = newValue;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "Time: ",
                        style: TextStyle(
                          fontSize: 18,
                          color: Theme.of(context).textTheme.bodyText1!.color,
                        ),
                      ),
                      DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              color:
                                  Theme.of(context).textTheme.bodyText1!.color!,
                              width: 1),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: DropdownButton(
                            underline: const SizedBox(),
                            dropdownColor:
                                Theme.of(context).scaffoldBackgroundColor,
                            items: times.map((item) {
                              return DropdownMenuItem(
                                value: item,
                                child: Text(
                                  item,
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyText1!
                                        .color,
                                  ),
                                ),
                              );
                            }).toList(),
                            value: time == null ? null : time,
                            hint: const Text(
                              "Select time",
                              style: TextStyle(color: Colors.grey),
                            ),
                            onChanged: (newValue) {
                              setState(() {
                                time = newValue;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "Job type: ",
                        style: TextStyle(
                          fontSize: 18,
                          color: Theme.of(context).textTheme.bodyText1!.color,
                        ),
                      ),
                      DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              color:
                                  Theme.of(context).textTheme.bodyText1!.color!,
                              width: 1),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: DropdownButton(
                            underline: const SizedBox(),
                            dropdownColor:
                                Theme.of(context).scaffoldBackgroundColor,
                            items: jobTypes.map((item) {
                              return DropdownMenuItem(
                                value: item,
                                child: Text(
                                  item,
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyText1!
                                        .color,
                                  ),
                                ),
                              );
                            }).toList(),
                            value: jobType == null ? null : jobType,
                            hint: const Text(
                              "Select job type",
                              style: TextStyle(color: Colors.grey),
                            ),
                            onChanged: (newValue) {
                              setState(() {
                                jobType = newValue;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Feature jobs: ",
                        style: TextStyle(
                            fontSize: 20,
                            color:
                                Theme.of(context).textTheme.bodyText1!.color),
                      ),
                      Theme(
                        data: Theme.of(context).copyWith(
                          unselectedWidgetColor:
                              Theme.of(context).textTheme.bodyText1!.color,
                        ),
                        child: Checkbox(
                          value: feature_jobs,
                          onChanged: (value) {
                            setState(() {
                              feature_jobs = value!;
                            });
                          },
                          activeColor:
                              Theme.of(context).textTheme.bodyText1!.color,
                          checkColor:
                              Theme.of(context).textTheme.bodyText2!.color,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                ],
              ),
            ),
            isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      color: colorButton,
                    ),
                  )
                : CustomButton(
                    text: widget.isUpdate ? "Update job" : "Add job",
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        formKey.currentState!.save();
                        setState(() {
                          isLoading = true;
                        });
                        if (widget.isUpdate) {
                          updateJob(
                              id: widget.data["id"],
                              address: city,
                              description: description.text,
                              expertise: expertise.text,
                              feature_jobs: feature_jobs,
                              job_type: jobType,
                              logo: image != null ? image : null,
                              salary: salary.text,
                              salary_refund: salary_refund,
                              state: state,
                              time: time,
                              title: title.text,
                              context: context);
                        } else {
                          addJob(
                              address: city,
                              description: description.text,
                              expertise: expertise.text,
                              feature_jobs: feature_jobs,
                              job_type: jobType,
                              logo: image!,
                              salary: salary.text,
                              salary_refund: salary_refund,
                              state: state,
                              time: time,
                              title: title.text,
                              context: context);
                        }
                      } else {
                        setState(() {
                          isLoading = true;
                        });
                      }
                    })
          ],
        ),
      ),
    );
  }

  Future<XFile?> chooseImage() async {
    XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      return image;
    }
    return null;
  }
}
