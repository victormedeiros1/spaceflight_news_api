import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'news_details.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ScrollController _scrollController = ScrollController();
  List<dynamic> _newsList = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchSpaceflightNews();
    _scrollController.addListener(_scrollListener);
  }

  Future<List<dynamic>> fetchSpaceflightNews() async {
    setState(() {
      _isLoading = true;
    });

    final response = await http
        .get(Uri.parse('https://api.spaceflightnewsapi.net/v3/articles'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      setState(() {
        _newsList.addAll(data);
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
      throw Exception('Falha ao carregar os dados da API');
    }
    return _newsList;
  }

  void _navigateToNewsDetails(BuildContext context, Map<String, dynamic> news) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NewsDetailsPage(news: news),
      ),
    );
  }

  void _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      fetchSpaceflightNews();
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
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
        body: ListView.builder(
          controller: _scrollController,
          itemCount: _newsList.length + 1,
          itemBuilder: (context, index) {
            if (index < _newsList.length) {
              final news = _newsList[index];
              final description =
                  (news['summary'] as String).split(' ').take(20).join(' ');
              final isDescriptionTruncated =
                  (news['summary'] as String).split(' ').length > 20;
              final truncatedDescription =
                  isDescriptionTruncated ? '$description...' : description;

              return Container(
                margin: EdgeInsets.symmetric(vertical: 10.0),
                child: ListTile(
                  title: Text(news['title']),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(truncatedDescription),
                      if (isDescriptionTruncated)
                        Text(
                          'Clique aqui para ver mais...',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                    ],
                  ),
                  onTap: () => _navigateToNewsDetails(context, news),
                ),
              );
            } else if (_isLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}
