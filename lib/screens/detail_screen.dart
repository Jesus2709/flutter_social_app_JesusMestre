import 'package:flutter/material.dart';
import '../models/post.dart';
import '../services/api_service.dart';
import '../models/comment.dart';
import '../models/user.dart';

class DetailScreen extends StatefulWidget {
  final Post post;

  const DetailScreen({super.key, required this.post});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final api = ApiService();
  late Future<List<Comment>> comments;
  late Future<User> user;

  @override
  void initState() {
    super.initState();
    comments = api.getComments(widget.post.id);
    user = api.getUser(widget.post.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detalle"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔥 TÍTULO CON GRADIENTE
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.deepPurple, Colors.pinkAccent],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                widget.post.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 15),
            Text(widget.post.body),

            const SizedBox(height: 20),

            // 👤 USUARIO
            FutureBuilder<User>(
              future: user,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const CircularProgressIndicator();
                }

                final u = snapshot.data!;

                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Colors.purple,
                      child: Icon(Icons.person, color: Colors.white),
                    ),
                    title: Text(u.name),
                    subtitle: Text("${u.email} • ${u.city}"),
                  ),
                );
              },
            ),

            const SizedBox(height: 20),

            const Text(
              "Comentarios",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            // 💬 COMENTARIOS
            FutureBuilder<List<Comment>>(
              future: comments,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const CircularProgressIndicator();
                }

                return Column(
                  children: snapshot.data!
                      .map(
                        (c) => Card(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 3,
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.deepPurple,
                              child: Text(c.name[0].toUpperCase()),
                            ),
                            title: Text(c.name),
                            subtitle: Text(c.body),
                            trailing: Text(
                              c.email,
                              style: const TextStyle(fontSize: 10),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}