import 'dart:convert';

import 'package:http/http.dart' as http;

class ARAIService {
  final String aiBase = 'https://j8a401.p.ssafy.io/ai';
  final String springBase = 'https://j8a401.p.ssafy.io/api/v1';
  final String apiKey = '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';
  final String apiUrl = 'https://api.openai.com/v1/completions';

  Future<String> postPictureAndGetWord({required String path}) async {
    var request =
        http.MultipartRequest('POST', Uri.parse('$aiBase/predictions/objects'))
          ..files.add(await http.MultipartFile.fromPath('file', path));
    var response = await request.send();
    if (response.statusCode == 200) {
      return response.stream.bytesToString();
    } else {
      return 'CANNOT GET WORD';
    }
  }


  Future<Map<String, String>> generateText({required String obj, required String token}) async {
    var response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey'
      },
      body: jsonEncode({
        "model": "text-davinci-003",
        'prompt':
            'give me one simple sentence about $obj and translation of that in korean too',
        'max_tokens': 1000,
        'temperature': 0,
        'top_p': 1,
        'frequency_penalty': 0,
        'presence_penalty': 0
      }),
    );

    Map<String, dynamic> newresponse =
        jsonDecode(utf8.decode(response.bodyBytes));
    List<String> str = newresponse['choices'][0]['text'].split('\n');
    Map<String, String> result = {'word':obj, 'wordExampleKor':str[3].toString(), 'wordExampleEng':str[2].toString()};


    final res = await http.post(
      Uri.parse('$springBase/word-list'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(result),
    );

    return result;
  }
}
