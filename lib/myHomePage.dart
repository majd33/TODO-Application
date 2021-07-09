import 'package:flutter/material.dart';
import 'package:todo_app/database_helper.dart';
import 'package:todo_app/taskPage.dart';
import 'package:todo_app/widgets.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DatabaseHelper _dbHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Colors.grey[200],
          width: double.infinity,
          padding: EdgeInsets.all(10),
          child: Column(children: [
            Image.asset(
              'assets/myicon.png',
              width: 175,
              height: 175,
            ),
            Expanded(
              child: FutureBuilder(
                initialData: [],
                future: _dbHelper.getTasks(),
                builder: (context, snapshot) {
                  return snapshot.data.length == 0
                      ? Center(
                          child: Text(
                          "No Tasks",
                        ))
                      : ScrollConfiguration(
                          behavior: NoGlowBehavior(),
                          child: ListView.builder(
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => TaskPage(
                                                  task: snapshot.data[index],
                                                ))).then((value) {
                                      setState(() {});
                                    });
                                  },
                                  child: TaskCard(
                                    title: snapshot.data[index].title,
                                    descreption:
                                        snapshot.data[index].description,
                                  ));
                            },
                            itemCount: snapshot.data.length,
                          ),
                        );
                },
              ),
            ),
          ]),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.deepOrange,
        onPressed: () {
          Navigator.push(
                  context, MaterialPageRoute(builder: (context) => TaskPage()))
              .then((value) {
            setState(() {});
          });
        },
      ),
    );
  }
}
