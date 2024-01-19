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
// Import the generated adapter files

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nodevice/common/app_router.dart';
import 'package:nodevice/constants/custom_colors.dart';
import 'package:nodevice/data_struct/exercise_data.dart';
import 'package:nodevice/data_struct/set_data.dart';
import 'package:nodevice/data_struct/user.dart';
import 'package:nodevice/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // 추가된 부분
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Hive.initFlutter();

  Hive.registerAdapter(UserDataAdapter());
  Hive.registerAdapter(ExerciseAdapter());
  Hive.registerAdapter(SetDataAdapter());

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: CustomColors.appColor,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor:
          CustomColors.loginBackGround, // navigation bar color
    ));
    return MaterialApp.router(
      routerConfig: AppRouter.goRouter,
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
    );
  }
}
