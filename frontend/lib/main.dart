import 'package:flutter/material.dart';
import 'package:frontend/models/UserModel.dart';
import 'package:frontend/screen/userScreen.dart';
import 'package:frontend/services/apiremote.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Demo',
      home: MyHomePage(title: 'Admin Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<UsersModel> _users = [];
  bool _isLoading = true; // Yuklanish holatini kuzatish uchun

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    try {
      List<UsersModel> users = await UserAPI.getUsers();
      setState(() {
        _users = users;
        _isLoading = false; // Ma'lumot kelgach loadingni o'chiramiz
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print("Xatolik: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            ) // Ma'lumot kelguncha spinner
          : _users.isEmpty
          ? const Center(
              child: Text("Ma'lumot topilmadi"),
            ) // Bo'sh bo'lsa xabar
          : ListView.builder(
              itemCount: _users.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsetsGeometry.symmetric(horizontal: 10),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 168, 167, 168),
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    height: 60,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    Userscreen(index: index, users: _users),
                              ),
                            );
                          },
                          child: Text(
                            _users[index].name,
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        FloatingActionButton(
                          onPressed: () async {
                            final response = await http.delete(
                              Uri.parse(
                                'http://127.0.0.1:8000/users/${_users[index].id}',
                              ),
                            );

                            loadData();
                          },
                          child: Icon(Icons.delete),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: loadData,
        child: Icon(Icons.replay_outlined),
      ),
    );
  }
}
