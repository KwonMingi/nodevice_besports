import 'dart:convert';
import 'dart:isolate';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

// const apiKey = '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';
String generateQuestionFormet(
    selectGoal, selectGender, selectDivide, selectPart, selectTime) {
  // Your existing code to construct the initial part of the prompt

  // Example of how you might structure the prompt for a specific day's workout plan
  String prompt =
      "I'm planning my workout for Tuesday. I want to include bench presses and lat pulldowns. "
      "Can you recommend a workout plan that includes these exercises? Please format the plan as follows: "
      "'[Day]: [Exercise], [Weight], [Reps], [Sets]'. For example, 'Tuesday: Bench Press, 50kg, 10 reps, 10 sets / Lat Pulldown, 50kg, 10 reps, 10 sets'.";

  return prompt;
}

String generateQuestion(
    selectGoal, selectGender, selectDivide, selectPart, selectTime) {
  String goal = "";

  if (selectGoal.value == 0) {
    goal = "to lose weight";
  } else if (selectGoal.value == 1) {
    goal = "for muscle growth";
  } else if (selectGoal.value == 2) {
    goal = "to maintain";
  } else if (selectGoal.value == 3) {
    goal = "to enhance performance";
  }

  String gender = "";
  if (selectGender.value == 0) {
    gender = "for a man";
  } else if (selectGender.value == 1) {
    gender = "for a women";
  }

  String divide = "workout";
  if (selectDivide.value == 0) {
    divide = "workout";
  } else if (selectDivide.value == 1) {
    divide = "2-day split workout";
  } else if (selectDivide.value == 2) {
    divide = "3-day split workout";
  } else if (selectDivide.value == 3) {
    divide = "5-day split workout";
  }

  String part = "";
  if (selectPart.value.contains(0)) {
    part += "arm, ";
  }
  if (selectPart.value.contains(1)) {
    part += "chest, ";
  }
  if (selectPart.value.contains(2)) {
    part += "lower-body, ";
  }
  if (selectPart.value.contains(3)) {
    part += "back, ";
  }
  if (selectPart.value.contains(4)) {
    part += "shoulder, ";
  }

  String time = "";
  if (selectTime.value == 0) {
    time = "for 30 minutes or less per day";
  } else if (selectTime.value == 1) {
    time = "for an hour per day";
  } else if (selectTime.value == 2) {
    time = "for an hour and half per day";
  } else if (selectTime.value == 3) {
    time = "for 2 hours or more per day";
  }

  if (part.endsWith(", ")) {
    part = part.substring(0, part.length - 2);
  }
  String prompt = 'Recommend $part $divide $gender to do $goal $time';

  return prompt;
}

void fetchGPTResponseIsolate(SendPort sendPort) async {
  ReceivePort receivePort = ReceivePort();
  sendPort.send(receivePort.sendPort);

  await for (var message in receivePort) {
    IsolateData data = message[0];
    SendPort replyTo = message[1];

    String prompt = data.prompt;
    String apiKey = data.apiKey; // API 키를 IsolateData 객체에서 추출

    // GPT-3.5 모델을 사용하려면, 모델명을 요청 본문에 포함시켜야 합니다.
    // 예: 'text-davinci-002'를 사용하는 경우
    final url = dotenv.env['BASE_URL'].toString(); // 엔드포인트 수정

    final headers = {
      'Authorization': 'Bearer $apiKey',
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    try {
      var response = await http
          .post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode({
          'model': 'davinci-002', // 사용할 모델명 지정
          'prompt': prompt,
          'max_tokens': 100,
          'temperature': 0.5,
          // 필요한 경우 추가 파라미터 지정
        }),
      )
          .timeout(const Duration(seconds: 10), onTimeout: () {
        return http.Response('request timed out', 408);
      });

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        replyTo.send(data['choices'][0]['text'].trim());
      } else {
        var errorData = json.decode(response.body);
        replyTo.send("Error: ${errorData['error']['message']}");
      }
    } catch (e) {
      replyTo.send("Error: Exception during API call - $e");
    }

    // 작업 완료 후 ReceivePort를 닫음
    receivePort.close();
  }
}

Future<String> fetchGPTResponseInIsolate(String prompt) async {
  ReceivePort receivePort = ReceivePort();
  Isolate isolate =
      await Isolate.spawn(fetchGPTResponseIsolate, receivePort.sendPort);

  SendPort sendPort = await receivePort.first;

  ReceivePort responsePort = ReceivePort();
  sendPort.send([
    IsolateData(prompt,
        dotenv.env['OPENAI_API_KEY'].toString()), // IsolateData 객체를 사용하여 데이터 전달
    responsePort.sendPort,
  ]);

  final response = await responsePort.first;

  isolate.kill(priority: Isolate.immediate);

  return response;
}

class IsolateData {
  final String prompt;
  final String apiKey;

  IsolateData(this.prompt, this.apiKey);
}
