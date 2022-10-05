import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/widgets.dart';
import 'mainscreen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

/*
class graphapp extends StatefulWidget {
  const graphapp({Key? key}) : super(key: key);

  @override
  State<graphapp> createState() => _graphappState();
}

class _graphappState extends State<graphapp> {
  @override
  Widget build(BuildContext context) {
    return (
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}
/*
class graphapp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}
*/
*/
enum ImageSourceType { gallery, camera }

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void _handleURLButtonPress(BuildContext context, var type) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => ImageFromGalleryEx(type)));
  }

  mainscreeny() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => mainscreen(name: 'user')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Image Intensity Plotter",
          style: TextStyle(fontSize: 17, color: Colors.white),
        ),
        elevation: 10,
        backgroundColor: Colors.blue,
        actions: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(Icons.search),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(Icons.notifications),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(Icons.more_vert),
          ),
        ],
      ),
      //   drawer: Drawer(),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 0.0),
              child: Container(
                width: 350,
                height: 180,
                child: Image.asset("assets/image.png"),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 30.0),
              child: MaterialButton(
                color: Colors.blue,
                elevation: 20,
                minWidth: 350.0,
                height: 100.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32.0)),
                child: Text(
                  "Pick Image from Gallery",
                  style: TextStyle(
                      color: Colors.white70,
                      fontWeight: FontWeight.bold,
                      fontSize: 25),
                ),
                onPressed: () {
                  _handleURLButtonPress(context, ImageSourceType.gallery);
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: MaterialButton(
                color: Colors.blue,
                minWidth: 350.0,
                elevation: 20,
                height: 100.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32.0)),
                child: Text(
                  "Pick Image from Camera",
                  style: TextStyle(
                      color: Colors.white70,
                      fontWeight: FontWeight.bold,
                      fontSize: 25),
                ),
                onPressed: () {
                  _handleURLButtonPress(context, ImageSourceType.camera);
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 150.0),
              child: MaterialButton(
                color: Colors.blue,
                minWidth: 350.0,
                elevation: 20,
                height: 100.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32.0)),
                child: Text(
                  "Back to Home",
                  style: TextStyle(
                      color: Colors.white70,
                      fontWeight: FontWeight.bold,
                      fontSize: 25),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
      /*  bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
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
          onTap: mainscreeny(),
          elevation: 5
          // onTap: _onItemTapped,
          ),*/
    );
  }
}

class ImageFromGalleryEx extends StatefulWidget {
  final type;

  ImageFromGalleryEx(this.type);

  @override
  ImageFromGalleryExState createState() => ImageFromGalleryExState(this.type);
}

var absimage;
var _image;

String processed = "";

class ImageFromGalleryExState extends State<ImageFromGalleryEx> {
  var imagePicker;
  var type;
  String pathy = "";
  String url = "";
  ImageFromGalleryExState(this.type);

  @override
  void initState() {
    super.initState();
    imagePicker = new ImagePicker();
  }

// http://172.26.109.11:8000/uploadgraph
  uploadImageyi() async {
    final request = http.MultipartRequest(
        "POST", Uri.parse('http://172.26.109.11:5000/uploadgraph'));
    final headers = {"Content-type": "multipart/form-data"};

    request.files.add(http.MultipartFile(
        'image', _image!.readAsBytes().asStream(), _image!.lengthSync(),
        filename: _image!.path.split("/").last));

    request.headers.addAll(headers);
    final response = await request.send();
    http.Response res = await http.Response.fromStream(response);
    //print(processed);
    final resJson = await jsonDecode(res.body);
    //processed = resJson["processed"];

    /* String pathe = path.join(
      'C:/Users/91799/Desktop/camera app/API/Uploadimages/filename.jpg');
    print(pathe);*/

    await Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => ImageFromUploadEx()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(type == ImageSourceType.camera
              ? "Image from Camera"
              : "Image from Gallery")),
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 52,
          ),
          Center(
            child: Column(
              children: [
                GestureDetector(
                  onTap: () async {
                    var source = type == ImageSourceType.camera
                        ? ImageSource.camera
                        : ImageSource.gallery;
                    XFile image = await imagePicker.pickImage(
                        source: source,
                        imageQuality: 50,
                        preferredCameraDevice: CameraDevice.front);

                    setState(() {
                      pathy = image.path;
                      _image = File(image.path);
                    });
                  },
                  child: Container(
                    width: 400,
                    height: 400,
                    decoration: BoxDecoration(color: Colors.red[200]),
                    child: _image != null
                        ? Image.file(
                            _image,
                            width: 400.0,
                            height: 400.0,
                            fit: BoxFit.fitHeight,
                          )
                        : Container(
                            decoration: BoxDecoration(color: Colors.red[200]),
                            width: 200,
                            height: 200,
                            child: Icon(
                              Icons.camera_alt,
                              color: Colors.grey[800],
                            ),
                          ),
                  ),
                ),
                MaterialButton(
                  color: Colors.blue,
                  child: Text(
                    "Upload",
                    style: TextStyle(
                        color: Colors.white70, fontWeight: FontWeight.bold),
                  ),
                  onPressed: uploadImageyi,
                  // Navigator.of(context).push(MaterialPageRoute(
                  //  builder: (context) => ImageFromUploadEx()));
                ),
                MaterialButton(
                  color: Colors.orange,
                  child: Text(
                    "Crop",
                    style: TextStyle(
                        color: Colors.white70, fontWeight: FontWeight.bold),
                  ),
                  onPressed: uploadImageyi,
                  // Navigator.of(context).push(MaterialPageRoute(
                  //  builder: (context) => ImageFromUploadEx()));
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class ImageFromUploadEx extends StatefulWidget {
  @override
  ImageFromUploadExState createState() => ImageFromUploadExState();
}

class ImageFromUploadExState extends State<ImageFromUploadEx> {
  //var imguploaded = File(processed);

  var rgb = Image.asset("./assets/rgb3.png");
  var gray = Image.asset("./assets/gray3.png");

  @override
  void initState() {
    super.initState();
    rgb = Image.asset("./assets/rgb3.png");
    gray = Image.asset("./assets/gray3.png");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("PLOT:")),
      body: Column(
        children: <Widget>[
          Center(
            child: Container(
              width: 350,
              height: 300,
              child: gray != null
                  ? gray
                  : Container(
                      width: 260,
                      height: 260,
                      child: Icon(
                        Icons.camera_alt,
                        color: Colors.grey[800],
                      ),
                    ),
            ),
          ),
          Center(
            child: Container(
              width: 350,
              height: 300,
              child: rgb != null
                  ? rgb
                  : Container(
                      width: 350,
                      height: 300,
                      child: Icon(
                        Icons.camera_alt,
                        color: Colors.grey[800],
                      ),
                    ),
            ),
          )
        ],
      ),
    );
  }
}

/*
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("PLOT:")),
      body: Column(
        children: <Widget>[
          Center(
            child: Container(
              width: 350,
              height: 300,
              child: gray != null
                  ? Image.file(
                      gray,
                      width: 400.0,
                      height: 400.0,
                      fit: BoxFit.fitHeight,
                    )
                  : Container(
                      decoration: BoxDecoration(color: Colors.red[200]),
                      width: 200,
                      height: 200,
                      child: Icon(
                        Icons.camera_alt,
                        color: Colors.grey[800],
                      ),
                    ),
            ),
          ),
          Center(
            child: Container(
              width: 350,
              height: 300,
              child: rgb != null
                  ? Image.file(
                      rgb,
                      width: 260,
                      height: 260,
                      fit: BoxFit.fitHeight,
                    )
                  : Container(
                      decoration: BoxDecoration(color: Colors.red[200]),
                      width: 350,
                      height: 350,
                      child: Icon(
                        Icons.camera_alt,
                        color: Colors.grey[800],
                      ),
                    ),
            ),
          )
        ],
      ),
    );
  }
}
*/