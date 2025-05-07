// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:google_ml_kit/google_ml_kit.dart';

// void main() {
//   runApp(const MaterialApp(
//     home: MainApp(),
//     debugShowCheckedModeBanner: false,
//   ));
// }

// class MainApp extends StatefulWidget {
//   const MainApp({super.key});

//   @override
//   State<MainApp> createState() => _MainAppState();
// }

// class _MainAppState extends State<MainApp> {
//   final ImagePicker _picker = ImagePicker();
//   File? _imageFile;
//   String _scannedText = '';
//   bool _isProcessing = false;

//   Future<void> _captureAndScanImage() async {
//     try {
//       setState(() {
//         _isProcessing = true;
//         _scannedText = '';
//         _imageFile = null;
//       });

//       final pickedFile = await _picker.pickImage(source: ImageSource.camera);
//       if (pickedFile == null) {
//         setState(() => _isProcessing = false);
//         return;
//       }

//       final file = File(pickedFile.path);
//       final inputImage = InputImage.fromFile(file);
//       final textRecognizer = GoogleMlKit.vision.textRecognizer();
//       final result = await textRecognizer.processImage(inputImage);

//       final scanned = result.blocks
//           .expand((block) => block.lines)
//           .map((line) => line.text)
//           .join('\n');

//       setState(() {
//         _imageFile = file;
//         _scannedText = scanned.isNotEmpty ? scanned : 'No text found.';
//         _isProcessing = false;
//       });
//     } catch (e) {
//       setState(() {
//         _scannedText = 'Error: ${e.toString()}';
//         _isProcessing = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey.shade100,
//       appBar: AppBar(
//         title: const Text('Text Scanner'),
//         backgroundColor: Colors.teal,
//         centerTitle: true,
//         elevation: 3,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
//         child: Column(
//           children: [
//             if (_imageFile != null)
//               Card(
//                 elevation: 4,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(12),
//                   child: Image.file(
//                     _imageFile!,
//                     fit: BoxFit.cover,
//                     width: double.infinity,
//                     height: 220,
//                   ),
//                 ),
//               )
//             else
//               Container(
//                 width: double.infinity,
//                 height: 220,
//                 alignment: Alignment.center,
//                 decoration: BoxDecoration(
//                   color: Colors.grey.shade200,
//                   borderRadius: BorderRadius.circular(12),
//                   border: Border.all(color: Colors.grey.shade300),
//                 ),
//                 child: const Text(
//                   'Tap the scan button to take a picture.',
//                   textAlign: TextAlign.center,
//                   style: TextStyle(fontSize: 16, color: Colors.grey),
//                 ),
//               ),
//             const SizedBox(height: 20),
//             const Align(
//               alignment: Alignment.centerLeft,
//               child: Text(
//                 'Scanned Text',
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//             ),
//             const SizedBox(height: 8),
//             Expanded(
//               child: Container(
//                 padding: const EdgeInsets.all(12),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   border: Border.all(color: Colors.grey.shade300),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: _isProcessing
//                     ? const Center(child: CircularProgressIndicator())
//                     : _scannedText.isEmpty
//                         ? const Center(
//                             child: Text(
//                               'Scanned text will appear here.',
//                               style: TextStyle(color: Colors.grey),
//                             ),
//                           )
//                         : SingleChildScrollView(
//                             child: SelectableText(
//                               _scannedText,
//                               style: const TextStyle(fontSize: 16),
//                             ),
//                           ),
//               ),
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton.extended(
//         onPressed: _isProcessing ? null : _captureAndScanImage,
//         icon: const Icon(Icons.camera_alt),
//         label: const Text('Scan Text'),
//         backgroundColor: Colors.teal,
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
//     );
//   }
// }
