import 'package:flutter/material.dart';

class TaskCard extends StatelessWidget {
  final String title, descreption;

  const TaskCard({this.title, this.descreption});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Container(
          width: double.infinity,
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title ?? "(Unnamed Task)",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              Divider(),
              SizedBox(
                height: 15,
              ),
              Text(
                descreption ?? "No Descreption",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                  height: 1.5,
                ),
              ),
            ],
          )),
    );
  }
}

class TodoWidget extends StatelessWidget {
  final String title;
  final bool isDone;

  const TodoWidget({this.title, this.isDone});

  //bool v=false;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 35),
        child: Row(
          children: [
            Icon(
              isDone == false
                  ? Icons.check_box_outline_blank_outlined
                  : Icons.check_box,
              color: isDone == false ? Colors.grey : Colors.green,
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                    color: isDone == false ? Colors.grey : Colors.black),
              ),
            )
          ],
        ),
      ),
      /*Column(
        children: [
          CheckboxListTile(value: isDone?? false, onChanged: (val){}, title: Text(title??"majd", style: TextStyle(color: Colors.black),),),
        ],
      ),*/
    );
  }
}

class NoGlowBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
