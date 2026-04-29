
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/post.dart';
import '../models/comment.dart';
import '../models/user.dart';

class ApiService {
  final String baseUrl = "https://jsonplaceholder.typicode.com";

  Future<List<Post>> getPosts() async {
    final res = await http.get(Uri.parse("$baseUrl/posts"));
    final data = json.decode(res.body);
    return data.map<Post>((e) => Post.fromJson(e)).toList();
  }

  Future<List<Comment>> getComments(int postId) async {
    final res = await http.get(Uri.parse("$baseUrl/comments?postId=$postId"));
    final data = json.decode(res.body);
    return data.map<Comment>((e) => Comment.fromJson(e)).toList();
  }

  Future<User> getUser(int id) async {
    final res = await http.get(Uri.parse("$baseUrl/users/$id"));
    return User.fromJson(json.decode(res.body));
  }
}
