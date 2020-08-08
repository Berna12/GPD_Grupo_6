
import 'package:flutter/material.dart';
import 'package:rep_gpd_work/src/widgets/Loader.dart';

class Loading extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
   return Container();
  }


   Future<bool> loading(BuildContext context){
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: ColorLoader3(),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
    );
}


}