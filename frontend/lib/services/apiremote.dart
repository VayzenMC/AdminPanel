import 'package:frontend/models/UserModel.dart';
import 'package:http/http.dart' as http;

// https://jsonplaceholder.typicode.com/users
abstract class UserAPI {
  static Future<List<UsersModel>> getUsers() async {
    final response = await http.get(Uri.parse('http://127.0.0.1:8000/users'));
    if (response.statusCode == 200) {
      print(response.body);
      return usersModelFromJson(response.body);
    }
    return [];
  }
}
