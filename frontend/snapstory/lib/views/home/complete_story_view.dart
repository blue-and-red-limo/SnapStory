import 'dart:io';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:path/path.dart' as p;
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:snapstory/views/home/home_view.dart';
import 'package:snapstory/views/home/make_story_view.dart';
import 'package:snapstory/views/main_view.dart';
import 'package:http/http.dart' as http;
import 'package:snapstory/views/my_library/my_library_view.dart';
import 'package:network_to_file_image/network_to_file_image.dart';

class CompleteStory extends StatefulWidget {
  const CompleteStory({Key? key, required this.fairyTale}) : super(key: key);

  final FairyTale fairyTale;

  @override
  State<CompleteStory> createState() => _CompleteStoryState();
}



class _CompleteStoryState extends State<CompleteStory> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Image.network(widget.fairyTale.image),
              Text(widget.fairyTale.contentEng),
              OutlinedButton(onPressed: (){
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const MainView(selectedPage: 1)),
                );
              }, child: const Text("나만의 도서관 가기")),

           ],
          ),
        ),
      ),
    );
  }


}
