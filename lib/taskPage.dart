import 'package:flutter/material.dart';
import 'package:todo_app/database_helper.dart';
import 'package:todo_app/models/todo.dart';
import 'package:todo_app/widgets.dart';

import 'models/tasks.dart';

class TaskPage extends StatefulWidget {
  final Task task;

  TaskPage({@required this.task});

  @override
  _TaskPageState createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  TextEditingController myController=TextEditingController();
  int myid;
  var title, des, todo;
  DatabaseHelper _myDbhelper = DatabaseHelper();
  FocusNode titleFocus, desFocus, todoFocus;
  bool contentVisile = false;

  @override
  void initState() {
    if (widget.task != null) {
      contentVisile = true;
      title = widget.task.title;
      des = widget.task.description;

      myid = widget.task.id;
    } else
      myid = 0;

    titleFocus = FocusNode();
    desFocus = FocusNode();
    todoFocus = FocusNode();

    super.initState();
  }

  @override
  void dispose() {
    titleFocus.dispose();
    desFocus.dispose();
    todoFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
            child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                    padding: EdgeInsets.symmetric(vertical: 30, horizontal: 25),
                    child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(
                          Icons.arrow_back,
                        ))),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                  child: Visibility(
                      visible: myid == 0 ? false : true,
                      child: IconButton(
                          icon: Icon(
                            Icons.delete_forever,
                            color: Colors.red,
                            size: 40,
                          ),
                          onPressed: myid == 0
                              ? null
                              : () async {
                                  await deleteTask();
                                  Navigator.pop(context);
                                })),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: TextField(
                focusNode: titleFocus,
                decoration: InputDecoration(
                  hintText: "Enter Task Title ...",
                ),
                onChanged: (value) {
                  if (value != null) {
                    title = value;
                  }
                  titleFocus.requestFocus();
                },
                controller: TextEditingController()..text = title,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: TextField(
                focusNode: desFocus,
                onChanged: (value) {
                  des = value;

                  desFocus.requestFocus();
                },
                decoration: InputDecoration(
                  hintText: "Enter description for the Task ...",
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                ),
                controller: TextEditingController()..text = des,
              ),
            ),
            Visibility(
              visible: contentVisile,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 35),
                child: Row(
                  children: [
                    Icon(Icons.check_box_outline_blank_outlined),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: TextField(
                        focusNode: todoFocus,
                        onChanged: (val) async {
                          setState(() {
                            todo = val;
                          });
                          todoFocus.requestFocus();
                          print("$val");
                        },
                        decoration: InputDecoration(
                            suffixIcon: IconButton(
                                icon: Icon(Icons.add),
                                onPressed: () async {
                                  if (todo != null && widget.task != null) {
                                    await addTodo();
                                    myController.clear();
                                  }
                                }),
                            hintText: "Enter Task item...",
                            border: InputBorder.none),
                        controller: myController,
                      ),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            FutureBuilder(
                initialData: [],
                future: _myDbhelper.getTodo(myid),
                builder: (context, snap) {
                  return Expanded(
                    child: ListView.builder(
                      itemCount: snap.data.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.all(10.0),
                          child: GestureDetector(
                              onTap: () async {
                                if (snap.data[index].isDone == 0)
                                  await updateTodo(snap.data[index].id, 1);
                                else
                                  await updateTodo(snap.data[index].id, 0);

                                setState(() {});
                              },
                              child: TodoWidget(
                                title: snap.data[index].title == null
                                    ? "Unnamed"
                                    : snap.data[index].title,
                                isDone:
                                    snap.data[index].isDone == 0 ? false : true,
                              )),
                        );
                      },
                    ),
                  );
                }),
          ],
        )),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.done),
        onPressed: () async {
          if (title != null && des != null) {
            if (widget.task == null) {
              await addTask();
              print("donnnnnnnnne");
              Navigator.pop(context);
            } else {
              await updateTask();
              await updateDes();
              print("update");
              Navigator.pop(context);
            }
          }
        },
        backgroundColor: Colors.lightBlue,
      ),
    );
  }

  addTodo() async {
    DatabaseHelper _dbhelper2 = DatabaseHelper();
    Todo _newTodo = Todo(title: todo, taskId: myid, isDone: 0);
    await _dbhelper2.insertTodo(_newTodo);
  }

  addTask() async {
    DatabaseHelper _dbhelper = DatabaseHelper();
    Task _newTask = Task(title: title, description: des);
    await _dbhelper.insertTask(_newTask);
  }

  updateTask() {
    DatabaseHelper _dbhelper = DatabaseHelper();
    _dbhelper.updateTaskTitle(myid, title);
  }

  updateDes() {
    DatabaseHelper _dbhelper = DatabaseHelper();
    _dbhelper.updateTaskDes(myid, des);
  }

  updateTodo(int id, int done) async {
    DatabaseHelper _dbhelper = DatabaseHelper();
    await _dbhelper.updateTodo(id, done);
  }

  deleteTask() async {
    DatabaseHelper _dbhelper = DatabaseHelper();
    await _dbhelper.deleteTask(myid);
  }
}
