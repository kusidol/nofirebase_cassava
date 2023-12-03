import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:localization/src/localization_extension.dart';
import 'package:mun_bot/controller/tagerpoint_image_service.dart';
import 'package:mun_bot/screen/widget/no_data.dart';
import 'package:mun_bot/util/size_config.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';

import '../../../../env.dart';
import '../../../../main.dart';
import 'stp_plant_gallery_fullImage.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:mun_bot/screen/login/login_screen.dart';

class Gallery extends StatefulWidget {
  late int targetpointId;
  Gallery(this.targetpointId);

  @override
  State<Gallery> createState() => _GalleryPage();
}

class _GalleryPage extends State<Gallery> with WidgetsBindingObserver {
  final ImageTagetpointService imageService = ImageTagetpointService();

  String? token;
  List<ImageData> images = [];
  bool isLoading = true;
  late ImageData selectedImage;

  late bool isDeletingAll;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    token = tokenFromLogin?.token;
    print(widget.targetpointId);
    _fetchImages();
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      final camera_granted = await Permission.camera.isGranted;
      final storage_granted = await Permission.storage.isGranted;
      if (camera_granted) {
        // print("Resume with Camera");
        Navigator.of(context).pop();
      }
      if (storage_granted) {
        // print("Resume with Storage");
        Navigator.of(context).pop();
      }
    }
  }

  Future<void> _fetchImages() async {
    try {
      final fetchedImages = await imageService.fetchImages(
          token.toString(), widget.targetpointId);
      setState(() {
        images = fetchedImages;
        isLoading = false;
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> _uploadImage(BuildContext context, ImageSource source) async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: source);
      print("PICKEDFILE : ${pickedFile}");
      if (pickedFile != null) {
        final shouldUpload = await showDialog(
          context: context,
          builder: (context) {
            return CupertinoAlertDialog(
              title: Text(
                'confirm-upload'.i18n(),
                style: TextStyle(fontSize: 15, color: Colors.black),
              ),
              content: Text(
                'Do-you-want-to-upload-this-picture'.i18n(),
                style: TextStyle(fontSize: 15, color: Colors.black),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Text(
                    'cancel'.i18n(),
                    style: TextStyle(fontSize: 15, color: Colors.red),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: Text(
                    'upload'.i18n(),
                    style: TextStyle(fontSize: 15, color: Colors.blue),
                  ),
                ),
              ],
            );
          },
        );

        if (shouldUpload == true) {
          ProgressDialog progressDialog = ProgressDialog(context);
          progressDialog.style(
            message: "uploading".i18n(),
            progressWidget: Container(
                padding: const EdgeInsets.all(12.0),
                child: const CircularProgressIndicator(
                  color: theme_color,
                )),
            maxProgress: 100.0,
            progressTextStyle: TextStyle(
                fontSize: 15, color: Colors.black, fontWeight: FontWeight.w400),
            messageTextStyle: TextStyle(
                fontSize: 15, color: Colors.black, fontWeight: FontWeight.w600),
          );
          progressDialog.show();

          List<int> imageBytes = await pickedFile.readAsBytes();
          String base64Image = base64Encode(imageBytes);

          int? status;
          status = await imageService.uploadImage(
            base64Image,
            token.toString(),
            widget.targetpointId,
          );

          bool serviceFinished = false;

          while (!serviceFinished) {
            await Future.delayed(Duration(seconds: 1));
            if (status == 200) {
              serviceFinished = true;
            } else {
              serviceFinished = false;
            }
          }

          _fetchImages();

          progressDialog.hide();
        }
      }
    } catch (e) {
      if (source.toString() == "ImageSource.camera") {
        var statusCamera = await Permission.camera.status;
        if (statusCamera.isDenied) {
          showAlertDialog_Camera(context);
        } else {
          print("Exception !");
        }
      } else {
        var statusPhotos = await Permission.photos.status;
        if (statusPhotos.isDenied) {
          showAlertDialog_Photos(context);
        } else {
          print("Exception !");
        }
      }
    }
  }

  showAlertDialog_Camera(context) => showCupertinoDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: Text("Permission-Denied".i18n()),
          content: Text('Allow-access-to-camera'.i18n()),
          actions: <CupertinoDialogAction>[
            CupertinoDialogAction(
                onPressed: () {
                  Navigator.of(context).pop();

                },
                child: Text('cancel'.i18n())),
            CupertinoDialogAction(
                isDefaultAction: true,
                onPressed: () => openAppSettings(),
                child: Text('Setting'.i18n())),
          ],
        ),
      );

  showAlertDialog_Photos(context) => showCupertinoDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: Text("Permission-Denied".i18n()),
          content: Text('Allow-access-to-gallery-and-photos'.i18n()),
          actions: <CupertinoDialogAction>[
            CupertinoDialogAction(
                onPressed: () {
                  Navigator.of(context).pop();

                },
                child: Text('cancel'.i18n())),
            CupertinoDialogAction(
                isDefaultAction: true,
                onPressed: () => openAppSettings(),
                child: Text('Setting'.i18n())),
          ],
        ),
      );

  Future<void> _deleteImage(int index) async {
    final imageUrl = images[index];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text(
            'confirm-delete'.i18n(),
            style: TextStyle(fontSize: 15, color: Colors.black),
          ),
          content: Text(
            'Do-you-want-to-delete-this-image'.i18n(),
            style: TextStyle(fontSize: 15, color: Colors.black),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'cancel'.i18n(),
                style: TextStyle(fontSize: 15, color: Colors.blue),
              ),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await _performDeleteImage(index, imageUrl.imageId);
              },
              child: Text(
                'deleted'.i18n(),
                style: TextStyle(fontSize: 15, color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _performDeleteImage(int index, imageId) async {
    try {
      ProgressDialog progressDialog = ProgressDialog(context);
      progressDialog.style(
        message: "waiting".i18n(),
        progressWidget: Container(
            padding: EdgeInsets.all(12.0),
            child: CircularProgressIndicator(
              color: theme_color,
            )),
        maxProgress: 100.0,
        progressTextStyle: TextStyle(
            fontSize: 15, color: Colors.black, fontWeight: FontWeight.w400),
        messageTextStyle: TextStyle(
            fontSize: 15, color: Colors.black, fontWeight: FontWeight.w600),
      );
      progressDialog.show();

      int? status;
      status = await imageService.deleteImage(
          widget.targetpointId, imageId, token.toString());

      bool serviceFinished = false;

      while (!serviceFinished) {
        await Future.delayed(Duration(seconds: 1));
        if (status == 200) {
          serviceFinished = true;
          setState(() {
            images.removeAt(index);
          });
        } else {
          serviceFinished = false;
        }
      }
      progressDialog.hide();
    } catch (e) {
      print(e);
    }
  }

  void _viewImage(BuildContext context, ImageData image) {
    final imageIndex = images.indexOf(image);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            FullScreenImage(widget.targetpointId, images, imageIndex),
      ),
    );
  }

  void _showDeleteAllConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text(
            'Confirm-deletion-of-all-data'.i18n(),
            style: TextStyle(fontSize: 15, color: Colors.black),
          ),
          content: Text(
            'Do-you-want-to-delete-all-photos'.i18n(),
            style: TextStyle(fontSize: 15, color: Colors.black),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'cancel'.i18n(),
                style: TextStyle(fontSize: 15, color: Colors.black),
              ),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await _performDeleteAllImages();
              },
              child: Text(
                'Delete-all'.i18n(),
                style: TextStyle(fontSize: 15, color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _performDeleteAllImages() async {
    setState(() {
      isDeletingAll = true;
    });

    try {
      ProgressDialog progressDialog = ProgressDialog(context);
      progressDialog.style(
        message: "waiting".i18n(),
        progressWidget: Container(
            padding: EdgeInsets.all(12.0),
            child: CircularProgressIndicator(
              color: theme_color,
            )),
        maxProgress: 100.0,
        progressTextStyle: TextStyle(
            fontSize: 15, color: Colors.black, fontWeight: FontWeight.w400),
        messageTextStyle: TextStyle(
            fontSize: 15, color: Colors.black, fontWeight: FontWeight.w600),
      );
      progressDialog.show();

      for (int i = 0; i < images.length; i++) {
        await imageService.deleteImage(
            widget.targetpointId, images[i].imageId, token.toString());
      }
      setState(() {
        images.clear();
        isDeletingAll = false;
      });

      await Future.delayed(Duration(seconds: 3));

      progressDialog.hide();
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          'Gallery'.i18n(),
          style: TextStyle(
              fontSize: 25, fontWeight: FontWeight.w700, color: Colors.black),
        ),
        backgroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          images.isNotEmpty
              ? Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.white.withOpacity(1),
                        theme_color3.withOpacity(.4),
                        theme_color4.withOpacity(1),
                      ],
                    ),
                  ),
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                    ),
                    physics: const BouncingScrollPhysics(),
                    itemCount: images.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () => _viewImage(context, images[index]),
                        child: Card(
                          child: Stack(
                            children: [
                              Container(
                                width: 400,
                                height: 400,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Hero(
                                  tag: images[index].imageId,
                                  child: Image.memory(
                                    base64Decode(images[index].imgBase64),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Positioned(
                                  top: 1,
                                  right: 1,
                                  child: Material(
                                    type: MaterialType.transparency,
                                    child: Ink(
                                      decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.grey),
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(5.0)),
                                      child: InkWell(
                                        onTap: () {
                                          _deleteImage(index);
                                        },
                                        child: const Padding(
                                          padding: EdgeInsets.all(1.0),
                                          child: Icon(
                                            Icons.delete_forever,
                                            size: 25.0,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                )
              : Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.white.withOpacity(1),
                        theme_color3.withOpacity(.4),
                        theme_color4.withOpacity(1),
                      ],
                    ),
                  ),
                  height: SizeConfig.screenHeight,
                  child: Center(child: NoData().showNoData(context))),
          if (isLoading)
            const Center(
              child: CircularProgressIndicator(
                color: theme_color2,
              ),
            ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: SpeedDial(
        backgroundColor: theme_color2,
        spacing: 20,
        spaceBetweenChildren: 5,
        child: Icon(Icons.add_a_photo),
        animatedIconTheme: IconThemeData(size: 45.0),
        children: [
          SpeedDialChild(
            child: Icon(
              Icons.add_photo_alternate_rounded,
              color: Colors.white,
            ),
            backgroundColor: theme_color4,
            label: 'Gallery'.i18n(),
            labelStyle: TextStyle(fontSize: 20, color: Colors.black),
            onTap: () {
              _uploadImage(context, ImageSource.gallery);
            },
          ),
          SpeedDialChild(
            child: Icon(Icons.camera_alt, color: Colors.white),
            backgroundColor: theme_color4,
            label: 'Camera'.i18n(),
            labelStyle: TextStyle(fontSize: 20, color: Colors.black),
            onTap: () {
              _uploadImage(context, ImageSource.camera);
            },
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        shape: const CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: Icon(Icons.delete_sweep),
              onPressed: () {
                _showDeleteAllConfirmationDialog(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
