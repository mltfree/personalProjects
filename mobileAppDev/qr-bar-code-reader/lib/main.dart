
import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';

import 'dart:math';

// References
// https://pub.dartlang.org/packages/firebase_ml_vision#-readme-tab-
// https://github.com/flutter/plugins/blob/master/packages/firebase_ml_vision/example/lib/detector_painters.dart
// https://pub.dartlang.org/packages/image_picker#-changelog-tab-

void main() => runApp(MaterialApp(home: MyHomePage()));

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File _imageFile;
  Size _imageSize;
  String _rawValue = "";
  dynamic _scanResults;
 // Detector _currentDetector = Detector.text;

  Future<void> _getAndScanImage() async {
    setState(() {
      _imageFile = null;
      _imageSize = null;
    });

    final File imageFile =
    //await ImagePicker.pickImage(source: ImageSource.camera); // Switch for Camera source
    await ImagePicker.pickImage(source: ImageSource.gallery);


    if (imageFile != null) {
      _getImageSize(imageFile);
      _scanImage(imageFile);
    }

    setState(() {
      _imageFile = imageFile;
    });
  }

  Future<void> _getImageSize(File imageFile) async {
    final Completer<Size> completer = Completer<Size>();

    final Image image = Image.file(imageFile);
    image.image.resolve(const ImageConfiguration()).addListener(
          (ImageInfo info, bool _) {
        completer.complete(Size(
          info.image.width.toDouble(),
          info.image.height.toDouble(),
        ));
      },
    );

    final Size imageSize = await completer.future;
    setState(() {
      _imageSize = imageSize;
    });
  }

  Future<void> _scanImage(File imageFile) async {
    setState(() {
      _scanResults = null;
    });

    final FirebaseVisionImage visionImage =
    FirebaseVisionImage.fromFile(imageFile);

    final BarcodeDetector barcodeDetector = FirebaseVision.instance.barcodeDetector();

    final List<Barcode> barcodes = await barcodeDetector.detectInImage(visionImage);

    for (Barcode barcode in barcodes) {
      final Rectangle<int> boundingBox = barcode.boundingBox;
      final List<Point<int>> cornerPoints = barcode.cornerPoints;

      final String rawValue = barcode.rawValue;
      print(rawValue);
      _rawValue = rawValue;

      final BarcodeValueType valueType = barcode.valueType;
//
//      // See API reference for complete list of supported types
//      switch (valueType) {
//        case BarcodeValueType.wifi:
//          final String ssid = barcode.wifi.ssid;
//          final String password = barcode.wifi.password;
//          final BarcodeWiFiEncryptionType type = barcode.wifi.encryptionType;
//          break;
//        case BarcodeValueType.url:
//          final String title = barcode.url.title;
//          final String url = barcode.url.url;
//          break;
//        case BarcodeValueType.calendarEvent:
//          final String title = barcode.calendarEvent.location;
//          break;
//        case BarcodeValueType.contactInfo:
//          final List<BarcodeAddress> addresses = barcode.contactInfo.addresses;
//          break;
//        case BarcodeValueType.driverLicense:
//          break;
//        case BarcodeValueType.email:
//          break;
//        case BarcodeValueType.geographicCoordinates:
//          break;
//        case BarcodeValueType.isbn:
//          break;
//        case BarcodeValueType.phone:
//          break;
//        case BarcodeValueType.product:
//          break;
//        case BarcodeValueType.sms:
//          break;
//        case BarcodeValueType.text:
//          break;
//        case BarcodeValueType.unknown:
//          break;
//
//      }
    }

    setState(() {
      _scanResults = barcodes;
    });

  }


  CustomPaint _buildResults(Size imageSize, dynamic results) {
    CustomPainter painter;

    painter = BarcodeDetectorPainter(_imageSize, results);

    return CustomPaint(
      painter: painter,
      child: Center(
        child : Text(
          _rawValue,
          style: TextStyle(
            color: Colors.red,
            fontSize: 20.0,
        ),
      ),
      ),
    );
  }

  Widget _buildImage() {
    return Container(
      constraints: const BoxConstraints.expand(),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: Image.file(_imageFile).image,
          fit: BoxFit.fill,
        ),
      ),
      child: _imageSize == null || _scanResults == null
          ? const Center(
        child: Text(
          'Scanning...',
          style: TextStyle(
            color: Colors.green,
            fontSize: 30.0,
          ),
        ),
      )
          : _buildResults(_imageSize, _scanResults),
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ML Vision - QR/Bar Code Reader'),
      ),
      body: _imageFile == null
          ? const Center(child: Text('No image selected.'))
          : _buildImage(),
      floatingActionButton: FloatingActionButton(
        onPressed: _getAndScanImage,
        tooltip: 'Pick Image',
        child: const Icon(Icons.add_a_photo),
      ),
    );
  }



}


class BarcodeDetectorPainter extends CustomPainter {
  BarcodeDetectorPainter(this.absoluteImageSize, this.barcodeLocations);

  final Size absoluteImageSize;
  final List<Barcode> barcodeLocations;

  @override
  void paint(Canvas canvas, Size size) {
    final double scaleX = size.width / absoluteImageSize.width;
    final double scaleY = size.height / absoluteImageSize.height;

    Rect scaleRect(Barcode barcode) {
      return Rect.fromLTRB(
        barcode.boundingBox.left * scaleX,
        barcode.boundingBox.top * scaleY,
        barcode.boundingBox.right * scaleX,
        barcode.boundingBox.bottom * scaleY,
      );
    }

    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    for (Barcode barcode in barcodeLocations) {
      paint.color = Colors.green;
      canvas.drawRect(scaleRect(barcode), paint);
    }
  }

  @override
  bool shouldRepaint(BarcodeDetectorPainter oldDelegate) {
    return oldDelegate.absoluteImageSize != absoluteImageSize ||
        oldDelegate.barcodeLocations != barcodeLocations;
  }
}