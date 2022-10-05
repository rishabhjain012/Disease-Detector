import 'dart:io';
import 'dart:async';
import 'package:cp301_app/uploadscreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'Gresult.dart';
import 'Wresult.dart';

class uploadplant extends StatefulWidget {
  const uploadplant({Key? key}) : super(key: key);

  @override
  State<uploadplant> createState() => _uploadplantState();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: EasyLoading.init(),
    );
  }
}

enum ImageSourceType { gallery, camera }

class _uploadplantState extends State<uploadplant> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(),
        backgroundColor: Colors.white,
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/upload.png',
              height: 200,
            ),
            MyCardWidget(),
            //  Mycontinue(),
          ],
        ),
      ),
    );
  }
}

/// This is the stateless widget that the main application instantiates.
class MyCardWidget extends StatelessWidget {
  MyCardWidget({Key? key}) : super(key: key);

  void _handleURLButtonPress(BuildContext context, var type) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => ImageFromGalleryEx(type)));
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Container(
          width: 324,
          height: 363,
          padding: new EdgeInsets.all(10.0),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24.0),
            ),
            color: Color.fromRGBO(228, 233, 241, 1),
            elevation: 10,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    elevation: 10,
                    child: new InkWell(
                      onTap: () {
                        _handleURLButtonPress(context, ImageSourceType.camera);
                      },
                      child: Container(
                          width: 100.0,
                          height: 95.65,
                          child: Icon(Icons.camera)),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Text(
                      "Camera",
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    elevation: 10,
                    child: new InkWell(
                      onTap: () {
                        _handleURLButtonPress(context, ImageSourceType.gallery);
                      },
                      child: Container(
                          width: 100.0,
                          height: 95.65,
                          child: Icon(Icons.upload)),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Text(
                      "Upload",
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
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

String processed = "null";
String description = "null";

class ImageFromGalleryExState extends State<ImageFromGalleryEx> {
  var imagePicker;
  var type;
  String pathy = "";
  String url = "";
  ImageFromGalleryExState(this.type);
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    imagePicker = new ImagePicker();
    EasyLoading.addStatusCallback((status) {
      print('EasyLoading Status $status');
      if (status == EasyLoadingStatus.dismiss) {
        _timer?.cancel();
      }
    });
    // EasyLoading.showSuccess('Use in initState');
  }

  uploadImagey() async {
    EasyLoading.show(status: 'uploading...');
    final request = http.MultipartRequest(
        "POST", Uri.parse('http://172.26.109.11:5000/uploadplant'));
    final headers = {"Content-type": "multipart/form-data"};

    request.files.add(http.MultipartFile(
        'image', _image!.readAsBytes().asStream(), _image!.lengthSync(),
        filename: _image!.path.split("/").last));

    request.headers.addAll(headers);
    final response = await request.send();
    http.Response res = await http.Response.fromStream(response);
    final resJson = await jsonDecode(res.body);

    processed = resJson["processed"];

    description = resJson["desc"];
    print(description);

    //String dname="";
    if (response.statusCode == 200) {
      EasyLoading.showSuccess('Great Success!');
      if (processed.contains('healthy')) {
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => gresult()),
        );
      } else {
        processed =
            processed.replaceAll(new RegExp('[\\W_]+'), ' ').toLowerCase();
        print(processed);
        await Navigator.of(context).push(
          MaterialPageRoute(
              builder: (context) => wresult(
                    dname: processed,
                    ddesc: description,
                  )),
        );
      }
      EasyLoading.dismiss();
    }

    print(processed);
    setState(() {
      processed = resJson["processed"];
    });
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
                /*   MaterialButton(
                  color: Colors.blue,
                  child: Text(
                    "Upload",
                    style: TextStyle(
                        color: Colors.white70, fontWeight: FontWeight.bold),
                  ),
                  onPressed: uploadImagey,
                ),
                MaterialButton(
                  color: Colors.orange,
                  child: Text(
                    "Crop",
                    style: TextStyle(
                        color: Colors.white70, fontWeight: FontWeight.bold),
                  ),
                  onPressed: uploadImagey,
                ),*/
                Padding(
                  padding: EdgeInsets.only(top: 20.0),
                  child: MaterialButton(
                    color: Colors.blue,
                    //   elevation: 20,
                    minWidth: 250.0,
                    height: 100.0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                    child: Text(
                      "Upload",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 24),
                    ),
                    onPressed: uploadImagey,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20.0),
                  child: MaterialButton(
                    color: Colors.orange,
                    //   elevation: 20,
                    minWidth: 250.0,
                    height: 100.0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                    child: Text(
                      "Crop",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 24),
                    ),
                    onPressed: uploadImagey,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
