import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:science/server/user/user.dart';
import 'package:science/shared/color.dart';
import 'package:science/shared/methods.dart';
import 'package:science/widgets/custom_button.dart';

class DetailsScreen extends StatefulWidget {
  var data;

  DetailsScreen({required this.data, Key? key}) : super(key: key);

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  var data2;
  var data3;

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      setState(() {
        data3 = value.data();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            "Detail Job",
            style: TextStyle(fontSize: 20),
          ),
          actions: [
            SizedBox(
              height: 50,
              width: 50,
              child: StreamBuilder<DocumentSnapshot>(
                  stream: getData(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      var data5 = snapshot.data!;
                      List<dynamic> saved = data5["saved"];
                      return IconButton(
                        onPressed: () {
                          if (saved.contains(data2.id)) {
                            saved.remove(data2.id);
                            removeSave(
                              id: data2.id,
                              saved: saved,
                            );
                            setState(() {});
                          } else {
                            saved.add(data2.id);
                            addSave(saved: saved);
                            setState(() {});
                          }
                        },
                        icon: Icon(
                          saved.contains(data2.id)
                              ? Icons.bookmark
                              : Icons.bookmark_add,
                          color: saved.contains(data2.id)
                              ? Colors.blue
                              : Colors.grey,
                        ),
                      );
                    } else {
                      return SizedBox(
                        child: Center(
                          child: CircularProgressIndicator(
                            color: colorButton,
                          ),
                        ),
                      );
                    }
                  }),
            ),
          ],
        ),
        body: StreamBuilder<DocumentSnapshot>(
            stream: getDetails(widget.data.id),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                data2 = snapshot.data!;
                var data = snapshot.data!;
                return Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      ListView(
                        children: [
                          Center(
                            child: Container(
                              height: size.width * 0.3,
                              width: size.width * 0.3,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image: NetworkImage(data["logo"]),
                                      fit: BoxFit.cover)),
                            ),
                          ),
                          SizedBox(
                            height: size.height * 0.03,
                          ),
                          Center(
                            child: Text(
                              data["title"],
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .color,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyText1!
                                        .color!
                                        .withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 7),
                                    child: Text(
                                      data["job_type"],
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                      maxLines: 1,
                                    ),
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyText1!
                                        .color!
                                        .withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 7),
                                    child: Text(
                                      data["time"],
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                      maxLines: 1,
                                    ),
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyText1!
                                        .color!
                                        .withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 7),
                                    child: Text(
                                      data["expertise"],
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                      maxLines: 1,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: size.height * 0.02,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 20,
                              right: 20,
                              bottom: 10,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "\$${data["salary"]}/${data["salary_refund"]}",
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyText1!
                                        .color,
                                  ),
                                  maxLines: 1,
                                ),
                                Text(
                                  data["address"],
                                  maxLines: 1,
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyText1!
                                        .color,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            "Description:",
                            style: TextStyle(color: colorButton, fontSize: 18),
                          ),
                          SizedBox(
                            height: size.height * 0.02,
                          ),
                          Text(
                            data["description"]
                                .toString()
                                .replaceAll(".", ".\n"),
                            style: TextStyle(
                              color:
                                  Theme.of(context).textTheme.bodyText1!.color,
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(
                            height: size.height * 0.1,
                          ),
                        ],
                      ),
                      StreamBuilder<DocumentSnapshot>(
                          stream: getData(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              var data5 = snapshot.data!;
                              List<dynamic> applications =
                                  data5["applications"];
                              List<dynamic> state_applications =
                                  data5["state_applications"];
                              return data["state"] != "Open"
                                  ? const SizedBox()
                                  : Container(
                                      height: size.height * 0.1,
                                      color: Theme.of(context)
                                          .scaffoldBackgroundColor,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            bottom: 10, top: 10),
                                        child: CustomButton(
                                            text:
                                                applications.contains(data2.id)
                                                    ? "Cancel Apply"
                                                     : "Apply Now",
                                            onPressed: () {
                                              if (data3["cv"] != "") {
                                                if (applications
                                                    .contains(data2.id)) {
                                                  int indexOf = applications
                                                      .indexOf(data2.id);
                                                  state_applications
                                                      .removeAt(indexOf);
                                                  applications.remove(data2.id);
                                                  removeApplication(
                                                      applications: applications,
                                                      state_applications:
                                                      state_applications);
                                                  setState(() {});
                                                } else {
                                                  applications.add(data2.id);
                                                  state_applications
                                                      .add("Reviewing");
                                                  addApplication(
                                                      applications: applications,
                                                      state_applications:
                                                      state_applications);
                                                  setState(() {});
                                                }
                                              }else{
                                                showFluttertoastError("Please Upload your CV");
                                              }
                                            }),
                                      ),
                                    );
                            } else {
                              return SizedBox(
                                child: Center(
                                  child: CircularProgressIndicator(
                                    color: colorButton,
                                  ),
                                ),
                              );
                            }
                          }),
                    ],
                  ),
                );
              } else {
                return SizedBox(
                  child: Center(
                    child: CircularProgressIndicator(
                      color: colorButton,
                    ),
                  ),
                );
              }
            }));
  }
}
