part of 'news_bloc.dart';

abstract class NewsState {
  List<Article> featuredNews;
  List<Article> latestNews;

  NewsState({required this.featuredNews, required this.latestNews});
}

class NewsInitialState extends NewsState {
  NewsInitialState() : super(featuredNews: [], latestNews: []);
}

class NewsLoadingState extends NewsState {
  NewsLoadingState() : super(featuredNews: [], latestNews: []);
}

class NewsLoadedState extends NewsState {
  final List<Article> featuredNews;
  final List<Article> latestNews;

  NewsLoadedState({required this.featuredNews, required this.latestNews})
      : super(featuredNews: featuredNews, latestNews: latestNews);
}

class NewsErrorState extends NewsState {
  NewsErrorState() : super(featuredNews: [], latestNews: []);
}
