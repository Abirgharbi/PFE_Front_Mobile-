import 'dart:async';
import 'dart:io';

import 'package:cloudinary/cloudinary.dart';
import 'package:flutter/material.dart';

import './utility.dart';

const String apiKey = '674684268545591';
const String apiSecret = 'QbAEIGv7obzNQFMgfVCIwXQnKLs';
const String cloudName = 'dbkivxzek';
const String folder = 'ARkea';
const String uploadPreset = 'ARkea-dashboard';

final cloudinary = Cloudinary.unsignedConfig(
  cloudName: cloudName,
);

class CloudinaryImgUpload extends StatefulWidget {
  const CloudinaryImgUpload({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<CloudinaryImgUpload> createState() => CloudinaryImgUploadPageState();
}

enum FileSource {
  path,
  bytes,
}

class DataTransmitNotifier {
  final String? path;
  late final ProgressCallback? progressCallback;
  final notifier = ValueNotifier<double>(0);

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
  CloudinaryResponse cloudinaryResponses = CloudinaryResponse();
  String? errorMessage;
  FileSource fileSource = FileSource.path;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Scrollbar(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => onClick(loadImage),
                child: const Text(
                  'Choose Image',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              Visibility(
                visible: errorMessage?.isNotEmpty ?? false,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "$errorMessage",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 18, color: Colors.red.shade900),
                    ),
                    const SizedBox(
                      height: 128,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              const SizedBox(height: 16.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => onClick(upload),
                    style: ButtonStyle(
                      padding:
                          MaterialStateProperty.all(const EdgeInsets.all(16.0)),
                    ),
                    child: const Text(
                      'Unsigned upload',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40.0),
            ],
          ),
        ),
      ),
    );
  }

  void onNewImages(List<String> filePaths) {
    if (filePaths.isNotEmpty) {
      for (final path in filePaths) {
        if (path.isNotEmpty) {
          setState(() {
            dataImages = DataTransmitNotifier(path: path);
          });
        }
      }
      setState(() {});
    }
  }

  Future<List<int>> getFileBytes(String path) async {
    return await File(path).readAsBytes();
  }

  Future<void> doSingleUpload({bool signed = false}) async {
    try {
      final data = dataImages;
      List<int>? fileBytes;

      if (fileSource == FileSource.bytes) {
        fileBytes = await getFileBytes(data.path!);
      }

      CloudinaryResponse response = await cloudinary.unsignedUpload(
        file: data.path,
        fileBytes: fileBytes,
        resourceType: CloudinaryResourceType.image,
        folder: folder,
        progressCallback: data.progressCallback,
        uploadPreset: uploadPreset,
      );

      if (response.isSuccessful && response.secureUrl!.isNotEmpty) {
        setState(() {
          cloudinaryResponses = response;
        });
      } else {
        setState(() {
          errorMessage = response.error;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
      });
    }
  }

  void onClick(int id) async {
    errorMessage = null;
    try {
      switch (id) {
        case loadImage:
          Utility.showImagePickerModal(
            context: context,
            onImageFromGallery: () async {
              print(cloudinaryResponses.secureUrl);
              onNewImages(await handleImagePickerResponse(
                  Utility.pickImageFromGallery()));
            },
          );
          break;
        case upload:
          await doSingleUpload();
          break;
      }
    } catch (e) {
      setState(() => errorMessage = e.toString());
    }
  }

  Future<List<String>> handleImagePickerResponse(Future getImageCall) async {
    Map<String, dynamic> resource =
        await (getImageCall as FutureOr<Map<String, dynamic>>);
    if (resource.isEmpty)
      return [];
    else if (resource['status'] == 'SUCCESS') {
      return resource['data'];
    }
    return [];
  }
}
