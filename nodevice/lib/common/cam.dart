import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:permission_handler/permission_handler.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _cameraController;
  QRViewController? _qrViewController;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  bool _cameraPermissionGranted = false;

  @override
  void initState() {
    super.initState();
    _requestCameraPermission();
  }

  void _requestCameraPermission() async {
    final status = await Permission.camera.request();
    if (status == PermissionStatus.granted) {
      setState(() {
        _cameraPermissionGranted = true;
      });
      _initCamera();
    } else if (status == PermissionStatus.permanentlyDenied) {
      _showCameraPermissionDeniedMessage();
    }
  }

  void _initCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;
    _cameraController = CameraController(firstCamera, ResolutionPreset.medium);
    await _cameraController!.initialize().then((_) {
      if (!mounted) return;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_cameraPermissionGranted) {
      return const Scaffold(
        body: Center(
          child: Text('카메라 접근 권한이 필요합니다.'),
        ),
      );
    }

    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return Container();
    }

    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
          const Expanded(
            flex: 1,
            child: Center(
              child: Text('QR 코드를 스캔하세요.'),
            ),
          ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    _qrViewController = controller;
    controller.scannedDataStream.listen((scanData) {
      // 스캔된 데이터 처리
      // 예: 스캔된 데이터를 다이얼로그에 표시
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: Text('스캔된 데이터: ${scanData.code}'),
        ),
      );
    });
  }

  void _showCameraPermissionDeniedMessage() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('카메라 접근 권한'),
        content: const Text('앱 설정에서 카메라 접근 권한을 활성화해주세요.'),
        actions: <Widget>[
          TextButton(
            child: const Text('확인'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _qrViewController?.dispose();
    super.dispose();
  }
}
