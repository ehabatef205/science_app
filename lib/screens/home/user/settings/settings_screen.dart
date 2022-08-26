import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:provider/provider.dart';
import 'package:science/screens/home/user/settings/about_screen.dart';
import 'package:science/screens/home/user/settings/change_password_screen.dart';
import 'package:science/screens/home/user/settings/privacy_screen.dart';
import 'package:science/screens/home/user/settings/terms_and_conditions_screen.dart';
import 'package:science/server/auth/auth.dart';
import 'package:science/shared/theme.dart';

class SettingScreen extends StatefulWidget {
  final String userId;

  const SettingScreen({required this.userId, Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool isDark = true;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final themeProvider = Provider.of<ThemeNotifier>(context);
    themeProvider.readData().then((value) {
      setState(() {
        isDark = value;
      });
    });

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Settings",
          style: TextStyle(fontSize: 20),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: [
            const Text(
              "Applications",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 20,
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ChangePasswordScreen(userId: widget.userId)));
              },
              title: Text(
                "Change Password",
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyText1!.color,
                ),
              ),
              leading: const Icon(
                Icons.password_outlined,
                color: Colors.grey,
              ),
            ),
            ListTile(
              title: Text(
                "Dark Mode",
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyText1!.color,
                ),
              ),
              trailing: Consumer<ThemeNotifier>(builder: (context, theme, _) {
                return CupertinoSwitch(
                  value: isDark,
                  onChanged: (value) {
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
                );
              }),
              leading: const Icon(
                Icons.dark_mode,
                color: Colors.grey,
              ),
            ),
            ListTile(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        backgroundColor:
                            Theme.of(context).scaffoldBackgroundColor,
                        title: Column(
                          children: [
                            const Icon(
                              Icons.delete_outline,
                              color: Colors.red,
                            ),
                            SizedBox(
                              height: size.height * 0.05,
                            ),
                            Text(
                              "Delete your account",
                              style: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .color,
                              ),
                            ),
                          ],
                        ),
                        actions: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Center(
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    "Cancel",
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyText1!
                                          .color,
                                    ),
                                  ),
                                ),
                              ),
                              Center(
                                child: TextButton(
                                  onPressed: () {
                                    deleteAccount(context);
                                  },
                                  child: const Text(
                                    "Delete Account",
                                    style: TextStyle(
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      );
                    });
              },
              title: const Text(
                "Delete Account",
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
              leading: const Icon(
                Icons.delete_outline,
                color: Colors.red,
              ),
            ),
            SizedBox(
              height: size.height * 0.02,
            ),
            const Text(
              "About",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 20,
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PrivacyScreen(),
                  ),
                );
              },
              title: Text(
                "Privacy",
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyText1!.color,
                ),
              ),
              leading: const Icon(
                Icons.privacy_tip_outlined,
                color: Colors.grey,
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TermsAndConditionsScreen(),
                  ),
                );
              },
              title: Text(
                "Terms and conditions",
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyText1!.color,
                ),
              ),
              leading: const Icon(
                Icons.private_connectivity_rounded,
                color: Colors.grey,
              ),
            ),
            ListTile(
              onTap: send,
              title: Text(
                "Help Center",
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyText1!.color,
                ),
              ),
              leading: const Icon(
                Icons.support_agent_outlined,
                color: Colors.grey,
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AboutScreen(),
                  ),
                );
              },
              title: Text(
                "About",
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyText1!.color,
                ),
              ),
              leading: const Icon(
                Icons.help_outline,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> send() async {
    final Email email = Email(
      recipients: ["sciencejobs2022@gmail.com"],
    );

    String platformResponse;

    try {
      await FlutterEmailSender.send(email);
      platformResponse = 'success';
    } catch (error) {
      print(error);
      platformResponse = error.toString();
    }

    if (!mounted) return;
  }
}
