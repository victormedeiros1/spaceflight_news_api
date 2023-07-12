import 'package:redux/redux.dart';
import 'actions.dart';
import 'reducers.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AppState {
  final List<dynamic> newsList;
  final List<dynamic> filteredNewsList;
  final bool isLoading;
  final String searchKeyword;
  final String error;

  AppState({
    required this.newsList,
    required this.filteredNewsList,
    required this.isLoading,
    required this.searchKeyword,
    this.error = '',
  });
}

class AppStore {
  final Store<AppState> store;

  AppStore() : store = Store<AppState>(
          appStateReducer,
          initialState: AppState(
            newsList: [],
            filteredNewsList: [],
            isLoading: true,
            searchKeyword: '',
          ),
        ) {
    fetchSpaceflightNews();
  }

  Future<void> fetchSpaceflightNews() async {
    store.dispatch(FetchDataAction());

    try {
      final response = await http.get(Uri.parse(
          'https://api.spaceflightnewsapi.net/v3/articles'));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        store.dispatch(FetchDataSuccessAction(data));
      } else {
        throw Exception('Failed to load data from API');
      }
    } catch (error) {
      store.dispatch(FetchDataFailureAction(error.toString()));
    }
  }
}
