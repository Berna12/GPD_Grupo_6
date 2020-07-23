import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rep_gpd_work/src/utils/Colors.dart';
//PANEL LATERAL DE PANTALLA
class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 80),
      child: ClipRRect(
        // give it your desired border radius
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(250),
        ),
        // wrap with a sizedbox for a custom width [for more flexibility]
        child: SizedBox(
          width: 250,
          child: Drawer(
              // your widgets goes here
              child: Container(
            child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                SizedBox(
                  height: 100.0,
                ),
                ListTile(
                  //   leading: Icon(Icons.home, color: Colors.blue),
                  title: Row(children: <Widget>[
                    GestureDetector(
                           onTap: ()=>Navigator.pushReplacementNamed(context, "Acceso"),
                                          child: Text('Accede o Registrate',
                        style:  Utils.styleGreenTitleNormal),
                    ),
                     
                  ],),
                 
                ),
                ListTile(
                  //leading: Icon(Icons.contact_phone, color: Colors.blue),
                  title: Text('Reportar Usuario',
                      style: Utils.styleGreenTitleNormal),
                  onTap: () {},
                ),
                Center(
                  child: ListTile(
                    title: Text('Contáctanos',
                      style: Utils.styleGreenTitleNormal),
                    onTap: () {},
                  ),
                ),
                ListTile(
                  title: Text('Sobre GPD',
                      style: Utils.styleGreenTitleNormal),
                  onTap: () {},
                ),
              ],
            ),
          )),
        ),
      ),
    );
  }
}
