import 'package:flutter/material.dart';
class profile extends StatefulWidget {
  const profile({Key? key}) : super(key: key);

  @override
  State<profile> createState() => _profileState();
}

class _profileState extends State<profile> {
  TextEditingController t = TextEditingController();
  bool? valuecheck = false;
  bool valueswitch = false;
  double valueslider = 0.0;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              decoration: InputDecoration(border: OutlineInputBorder()),
              controller: t,
              onEditingComplete: () {
                setState(() {

                });
              },
            ),
            Text(t.text),
            Checkbox(value: valuecheck, onChanged: (value) {
              valuecheck = value;
              setState(() {

              });
            },),
            SwitchListTile(value: valueswitch, onChanged: (value) {
              valueswitch = value;
              setState(() {

              });
            },
              title: Text("azbot"),
            ),
            Slider.adaptive(value: valueslider, onChanged:
                (value) {
              setState(() {

              });
              valueslider = value;
            },
              divisions: 10,
            ),

            Container(
              child: Text(valueslider.toString()),
              height: 200,

            ),
            Container(
              child: Text(valueslider.toString()),
              height: 200,

            ),
            Container(
              child: Text(valueslider.toString()),
              height: 200,

            ),
            Container(
              child: Text(valueslider.toString()),
              height: 200,

            ),
          ]

      ),
    );
  }
}