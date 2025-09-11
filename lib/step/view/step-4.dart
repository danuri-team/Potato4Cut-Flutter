import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:image/image.dart' as img;

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:path_provider/path_provider.dart';
import 'package:potato4cut/designSystem/font.dart';

class Step4Page extends StatefulWidget {
  const Step4Page({super.key});

  @override
  State<Step4Page> createState() => _Step4PageState();
}

class _Step4PageState extends State<Step4Page> {
  late final Directory directory;
  List<File>? photos;
  List<File> selectedPhotos = [];
  File? finalPhoto;

  @override
  void initState() {
    super.initState();
    getPhotos();
  }

  Future<void> getPhotos() async {
    directory = await getTemporaryDirectory();
    photos = directory.listSync().cast<File>();
    setState(() {});
  }

  Future<void> collage() async {
    try {
      final boundary = _repaintKey.currentContext?.findRenderObject()
          as RenderRepaintBoundary?;
      if (boundary == null) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('boundary == null')));
      }

      final image = await boundary!.toImage(pixelRatio: 3);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      final pngBytes = byteData!.buffer.asUint8List();

      final jpgBytes = await convertPngToJpg(pngBytes);

      final dir = await getApplicationDocumentsDirectory();
      finalPhoto = File('${dir.path}/collage_with_frame.jpg');
      await finalPhoto?.writeAsBytes(jpgBytes); 
      setState(() {});
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  Future<Uint8List> convertPngToJpg(Uint8List pngBytes) async {
  final img.Image? decoded = img.decodeImage(pngBytes);
  if (decoded == null) throw Exception("PNG decode 실패");

  // 100은 품질 (0~100)
  return Uint8List.fromList(img.encodeJpg(decoded, quality: 90));
}

  Future<void> printPicture() async {
    final dio = Dio();
    final filePath = finalPhoto!.path;
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(filePath),
    });
    final response = await dio
        .post('http://124.61.34.206:3000/api/printer/upload', data: formData);
  }

  final GlobalKey _repaintKey = GlobalKey();

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
            SvgPicture.asset('assets/images/icons/close.svg'),
            SizedBox(height: 10.h),
            Align(
              child: Column(
                children: [
                  Text(
                    '사진을 선택해주세요',
                    style: AppTextStyle.pageTitleBold,
                  ),
                  SizedBox(height: 48.h),
                  Row(
                    children: [
                      // SizedBox(width: 131.w),
                      RepaintBoundary(
                        key: _repaintKey,
                        child: Stack(
                          children: [
                            Container(
                              width: 262.w,
                              height: 468.h,
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.5),
                                    blurRadius: 5,
                                    offset: const Offset(
                                      2,
                                      5,
                                    ),
                                  ),
                                ],
                              ),
                              child: SvgPicture.asset(
                                'assets/images/icons/default_frame.svg',
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.only(
                                right: 23,
                                left: 19,
                                top: 6,
                                bottom: 88,
                              ),
                              width: 266.w,
                              height: 468.h,
                              child: GridView(
                                gridDelegate:
                                    SliverGridDelegateWithMaxCrossAxisExtent(
                                  maxCrossAxisExtent: 120.w,
                                  mainAxisExtent: 168.h,
                                  mainAxisSpacing: 11,
                                  crossAxisSpacing: 8,
                                ),
                                physics: const NeverScrollableScrollPhysics(),
                                children: List.generate(
                                  // 4,
                                  // (index) {
                                  selectedPhotos.length < 4
                                      ? selectedPhotos.length
                                      : 4,
                                  (index) {
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          selectedPhotos.removeWhere(
                                            (element) =>
                                                element ==
                                                selectedPhotos[index],
                                          );
                                        });
                                      },
                                      // child: Container(
                                      //   width: 120.w,
                                      //   height: 171.h,
                                      //   color: Colors.amber,
                                      // ),
                                      child: Container(
                                        width: 120.w,
                                        height: 172.h,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: FileImage(
                                              selectedPhotos[index],
                                            ),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 123.w),
                      if (photos == null)
                        const CircularProgressIndicator()
                      else
                        SizedBox(
                          width: 381.w,
                          height: 396.h,
                          child: GridView(
                            gridDelegate:
                                SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 120.w,
                              mainAxisExtent: 172.h,
                              mainAxisSpacing: 51,
                              crossAxisSpacing: 30,
                            ),
                            physics: const NeverScrollableScrollPhysics(),
                            children: List.generate(
                              6,
                              (index) => GestureDetector(
                                onTap: () {
                                  if (selectedPhotos.contains(photos![index])) {
                                    setState(() {
                                      selectedPhotos.removeWhere(
                                        (element) => element == photos![index],
                                      );
                                    });
                                  } else if (selectedPhotos.length < 4) {
                                    setState(() {
                                      selectedPhotos.add(photos![index]);
                                    });
                                  }
                                },
                                child: Container(
                                  width: 120.w,
                                  height: 172.h,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      colorFilter: (selectedPhotos.contains(
                                        photos![index],
                                      ))
                                          ? ColorFilter.mode(
                                              Colors.black.withOpacity(0.4),
                                              BlendMode.darken,
                                            )
                                          : null,
                                      image: FileImage(
                                        photos![index],
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                    boxShadow: (selectedPhotos.contains(
                                      photos![index],
                                    ))
                                        ? [
                                            BoxShadow(
                                              color: Colors.black.withValues(),
                                              blurRadius: 6,
                                              offset: const Offset(0, 3),
                                            ),
                                          ]
                                        : null,
                                  ),
                                  child: (selectedPhotos.contains(
                                    photos![index],
                                  ))
                                      ? Center(
                                          child: Container(
                                            width: 40.r,
                                            height: 40.r,
                                            decoration: ShapeDecoration(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                  22,
                                                ),
                                                side: const BorderSide(
                                                  width: 2.4,
                                                  color: Color(0xFFFF09DA),
                                                ),
                                              ),
                                            ),
                                            alignment: Alignment.center,
                                            child: Text(
                                              '${index + 1}',
                                              style: TextStyle(
                                                color: const Color(
                                                  0xFFFF09DA,
                                                ),
                                                fontSize: 20.sp,
                                                fontWeight: FontWeight.w800,
                                                height: 1.30,
                                              ),
                                            ),
                                          ),
                                        )
                                      : const SizedBox.shrink(),
                                ),
                              ),
                            ),
                          ),
                        ),
                      if (finalPhoto == null)
                        const Text('null')
                      else
                        SizedBox(
                          width: 262.w,
                          height: 468.h,
                          child: Image.file(finalPhoto!),
                        ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      await collage();
                      await printPicture();
                    },
                    child: const Text('출력하기'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// abstract class AppDio {
//   AppDio._internal();

//   static Dio? _instance;

//   static Dio getInstance() => _instance ??= _AppDio();
// }

// class _AppDio with DioMixin implements AppDio {
//   _AppDio() {
//     httpClientAdapter = IOHttpClientAdapter();
//     options = BaseOptions(
//       baseUrl: dotenv.env['API_URL']!,
//       headers: {
//         'Content-Type': 'application/json',
//       },
//       sendTimeout: const Duration(seconds: 30),
//       connectTimeout: const Duration(seconds: 30),
//       receiveTimeout: const Duration(seconds: 30),
//       receiveDataWhenStatusError: true,
//     );

//     interceptors.addAll(
//       [
//         InterceptorsWrapper(
//           onError: (error, handler) async {
//             return handler.reject(error);
//           },
//           onRequest: (options, handler) async {
//             return handler.next(options);
//           },
//         ),
//         LogInterceptor(
//           requestBody: true,
//           responseBody: true,
//         ),
//       ],
//     );
//   }
// }
