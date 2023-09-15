import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../logic/bloc/news_bloc.dart';
import '../widgets/carousel_item.dart';
import '../widgets/list_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isFeaturedListVisable = false;
  final _controller = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            )),
        elevation: 0,
        backgroundColor: const Color(0xFFF9F9F9),
        title: const Text('Notifications'),
        titleTextStyle: const TextStyle(color: Colors.black),
        actions: [
          TextButton(
              onPressed: () {
                BlocProvider.of<NewsBloc>(context).add(MarkAllAsReadEvent());
              },
              child: const Text(
                'Mark all read',
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.normal),
              ))
        ],
      ),
      body: BlocBuilder<NewsBloc, NewsState>(
        builder: (context, state) {
          if (state is NewsLoadingState) {
            return const CircularProgressIndicator();
          } else if (state is NewsLoadedState) {
            return ListView(
              controller: _controller
                ..addListener(() {
                  if (_controller.offset >= _controller.position.maxScrollExtent) {
                    setState(() {
                      _isFeaturedListVisable = true;
                    });
                  }
                  if (_controller.offset <= _controller.position.minScrollExtent && !_controller.position.outOfRange) {
                    if (_isFeaturedListVisable) {
                      setState(() {
                        _isFeaturedListVisable = false;
                      });
                    }
                  }
                }),
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Text(
                    'Featured',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                SizedBox(
                  height: _isFeaturedListVisable ? null : MediaQuery.of(context).size.height * 0.3,
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: !_isFeaturedListVisable ? const ScrollPhysics() : const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    scrollDirection: _isFeaturedListVisable ? Axis.vertical : Axis.horizontal,
                    itemCount: state.featuredNews.length,
                    itemBuilder: (context, index) {
                      final news = state.featuredNews[index];
                      return _isFeaturedListVisable ? ListItem(news: news) : CarouselItem(news: news);
                    },
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Text(
                    'Latest news',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: state.latestNews.length,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    final news = state.latestNews[index];
                    return ListItem(news: news);
                  },
                ),
              ],
            );
          } else if (state is NewsErrorState) {
            return const Text('Failed to load news');
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}
