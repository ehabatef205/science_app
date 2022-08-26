import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:science/shared/color.dart';
import 'package:science/screens/auth/forgot_password_screen.dart';
import 'package:science/screens/auth/register_screen.dart';
import 'package:science/server/auth/auth.dart';
import 'package:science/shared/methods.dart';
import 'package:science/widgets/custom_button.dart';
import 'package:science/widgets/custom_text_form_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool isDark = true;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();

        return await true;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: const SizedBox(),
        ),
        body: Padding(
          padding: const EdgeInsets.only(right: 10, left: 10),
          child: ListView(
            children: [
              Text(
                "Science Jobs",
                style: TextStyle(
                  color: colorButton,
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(
                height: size.height * 0.02,
              ),
              Text(
                "Welcome Back 👋",
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyText1!.color,
                  fontSize: 25,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(
                height: size.height * 0.02,
              ),
              const Text(
                "Let's log in. Apply to jobs!",
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
              SizedBox(
                height: size.height * 0.05,
              ),
              Form(
                key: formKey,
                child: Column(
                  children: [
                    CustomTextFormField(
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
                    SizedBox(
                      height: size.height * 0.03,
                    ),
                    CustomTextFormField(
                      controller: passwordController,
                      iconData: Icons.lock_outline_sharp,
                      hintText: "**********",
                      maxLines: 1,
                      labelText: "Password",
                      obscureText: true,
                      keyboardType: TextInputType.visiblePassword,
                      validator: (String? value) {
                        if (value!.isEmpty) {
                          return "Password is required";
                        }

                        return null;
                      },
                    ),
                    SizedBox(
                      height: size.height * 0.05,
                    ),
                    isLoading
                        ? CircularProgressIndicator(
                            color: colorButton,
                          )
                        : CustomButton(
                            text: "Log in",
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                formKey.currentState!.save();
                                setState(() {
                                  isLoading = true;
                                });
                                login(emailController.text,
                                        passwordController.text, context)
                                    .catchError((error) {
                                  if (error.code == "network-request-failed") {
                                    showFluttertoastError("Check Network");
                                  } else if (error.code == "user-not-found") {
                                    showFluttertoastError("User not exists");
                                  } else if (error.code == "wrong-password") {
                                    showFluttertoastError("Wrong Password");
                                  } else if (error.code == "user-disabled") {
                                    showFluttertoastError("User blocked");
                                  } else if (error.code == "invalid-email") {
                                    showFluttertoastError(
                                        "Email address is not valid");
                                  } else {
                                    showFluttertoastError(error.message);
                                  }
                                  setState(() {
                                    isLoading = false;
                                  });
                                });
                              } else {
                                setState(() {
                                  isLoading = false;
                                });
                              }
                            },
                          ),
                    SizedBox(
                      height: size.height * 0.04,
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ForgotPasswordScreen(),
                          ),
                        );
                      },
                      child: Text(
                        "Forgot Password?",
                        style: TextStyle(
                          color: colorButton,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.04,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Haven't an account?",
                          style: TextStyle(color: Colors.grey),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const RegisterScreen(),
                              ),
                            );
                          },
                          child: Text(
                            "Register",
                            style: TextStyle(
                              color: colorButton,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
