import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloudinary/cloudinary.dart';
import '../Model/service/CloudinaryService.dart';
import './utility.dart';

class CloudinaryImgUpload extends StatefulWidget {
  const CloudinaryImgUpload({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<CloudinaryImgUpload> createState() => CloudinaryImgUploadPageState();
}

class DataTransmitNotifier {
  final String? path;
  final notifier = ValueNotifier<double>(0);
  late final ProgressCallback? progressCallback;

  DataTransmitNotifier({this.path, ProgressCallback? progressCallback}) {
    this.progressCallback = progressCallback ??
        (count, total) {
          notifier.value = count.toDouble() / total.toDouble();
        };
  }
}

class CloudinaryImgUploadPageState extends State<CloudinaryImgUpload> {
  static const int loadImage = 1;
  static const int upload = 3;
  DataTransmitNotifier dataImages = DataTransmitNotifier();
  CloudinaryResponse? cloudinaryResponse;
  final CloudinaryService cloudinaryService = CloudinaryService();
  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Scrollbar(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => onClick(loadImage),
                child: const Text('Choisir une image'),
              ),
              const SizedBox(height: 16),
              if (errorMessage != null)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    errorMessage!,
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => onClick(upload),
                child: const Text('Uploader l’image'),
              ),
              const SizedBox(height: 32),
              if (cloudinaryResponse != null &&
                  cloudinaryResponse!.secureUrl != null)
                Image.network(cloudinaryResponse!.secureUrl!),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> onClick(int id) async {
    setState(() => errorMessage = null);
    try {
      if (id == loadImage) {
        Utility.showImagePickerModal(
          context: context,
          onImageFromGallery: () async {
            List<String> paths = await handleImagePickerResponse(
                Utility.pickImageFromGallery());
            if (paths.isNotEmpty) {
              setState(() {
                dataImages = DataTransmitNotifier(path: paths.first);
              });
            }
          },
        );
      } else if (id == upload) {
        await doSingleUpload();
      }
    } catch (e) {
      setState(() => errorMessage = e.toString());
    }
  }

  Future<void> doSingleUpload() async {
    if (dataImages.path == null) {
      setState(() => errorMessage = 'Aucune image sélectionnée.');
      return;
    }

    try {
      final response = await cloudinaryService.unsignedUpload(
        path: dataImages.path!,
        progressCallback: dataImages.progressCallback,
      );

      if (response.isSuccessful) {
        setState(() {
          cloudinaryResponse = response;
        });
      } else {
        setState(() {
          errorMessage = response.error ?? 'Upload échoué.';
        });
      }
    } catch (e) {
      setState(() => errorMessage = e.toString());
    }
  }

  Future<List<String>> handleImagePickerResponse(Future<dynamic> picker) async {
    final resource = await picker;
    if (resource == null || resource.isEmpty) return [];
    if (resource['status'] == 'SUCCESS') return List<String>.from(resource['data']);
    return [];
  }
}
