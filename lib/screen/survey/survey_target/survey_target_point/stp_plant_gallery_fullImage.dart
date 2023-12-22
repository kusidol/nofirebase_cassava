import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import 'package:localization/src/localization_extension.dart';
import 'package:mun_bot/controller/tagerpoint_image_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';

import '../../../../env.dart';
import '../../../../util/size_config.dart';

// test
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mun_bot/controller/survey_target_point.dart';
import 'package:mun_bot/entities/survey.dart';

import '../../../../env.dart';
import '../../../../main.dart';

import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/widgets.dart';

import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mun_bot/screen/login/login_screen.dart';

class FullScreenImage extends StatefulWidget {
  final List<ImageData> images;
  final int initialIndex;
  int targetpointId;

  FullScreenImage(this.targetpointId, this.images, this.initialIndex);

  @override
  _FullScreenImageState createState() => _FullScreenImageState();
}

class _FullScreenImageState extends State<FullScreenImage> {
  int currentIndex = 0;

  final ImageTagetpointService imageService = ImageTagetpointService();

  String? token;

  @override
  void initState() {
    super.initState();
    token = tokenFromLogin?.token;
    currentIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    Future<void> deleteImage() async {
      try {
        final imageId = widget.images[currentIndex].imageId;

        showCupertinoDialog<void>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) => CupertinoAlertDialog(
            title: Text('confirm-delete'.i18n()),
            content: Column(
              children: [
                Text(
                  'Do-you-want-to-delete-this-image'.i18n(),
                  style: TextStyle(fontSize: 15, color: Colors.black),
                ),
              ],
            ),
            actions: <CupertinoDialogAction>[
              CupertinoDialogAction(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'no'.i18n(),
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              CupertinoDialogAction(
                onPressed: () async {
                  ProgressDialog progressDialog = ProgressDialog(context);
                  progressDialog.style(
                    message: "uploading".i18n(),
                    progressWidget: Container(
                        padding: EdgeInsets.all(12.0),
                        child: CircularProgressIndicator(
                          color: theme_color,
                        )),
                    maxProgress: 100.0,
                    progressTextStyle: TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                        fontWeight: FontWeight.w400),
                    messageTextStyle: TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                        fontWeight: FontWeight.w600),
                  );
                  progressDialog.show();

                  int? status = await imageService.deleteImageByID(
                      widget.targetpointId, imageId, token.toString());
                  //Navigator.of(context).pop();
                  bool serviceFinished = false;

                  while (!serviceFinished) {
                    await Future.delayed(Duration(seconds: 1));
                    if (status == 200) {
                      serviceFinished = true;
                      Navigator.of(context).pop();
                      setState(() {
                        widget.images.removeAt(currentIndex);
                        if (currentIndex >= widget.images.length) {
                          currentIndex--;
                        }
                      });
                    } else {
                      serviceFinished = false;
                    }
                  }
                  progressDialog.hide();
                },
                child: Text(
                  'yes'.i18n(),
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
        );
      } catch (error) {
        //print('Error deleting image: $error');
      }
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: deleteImage,
          ),
        ],
      ),
      body: PhotoViewGallery.builder(
        itemCount: widget.images.length,
        builder: (BuildContext context, int index) {
          return PhotoViewGalleryPageOptions(
            imageProvider: MemoryImage(
              base64Decode(widget.images[index].imgBase64),
            ),
            minScale: PhotoViewComputedScale.contained * 0.8,
            maxScale: PhotoViewComputedScale.covered * 2,
            initialScale: PhotoViewComputedScale.contained,
            heroAttributes: PhotoViewHeroAttributes(tag: index),
          );
        },
        scrollPhysics: const BouncingScrollPhysics(),
        backgroundDecoration: BoxDecoration(
          color: Colors.black,
        ),
        onPageChanged: (int index) {
          setState(() {
            currentIndex = index;
          });
        },
        pageController: PageController(initialPage: currentIndex),
      ),
    );
  }
}
