import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:science/screens/home/admin/add_job_type_screen.dart';
import 'package:science/server/admin/admin_server.dart';
import 'package:science/shared/color.dart';

class JobTypesScreen extends StatefulWidget {
  const JobTypesScreen({Key? key}) : super(key: key);

  @override
  State<JobTypesScreen> createState() => _JobTypesScreenState();
}

class _JobTypesScreenState extends State<JobTypesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Job Types",
          style: TextStyle(fontSize: 20),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const AddJobTypes(isUpdate: false, data: [],)));
            },
            icon: Icon(
              Icons.add,
              color: Theme.of(context).textTheme.bodyText1!.color,
            ),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: getAllJobTypes(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var data = snapshot.data!.docs;
            return Padding(
              padding: const EdgeInsets.all(10),
              child: ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      onTap: (){
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                AddJobTypes(isUpdate: true, data: data[index],)));
                      },
                      title: Text(
                        data[index]["name"],
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodyText1!.color,
                        ),
                      ),
                      trailing: Theme(
                        data: Theme.of(context).copyWith(
                          unselectedWidgetColor:
                              Theme.of(context).textTheme.bodyText1!.color,
                        ),
                        child: Checkbox(
                          value: data[index]["state"],
                          onChanged: (value) {
                            jobState(idDoc: data[index].id, value: value);
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
        },
      ),
    );
  }
}
