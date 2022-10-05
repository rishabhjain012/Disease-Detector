import 'package:flutter/material.dart';
import 'mainscreen.dart';

class wresult extends StatefulWidget {
  //const wresult({Key? key}) : super(key: key);
  final String dname;
  final String ddesc;
  const wresult({Key? key, required this.dname, required this.ddesc})
      : super(key: key);

  @override
  State<wresult> createState() => _wresultState();
}

class _wresultState extends State<wresult> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(165, 36, 36, 1),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Image.asset(
                'assets/wred.png',
                width: 550,
                //height: 500,
              ),
              Container(
                  width: 319,
                  height: 130,
                  padding: EdgeInsets.only(top: 49.0),
                  child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28.0),
                      ),
                      color: Color.fromRGBO(245, 211, 211, 1),
                      elevation: 10,
                      child: Center(
                        child: Text(
                          // "null",
                          '${widget.dname}',
                          style: TextStyle(
                            color: Colors.black,
                            letterSpacing: 1.5,
                            fontSize: 33,
                          ),
                        ),
                      ))),
              Container(
                  padding: EdgeInsets.only(top: 49.0),
                  child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(1.0),
                      ),
                      color: Color.fromRGBO(245, 211, 211, 1),
                      elevation: 10,
                      child: Center(
                        child: Text(
                          //"null",
                          '${widget.ddesc}',
                          style: TextStyle(
                            color: Colors.black,
                            letterSpacing: 1.5,
                            fontSize: 15,
                          ),
                        ),
                      ))),
              Padding(
                padding: EdgeInsets.only(top: 20.0),
                child: MaterialButton(
                  color: Color.fromRGBO(28, 107, 164, 1),
                  //   elevation: 20,
                  minWidth: 264.0,
                  height: 70.0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14.0)),
                  child: Text(
                    "Return to Home Page",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Color.fromRGBO(255, 255, 255, 1),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => mainscreen(name: "undefined")),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
