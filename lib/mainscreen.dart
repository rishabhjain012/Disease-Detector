import 'package:flutter/material.dart';
import 'uploadscreen.dart';
import 'graph.dart';
import 'uploadplant.dart';

class mainscreen extends StatefulWidget {
  const mainscreen({Key? key, required this.name}) : super(key: key);

  final String name;

  @override
  State<mainscreen> createState() => _mainscreenState();
}

class _mainscreenState extends State<mainscreen> {
  uploadimage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => uploadscreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 60.0, right: 250.0, bottom: 0.0),
                child: Container(
                    child: Text(
                  "Hello!! \n"
                  '${widget.name}',
                  style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                )),
              ),
              Image.asset(
                'assets/mainpage1.png',
                height: 300,
              ),
              Padding(
                padding: EdgeInsets.only(top: 0.0, right: 230.0, bottom: 5.0),
                child: Container(
                    child: Text(
                  "Services",
                  style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                )),
              ),
              Padding(
                padding: EdgeInsets.only(top: 0.0),
                child: MaterialButton(
                  color: Color.fromRGBO(250, 240, 219, 1),
                  //   elevation: 20,
                  minWidth: 350.0,
                  height: 100.0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28.0)),
                  child: Text(
                    "Human Diseases",
                    style: TextStyle(
                        color: Color.fromRGBO(37, 49, 65, 1),
                        fontWeight: FontWeight.bold,
                        fontSize: 24),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => uploadscreen()),
                    );
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20.0),
                child: MaterialButton(
                  color: Color.fromRGBO(255, 234, 234, 1),
                  minWidth: 350.0,
                  //    elevation: 20,
                  height: 100.0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32.0)),
                  child: Text(
                    "Plant Diseases",
                    style: TextStyle(
                        color: Color.fromRGBO(37, 49, 65, 1),
                        fontWeight: FontWeight.bold,
                        fontSize: 24),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => uploadplant()),
                    );
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20.0),
                child: MaterialButton(
                  color: Color.fromRGBO(174, 220, 255, 1),
                  minWidth: 350.0,
                  //    elevation: 20,
                  height: 100.0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32.0)),
                  child: Text(
                    "Intensity Plot",
                    style: TextStyle(
                        color: Color.fromRGBO(37, 49, 65, 1),
                        fontWeight: FontWeight.bold,
                        fontSize: 24),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage()),
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







  /*  bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (index) => currentIndex = index,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
              backgroundColor: Color.fromRGBO(174, 220, 255, 1),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart),
              label: 'Graph',
              backgroundColor: Color.fromRGBO(174, 220, 255, 1),
            ),
          ],
          type: BottomNavigationBarType.shifting,
          selectedItemColor: Colors.black,
          iconSize: 40,
          elevation: 5
          // onTap: _onItemTapped,
          ),
          */