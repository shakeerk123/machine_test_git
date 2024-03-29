import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> repos = [];
   int currentPage = 1;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchGitHubRepos();
  }

  Future<void> fetchGitHubRepos() async {
     if (isLoading) return;
    setState(() {
      isLoading = true;
    });
    String uri =
        "https://api.github.com/search/repositories?q=created:>2022-04-29&sort=stars&order=desc";
    final response = await http.get(Uri.parse(uri));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      setState(() {
        repos = List<Map<String, dynamic>>.from(data['items']);
         currentPage++;
        isLoading = false;
      });
    } else {
       setState(() {
        isLoading = false;
      });
      throw Exception('Failed to load GitHub repos');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text('GitHub Top Repos',style:GoogleFonts.poppins(fontSize: 15,fontWeight: FontWeight.bold),)
      ),
      body: ListView.builder(
        itemCount: repos.length + 1,
        itemBuilder: (BuildContext context, int index) {
          if (index == repos.length) {
                  return isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : ElevatedButton(
                          onPressed: fetchGitHubRepos,
                          child:const Text('Load More'),
                        );
                }
          final repo = repos[index];
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(shadowColor: Colors.white,
              
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        ClipRRect(borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            repo['owner']['avatar_url'],
                            height: 100,
                            width: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Container(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(height: 5),
                               Text(
                                repo['owner']['login'],style:GoogleFonts.poppins(fontSize: 15,fontWeight: FontWeight.bold),
                              ),
                              Text(
                                repo['name'],style:GoogleFonts.poppins(fontSize: 13),
                              ),
                              Container(height: 5),
                              Text(
                                   repo['description'] ?? 'No description' ,style:GoogleFonts.poppins(fontSize: 12),
                              ),
                              Container(height: 10),
                              Text(
                                '${repo['stargazers_count']} stars',style:GoogleFonts.poppins(fontSize: 15,),
                              
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
