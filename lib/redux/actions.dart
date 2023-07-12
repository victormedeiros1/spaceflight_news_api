class FetchDataAction {}

class FetchDataSuccessAction {
  final List<dynamic> data;

  FetchDataSuccessAction(this.data);
}

class FetchDataFailureAction {
  final String error;

  FetchDataFailureAction(this.error);
}

class UpdateSearchKeywordAction {
  final String keyword;

  UpdateSearchKeywordAction(this.keyword);
}

class FilterNewsAction {
  final String keyword;

  FilterNewsAction(this.keyword);
}