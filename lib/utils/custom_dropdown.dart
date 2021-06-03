import 'dart:ui';

import 'package:flutter/material.dart';

class CustomDropdown<T> extends StatelessWidget {
  final List<DropdownMenuItem<T>> dropdownMenuItemList;
  final ValueChanged<T> onChanged;
  final T value;
  final bool isEnabled;
  CustomDropdown({
    Key key,
    @required this.dropdownMenuItemList,
    @required this.onChanged,
    @required this.value,
    this.isEnabled = true,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !isEnabled,
      child: Container(
        padding: EdgeInsets.only(left: 20.0, right: 20.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(30.0)),
          border: Border.all(
            color: Theme.of(context).primaryColor,
            width: 1,
          ),
          // color: isEnabled ? Colors.white : Colors.grey.withAlpha(100)
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton(
            icon: Icon(Icons.view_list_rounded,color: Theme.of(context).primaryColor),
            isExpanded: true,
            itemHeight: 50.0,
            style: TextStyle(
                fontSize: 14,
                color: isEnabled ? Colors.black : Colors.grey[700]),
            items: dropdownMenuItemList,
            onChanged: onChanged,
            value: value,
          ),
        ),
      ),
    );
  }
}
