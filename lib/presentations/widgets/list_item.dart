import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forestvpn_test/logic/bloc/news_bloc.dart';

import '../../repositories/news/models/article.dart';
import '../screens/news_details_page.dart';

class ListItem extends StatelessWidget {
  const ListItem({
    super.key,
    required this.news,
  });

  final Article news;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: news.readed ? const Color(0xFFF5F5F5) : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: SizedBox(
            width: 90,
            height: 60,
            child: Image.network(
              news.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        contentPadding: const EdgeInsets.all(10),
        title: Text(news.title),
        subtitle: Text(
          news.publicationDate.difference(DateTime.now()).inDays.abs() == 1
              ? '1 day ago'
              : '${news.publicationDate.difference(DateTime.now()).inDays.abs()} days ago',
          style: const TextStyle(
            color: Color(0xFF9A9A9A),
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
        ),
        onTap: () {
          context.read<NewsBloc>().markNewsAsReaded(news.id);
          Navigator.push(context, MaterialPageRoute(builder: (context) => NewsDetailsPage(news: news)));
        },
      ),
    );
  }
}
