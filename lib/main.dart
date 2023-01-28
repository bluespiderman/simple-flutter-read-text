import 'package:flutter/material.dart';
import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;
import 'package:html/parser.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Text File Asset'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;
  List<String> list = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(this.title),
      ),
      body: FutureBuilder(
        future: loadAsset(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Container(
                child: Center(
                  child: Text('Has Error'),
                ),
              );
            }

            String origin = snapshot.data.toString();

            var regExp = RegExp(r'src=\\"http:(.*?)(?=")');
            var images =
                regExp.allMatches(origin).map(((e) => e.group(0))).toList();
            for (int i = 0; i < images.length; i++) {
              images[i] = images[i]!.replaceAll(r'\', '').substring(5);
              list.add(images[i].toString());
            }
            print(list[0]);
            print(list[1]);
            return GridView.builder(
                itemCount: images.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                itemBuilder: (context, index) {
                  return Padding(
                      padding: EdgeInsets.all(5),
                      child: Container(
                        decoration: new BoxDecoration(
                            image: DecorationImage(
                                image: NetworkImage(list[index]))),
                      ));
                });
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

Future<String> loadAsset() async {
  return await rootBundle.loadString('assets/message.txt');
}
