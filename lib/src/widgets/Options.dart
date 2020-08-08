import 'package:flutter/material.dart';

class FoldableOptions extends StatefulWidget {
  Function fshare;
  Function fpost;

  FoldableOptions({
    this.fshare,
    this.fpost,
  });
  @override
  _FoldableOptionsState createState() => _FoldableOptionsState();
}

class _FoldableOptionsState extends State<FoldableOptions>
    with SingleTickerProviderStateMixin {
  final List<IconData> options = [
    /*  Icons.folder, */
    Icons.share,
    Icons.star,
  ];

  /*  Animation<Alignment> firstAnim; */
  Animation<Alignment> secondAnim;
  Animation<Alignment> thirdAnim;
  /*  Animation<Alignment> fourthAnim;
  Animation<Alignment> fifthAnim; */
  Animation<double> verticalPadding;
  AnimationController controller;
  final duration = Duration(milliseconds: 100);

  Widget getItem(IconData source) {
    final size = 40.0;
    return GestureDetector(
      onTap: () {
        if (source == Icons.share) {
          widget.fshare();
        } else {
          widget.fpost();
        }
        controller.reverse();
      },
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
            color: Color(0XFF212121),
            borderRadius: BorderRadius.all(Radius.circular(30))),
        child: Icon(
          source,
          color: Colors.white,
          size: 18,
        ),
      ),
    );
  }

  Widget buildPrimaryItem(IconData source) {
    final size = 40.0;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
          color: Color(0XFF212121),
          borderRadius: BorderRadius.all(Radius.circular(30)),
          boxShadow: [
            BoxShadow(
                color: Color(0XFF212121), blurRadius: verticalPadding.value)
          ]),
      child: Icon(
        source,
        color: Colors.white,
        size: 20,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this, duration: duration);

    final anim = CurvedAnimation(parent: controller, curve: Curves.linear);
    /*    firstAnim = Tween<Alignment>(begin: Alignment.centerRight, end: Alignment.topRight).animate( anim); */
    secondAnim =
        Tween<Alignment>(begin: Alignment.centerRight, end: Alignment.topLeft)
            .animate(anim);
    thirdAnim = Tween<Alignment>(
            begin: Alignment.centerRight, end: Alignment.centerLeft)
        .animate(anim);
    /*   fourthAnim = Tween<Alignment>(begin: Alignment.centerRight, end: Alignment.bottomLeft).animate( anim);
    fifthAnim = Tween<Alignment>(begin: Alignment.centerRight, end: Alignment.bottomRight).animate( anim); */
    verticalPadding = Tween<double>(begin: 0, end: 26).animate(anim);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 200,
      //color: Colors.white,
      margin: EdgeInsets.only(right: 2),
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, child) {
          return Stack(
            children: <Widget>[
              /*   Align(alignment: firstAnim.value, child: getItem(options.elementAt(0)),), */
              Align(
                  alignment: secondAnim.value,
                  child: Container(
                      padding:
                          EdgeInsets.only(left: 50, top: verticalPadding.value),
                      child: getItem(options.elementAt(0)))),
              Align(
                  alignment: thirdAnim.value,
                  child: GestureDetector(
                      onTap: () {
                        print("asjdnnasjd");
                      },
                      child: getItem(options.elementAt(1)))),
              /*    Align(alignment: fourthAnim.value,
                    child: Container(
                      padding: EdgeInsets.only(left: 50, bottom: verticalPadding.value),
                      child: getItem(options.elementAt(3)),
                    )
              ),
              Align(alignment: fifthAnim.value, child: getItem(options.elementAt(4))), */
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                    onTap: () {
                      controller.isCompleted
                          ? controller.reverse()
                          : controller.forward();
                    },
                    child: buildPrimaryItem(
                        controller.isCompleted || controller.isAnimating
                            ? Icons.close
                            : Icons.add)),
              )
            ],
          );
        },
      ),
    );
  }
}
