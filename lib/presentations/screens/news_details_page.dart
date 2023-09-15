import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forestvpn_test/logic/bloc/news_bloc.dart';
import 'package:forestvpn_test/presentations/widgets/carousel_item.dart';
import 'package:forestvpn_test/repositories/news/models/article.dart';

class NewsDetailsPage extends StatelessWidget {
  final Article news;

  const NewsDetailsPage({super.key, required this.news});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            elevation: 0,
            backgroundColor: const Color(0xFFF9F9F9),
            expandedHeight: MediaQuery.of(context).size.height / 2,
            floating: false,
            pinned: true,
            flexibleSpace: ClipRRect(
              borderRadius: BorderRadiusDirectional.circular(15),
              child: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
                bool top = constraints.biggest.height > MediaQuery.of(context).padding.top + kToolbarHeight;
                return FlexibleSpaceBar(
                  centerTitle: true,
                  titlePadding: const EdgeInsets.all(20),
                  title: Text(
                    news.title,
                    style: TextStyle(color: top ? Colors.white : Colors.black, fontWeight: FontWeight.w400),
                  ),
                  background: Image.network(
                    news.imageUrl,
                    colorBlendMode: BlendMode.darken,
                    color: Colors.black.withOpacity(0.7),
                    fit: BoxFit.cover,
                  ),
                );
              }),
            ),
          ),
          SliverFillRemaining(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: Column(
                  children: [
                    if (news.description != null && news.description!.isNotEmpty)
                      Text(
                        news.description!,
                        style: const TextStyle(fontSize: 16),
                      ),
                    const SizedBox(height: 15),
                    SizedBox(
                      height: 250,
                      child: BlocBuilder<NewsBloc, NewsState>(
                        builder: (context, state) {
                          if (state is NewsLoadedState) {
                            final otherNews = state.latestNews.where((article) => article.id != news.id).toList();
                            final randomNews = (otherNews..shuffle()).first;
                            return CarouselItem(news: randomNews, setWidth: true);
                          }
                          return const CircularProgressIndicator();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
