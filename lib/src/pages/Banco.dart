import 'package:flutter/material.dart';
import 'package:rep_gpd_work/src/widgets/AppBar.dart';
import 'package:rep_gpd_work/src/widgets/Drawer.dart';
class Banco extends StatefulWidget {


  @override
  _BancoState createState() => _BancoState();
}

class _BancoState extends State<Banco> {
    @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width; //GET ANCHO DE LA PANTALLA
    return Scaffold(
      endDrawer: CustomDrawer(),
      //drawer: CustomDrawer(),
      appBar: CustomBar(
        appBar: AppBar(),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}