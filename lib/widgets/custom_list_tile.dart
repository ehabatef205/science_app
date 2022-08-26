import 'package:flutter/material.dart';

class CustomListTile extends StatelessWidget {
  final Function() onTap;
  final String text;
  final IconData iconData;
  const CustomListTile({
    required this.onTap,
    required this.text,
    required this.iconData,
    Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      title: Text(
        text,
        style: TextStyle(
          color: Theme.of(context).textTheme.bodyText1!.color,
          fontSize: 16,
        ),
      ),
      leading: Icon(
        iconData,
        color: Theme.of(context).iconTheme.color,
      ),
    );
  }
}
