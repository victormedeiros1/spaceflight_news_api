import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Importar o pacote intl

class NewsDetailsPage extends StatelessWidget {
  final Map<String, dynamic> news;

  NewsDetailsPage({required this.news});

  @override
  Widget build(BuildContext context) {
    final publishedDate = news['publishedAt'];
    final formattedDate = publishedDate != null
        ? DateFormat('dd MMMM yyyy').format(DateTime.parse(publishedDate))
        : 'Indisponível';

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
              'Data de Publicação: $formattedDate',
              style: TextStyle(
                fontSize: 12.0,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              news['summary'],
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Fonte: ${news['newsSite']}',
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
