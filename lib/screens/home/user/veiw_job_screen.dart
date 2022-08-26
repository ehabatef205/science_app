import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:science/screens/home/user/details_screen.dart';
import 'package:science/server/user/user.dart';
import 'package:science/shared/color.dart';

class ViewJobScreen extends StatefulWidget {
  final String job_type;

  const ViewJobScreen({required this.job_type, Key? key}) : super(key: key);

  @override
  State<ViewJobScreen> createState() => _ViewJobScreenState();
}

class _ViewJobScreenState extends State<ViewJobScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "View Jobs",
          style: TextStyle(fontSize: 20),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: StreamBuilder<QuerySnapshot>(
            stream: getJobOfType(widget.job_type),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var data = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (BuildContext context, int index) => SizedBox(
                      child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  DetailsScreen(data: data[index])));
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      color: Colors.purple,
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      image: DecorationImage(
                                          image:
                                              NetworkImage(data[index]["logo"]),
                                          fit: BoxFit.cover)),
                                  height: size.width * 0.15,
                                  width: size.width * 0.15,
                                ),
                                SizedBox(
                                  width: size.width * 0.55,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10, top: 10),
                                    child: Text(
                                      data[index]["title"],
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 17),
                                    ),
                                  ),
                                ),
                                Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: SizedBox(
                                      height: 50,
                                      width: 50,
                                      child: StreamBuilder<DocumentSnapshot>(
                                          stream: getData(),
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData) {
                                              var data5 = snapshot.data!;
                                              List<dynamic> saved =
                                                  data5["saved"];
                                              return IconButton(
                                                onPressed: () {
                                                  if (saved.contains(
                                                      data[index].id)) {
                                                    saved
                                                        .remove(data[index].id);
                                                    removeSave(
                                                      id: data[index].id,
                                                      saved: saved,
                                                    );
                                                    setState(() {});
                                                  } else {
                                                    saved.add(data[index].id);
                                                    addSave(saved: saved);
                                                    setState(() {});
                                                  }
                                                },
                                                icon: Icon(
                                                  saved.contains(data[index].id)
                                                      ? Icons.bookmark
                                                      : Icons.bookmark_add,
                                                  color: saved.contains(
                                                          data[index].id)
                                                      ? Colors.blue
                                                      : Colors.grey,
                                                ),
                                              );
                                            } else {
                                              return SizedBox(
                                                child: Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                    color: colorButton,
                                                  ),
                                                ),
                                              );
                                            }
                                          }),
                                    ))
                              ],
                            ),
                            SizedBox(
                              height: size.height * 0.02,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: Text(
                                      data[index]["job_type"],
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: Text(
                                      data[index]["time"],
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: Text(
                                      data[index]["expertise"],
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
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
                                  "\$${data[index]["salary"]}/${data[index]["salary_refund"]}",
                                  style: const TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  data[index]["address"],
                                  style: const TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  )),
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
    );
  }
}
