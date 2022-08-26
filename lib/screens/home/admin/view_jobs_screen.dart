import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:science/screens/home/admin/add_job_screen.dart';
import 'package:science/server/admin/admin_server.dart';
import 'package:science/shared/color.dart';

class ViewJobsScreen extends StatefulWidget {
  const ViewJobsScreen({Key? key}) : super(key: key);

  @override
  State<ViewJobsScreen> createState() => _ViewJobsScreenState();
}

class _ViewJobsScreenState extends State<ViewJobsScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "View jobs",
          style: TextStyle(fontSize: 20),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AddJobScreen(
                            isUpdate: false,
                            data: [],
                          )));
            },
            icon: Icon(
              Icons.add,
              color: Theme.of(context).textTheme.bodyText1!.color,
            ),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: getAllJobs(),
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
                                  builder: (context) => AddJobScreen(
                                      isUpdate: true, data: data[index])));
                        },
                        title: Text(
                          data[index]["title"],
                          style: TextStyle(
                            color: Theme.of(context).textTheme.bodyText1!.color,
                          ),
                        ),
                        subtitle: Text(
                          data[index]["job_type"],
                          maxLines: 1,
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
                                image: NetworkImage(data[index]["logo"]),
                              )),
                        ),
                        trailing: Theme(
                          data: Theme.of(context).copyWith(
                            unselectedWidgetColor:
                                Theme.of(context).textTheme.bodyText1!.color,
                          ),
                          child: Checkbox(
                            value:
                                data[index]["state"] == "Open" ? true : false,
                            onChanged: (value) {
                              if(value == true){
                                closedJob(idDoc: data[index].id, value: "Open");
                              }else{
                                closedJob(idDoc: data[index].id, value: "Closed");
                              }
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
