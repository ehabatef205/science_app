import 'package:flutter/material.dart';

class TermsAndConditionsScreen extends StatefulWidget {
  const TermsAndConditionsScreen({Key? key}) : super(key: key);

  @override
  State<TermsAndConditionsScreen> createState() => _TermsAndConditionsScreenState();
}

class _TermsAndConditionsScreenState extends State<TermsAndConditionsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Terms & Conditions",
          style: TextStyle(fontSize: 20),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: [
            Text(
              "Terms and Conditions when applying to jobs at Science Jobs.\n",
              style: TextStyle(
                fontSize: 18,
                color: Theme.of(context).textTheme.bodyText1!.color,
              ),
            ),
            Text(
              "I certify that the statements made in this application, on my resume and any other attachments, and any other information that I provide to Science Jobs is true and correct to the best of my knowledge and that I am not using / will not bring any presentations, templates, emails or other information from my prior jobs to Science Jobs that could be in violation of the Defend Trade Secrets Act of 2016. I further understand that any misinformation or falsification of information on this application or any other document including, but not limited to the authorization for background investigation or will be cause for denial or termination of employment.\n",
              style: TextStyle(
                fontSize: 18,
                color: Theme.of(context).textTheme.bodyText1!.color,
              ),
            ),
            Text(
              "I understand that all employment offers are contingent upon the results of employment and educational background checks. I agree to execute any consent forms necessary for Science Jobs to conduct its lawful pre-employment checks. By submitting this form, I authorize all present or prior employers, schools, companies, corporations, credit bureaus and law enforcement agencies to supply Science Jobs with any information concerning my background, and hereby release them from any liability and responsibility arising from their doing so. I understand that all employment offers are contingent upon the results of employment and educational background checks. Should my employment terminate, I understand thatScience Jobs may supply my complete record in response to any bona fide request, and I hereby release Science Jobs and any of its staff from any liability and responsibility in connection therewith.\n",
              style: TextStyle(
                fontSize: 18,
                color: Theme.of(context).textTheme.bodyText1!.color,
              ),
            ),
            Text(
              "If hired, I agree to abide by all of the Company rules and regulations. I agree that in the event Science Jobs should employ me, my employment may be terminated at any time by either party for any reason or for no reason.\n",
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

