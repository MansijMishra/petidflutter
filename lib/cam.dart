import 'dart:io';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;


class TakePictureScreen extends StatefulWidget {
  const TakePictureScreen({
    super.key,
    required this.camera,
  });

  final CameraDescription camera;

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

/*
class TakePictureScreenState extends State<TakePictureScreen> {
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
      appBar: AppBar(title: const Text('Take a picture')),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            await _initializeControllerFuture;
            picture = await _controller.takePicture();
            if (!mounted) return;
            await getImage();
            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => DisplayPictureScreen(
                  imagePath: picture.path,
                ),
              ),
            );
          }
          catch (e) {
            print(e);
          }
        },
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}

// A widget that displays the picture taken by the user.
class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;
  const DisplayPictureScreen({super.key, required this.imagePath});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Display the Picture')),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: Image.file(File(imagePath)),

    );
  }
}
*/


class TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  var imagePicker;
  var picture;

  Future<String?> getImage() async {
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
      String results = await response.stream.bytesToString();
      print(results);
      return results;
    } else {
      print(response.reasonPhrase);
    }
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
      appBar: AppBar(title: const Text('Take a picture')),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            await _initializeControllerFuture;
            picture = await _controller.takePicture();
            if (!mounted) return;

            String? results = await getImage();
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => DisplayPictureScreen(
                  imagePath: picture.path,
                  results: results,
                ),
              ),
            );
          } catch (e) {
            print(e);
          }
        },
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}

// A widget that displays the picture taken by the user.
class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;
  final String? results;

  const DisplayPictureScreen({
    super.key,
    required this.imagePath,
    required this.results,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Display the Picture')),
    body: Column(
    children: [
    Expanded(
    child: Image.file(File(imagePath)),
    ),
    results == null
    ?Container()
    : Expanded(child: Padding(
    padding: const EdgeInsets.all(8),
    child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      const Text(
      "Breed Percentage",
      style: TextStyle(fontSize: 20),
    ),
    const SizedBox(height: 10),
    Text(results!, style: const TextStyle(fontSize: 16),
    ),
    const SizedBox(height: 20),
    ElevatedButton(onPressed: (){
      Navigator.pop(context);
    }
    , child: const Text('Back'),
    )
    ],
    ),
    ))],
    ));
  }
}