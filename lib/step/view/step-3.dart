import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:potato4cut/designSystem/font.dart';

class Step3Page extends StatefulWidget {
  const Step3Page({super.key});

  @override
  State<Step3Page> createState() => _Step3PageState();
}

class _Step3PageState extends State<Step3Page> {
  CameraController? _cameraController;
  bool _isCameraInitialized = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
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
        cameras.first,
        ResolutionPreset.high,
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
    super.dispose();
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset('assets/images/icons/close.svg'),
              Text('2초', style: AppTextStyle.pageTitleBold),
              Text('1/6',
                  style: AppTextStyle.pageTitleSemiBold
                      .copyWith(color: Colors.grey)),
            ],
          ),
          SizedBox(height: 40.h),
          Expanded(
            child: Center(
              child: _buildCameraPreview(),
            ),
          ),
        ],
      ),
    )));
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
