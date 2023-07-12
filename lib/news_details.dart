import 'package:flutter/material.dart';

class NewsDetailsPage extends StatelessWidget {
  final Map<String, dynamic> news;

  NewsDetailsPage({required this.news});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes da Notícia'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              news['title'],
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              news['summary'],
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 16.0),
            Text(
              'Data de Publicação: ${news['publishedAt']}',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 16.0),
            Text(
              'URL: ${news['url']}',
              style: TextStyle(fontSize: 16.0),
            ),
          ],
        ),
      ),
    );
  }
}
