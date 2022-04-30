import 'package:tes_sejutacita/model/issues.dart';
import 'package:tes_sejutacita/model/repo.dart';
import 'package:tes_sejutacita/model/user.dart';

abstract class RootState {
  final bool isLoading = true;
  final List user = [];
  final int page = 1;
  final String keyword = 'a';
  final int total = 0;
  final String typePaging = 'lazyload';
}

class InitialState extends RootState {
  final bool isLoading = true;
  final List user = [];
  final int page = 1;
  final String keyword = 'a';
  final int total = 0;
  final String typePaging = 'lazyload';
}

class UserStateLoaded extends RootState {
  final bool isLoading;
  final List<User> user;
  final int page;
  final String keyword;
  final int total;
  final String typePaging;
  UserStateLoaded({required this.user, required this.page, required this.keyword, required this.total, required this.isLoading, required this.typePaging});
}

class IssuesStateLoaded extends RootState {
  final bool isLoading;
  final List<Issues> issues;
  final int page;
  final String keyword;
  final int total;
  final String typePaging;
  IssuesStateLoaded({required this.issues, required this.page, required this.keyword, required this.total, required this.isLoading, required this.typePaging});

  IssuesStateLoaded copyFrom(IssuesStateLoaded state) {
    return IssuesStateLoaded(
      issues: state.issues,
      page: state.page,
      keyword: state.keyword,
      total: state.total,
      isLoading: state.isLoading,
      typePaging: state.typePaging,
    );
  }
}

class RepoStateLoaded extends RootState {
  final bool isLoading;
  final List<Repo> repo;
  final int page;
  final String keyword;
  final int total;
  final String typePaging;
  RepoStateLoaded({required this.repo, required this.page, required this.keyword, required this.total, required this.isLoading, required this.typePaging});
}