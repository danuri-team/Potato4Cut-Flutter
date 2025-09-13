import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
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
  Timer? _timer;
  bool _isCountdownRunning = false;
  final List<String> _takenPhotoPaths = [];

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        if (!mounted) return;
        setState(() {
          _errorMessage = '사용 가능한 카메라가 없습니다.';
        });
        return;
      }

      _cameraController = CameraController(
        // Use the front camera if available
        cameras.length > 1 ? cameras[1] : cameras[0],
        ResolutionPreset.max,
        enableAudio: false,
      );

      await _cameraController!.initialize();

      if (!mounted) return;
      setState(() {
        _isCameraInitialized = true;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = '카메라 초기화 실패: $e';
      });
    }
  }

  void _startCountdown() {
    if (_isCountdownRunning) return;

    setState(() {
      _takenPhotoPaths.clear();
      photoCount = 0;
      count = 5;
      _isCountdownRunning = true;
    });

    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) async {
        if (photoCount >= 6) {
          timer.cancel();
          _isCountdownRunning = false;
          if (!mounted) return;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Step4Page(photoPaths: _takenPhotoPaths),
            ),
          ).then((_) {
            setState(() {
              _isCountdownRunning = false;
            });
          });
          return;
        }

        if (count == 1) {
          // Take picture on 1, so the user sees '0' briefly
          final imageFile = await _cameraController!.takePicture();
          _takenPhotoPaths.add(imageFile.path);
          setState(() {
            photoCount++;
            count = 5;
          });
        } else {
          setState(() {
            count--;
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
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(),
              SizedBox(height: 40.h),
              Expanded(
                child: Center(
                  child: _buildCameraPreview(),
                ),
              ),
              SizedBox(height: 40.h),
              if (_isCameraInitialized && !_isCountdownRunning)
                SizedBox(
                  width: 110.w,
                  height: 54.h,
                  child: ElevatedButton(
                    onPressed: _startCountdown,
                    child: const Text('촬영 시작'),
                  ),
                ),
              // SizedBox(height: 20.h),
              // _buildFooter(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SvgPicture.asset('assets/images/icons/close.svg'),
          RichText(
            text: TextSpan(
              text: '$count',
              style: AppTextStyle.pageTitleBold
                  .copyWith(color: Colors.red, fontSize: 44.sp),
              children: [
                TextSpan(
                  text: '초',
                  style: TextStyle(color: Colors.black, fontSize: 32.sp),
                ),
              ],
            ),
          ),
          RichText(
            text: TextSpan(
              text: '$photoCount',
              style: AppTextStyle.pageTitleBold
                  .copyWith(color: Colors.red, fontSize: 44.sp),
              children: [
                TextSpan(
                  text: '/6',
                  style: AppTextStyle.pageTitleSemiBold
                      .copyWith(color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset('assets/images/icons/logo.svg'),
      ],
    );
  }

  Widget _buildCameraPreview() {
    if (_errorMessage != null) {
      return _buildErrorWidget(_errorMessage!);
    }

    if (!_isCameraInitialized || _cameraController == null) {
      return _buildErrorWidget('카메라 준비 중...', showIndicator: true);
    }

    return Container(
      width: 700.w,
      height: 700.h,
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
        child: CameraPreview(_cameraController!),
      ),
    );
  }

  Widget _buildErrorWidget(String message, {bool showIndicator = false}) {
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
            if (showIndicator)
              CircularProgressIndicator(
                strokeWidth: 3.w,
                color: Colors.grey[600],
              )
            else
              Icon(
                Icons.camera_alt_outlined,
                size: 48.sp,
                color: Colors.grey[600],
              ),
            SizedBox(height: 16.h),
            Text(
              message,
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
}
