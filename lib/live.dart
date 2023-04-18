import 'dart:io';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;


class LivePicture extends StatefulWidget {
  const LivePicture({
    super.key,
    required this.camera,
  });

  final CameraDescription camera;

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}
class TakePictureScreenState extends State<LivePicture> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  var imagePicker;
  var picture;

  String results = '';

  Future<void> getImage() async {
    //final picture = await imagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      if (picture != null) {
        picture = File(picture.path);
      } else {
        print('No image selected.');
      }
    });
    var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            'https://bc15-2600-4041-50e2-ac00-9022-399d-7b52-4c73.ngrok-free.app/predict'));
    request.files.add(
        await http.MultipartFile.fromPath('file', picture.path.toString()));

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      results = await response.stream.bytesToString();
      print(results);
    } else {
      print(response.reasonPhrase);
    }

    showResults();
  }

  Future<void> showResults() async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Breed Percentage"),
            content: SingleChildScrollView(
                child: ListBody(children: <Widget>[
                  Text(results),
                ])),
            actions: <Widget>[
              TextButton(
                child: const Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                  Future.delayed(Duration(seconds: 3)).then((_) {
                    getImage();
                  });
                },
              ),
            ],
          );
        });
  }

  @override
  void initState() {
    super.initState();
    // To display the current output from the Camera,
    // create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.camera,
      // Define the resolution to use.
      ResolutionPreset.medium,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();

    // Take picture automatically after 2 seconds
    Future.delayed(Duration(seconds: 3)).then((_) {
      _controller.takePicture().then((XFile file) async {
        picture = File(file.path);
        if (!mounted) return;
        await getImage();
      }).catchError((e) {
        print(e);
      });
    });
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Automatic Detection')),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CameraPreview(_controller);
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}




