import 'package:flutter/material.dart';
import 'package:frontend/main.dart';
import 'package:frontend/models/UserModel.dart';

class Userscreen extends StatefulWidget {
  int index;
  List<UsersModel> users;
  Userscreen({super.key, this.index = 0, required this.users});
  @override
  State<Userscreen> createState() => _UserscreenState();
}

class _UserscreenState extends State<Userscreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("${widget.users[widget.index].name}ni profili"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 50),
              Padding(
                padding: EdgeInsetsGeometry.symmetric(horizontal: 10),
                child: Container(
                  height: 600,
                  color: Color.fromARGB(255, 138, 138, 138),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          "${widget.users[widget.index].name}",
                          style: TextStyle(fontSize: 40),
                        ),
                      ),
                      Text(
                        "ID: ${widget.users[widget.index].id}",
                        style: TextStyle(fontSize: 20),
                      ),
                      Text(
                        "Name: ${widget.users[widget.index].name}",
                        style: TextStyle(fontSize: 20),
                      ),
                      Text(
                        "Email: ${widget.users[widget.index].email}",
                        style: TextStyle(fontSize: 20),
                      ),
                      Text(
                        "Role: ${widget.users[widget.index].role}",
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
