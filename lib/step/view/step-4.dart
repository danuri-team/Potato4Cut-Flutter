import 'dart:async';
import 'dart:developer' as dev;
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:potato4cut/designSystem/font.dart';
import 'package:potato4cut/step/view/step-5.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:uuid/uuid.dart';

class Step4Page extends StatefulWidget {
  const Step4Page({required this.photoPaths, super.key});
  final List<String> photoPaths;

  @override
  State<Step4Page> createState() => _Step4PageState();
}

final List<Rect> _photoSlotRatios = [
  // Slot 1 (Top-Left)
  const Rect.fromLTWH(0.0639, 0.0603, 0.4202, 0.3618),
  // Slot 2 (Top-Right)
  const Rect.fromLTWH(0.5129, 0.0603, 0.4202, 0.3618),
  // Slot 3 (Bottom-Left)
  const Rect.fromLTWH(0.0639, 0.4496, 0.4202, 0.3618),
  // Slot 4 (Bottom-Right)
  const Rect.fromLTWH(0.5129, 0.4496, 0.4202, 0.3618),
];

class _Step4PageState extends State<Step4Page> {
  List<File> photos = [];
  List<File> selectedPhotos = [];
  File? finalPhoto;
  late String uuidV4;
  bool _isPrinting = false;

  final GlobalKey _repaintKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    const uuid = Uuid();
    uuidV4 = uuid.v4();
    photos = widget.photoPaths.map(File.new).toList();
    // selectedPhotos = photos.take(4).toList();
  }

  @override
  void dispose() {
    _cleanupTemporaryPhotos();
    super.dispose();
  }

  Future<void> _cleanupTemporaryPhotos() async {
    for (final path in widget.photoPaths) {
      try {
        final file = File(path);
        if (await file.exists()) {
          await file.delete();
        }
      } catch (e) {
        // log('Failed to delete temporary photo: $e');
      }
    }
  }

  Future<void> collage() async {
    try {
      final boundary = _repaintKey.currentContext?.findRenderObject()
          as RenderRepaintBoundary?;
      if (boundary == null) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('boundary == null')));
        return;
      }

      final image = await boundary.toImage(pixelRatio: 3);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      final pngBytes = byteData!.buffer.asUint8List();

      final jpgBytes = await convertPngToJpeg(pngBytes);

      final dir = await getApplicationDocumentsDirectory();
      finalPhoto = File('${dir.path}/$uuidV4.jpeg');
      await finalPhoto?.writeAsBytes(jpgBytes);
      setState(() {});
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  Future<Uint8List> convertPngToJpeg(Uint8List pngBytes) async {
    final decoded = img.decodeImage(pngBytes);
    if (decoded == null) throw Exception('PNG decode 실패');

    return Uint8List.fromList(img.encodeJpg(decoded, quality: 90));
  }

  Future<bool> printPicture() async {
    if (finalPhoto == null) return false;
    try {
      final dio = Dio();
      final filePath = finalPhoto!.path;
      final formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(filePath),
        'shouldPrint': false,
        'border': false,
      });
      final response = await dio.post(
        'http://10.211.41.155:3000/api/printer/upload',
        data: formData,
      );
      return response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300;
    } catch (e) {
      // log('error = $e');
      return false;
    }
  }

  void _onPhotoTap(File photo) {
    setState(() {
      if (selectedPhotos.contains(photo)) {
        selectedPhotos.remove(photo);
      } else if (selectedPhotos.length < 4) {
        selectedPhotos.add(photo);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 52.w,
          vertical: 58.h,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: SvgPicture.asset('assets/images/icons/close.svg'),
            ),
            SizedBox(height: 10.h),
            Align(
              child: Text(
                '사진을 선택해주세요',
                style: AppTextStyle.pageTitleBold,
              ),
            ),
            SizedBox(height: 48.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 262.w,
                  height: 468,
                  child: _buildPhotoFrame(),
                ),
                SizedBox(width: 20.w),
                SizedBox(
                  width: 662.w,
                  height: 374.h,
                  child: _buildAvailablePhotosGrid(),
                ),
              ],
            ),
            Center(
              child: GestureDetector(
                onTap: _isPrinting
                    ? null
                    : () {
                        Throttle.run(
                          () async {
                            setState(() {
                              _isPrinting = true;
                            });

                            await collage();
                            final success = await printPicture();

                            if (!mounted) return;

                            setState(() {
                              _isPrinting = false;
                            });

                            if (success) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Step5Page(
                                    uuid: uuidV4,
                                  ),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('출력에 실패했습니다. 다시 시도해주세요.'),
                                ),
                              );
                            }
                          },
                        );
                      },
                child: Container(
                  width: 190.w,
                  height: 68.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.black,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '출력하기',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              // child: ElevatedButton(
              //   onPressed: _isPrinting
              //       ? null
              //       : () {
              //           Throttle.run(
              //             () async {
              //               setState(() {
              //                 _isPrinting = true;
              //               });

              //               await collage();
              //               final success = await printPicture();

              //               if (!mounted) return;

              //               setState(() {
              //                 _isPrinting = false;
              //               });

              //               if (success) {
              //                 Navigator.pushReplacement(
              //                   context,
              //                   MaterialPageRoute(
              //                     builder: (context) => Step5Page(
              //                       uuid: uuidV4,
              //                     ),
              //                   ),
              //                 );
              //               } else {
              //                 ScaffoldMessenger.of(context).showSnackBar(
              //                   const SnackBar(
              //                     content: Text('출력에 실패했습니다. 다시 시도해주세요.'),
              //                   ),
              //                 );
              //               }
              //             },
              //           );
              //         },
              //   child: _isPrinting
              //       ? const CircularProgressIndicator(color: Colors.white)
              //       : const Text('출력하기'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoFrame() {
    return RepaintBoundary(
      key: _repaintKey,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final frameWidth = constraints.maxWidth;
          final frameHeight = constraints.maxHeight;

          return Stack(
            fit: StackFit.expand,
            children: [
              SvgPicture.asset(
                'assets/images/icons/default_frame.svg',
                fit: BoxFit.fill,
              ),
              for (int i = 0; i < selectedPhotos.length; i++)
                Positioned(
                  left: frameWidth * _photoSlotRatios[i].left,
                  top: frameHeight * _photoSlotRatios[i].top,
                  width: frameWidth * _photoSlotRatios[i].width,
                  height: frameHeight * _photoSlotRatios[i].height,
                  child: RotatedBox(
                    quarterTurns: 1,
                    child: GestureDetector(
                      onTap: () {
                        _onPhotoTap(selectedPhotos[i]);
                      },
                      child: Image.file(
                        selectedPhotos[i],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              // Positioned(
              //   right: frameWidth * 0.04,
              //   bottom: frameHeight * 0.08,
              //   width: frameWidth * 0.2,
              //   height: frameWidth * 0.2,
              //   child: QrImageView(
              //     data:
              //         'https://storage.danuri.cloud/potato-4-cut/$uuidV4.jpeg',
              //   ),
              // ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildAvailablePhotosGrid() {
    return SizedBox(
      width: 662.w,
      height: 374.h,
      child: GridView.builder(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 190.w,
          mainAxisExtent: 170.h,
          mainAxisSpacing: 30,
          crossAxisSpacing: 51,
        ),
        physics: const NeverScrollableScrollPhysics(),
        itemCount: photos.length,
        itemBuilder: (context, index) {
          final photo = photos[index];
          final isSelected = selectedPhotos.contains(photo);
          return GestureDetector(
            onTap: () => _onPhotoTap(photo),
            child: Container(
              width: 120.w,
              height: 172.h,
              decoration: BoxDecoration(
                image: DecorationImage(
                  colorFilter: isSelected
                      ? ColorFilter.mode(
                          Colors.black.withOpacity(0.4),
                          BlendMode.darken,
                        )
                      : null,
                  image: FileImage(photo),
                  fit: BoxFit.cover,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.25),
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
              child: isSelected
                  ? _buildSelectionIndicator(photo)
                  : const SizedBox.shrink(),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSelectionIndicator(File photo) {
    return Center(
      child: Container(
        width: 40.r,
        height: 40.r,
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
            side: const BorderSide(
              width: 2.4,
              color: Color(0xFFFF09DA),
            ),
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          '${selectedPhotos.indexOf(photo) + 1}',
          style: TextStyle(
            color: const Color(0xFFFF09DA),
            fontSize: 20.sp,
            fontWeight: FontWeight.w800,
            height: 1.30,
          ),
        ),
      ),
    );
  }
}

class Throttle {
  static Timer? timer;

  static void run(Function onTap) {
    if (timer?.isActive ?? false) return;

    onTap();
    timer = Timer(
      const Duration(seconds: 2),
      () => timer = null,
    );
  }
}
