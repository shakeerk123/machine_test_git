import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class GitHubReposScreen extends StatefulWidget {
  @override
  _GitHubReposScreenState createState() => _GitHubReposScreenState();
}

class _GitHubReposScreenState extends State<GitHubReposScreen> {
  List<Map<String, dynamic>> repos = [];

  @override
  void initState() {
    super.initState();
    fetchGitHubRepos();
  }

  Future<void> fetchGitHubRepos() async {
    String uri =
        "https://api.github.com/search/repositories?q=created:>2022-04-29&sort=stars&order=desc";
    final response = await http.get(Uri.parse(uri));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      setState(() {
        repos = List<Map<String, dynamic>>.from(data['items']);
      });
    } else {
      throw Exception('Failed to load GitHub repos');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GitHub Top Repos'),
      ),
      body: ListView.builder(
        itemCount: repos.length,
        itemBuilder: (BuildContext context, int index) {
          final repo = repos[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(repo['owner']['avatar_url']),
            ),
            title: Text(repo['name']),
            subtitle: Text(repo['description'] ?? 'No description'),
            trailing: Text('${repo['stargazers_count']} stars'),
            onTap: () {
              // You can implement onTap functionality here
            },
          );
        },
      ),
    );
  }
}
