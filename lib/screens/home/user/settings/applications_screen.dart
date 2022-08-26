import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:science/screens/home/user/details_screen.dart';
import 'package:science/server/user/user.dart';
import 'package:science/shared/color.dart';

class ApplicationsScreen extends StatefulWidget {
  final data;

  const ApplicationsScreen({required this.data, Key? key}) : super(key: key);

  @override
  State<ApplicationsScreen> createState() => _ApplicationsScreenState();
}

class _ApplicationsScreenState extends State<ApplicationsScreen> {
  String state = "All";

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Applications",
          style: TextStyle(fontSize: 20),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
        child: ListView(
          children: [
            StreamBuilder<DocumentSnapshot>(
                stream: getAllApplications(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    var data = snapshot.data!;
                    return Text(
                      "You have\n${data["applications"].length} Applications\n👍",
                      style: TextStyle(
                          color: Theme.of(context).textTheme.bodyText1!.color,
                          fontSize: 24,
                          fontWeight: FontWeight.w500),
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
            SizedBox(
              height: size.height * 0.03,
            ),
            SizedBox(
              height: size.height * 0.07,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: SizedBox(
                        width: size.width * 0.3,
                        child: ElevatedButton(
                          style: OutlinedButton.styleFrom(
                            backgroundColor: state == "All"
                                ? colorButton
                                : Theme.of(context).scaffoldBackgroundColor,
                            shape: StadiumBorder(
                                side: BorderSide(
                              color: colorButton,
                            )),
                          ),
                          child: Text(
                            'All',
                            style: TextStyle(
                                fontSize: 20,
                                color: state == "All"
                                    ? Colors.white
                                    : colorButton),
                          ),
                          onPressed: () {
                            setState(() {
                              state = "All";
                            });
                          },
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: SizedBox(
                      width: size.width * 0.4,
                      child: ElevatedButton(
                        style: OutlinedButton.styleFrom(
                          backgroundColor: state == "Accepted"
                              ? colorButton
                              : Theme.of(context).scaffoldBackgroundColor,
                          shape: StadiumBorder(
                              side: BorderSide(
                            color: colorButton,
                          )),
                        ),
                        child: Text(
                          'Accepted',
                          style: TextStyle(
                              fontSize: 20,
                              color: state == "Accepted"
                                  ? Colors.white
                                  : colorButton),
                        ),
                        onPressed: () {
                          setState(() {
                            state = "Accepted";
                          });
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: SizedBox(
                        width: size.width * 0.4,
                        child: ElevatedButton(
                          style: OutlinedButton.styleFrom(
                            backgroundColor: state == "Reviewing"
                                ? colorButton
                                : Theme.of(context).scaffoldBackgroundColor,
                            shape: StadiumBorder(
                                side: BorderSide(
                              color: colorButton,
                            )),
                          ),
                          child: Text(
                            'Reviewing',
                            style: TextStyle(
                                fontSize: 20,
                                color: state == "Reviewing"
                                    ? Colors.white
                                    : colorButton),
                          ),
                          onPressed: () {
                            setState(() {
                              state = "Reviewing";
                            });
                          },
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: SizedBox(
                        width: size.width * 0.4,
                        child: ElevatedButton(
                          style: OutlinedButton.styleFrom(
                            backgroundColor: state == "Cancelled"
                                ? colorButton
                                : Theme.of(context).scaffoldBackgroundColor,
                            shape: StadiumBorder(
                                side: BorderSide(
                              color: colorButton,
                            )),
                          ),
                          child: Text(
                            'Cancelled',
                            style: TextStyle(
                                fontSize: 20,
                                color: state == "Cancelled"
                                    ? Colors.white
                                    : colorButton),
                          ),
                          onPressed: () {
                            setState(() {
                              state = "Cancelled";
                            });
                          },
                        )),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: size.height * 0.03,
            ),
            StreamBuilder<DocumentSnapshot>(
                stream: getAllApplications(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    var data2 = snapshot.data!;
                    return ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: data2["applications"].length,
                        itemBuilder: (context, index) {
                          return StreamBuilder<DocumentSnapshot>(
                              stream:
                                  getApplication(data2["applications"][index]),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  var data = snapshot.data!;
                                  return data2["state_applications"][index] !=
                                              state &&
                                          state != "All"
                                      ? const SizedBox()
                                      : Card(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          color: Theme.of(context)
                                              .scaffoldBackgroundColor,
                                          elevation: 6,
                                          child: Padding(
                                            padding: const EdgeInsets.all(10),
                                            child: InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            DetailsScreen(
                                                              data: data,
                                                            )));
                                              },
                                              child: Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Container(
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                            image: DecorationImage(
                                                                image: NetworkImage(
                                                                    data[
                                                                        "logo"]),
                                                                fit: BoxFit
                                                                    .cover)),
                                                        height:
                                                            size.height * 0.1,
                                                        width: size.width * 0.2,
                                                      ),
                                                      SizedBox(
                                                        height:
                                                            size.height * 0.1,
                                                        width: size.width * 0.4,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 10,
                                                                  top: 10),
                                                          child: Text(
                                                            data["title"],
                                                            style: TextStyle(
                                                              color: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .bodyText1!
                                                                  .color,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height:
                                                            size.height * 0.1,
                                                        width:
                                                            size.width * 0.25,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  top: 10),
                                                          child: Column(
                                                            children: [
                                                              Text(
                                                                "\$${data["salary"]}/${data["salary_refund"]}",
                                                                style:
                                                                    TextStyle(
                                                                  color: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .bodyText1!
                                                                      .color,
                                                                ),
                                                              ),
                                                              Text(
                                                                data["address"],
                                                                style:
                                                                    const TextStyle(
                                                                  color: Colors
                                                                      .grey,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        vertical: 10),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Container(
                                                          decoration:
                                                              BoxDecoration(
                                                                  color: data2["state_applications"]
                                                                              [
                                                                              index] ==
                                                                          "Cancelled"
                                                                      ? Colors
                                                                          .red
                                                                          .shade400
                                                                          .withOpacity(
                                                                              0.2)
                                                                      : data2["state_applications"][index] ==
                                                                              "Accepted"
                                                                          ? Colors
                                                                              .green
                                                                              .shade400
                                                                              .withOpacity(
                                                                                  0.2)
                                                                          : Colors
                                                                              .orange
                                                                              .shade400
                                                                              .withOpacity(
                                                                                  0.2),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              50)),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        20,
                                                                    vertical:
                                                                        10),
                                                            child: Text(
                                                              data2["state_applications"]
                                                                  [index],
                                                              style: TextStyle(
                                                                fontSize: 20,
                                                                color: data2["state_applications"]
                                                                            [
                                                                            index] ==
                                                                        "Cancelled"
                                                                    ? Colors.red
                                                                    : data2["state_applications"][index] ==
                                                                            "Accepted"
                                                                        ? Colors
                                                                            .green
                                                                        : Colors
                                                                            .orange,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Text(
                                                          data["time"],
                                                          style: TextStyle(
                                                            color: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .bodyText1!
                                                                .color,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ));
                                } else {
                                  return SizedBox(
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        color: colorButton,
                                      ),
                                    ),
                                  );
                                }
                              });
                        });
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
      ),
    );
  }
}
