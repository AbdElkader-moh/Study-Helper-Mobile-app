import 'package:flutter/material.dart';
import 'package:refresher/data/data.dart';
class apbarwidg extends StatefulWidget implements PreferredSizeWidget
{
  const apbarwidg({Key? key}) : super(key: key);

  @override
  State<apbarwidg> createState() => _apbarwidgState();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => throw UnimplementedError();
}

class _apbarwidgState extends State<apbarwidg> {

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(valueListenable: selectedPagenotifier ,builder: (context, value, child)
    {

      return AppBar(
        title: Text("FlutterLogo"),
        backgroundColor:Colors.red ,
      );

    },);
  }

}


