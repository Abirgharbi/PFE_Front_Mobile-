import 'dart:async';
import 'dart:io';

import 'package:ARkea/ViewModel/signup_controller.dart';
import 'package:cloudinary/cloudinary.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import '../../../Model/service/network_handler.dart';
import '../../../ViewModel/login_controller.dart';
import '../../../ViewModel/profile_controller.dart';
import '../../../ViewModel/utility.dart';
import '../../../utils/colors.dart';
import '../../../utils/sizes.dart';
import '../../widgets/form_textfiled.dart';

var loginController = Get.put(LoginController());
var signUpController = Get.put(SignupScreenController());

const String apiKey = '674684268545591';
const String apiSecret = 'QbAEIGv7obzNQFMgfVCIwXQnKLs';
const String cloudName = 'dbkivxzek';
const String folder = 'ARkea';
const String uploadPreset = 'ARkea-dashboard';

final cloudinary = Cloudinary.signedConfig(
  cloudName: cloudName,
  apiKey: apiKey,
  apiSecret: apiSecret,
);

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => EditProfileScreenState();
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

class EditProfileScreenState extends State<EditProfileScreen> {
  static const int loadImage = 1;
  static const int upload = 3;
  static const int doUnsignedUpload = 3;
  DataTransmitNotifier dataImages = DataTransmitNotifier();
  CloudinaryResponse cloudinaryResponses = CloudinaryResponse();
  String? errorMessage;
  FileSource fileSource = FileSource.path;

  void onUploadSourceChanged(FileSource? value) =>
      setState(() => fileSource = value!);

  final double topContainerheight = 190;
  final ProfileController profileController = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
          ),
          title: Text(
            "Edit Profile",
            style: Theme.of(context).textTheme.displayMedium,
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
              padding: const EdgeInsets.all(tDefaultSize),
              child: Column(children: [
                FutureBuilder<String>(
                  future: NetworkHandler.getItem(
                      'customerImage'), // a previously-obtained Future<String> or null
                  builder:
                      (BuildContext context, AsyncSnapshot<String> snapshot) {
                    List<Widget> children;
                    if (snapshot.hasData) {
                      children = <Widget>[
                        SizedBox(
                          height: 150,
                          width: 150,
                          child: Stack(
                            children: [
                              ClipOval(
                                child: SizedBox.fromSize(
                                  size: Size.fromRadius(100), // Image radius
                                  child: dataImages.path != null
                                      ? Image.file(
                                          File(dataImages.path!),
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.75,
                                          scale: 1.0,
                                          fit: BoxFit.cover,
                                        )
                                      : Image.network(
                                          '${snapshot.data}',
                                          fit: BoxFit.cover,
                                        ),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  width: 35,
                                  height: 35,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      color: MyColors.btnBorderColor),
                                  child: IconButton(
                                    icon: const Icon(
                                      LineAwesomeIcons.camera,
                                      size: 20,
                                      color: Colors.white,
                                    ),
                                    onPressed: () => onClick(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ];
                    } else if (snapshot.hasError) {
                      children = <Widget>[Text('${snapshot.error}')];
                    } else {
                      children = const <Widget>[
                        SizedBox(
                          width: 60,
                          height: 60,
                          child: CircularProgressIndicator(),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 16),
                          child: Text('Awaiting result...'),
                        ),
                      ];
                    }
                    return Center(
                      child: Column(
                        children: children,
                      ),
                    );
                  },
                ),
                const SizedBox(
                  height: 30,
                ),
                Form(
                    child: Column(
                  children: [
                    FutureBuilder<String>(
                      future: NetworkHandler.getItem(
                          'customerName'), // a previously-obtained Future<String> or null
                      builder: (BuildContext context,
                          AsyncSnapshot<String> snapshot) {
                        List<Widget> children;
                        if (snapshot.hasData) {
                          children = <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(top: 16),
                              child: (loginController.isNameEnabled.value ==
                                          false &&
                                      signUpController.isEnabledName.value ==
                                          false)
                                  ? FormTextFiled(
                                      enabled: false,
                                      label: "Full Name",
                                      prefIcon: Icon(
                                        LineAwesomeIcons.user,
                                        color: MyColors.captionColor,
                                      ),
                                      controller: profileController.name)
                                  : FormTextFiled(
                                      label: "Full Name",
                                      prefIcon: Icon(
                                        LineAwesomeIcons.user,
                                        color: MyColors.captionColor,
                                      ),
                                      controller: profileController.name),
                            ),
                          ];
                        } else if (snapshot.hasError) {
                          children = <Widget>[Text('${snapshot.error}')];
                        } else {
                          children = const <Widget>[
                            SizedBox(
                              width: 60,
                              height: 60,
                              child: CircularProgressIndicator(),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 16),
                              child: Text('Awaiting result...'),
                            ),
                          ];
                        }
                        return Center(
                          child: Column(
                            children: children,
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    FutureBuilder<String>(
                      future: NetworkHandler.getItem(
                          'customerEmail'), // a previously-obtained Future<String> or null
                      builder: (BuildContext context,
                          AsyncSnapshot<String> snapshot) {
                        List<Widget> children;
                        if (snapshot.hasData) {
                          children = <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(top: 16),
                              child: FormTextFiled(
                                label: "Email",
                                enabled: false,
                                initialValue: "${snapshot.data} ",
                                prefIcon: Icon(LineAwesomeIcons.envelope_1,
                                    color: MyColors.captionColor),
                              ),
                            ),
                          ];
                        } else if (snapshot.hasError) {
                          children = <Widget>[Text('${snapshot.error}')];
                        } else {
                          children = const <Widget>[
                            SizedBox(
                              width: 60,
                              height: 60,
                              child: CircularProgressIndicator(),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 16),
                              child: Text('Awaiting result...'),
                            ),
                          ];
                        }
                        return Center(
                          child: Column(
                            children: children,
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    FutureBuilder<String>(
                      future: NetworkHandler.getItem(
                          'customerPhoneNumber'), // a previously-obtained Future<String> or null
                      builder: (BuildContext context,
                          AsyncSnapshot<String> snapshot) {
                        List<Widget> children;
                        if (snapshot.hasData) {
                          children = <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(top: 16),
                              child: FormTextFiled(
                                  label: "Phone N°",
                                  prefIcon: Icon(LineAwesomeIcons.phone,
                                      color: MyColors.captionColor),
                                  controller: profileController.phoneNumber),
                            ),
                          ];
                        } else if (snapshot.hasError) {
                          children = <Widget>[Text('${snapshot.error}')];
                        } else {
                          children = const <Widget>[
                            SizedBox(
                              width: 60,
                              height: 60,
                              child: CircularProgressIndicator(),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 16),
                              child: Text('Awaiting result...'),
                            ),
                          ];
                        }
                        return Center(
                          child: Column(
                            children: children,
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                  ],
                )),
                const SizedBox(
                  height: 40,
                ),
                SizedBox(
                  width: double.infinity,
                  height: 45,
                  child: ElevatedButton(
                    onPressed: () {
                      profileController
                          .updateProfile(cloudinaryResponses.secureUrl!);
                      print(cloudinaryResponses.secureUrl);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MyColors.btnColor,
                      side: BorderSide.none,
                      shape: const StadiumBorder(),
                    ),
                    child: const Text(
                      "Edit Profile",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ])),
        ));
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

  Future<void> doSingleUpload({bool signed = true}) async {
    try {
      final data = dataImages;
      List<int>? fileBytes;

      if (fileSource == FileSource.bytes) {
        fileBytes = await getFileBytes(data.path!);
      }

      CloudinaryResponse response = signed
          ? await cloudinary.upload(
              file: data.path,
              fileBytes: fileBytes,
              resourceType: CloudinaryResourceType.image,
              folder: folder,
              progressCallback: data.progressCallback,
            )
          : await cloudinary.unsignedUpload(
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
        //print('${cloudinaryResponses.secureUrl}');
      } else {
        setState(() {
          errorMessage = response.error;
        });
        print('${cloudinaryResponses}helloErr');
      }
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
      });
      if (kDebugMode) {
        print(e);
      }
    }
  }

  // Future<void> doSingleUpload() async {
  //   try {
  //     final data = dataImages;
  //     List<int>? fileBytes;

  //     if (fileSource == FileSource.bytes) {
  //       fileBytes = await getFileBytes(data.path!);
  //     }

  //     CloudinaryResponse response = await cloudinary.unsignedUpload(
  //       file: data.path,
  //       fileBytes: fileBytes,
  //       resourceType: CloudinaryResourceType.image,
  //       folder: folder,
  //       progressCallback: data.progressCallback,
  //       uploadPreset: uploadPreset,
  //     );

  //     if (response.isSuccessful && response.secureUrl!.isNotEmpty) {
  //       setState(() {
  //         cloudinaryResponses = response;
  //       });
  //       print('${cloudinaryResponses}hello');
  //     } else {
  //       setState(() {
  //         errorMessage = response.error;
  //       });
  //       print('${cloudinaryResponses}helloErr');
  //     }
  //   } catch (e) {
  //     setState(() {
  //       errorMessage = e.toString();
  //     });
  //   }
  // }

  void onClick() async {
    errorMessage = null;
    try {
      Utility.showImagePickerModal(
        context: context,
        onImageFromGallery: () async {
          onNewImages(
              await handleImagePickerResponse(Utility.pickImageFromGallery()));
          doSingleUpload();
        },
      );
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
