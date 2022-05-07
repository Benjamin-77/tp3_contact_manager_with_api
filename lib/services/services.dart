import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';


class SQLHelper {
  static Future<User> createUser(User user) async {
    String link="https://ifri.raycash.net/adduser";
    final response = await http.post(
      Uri.parse(link),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(user.toJson()),
    );
    print("##########################################");
    print(response.body);
    print("##########################################");
    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create a User');
    }
  }

  static Future<List<User>> getUsers() async {
    List<Map<String, dynamic>> jsons =[];
    List<User> users =[];

    final response = await http.get(Uri.parse('https://ifri.raycash.net/getusers'));
    var jsonss = json.decode(response.body);

    for (var i in jsonss['message']) {
        users.add(User.fromJson(i));
    }

    return users;
  }

  static Future<User> getUser(User user) async {

    String link="https://ifri.raycash.net/getuser/";
    link=link+user.getId();
    Map<String,dynamic> myjson ={};

    final response = await http.get(Uri.parse(link));
    var jsonss = json.decode(response.body);

    if(jsonss.length>0){
      myjson = jsonss['message'];
      user = User.fromJson(myjson);
    }

    return user;
  }


  static Future<User> updateUser(User user) async {
    String link="https://ifri.raycash.net/updateuser/"+user.getId();

    final response = await http.post(
        Uri.parse(link),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(user.toJson()),
      );

      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        print(jsonDecode(response.body));
        return User.fromJson(jsonDecode(response.body));
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        throw Exception('Failed to update album.');
      }
  }

  static Future<void> deleteUser(User user) async {
    /*
    final db = await SQLHelper.db();
    try {
      await db.delete("users", where: "id = ?", whereArgs: [user.getId()]);
    } catch (err) {
      debugPrint("Quelque chose s'est mal passé lors de la suppression : $err");
    }
    */
  }
}