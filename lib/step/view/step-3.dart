import 'dart:async';
import 'dart:developer';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:path_provider/path_provider.dart';
import 'package:potato4cut/designSystem/font.dart';
import 'package:potato4cut/step/view/step-4.dart';

class Step3Page extends StatefulWidget {
  const Step3Page({super.key});

  @override
  State<Step3Page> createState() => _Step3PageState();
}

class _Step3PageState extends State<Step3Page> {
  CameraController? _cameraController;
  bool _isCameraInitialized = false;
  String? _errorMessage;
  int count = 5;
  int photoCount = 0;
  late Timer timer;
  bool isRunning = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    getDirectory();
  }

  Future<void> getDirectory() async {
    final directory1 = await getTemporaryDirectory();
    log('directory1 = ${directory1.listSync()}');
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        setState(() {
          _errorMessage = '사용 가능한 카메라가 없습니다.';
        });
        return;
      }

      _cameraController = CameraController(
        cameras.last,
        ResolutionPreset.max,
      );

      await _cameraController!.initialize();

      if (mounted) {
        setState(() {
          _isCameraInitialized = true;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = '카메라 초기화 실패: $e';
        });
      }
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    timer.cancel();
    super.dispose();
  }

  void countDown() {
    if (isRunning) return;
    isRunning = true;

    timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) async {
        if (photoCount >= 6) {
          timer.cancel();
          isRunning = false;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const Step4Page(),
            ),
          );
          return;
        }

        setState(() {
          count--;
        });

        if (count == 0) {
          await _cameraController!.takePicture();

          setState(() {
            photoCount++;
            count = 5;
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 52.w, vertical: 58.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SvgPicture.asset('assets/images/icons/close.svg'),
                  Text('$count초', style: AppTextStyle.pageTitleBold),
                  Text(
                    '$photoCount/6',
                    style: AppTextStyle.pageTitleSemiBold
                        .copyWith(color: Colors.grey),
                  ),
                ],
              ),
              SizedBox(height: 40.h),
              ElevatedButton(
                onPressed: () async {
                  await _cameraController?.takePicture();
                },
                child: const Text('촬영'),
              ),
              ElevatedButton(
                onPressed: () async {
                  await getDirectory();
                },
                child: const Text('불러오기'),
              ),
              ElevatedButton(
                onPressed: () async {
                  final directory = await getTemporaryDirectory();
                  await directory.delete(recursive: true);
                },
                child: const Text('삭제'),
              ),
              ElevatedButton(
                onPressed: countDown,
                child: const Text('시작'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Step4Page(),
                    ),
                  );
                },
                child: const Text('step-4'),
              ),
              Expanded(
                child: Center(
                  child: _buildCameraPreview(),
                ),
              ),
              SizedBox(height: 40.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset('assets/images/icons/logo.svg'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCameraPreview() {
    if (_errorMessage != null) {
      return Container(
        width: 354.w,
        height: 526.h,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.camera_alt_outlined,
                size: 48.sp,
                color: Colors.grey[600],
              ),
              SizedBox(height: 16.h),
              Text(
                _errorMessage!,
                style: AppTextStyle.contentRegular.copyWith(
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    if (!_isCameraInitialized || _cameraController == null) {
      return Container(
        width: 354.w,
        height: 526.h,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                strokeWidth: 3.w,
                color: Colors.grey[600],
              ),
              SizedBox(height: 16.h),
              Text(
                '카메라 준비 중...',
                style: AppTextStyle.contentRegular.copyWith(
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      );
    }
    // countDown();
    return Container(
      width: 354.w,
      height: 526.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8.6,
            offset: const Offset(6, 12),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.r),
        child: AspectRatio(
          aspectRatio: _cameraController!.value.aspectRatio,
          child: CameraPreview(_cameraController!),
        ),
      ),
    );
  }
}
