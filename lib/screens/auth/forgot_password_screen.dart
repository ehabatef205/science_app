import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_otp/email_otp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:science/screens/auth/verify_opt_screen.dart';
import 'package:science/server/auth/auth.dart';
import 'package:science/shared/color.dart';
import 'package:science/widgets/custom_button.dart';
import 'package:science/widgets/custom_text_form_field.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  TextEditingController emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;
  EmailOTP myauth = EmailOTP();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back_ios_new_outlined,
            color: Theme.of(context).iconTheme.color,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: ListView(
          children: [
            Center(
              child: Text(
                "Science Jobs",
                style: TextStyle(
                  color: colorButton,
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(
              height: size.height * 0.05,
            ),
            Center(
              child: Text(
                "Forgot Password",
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyText1!.color,
                  fontSize: 25,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(
              height: size.height * 0.05,
            ),
            const Padding(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Center(
                child: Text(
                  "Enter your email, we will send you email to change your password.",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            SizedBox(
              height: size.height * 0.1,
            ),
            Form(
              key: formKey,
              child: CustomTextFormField(
                controller: emailController,
                iconData: Icons.email_outlined,
                hintText: "user@gmail.com",
                labelText: "Email",
                keyboardType: TextInputType.emailAddress,
                validator: (String? value) {
                  if (value!.isEmpty) {
                    return "Email is required";
                  }
                  return null;
                },
              ),
            ),
            SizedBox(
              height: size.height * 0.3,
            ),
            Center(
              child: isLoading
                  ? CircularProgressIndicator(
                      color: colorButton,
                    )
                  : CustomButton(
                      text: "Send email",
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          formKey.currentState!.save();
                          checkEmail(emailController.text, myauth, context);
                        }
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
