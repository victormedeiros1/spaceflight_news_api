import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'redux/actions.dart';
import 'redux/store.dart';
import 'news_details.dart';

void main() {
  final store = AppStore().store;

  store.dispatch(FetchDataAction());
  runApp(MyApp(store: store));
}

class MyApp extends StatelessWidget {
  final Store<AppState> store;

  MyApp({required this.store});

  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
      store: store,
      child: MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.purple,
        ),
        home: Scaffold(
          appBar: AppBar(
            title: const Text('Spaceflight News'),
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: StoreConnector<AppState, VoidCallback>(
                  converter: (store) {
                    return () {
                      store.dispatch(
                          FilterNewsAction(store.state.searchKeyword));
                    };
                  },
                  builder: (context, callback) {
                    return TextField(
                      decoration: const InputDecoration(
                        labelText: 'Search',
                        prefixIcon: Icon(Icons.search),
                      ),
                      onChanged: (value) {
                        store.dispatch(UpdateSearchKeywordAction(value));
                        callback();
                      },
                    );
                  },
                ),
              ),
              Expanded(
                child: StoreConnector<AppState, AppState>(
                  converter: (store) => store.state,
                  builder: (context, state) {
                    return ListView.builder(
                      itemCount: state.filteredNewsList.length + 1,
                      itemBuilder: (context, index) {
                        if (index < state.filteredNewsList.length) {
                          final news = state.filteredNewsList[index];
                          final title = news['title'];
                          final description = (news['summary'] as String)
                              .split(' ')
                              .take(20)
                              .join(' ');
                          final isDescriptionTruncated =
                              (news['summary'] as String).split(' ').length >
                                  20;
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
                            margin: const EdgeInsets.symmetric(vertical: 10.0),
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
                                    const Text(
                                      'Read more about...',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  const SizedBox(height: 4.0),
                                  Text(
                                    'Published at $formattedDate',
                                    style: TextStyle(
                                      fontSize: 12.0,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      NewsDetailsPage(news: news),
                                ),
                              ),
                            ),
                          );
                        } else if (state.isLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          return Container();
                        }
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
