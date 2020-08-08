import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rep_gpd_work/model/Usuario.dart';
import 'package:rep_gpd_work/src/pages/Filtros.dart';
import 'package:rep_gpd_work/src/pages/Home.dart';
import 'package:rep_gpd_work/src/pages/Perfil.dart';
import 'package:rep_gpd_work/src/pages/ReportarUsuario.dart';
import 'package:rep_gpd_work/src/utils/Colors.dart';

//PANEL LATERAL DE PANTALLA
class CustomDrawer extends StatelessWidget {
  CustomDrawer({this.userFirebase});
  Usuario userFirebase;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 80),
      child: ClipRRect(
        // give it your desired border radius
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(250),
        ),

        child: SizedBox(
          width: 250,
          child: Drawer(
              // your widgets goes here
              child: Container(
            child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                
                ListTile(
                  leading: Icon(Icons.home, color: Utils.colorgreen),
                  title: Text('Home', style: Utils.styleGreenTitleNormal),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Home(
                                  userFirebase: userFirebase,
                                )));
                  },
                ),
               ListTile(
                  title: Text('Filtros', style: Utils.styleGreenTitleNormal),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Filtros(
                                  userFirebase: userFirebase,
                                )));
                  },
                ),

                if (userFirebase == null) ...[
                  ListTile(
                    title: GestureDetector(
                      onTap: () =>
                          Navigator.pushReplacementNamed(context, "Acceso"),
                      child: Text('Accede o Registrate',
                          style: Utils.styleGreenTitleNormal),
                    ),
                  ),
                ],
                if (userFirebase != null) ...[
                  ListTile(
                    title: Text('Editar Perfil',
                        style: Utils.styleGreenTitleNormal),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PerfilPage(
                                    userFirebase: userFirebase,
                                  )));
                    },
                  ),
                ],
                ListTile(
                  title: Text('Reportar Usuario',
                      style: Utils.styleGreenTitleNormal),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Reportar(
                                  userFirebase: userFirebase,
                                )));
                  },
                ),
                Center(
                  child: ListTile(
                    title:
                        Text('Contáctanos', style: Utils.styleGreenTitleNormal),
                    onTap: () {},
                  ),
                ),
                ListTile(
                  title: Text('Sobre GPD', style: Utils.styleGreenTitleNormal),
                  onTap: () {},
                ),
                if (userFirebase != null) ...[
                  ListTile(
                    title: Text("Salir", style: Utils.styleGreenTitleNormal),
                    onTap: () {
                      //LOGOUT DE LA CUENTA

                      FirebaseAuth.instance.signOut().then((value) => {
                            Navigator.pushReplacementNamed(context, "Home"),
                          });
                    },
                  ),
                ],
              ],
            ),
          )),
        ),
      ),
    );
  }
}
