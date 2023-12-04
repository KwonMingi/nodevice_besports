// import 'package:device_preview/device_preview.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:nodevice/ui/main_view.dart';

// void main() {
//   runApp(DevicePreview(
//     enabled: !kReleaseMode,
//     builder: (context) => const MyApp(),
//   ));
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       locale: DevicePreview.locale(context),
//       builder: DevicePreview.appBuilder,
//       theme: ThemeData.light(),
//       darkTheme: ThemeData.light(),
//       home: const MainView(),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nodevice/ui/main_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: ThemeData.light().canvasColor, // 상태 표시 줄의 배경색 변경
      statusBarIconBrightness: Brightness.dark, // 상태 표시 줄 아이콘을 어둡게 설정
    ));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      //darkTheme: ThemeData.dark(), // 만약 다크 테마를 사용하고 싶다면 이렇게 설정할 수 있습니다.
      home: const MainView(),
    );
  }
}
