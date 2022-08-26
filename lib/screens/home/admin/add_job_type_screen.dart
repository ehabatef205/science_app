import 'package:flutter/material.dart';
import 'package:science/server/admin/admin_server.dart';
import 'package:science/widgets/custom_button.dart';
import 'package:science/widgets/custom_text_form_field.dart';

class AddJobTypes extends StatefulWidget {
  final bool isUpdate;
  final data;

  const AddJobTypes({required this.isUpdate, required this.data, Key? key})
      : super(key: key);

  @override
  State<AddJobTypes> createState() => _AddJobTypesState();
}

class _AddJobTypesState extends State<AddJobTypes> {
  TextEditingController nameController = TextEditingController();
  bool state = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.isUpdate) {
      nameController.text = widget.data["name"];
      state = widget.data["state"];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.isUpdate ? "Update Job Types" : "Add Job Types",
          style: const TextStyle(fontSize: 20),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Center(
          child: Form(
            child: ListView(
              shrinkWrap: true,
              children: [
                CustomTextFormField(
                    controller: nameController,
                    keyboardType: TextInputType.text,
                    iconData: Icons.title,
                    hintText: "Name",
                    labelText: "Name",
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Name is required";
                      }

                      return null;
                    }),
                Row(
                  children: [
                    Text(
                      "Open: ",
                      style: TextStyle(
                          fontSize: 20,
                          color: Theme.of(context).textTheme.bodyText1!.color),
                    ),
                    Theme(
                      data: Theme.of(context).copyWith(
                        unselectedWidgetColor:
                            Theme.of(context).textTheme.bodyText1!.color,
                      ),
                      child: Checkbox(
                        value: state,
                        onChanged: (value) {
                          setState(() {
                            state = value!;
                          });
                        },
                        activeColor:
                            Theme.of(context).textTheme.bodyText1!.color,
                        checkColor:
                            Theme.of(context).textTheme.bodyText2!.color,
                      ),
                    ),
                  ],
                ),
                CustomButton(
                    text: widget.isUpdate ? "Update job type" : "Add job type",
                    onPressed: () {
                      if (widget.isUpdate) {
                        updateJobType(
                            id: widget.data.id,
                            name: nameController.text,
                            state: state,
                            context: context);
                      } else {
                        addJobType(
                            name: nameController.text,
                            state: state,
                            context: context);
                      }
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
