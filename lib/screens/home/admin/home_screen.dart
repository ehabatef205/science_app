import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:science/screens/auth/login_screen.dart';
import 'package:science/screens/home/admin/add_job_screen.dart';
import 'package:science/screens/home/admin/job_types_screen.dart';
import 'package:science/screens/home/admin/view_jobs_screen.dart';
import 'package:science/screens/home/admin/view_moderators_screen.dart';
import 'package:science/screens/home/admin/view_users_screen.dart';
import 'package:science/shared/theme.dart';

class HomeScreen extends StatefulWidget {
  final bool isAdmin;

  const HomeScreen({required this.isAdmin, Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isDark = true;
  String email = "";
  String password = "";
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseFirestore.instance.collection("admins").doc(FirebaseAuth.instance.currentUser!.uid).get().then((value) {
      email = value.data()!["email"];
      password = value.data()!["password"];
    });
  }
  
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeNotifier>(context);
    themeProvider.readData().then((value) {
      setState(() {
        isDark = value;
      });
    });
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();

        return await true;
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            "Admin Panel",
            style: TextStyle(fontSize: 20),
          ),
          leading: IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ),
                );
              },
              icon: Icon(
                Icons.exit_to_app,
                color: Theme.of(context).iconTheme.color,
              )),
          actions: [
            Consumer<ThemeNotifier>(
                builder: (context, theme, _) => Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            theme.readData().then((value) {
                              setState(() {
                                if (value) {
                                  theme.setLightMode();
                                } else {
                                  theme.setDarkMode();
                                }
                              });
                            });
                          },
                          icon: Icon(
                            isDark
                                ? Icons.light_mode_outlined
                                : Icons.dark_mode_outlined,
                          ),
                        ),
                      ],
                    )),
          ],
        ),
        body: ListView(
          children: [
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ViewUsersScreen(),
                  ),
                );
              },
              child: Text(
                "View users",
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyText1!.color,
                  fontSize: 20,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const JobTypesScreen(),
                  ),
                );
              },
              child: Text(
                "Job types",
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyText1!.color,
                  fontSize: 20,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ViewJobsScreen(),
                  ),
                );
              },
              child: Text(
                "Jobs",
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyText1!.color,
                  fontSize: 20,
                ),
              ),
            ),
            widget.isAdmin? TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ViewModeratorsScreen(email: email, password: password),
                  ),
                );
              },
              child: Text(
                "Moderators",
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyText1!.color,
                  fontSize: 20,
                ),
              ),
            ) : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
