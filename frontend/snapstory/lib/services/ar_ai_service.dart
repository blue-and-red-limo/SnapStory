import 'dart:convert';

import 'package:http/http.dart' as http;

class ARAIService {
  final String base = 'https://j8a401.p.ssafy.io/ai';

  Future<String> postPictureAndGetWord({required String path}) async {
    var request =
        http.MultipartRequest('POST', Uri.parse('$base/predictions/drawings'))
          ..files.add(await http.MultipartFile.fromPath('file', path));
    var response = await request.send();
    if (response.statusCode == 200) {
      return response.stream.bytesToString();
    } else {
      return 'CANNOT GET WORD';
    }
  }

  final String apiKey = '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';
  final String apiUrl = 'https://api.openai.com/v1/completions';

  Future<String> generateText(String obj) async {
    var response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey'
      },
      body: jsonEncode({
        "model": "text-davinci-003",
        'prompt':
            'make a instructive story about $obj in 7 sentence for kids. And give me one sentence about this storys image by using this templete: "image: your answer',
        'max_tokens': 1000,
        'temperature': 0,
        'top_p': 1,
        'frequency_penalty': 0,
        'presence_penalty': 0
      }),
    );
    print(response.body.toString());

    Map<String, dynamic> newresponse =
        jsonDecode(utf8.decode(response.bodyBytes));

    return newresponse['choices'][0]['text'];
  }
}
