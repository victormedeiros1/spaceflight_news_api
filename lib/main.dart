import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'news_details.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Future<List<dynamic>> fetchSpaceflightNews() async {
    final response = await http
        .get(Uri.parse('https://api.spaceflightnewsapi.net/v3/articles'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception('Falha ao carregar os dados da API');
    }
  }

  void _navigateToNewsDetails(BuildContext context, Map<String, dynamic> news) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NewsDetailsPage(news: news),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Spaceflight News - Nóticias sobre o espaço!'),
        ),
        body: FutureBuilder<List<dynamic>>(
          future: fetchSpaceflightNews(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final news = snapshot.data![index];
                  final description =
                      (news['summary'] as String).split(' ').take(20).join(' ');
                  final isDescriptionTruncated =
                      (news['summary'] as String).split(' ').length > 20;
                  final truncatedDescription =
                      isDescriptionTruncated ? '$description...' : description;

                  return ListTile(
                    title: Text(news['title']),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(truncatedDescription),
                        if (isDescriptionTruncated)
                          Text('Clique para ver mais'),
                      ],
                    ),
                    onTap: () => _navigateToNewsDetails(context, news),
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Erro ao carregar os dados da API'),
              );
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}
