import 'package:tes_sejutacita/components/user.dart';

abstract class RootEvent {
}

class LoadUser extends RootEvent {
  final int page;
  final String keyword;
  final String mode = 'lazyload';
  LoadUser({required this.page, required this.keyword, String? mode});
}

class LoadIssues extends RootEvent {
  final int page;
  final String keyword;
  final String mode = 'lazyload';
  LoadIssues({required this.page, required this.keyword, String? mode});
}

class LoadRepo extends RootEvent {
  final int page;
  final String keyword;
  final String mode = 'lazyload';
  LoadRepo({required this.page, required this.keyword, String? mode});
}

class ChangePaging extends RootEvent{
  final mode;
  ChangePaging({required this.mode});
}

class ChangePage extends RootEvent{
  final int page;
  ChangePage({required this.page});
}