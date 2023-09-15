import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forestvpn_test/presentations/screens/home_page.dart';
import 'package:forestvpn_test/repositories/news/mock_news_repository.dart';

import 'logic/bloc/news_bloc.dart';

void main() {
  runApp(const NewsApp());
}

class NewsApp extends StatelessWidget {
  const NewsApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => NewsBloc(repository: MockNewsRepository())..add(GetNewsEvent()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'News app',
        theme: ThemeData(
          textTheme: ThemeData.light().textTheme.apply(
                fontFamily: 'SF Pro Display',
              ),
        ),
        home: const HomePage(),
      ),
    );
  }
}
