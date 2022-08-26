import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:science/screens/home/admin/view_user_profile_screen.dart';
import 'package:science/server/admin/admin_server.dart';
import 'package:science/shared/color.dart';

class ViewUsersScreen extends StatefulWidget {
  const ViewUsersScreen({Key? key}) : super(key: key);

  @override
  State<ViewUsersScreen> createState() => _ViewUsersScreenState();
}

class _ViewUsersScreenState extends State<ViewUsersScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "View users",
          style: TextStyle(fontSize: 20),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: getAllUsers(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var data = snapshot.data!.docs;
              return Padding(
                padding: const EdgeInsets.all(10),
                child: ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ViewUserProfileScreen(
                                      data: data[index])));
                        },
                        title: Text(
                          data[index]["username"],
                          style: TextStyle(
                            color: Theme.of(context).textTheme.bodyText1!.color,
                          ),
                        ),
                        subtitle: Text(
                          "applications: ${data[index]["applications"].length}",
                          style: const TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                        leading: Container(
                          height: 100,
                          width: 50,
                          decoration: BoxDecoration(
                              color: Colors.grey.shade700,
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: NetworkImage(data[index]["image"]),
                              )),
                        ),
                        trailing: Theme(
                          data: Theme.of(context).copyWith(
                            unselectedWidgetColor:
                                Theme.of(context).textTheme.bodyText1!.color,
                          ),
                          child: Checkbox(
                            value: data[index]["block"],
                            onChanged: (value) {
                              blockUser(idDoc: data[index].id, value: value);
                            },
                            activeColor:
                                Theme.of(context).textTheme.bodyText1!.color,
                            checkColor:
                                Theme.of(context).textTheme.bodyText2!.color,
                          ),
                        ),
                      );
                    }),
              );
            } else {
              return CircularProgressIndicator(
                color: colorButton,
              );
            }
          }),
    );
  }
}
