part of 'news_bloc.dart';

abstract class NewsEvent {}

class GetNewsEvent extends NewsEvent {}

class MarkAllAsReadEvent extends NewsEvent {}
