import 'package:http/http.dart' as http;

class ARAIService {
  final String base = 'https://j8a401.p.ssafy.io/ai';

  Future<String> postPictureAndGetWord({required String path}) async {
    var request =
        http.MultipartRequest('POST', Uri.parse('$base/predictions/drawings'))
          ..files.add(await http.MultipartFile.fromPath('file', path));
    var response = await request.send();
    if (response.statusCode == 200) print(response.toString());
    return response.toString();
  }
}
