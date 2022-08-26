import 'package:flutter/material.dart';
import 'package:science/server/admin/admin_server.dart';
import 'package:science/widgets/custom_button.dart';
import 'package:science/widgets/custom_text_form_field.dart';

class AddModeratorScreen extends StatefulWidget {
  final String email;
  final String password;

  const AddModeratorScreen(
      {required this.email, required this.password, Key? key})
      : super(key: key);

  @override
  State<AddModeratorScreen> createState() => _AddModeratorScreenState();
}

class _AddModeratorScreenState extends State<AddModeratorScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Add Moderator",
          style: TextStyle(fontSize: 20),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Form(
          key: formKey,
          child: ListView(
            children: [
              CustomTextFormField(
                controller: nameController,
                iconData: Icons.person,
                hintText: "Full name",
                labelText: "Full name",
                keyboardType: TextInputType.text,
                validator: (String? value) {
                  if (value!.isEmpty) {
                    return "Full name is required";
                  }

                  return null;
                },
              ),
              SizedBox(
                height: size.height * 0.03,
              ),
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
                labelText: "Password",
                maxLines: 1,
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
                height: size.height * 0.03,
              ),
              CustomTextFormField(
                controller: confirmPasswordController,
                iconData: Icons.lock_outline_sharp,
                hintText: "**********",
                labelText: "Confirm Password",
                maxLines: 1,
                obscureText: true,
                keyboardType: TextInputType.visiblePassword,
                validator: (String? value) {
                  if (value!.isEmpty) {
                    return "Confirm Password is required";
                  } else if (passwordController.text !=
                      confirmPasswordController.text) {
                    return "Password don't match";
                  }

                  return null;
                },
              ),
              SizedBox(
                height: size.height * 0.05,
              ),
              CustomButton(
                text: "Add Moderator",
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    formKey.currentState!.save();
                    AddModerator(
                      name: nameController.text,
                      email: emailController.text,
                      password: passwordController.text,
                      context: context,
                      emailAdmin: widget.email,
                      passwordAdmin: widget.password,
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
