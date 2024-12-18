// import 'dart:io';
// import 'package:http/http.dart' as http;
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:video_player/video_player.dart';


// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: UploadMediaDemo(),
//     );
//   }
// }

// class UploadMediaDemo extends StatefulWidget {
//   @override
//   _UploadMediaDemoState createState() => _UploadMediaDemoState();
// }

// class _UploadMediaDemoState extends State
// {
//   List<File> _mediaFiles = []; // Updated to hold multiple media files
//   final picker = ImagePicker();
//   TextEditingController nameController = TextEditingController();

//   Future<void> _getMediaFromGallery() async {
//     final pickedFiles = await picker.pickMultiImage(); // Updated to pick multiple files

//     setState(() {
//       if (pickedFiles != null) {
//         _mediaFiles.clear(); // Clear existing files
//         for (final pickedFile in pickedFiles) {
//           _mediaFiles.add(File(pickedFile.path)); // Add new files
//         }
//       } else {
//         print('No media selected.');
//       }
//     });
//   }

//   Future<void> uploadMedia() async {
//     final url = "http://192.168.54.26/practice/upload.php";
//     final name = nameController.text;

//     var request = http.MultipartRequest('POST', Uri.parse(url));
//     request.fields['name'] = name;

//     for (var i = 0; i < _mediaFiles.length; i++) {
//       final media = _mediaFiles[i];
//       request.files.add(await http.MultipartFile.fromPath('media_$i', media.path));
//     }

//     var response = await request.send();
//     if (response.statusCode == 200) {
//       print('Media uploaded successfully');
//     } else {
//       print('Failed to upload media');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'Media Uploader',
//           style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
//         ),
//         backgroundColor: Colors.black,
//       ),
//       body: SingleChildScrollView(
//         padding: EdgeInsets.all(12),
//         child: Column(
//           children: [
//             _mediaFiles.isNotEmpty
//                 ? Column(
//                     children: _mediaFiles.map((media) {
//                       return media.path.toLowerCase().endsWith('.mp4')
//                           ? VideoPlayerWidget(videoFile: media)
//                           : Image.file(
//                               media,
//                               height: 200,
//                               width: 200,
//                             );
//                     }).toList(),
//                   )
//                 : Placeholder(
//                     fallbackHeight: 200,
//                     fallbackWidth: 200,
//                   ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _getMediaFromGallery,
//               child: Text('Select Media'),
//             ),
//             SizedBox(
//               height: 20,
//             ),
//             TextField(
//               controller: nameController,
//               decoration: InputDecoration(labelText: 'Name'),
//             ),
//             SizedBox(
//               height: 20,
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 uploadMedia();
//               },
//               child: Text('Upload Media'),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

// class VideoPlayerWidget extends StatelessWidget {
//   final File videoFile;

//   const VideoPlayerWidget({required this.videoFile});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 200,
//       width: 200,
//       child: VideoPlayer(videoFile),
//     );
//   }
// }

// class VideoPlayer extends StatefulWidget {
//   final File videoFile;

//   VideoPlayer(this.videoFile);

//   @override
//   _VideoPlayerState createState() => _VideoPlayerState();
// }

// class _VideoPlayerState extends State
// {
//   late VideoPlayerController _controller;

//   @override
//   void initState() {
//     super.initState();
//     _controller = VideoPlayerController.file(widget.videoFile)
//       ..initialize().then((_) {
//         setState(() {});
//       });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return _controller.value.isInitialized
//         ? AspectRatio(
//             aspectRatio: _controller.value.aspectRatio,
//             child: VideoPlayer(_controller),
//           )
//         : Container();
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     _controller.dispose();
//   }
// }
