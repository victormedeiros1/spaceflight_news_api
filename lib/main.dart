import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

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
  List<dynamic> _filteredNewsList = [];
  bool _isLoading = false;
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchSpaceflightNews();
    _scrollController.addListener(_scrollListener);
  }

  Future<void> fetchSpaceflightNews() async {
    setState(() {
      _isLoading = true;
    });

    final response = await http
        .get(Uri.parse('https://api.spaceflightnewsapi.net/v3/articles'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      setState(() {
        _newsList.addAll(data);
        _filteredNewsList.addAll(data);
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
      throw Exception('Failed to load data from API');
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

  void _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange &&
        !_isLoading) {
      fetchSpaceflightNews();
    }
  }

  void _filterNews(String keyword) {
    setState(() {
      _filteredNewsList = _newsList.where((news) {
        final title = news['title'].toString().toLowerCase();
        final summary = news['summary'].toString().toLowerCase();
        return title.contains(keyword.toLowerCase()) ||
            summary.contains(keyword.toLowerCase());
      }).toList();
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    _searchController.dispose();
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
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(16.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  labelText: 'Pesquisar',
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: (value) => _filterNews(value),
              ),
            ),
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                itemCount: _filteredNewsList.length + 1,
                itemBuilder: (context, index) {
                  if (index < _filteredNewsList.length) {
                    final news = _filteredNewsList[index];
                    final title = news['title'];
                    final description = (news['summary'] as String)
                        .split(' ')
                        .take(20)
                        .join(' ');
                    final isDescriptionTruncated =
                        (news['summary'] as String).split(' ').length > 20;
                    final truncatedDescription = isDescriptionTruncated
                        ? '$description...'
                        : description;
                    final publishedDate = news['publishedAt'];
                    final formattedDate = publishedDate != null
                        ? DateFormat('dd MMMM yyyy')
                            .format(DateTime.parse(publishedDate))
                        : 'Indisponível';
                    final imageUrl = news['imageUrl'];

                    return Container(
                      margin: EdgeInsets.symmetric(vertical: 10.0),
                      child: ListTile(
                        leading: imageUrl != null
                            ? Image.network(
                                imageUrl,
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                              )
                            : Container(),
                        title: Text('${index + 1}. $title'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(truncatedDescription),
                            if (isDescriptionTruncated)
                              Text(
                                'Leia mais sobre...',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            SizedBox(height: 4.0),
                            Text(
                              'Data de Publicação: $formattedDate',
                              style: TextStyle(
                                fontSize: 12.0,
                                color: Colors.grey[600],
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
          ],
        ),
      ),
    );
  }
}
