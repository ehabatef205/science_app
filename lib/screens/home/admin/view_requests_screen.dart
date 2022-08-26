import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:science/server/admin/admin_server.dart';
import 'package:science/server/user/user.dart';
import 'package:science/shared/color.dart';

class ViewRequestsScreen extends StatefulWidget {
  final data;

  const ViewRequestsScreen({required this.data, Key? key}) : super(key: key);

  @override
  State<ViewRequestsScreen> createState() => _ViewRequestsScreenState();
}

class _ViewRequestsScreenState extends State<ViewRequestsScreen> {
  var states = [
    'Accepted',
    'Reviewing',
    'Cancelled',
  ];

  List state_applications = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    for (int i = 0; i < widget.data["applications"].length; i++) {
      state_applications.add(widget.data["state_applications"][i]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "View users",
          style: TextStyle(fontSize: 20),
        ),
      ),
      body: ListView.builder(
          itemCount: widget.data["applications"].length,
          itemBuilder: (context, index) {
            return StreamBuilder<DocumentSnapshot>(
                stream: getJobById(widget.data["applications"][index]),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    var data = snapshot.data!;
                    return ListTile(
                      title: Text(
                        data["title"],
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodyText1!.color,
                        ),
                      ),
                      leading: Container(
                        height: 100,
                        width: 50,
                        decoration: BoxDecoration(
                            color: Colors.grey.shade700,
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: NetworkImage(data["logo"]),
                            )),
                      ),
                      trailing: DropdownButton(
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
                        value: state_applications[index],
                        hint: const Text(
                          "Select time",
                          style: TextStyle(color: Colors.grey),
                        ),
                        onChanged: (newValue) {
                          setState(() {
                            state_applications[index] = newValue;
                          });
                          changeApplicationState(
                            idDoc: widget.data.id,
                            state_applications: state_applications,
                          );
                        },
                      ),
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(
                        color: colorButton,
                      ),
                    );
                  }
                });
          }),
    );
  }
}
