import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:science/screens/home/admin/add_moderator_screen.dart';
import 'package:science/server/admin/admin_server.dart';
import 'package:science/shared/color.dart';

class ViewModeratorsScreen extends StatefulWidget {
  final String email;
  final String password;

  const ViewModeratorsScreen(
      {required this.email, required this.password, Key? key})
      : super(key: key);

  @override
  State<ViewModeratorsScreen> createState() => _ViewModeratorsScreenState();
}

class _ViewModeratorsScreenState extends State<ViewModeratorsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Moderators",
          style: TextStyle(fontSize: 20),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddModeratorScreen(email: widget.email, password: widget.password)));
            },
            icon: Icon(
              Icons.add,
              color: Theme.of(context).textTheme.bodyText1!.color,
            ),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: getAllModerators(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var data = snapshot.data!.docs;
              return Padding(
                padding: const EdgeInsets.all(10),
                child: ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(
                          data[index]["username"],
                          style: TextStyle(
                            color: Theme.of(context).textTheme.bodyText1!.color,
                          ),
                        ),
                        subtitle: Text(
                          data[index]["email"],
                          style: const TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                        trailing: Theme(
                          data: Theme.of(context).copyWith(
                            unselectedWidgetColor:
                                Theme.of(context).textTheme.bodyText1!.color,
                          ),
                          child: Checkbox(
                            value: data[index]["block"],
                            onChanged: (value) {
                              blockModerator(
                                  idDoc: data[index].id, value: value);
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
