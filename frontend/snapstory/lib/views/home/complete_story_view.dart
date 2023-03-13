import 'package:flutter/material.dart';
import 'package:snapstory/views/home/home_view.dart';
import 'package:snapstory/views/home/make_story_view.dart';
import 'package:snapstory/views/main_view.dart';
import 'package:snapstory/views/my_library/my_library_view.dart';

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
              Image.network(widget.fairyTale.img),
              Text(widget.fairyTale.text),
              OutlinedButton(onPressed: (){
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const MainView(selectedPage: 1)),
                );
              }, child: Text("나만의 도서관 가기"))
           ],
          ),
        ),
      ),
    );
  }
}
