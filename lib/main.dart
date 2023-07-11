import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Future<List<dynamic>> fetchSpaceflightNews() async {
    final response = await http
        .get(Uri.parse('https://api.spaceflightnewsapi.net/v4/articles'));

    if (response.statusCode == 200) {
      // Decodifica a resposta JSON
      final List<dynamic> data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception('Falha ao carregar os dados da API');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Spaceflight News'),
        ),
        body: FutureBuilder<List<dynamic>>(
          future: fetchSpaceflightNews(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              // Exibe a lista de notícias
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final news = snapshot.data![index];
                  return ListTile(
                    title: Text(news['title']),
                    subtitle: Text(news['summary']),
                  );
                },
              );
            } else if (snapshot.hasError) {
              // Exibe uma mensagem de erro caso haja falha na busca dos dados
              return Center(
                child: Text('Erro ao carregar os dados da API'),
              );
            }
            // Exibe um indicador de progresso enquanto os dados são buscados
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}
