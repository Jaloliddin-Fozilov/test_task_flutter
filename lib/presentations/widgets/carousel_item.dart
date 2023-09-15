import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../logic/bloc/news_bloc.dart';
import '../../repositories/news/models/article.dart';
import '../screens/news_details_page.dart';

class CarouselItem extends StatelessWidget {
  CarouselItem({
    super.key,
    required this.news,
    this.setWidth = false,
  });

  final Article news;
  bool setWidth;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read<NewsBloc>().markNewsAsReaded(news.id);
        Navigator.push(context, MaterialPageRoute(builder: (context) => NewsDetailsPage(news: news)));
      },
      child: Container(
        alignment: Alignment.bottomLeft,
        width: setWidth ? MediaQuery.of(context).size.width : MediaQuery.of(context).size.width - 40,
        margin: setWidth ? null : const EdgeInsets.only(right: 20),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          image: DecorationImage(
            image: NetworkImage(news.imageUrl),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.7), BlendMode.darken),
          ),
        ),
        child: Text(
          news.title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
