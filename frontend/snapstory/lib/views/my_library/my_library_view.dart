import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:snapstory/services/ar_ai_service.dart';
import 'package:snapstory/utilities/loading_dialog.dart';

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
                  return GridView.count(
                    crossAxisCount: 3,
                    children: AITaleList.map(
                      (e) => Card(
                        elevation: 5.0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(23)),
                        child: Center(child: Text(e['wordEng'])),
                      ),
                    ).toList(),
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
