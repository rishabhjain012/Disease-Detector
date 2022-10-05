import 'package:flutter/material.dart';
import 'mainscreen.dart';

class gresult extends StatefulWidget {
  const gresult({Key? key}) : super(key: key);

  @override
  State<gresult> createState() => _gresultState();
}

class _gresultState extends State<gresult> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Color.fromRGBO(9, 141, 22, 1)),
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          children: [
            Image.asset(
              'assets/green.png',
              width: 450,
              //height: 500,
            ),
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
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => mainscreen(name: "user")),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
