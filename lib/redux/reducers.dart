import 'actions.dart';
import 'store.dart';

AppState appStateReducer(AppState state, dynamic action) {
  if (action is FetchDataSuccessAction) {
    return AppState(
      newsList: action.data,
      filteredNewsList: action.data,
      isLoading: false,
      searchKeyword: state.searchKeyword,
    );
  } else if (action is FetchDataFailureAction) {
    return AppState(
      newsList: [],
      filteredNewsList: [],
      isLoading: false,
      searchKeyword: state.searchKeyword,
      error: action.error,
    );
  } else if (action is UpdateSearchKeywordAction) {
    return AppState(
      newsList: state.newsList,
      filteredNewsList: state.filteredNewsList,
      isLoading: state.isLoading,
      searchKeyword: action.keyword,
    );
  } else if (action is FilterNewsAction) {
    final filteredList = state.newsList.where((news) {
      final title = news['title'].toString().toLowerCase();
      final summary = news['summary'].toString().toLowerCase();
      return title.contains(action.keyword.toLowerCase()) ||
          summary.contains(action.keyword.toLowerCase());
    }).toList();

    return AppState(
      newsList: state.newsList,
      filteredNewsList: filteredList,
      isLoading: state.isLoading,
      searchKeyword: action.keyword,
    );
  }

  return state;
}
