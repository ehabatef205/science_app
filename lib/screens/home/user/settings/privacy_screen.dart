import 'package:flutter/material.dart';

class PrivacyScreen extends StatefulWidget {
  const PrivacyScreen({Key? key}) : super(key: key);

  @override
  State<PrivacyScreen> createState() => _PrivacyScreenState();
}

class _PrivacyScreenState extends State<PrivacyScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Privacy",
          style: TextStyle(fontSize: 20),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: [
            Text(
              "Inc. (“ZipRecruiter”, “we”, or “us”) is committed to protecting the privacy and security of your personal information.  This Job Applicant Privacy Notice (“Privacy Notice”) applies solely to candidates who reside in Egypt, and apply for an open position to work at Science Jobs. This Privacy Notice does not apply to job seekers that use other application to search and/or apply for open positions with third-party companies.\n",
              style: TextStyle(
                fontSize: 18,
                color: Theme.of(context).textTheme.bodyText1!.color,
              ),
            ),
            Text(
              "This Privacy Notice describes how we collect and use your personal information during the application, recruitment, interview, and/or any on-boarding process prior to employment, when you choose to apply for an open position at Science Jobs.  We will only use your personal information in accordance with this Privacy Notice.\n",
              style: TextStyle(
                fontSize: 18,
                color: Theme.of(context).textTheme.bodyText1!.color,
              ),
            ),
            Text(
              "DISCLAIMER: Providing you with this Privacy Notice is not an indication and does not guarantee that you will be interviewed for the position to which you applied or that you will be offered employment by Science Jobs.",
              style: TextStyle(
                fontSize: 18,
                color: Theme.of(context).textTheme.bodyText1!.color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

