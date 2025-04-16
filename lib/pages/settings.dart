import 'package:flutter/material.dart';
class settings extends StatefulWidget {
  const settings({Key? key}) : super(key: key);

  @override
  State<settings> createState() => _settingsState();
}

class _settingsState extends State<settings> {
  TextEditingController t = TextEditingController();
  bool? valuecheck = false;
  bool valueswitch = false;
  double valueslider = 0.0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: SingleChildScrollView(
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
      )
    );
  }
}

