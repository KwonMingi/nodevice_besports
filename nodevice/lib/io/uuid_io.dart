import 'dart:io';
import 'package:uuid/uuid.dart';
import 'package:path_provider/path_provider.dart'; // path_provider 패키지를 임포트합니다.

Future<String> getOrCreateUuid() async {
  // 앱의 문서 디렉토리 경로를 가져옵니다.
  final directory = await getApplicationDocumentsDirectory();
  final path = directory.path;
  final String filePath = '$path/uuid.txt'; // 로컬 파일 경로 업데이트
  File file = File(filePath);

  String uuid;
  if (await file.exists()) {
    // 파일이 존재하면, 파일에서 UUID를 읽어옵니다.
    uuid = await file.readAsString();
    print('기존 UUID 사용: $uuid');
  } else {
    // 파일이 없으면, 새로운 UUID를 생성하고 파일에 저장합니다.
    var uuidGenerator = const Uuid();
    uuid = uuidGenerator.v4();
    await file.writeAsString(uuid);
    print('새로운 UUID 생성 및 저장: $uuid');
  }
  return uuid;
}
