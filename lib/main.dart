import 'package:flutter/material.dart';
import 'package:flutter_app_test1/cam.dart';
import 'package:image_picker/image_picker.dart';
import 'package:camera/camera.dart';
import 'home.dart';
import 'live.dart';
import 'cam.dart';
import 'imagepicker.dart';
import 'imagefromgallery.dart';

List<CameraDescription>? cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Pet Identification',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            selectedItemColor: Colors.blue,
            unselectedItemColor: Colors.grey,
          ),
        ),
        debugShowCheckedModeBanner: false,
        home: const RootPage());
  }
}

class RootPage extends StatefulWidget {
  const RootPage({Key? key}) : super(key: key);

  @override
  State<RootPage> createState() => RootPageState();
}

class RootPageState extends State<RootPage> {
  int currentPage = 0;

  List<Widget> pages = [
    const HomePage(),
    ImageFromGalleryEx(ImageSource.gallery),
    //const Live(),
    LivePicture(camera: cameras![0]),
    TakePictureScreen(camera: cameras![0])
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pet Identification'),
      ),
      body: pages[currentPage],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentPage,
        onTap: (index) {
          setState(() {
            currentPage = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.image),
            label: 'Upload',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fiber_manual_record_outlined),
            label: 'Live',
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.camera),
              label: 'Camera')
        ],
      ),
    );
  }
}

