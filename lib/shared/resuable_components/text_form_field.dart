

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget buildTextFormField({
  @required String textLable,
  @required IconData suffixIcon,
  @required TextEditingController textEditingController
}
    )=>TextFormField(
  controller: textEditingController,
  decoration: InputDecoration(
    label:Text(textLable) ,
    suffixIcon: Icon(suffixIcon),
    border: OutlineInputBorder()
  ),
);