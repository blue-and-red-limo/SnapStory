import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:snapstory/services/ar_ai_service.dart';
import 'package:snapstory/utilities/loading_dialog.dart';
import 'package:snapstory/views/home/complete_story_view.dart';

class MyLibrary extends StatefulWidget {
  const MyLibrary({Key? key}) : super(key: key);

  @override
  State<MyLibrary> createState() => _MyLibraryState();
}

class _MyLibraryState extends State<MyLibrary> {
  late final ARAIService _araiService;
  late List AITaleList;

  @override
  void initState() {
    _araiService = ARAIService();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
        body: FutureBuilder(
      future: FirebaseAuth.instance.currentUser!.getIdToken(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Center(
            child: FutureBuilder(
              future:
                  _araiService.getAITaleList(token: snapshot.data.toString()),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  AITaleList = snapshot.data!.toList();
                  return Column(
                    children: [
                      Row(
                        children: [
                          Text('내가 만든 동화책 '),
                          Icon(Icons.menu_book_rounded),
                        ],
                      ),
                      Expanded(
                        child: GridView.count(
                          padding: const EdgeInsets.all(4),
                          childAspectRatio: (1 / 1.61803398875),
                          crossAxisCount: 3,
                          children: AITaleList.map(
                            (AITale) => Column(
                              children: [
                                Container(
                                  height:
                                      (MediaQuery.of(context).size.width - 32) /
                                          3 *
                                          1.61803398875 - 11,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(23),
                                    // border: Border.all(
                                    //     width: 5,
                                    //     color: const Color(0xffFFCA10)),
                                    // color: const Color(0xffFFF0BB),
                                  ),
                                  margin: const EdgeInsets.all(4),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => CompleteStory(
                                              fairyTale: AITale['aiTaleId']),
                                        ),
                                      );
                                    },
                                    child: Image.network(
                                      AITale['image'],
                                      fit: BoxFit.fitHeight,
                                    ),
                                  ),
                                ),
                                Text(AITale['wordEng']),
                              ],
                            ),
                          ).toList(),
                        ),
                      ),
                    ],
                  );
                } else {
                  return const LoadingDialog();
                }
              },
            ),
          );
        } else {
          return const LoadingDialog();
        }
      },
    ));
  }
}
