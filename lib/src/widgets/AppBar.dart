import 'package:flutter/material.dart';
import 'package:rep_gpd_work/model/Usuario.dart';
import 'package:rep_gpd_work/src/utils/Colors.dart';

class CustomBar extends StatefulWidget implements PreferredSizeWidget {
  final AppBar appBar;

  final Function function;
  
  const CustomBar({this.appBar,this.function});

  @override
  _BarraState createState() => _BarraState();

  @override
  Size get preferredSize => new Size.fromHeight(appBar.preferredSize.height);
}

// BARRA DE ESTADOS POR AHORA FALTA AGREGAR LAS NAVEGACIONES A PANTALLAS ANTERIORES.
class _BarraState extends State<CustomBar> {
  @override
  AppBar build(BuildContext context) {
    return AppBar(
      backgroundColor: Utils.colorgreen,
      elevation: 0.0,
      centerTitle: true,
      titleSpacing: 5,
      leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: () {
            print("press leadign icon in AppBar");
            widget.function();

          }),    );
  }
}
