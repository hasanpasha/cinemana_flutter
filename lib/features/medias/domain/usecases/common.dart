class PagedParams {
  PagedParams({this.page});

  int? page;

  PagedParams copyWith({int? page}) => PagedParams(page: page);
}
