import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:refresher/widgets/crudmenu.dart';
import 'package:refresher/widgets/gallery.dart';

import '../auth/googleauth.dart';
class containerforlecs extends StatelessWidget {
  String docid = "";
  Function? ondelete;
String name="";
  containerforlecs(docid, ondelete) {
    this.docid = docid;
    this.name = ondelete;
  }


  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.red,

      onTap: () async {
        Map<String, String>? user = await AuthService().getgoogleUserDetails() as Map<String, String>?;

        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return GalleryPage(user?['email'], docid);
        },));
      },
      child: Container(

        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3), // Shadow position
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(LucideIcons.fileText, size: 40, color: Colors.blue),
            SizedBox(height: 10),
            Text(
              name,
              style: TextStyle(fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87),
              textAlign: TextAlign.center,
            ),
            Align(
              alignment: Alignment.topRight,
              child: InkWell(
                  child: Container(
                    child: Icon(Icons.edit),

                  ),
                  onTapDown: (details) async {
                    Map<String, String>? user = await AuthService().getgoogleUserDetails() as Map<String, String>?;

                    showPopupMenu(
                        context, details, user?['email'], docid);
                  }

              ),

            )
          ],
        ),
      ),
    );
  }


}
