import 'package:bloc/bloc.dart';
import 'package:forestvpn_test/repositories/news/repository.dart';

part 'news_event.dart';
part 'news_state.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  final AbstractNewsRepository repository;

  NewsBloc({required this.repository}) : super(NewsInitialState()) {
    on<GetNewsEvent>(_onGetNewsEvent);
    on<MarkAllAsReadEvent>(_onMarkAllAsReadEvent);
  }

  Future<void> _onGetNewsEvent(GetNewsEvent event, Emitter<NewsState> emit) async {
    emit(NewsLoadingState());
    try {
      final featuredNews = await repository.getFeaturedArticles();
      final latestNews = await repository.getLatestArticles();
      emit(NewsLoadedState(featuredNews: featuredNews, latestNews: latestNews));
    } catch (e) {
      emit(NewsErrorState());
    }
  }

  Future<void> markNewsAsReaded(String id) async {
    try {
      final news = await repository.getArticle(id);
      news.readed = true;

      final oldNewsIndex = state.featuredNews.indexWhere((article) => article.id == id);
      if (oldNewsIndex != -1) {
        state.featuredNews[oldNewsIndex] = news;
      } else {
        final oldNewsIndex = state.latestNews.indexWhere((article) => article.id == id);
        if (oldNewsIndex != -1) {
          state.latestNews[oldNewsIndex] = news;
        }
      }

      final featuredNews = state.featuredNews ?? []; // Default to empty list if null
      final latestNews = state.latestNews ?? []; // Default to empty list if null

      emit(NewsLoadedState(featuredNews: featuredNews, latestNews: latestNews));
    } catch (e) {
      emit(NewsErrorState());
    }
  }

  Future<void> _onMarkAllAsReadEvent(MarkAllAsReadEvent event, Emitter<NewsState> emit) async {
    try {
      final featuredNews = await repository.getFeaturedArticles();
      final latestNews = await repository.getLatestArticles();

      for (var article in featuredNews) {
        article.readed = true;
      }

      for (var article in latestNews) {
        article.readed = true;
      }

      emit(NewsLoadedState(featuredNews: featuredNews, latestNews: latestNews));
    } catch (e) {
      emit(NewsErrorState());
    }
  }

  Future<void> updateSingleNews(String id) async {
    try {
      final news = await repository.getArticle(id);

      final oldNewsIndex = state.featuredNews.indexWhere((article) => article.id == id);
      if (oldNewsIndex != -1) {
        state.featuredNews[oldNewsIndex] = news;
      } else {
        final oldNewsIndex = state.latestNews.indexWhere((article) => article.id == id);
        if (oldNewsIndex != -1) {
          state.latestNews[oldNewsIndex] = news;
        }
      }

      final featuredNews = state.featuredNews ?? []; // Default to empty list if null
      final latestNews = state.latestNews ?? []; // Default to empty list if null

      emit(NewsLoadedState(featuredNews: featuredNews, latestNews: latestNews));
    } catch (e) {
      emit(NewsErrorState());
    }
  }
}
