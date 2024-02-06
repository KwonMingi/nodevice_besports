import 'dart:convert';
import 'package:http/http.dart' as http;

const apiKey = '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';
const apiUrl = 'https://api.openai.com/v1/engines/text-davinci-002/completions';

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

Future<String> fetchGPTResponse(String prompt) async {
  const url = apiUrl;
  final headers = {
    'Authorization': 'Bearer $apiKey', // 여기에 실제 API 키를 넣으세요
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  var response = await http.post(
    Uri.parse(url),
    headers: headers,
    body: jsonEncode({
      'prompt': prompt,
      'max_tokens': 100,
      'temperature': 0.5,
    }),
  );

  if (response.statusCode == 200) {
    var data = json.decode(response.body);
    return data['choices'][0]['text'].trim();
  } else {
    return "Error: ${response.reasonPhrase}";
  }
}
