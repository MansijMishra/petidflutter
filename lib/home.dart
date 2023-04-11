import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: const Center(
        child: Text('Welcome to the Pet Identification App!'),
      ),
    );
  }
}
/*
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'main.dart';

class Home extends StatefulWidget {
  const Home({ Key? key}) : super(key:key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

    CameraImage? cameraImage;
    CameraController? cameraController;
    String output = '';

    @override
    void initState() {
      super.initState();
      loadCamera();
    }

    loadCamera() {
      cameraController = CameraController(cameras![0], ResolutionPreset.medium);
      cameraController!.initialize().then((value) {
        if (!mounted) {
          return;
        }
        else {
          setState(() {
            cameraController!.startImageStream((imageStream) {
              cameraImage = imageStream;
              // call api
            });
          });
        }
      });
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(title: const Text('Pet Detector')),
        body: Column(
          children: [
            Padding(padding: 
            const EdgeInsets.all(20),
            child: Container(
              height: MediaQuery.of(context).size.height*0.7,
              width:  MediaQuery.of(context).size.height,
              child: !cameraController!.value.isInitialized?
            Container():
            AspectRatio(aspectRatio: cameraController!.value.aspectRatio,
            child: CameraPreview(cameraController!),)  ,

            ),),
            const Text('Testing',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20
            ),)
          ],
        ),
      );
    }
}
*/
