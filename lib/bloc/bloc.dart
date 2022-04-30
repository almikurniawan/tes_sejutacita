import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tes_sejutacita/apiService/service.dart';
import 'package:tes_sejutacita/bloc/event.dart';
import 'package:tes_sejutacita/bloc/state.dart';
import 'package:tes_sejutacita/model/issues.dart';
import 'package:tes_sejutacita/model/repo.dart';
import 'package:tes_sejutacita/model/user.dart';

class GitHubBloc extends Bloc<RootEvent, RootState> {
  GitHubBloc(InitialState initialState) : super(initialState) {
    on<LoadUser>((event, emit) async {
      Map<String, dynamic> newUsers = await Service().getUser(event);
      List<User> listUsers = newUsers['items'].map<User>((item) {
        return User(name: item['login'], photo: item['avatar_url']);
      }).toList();

      if (state.typePaging == 'lazyload') {
        if (state is UserStateLoaded) {
          UserStateLoaded currentState = state as UserStateLoaded;
          listUsers = currentState.user + listUsers;
        }
      }

      emit(UserStateLoaded(
          user: listUsers,
          page: event.page,
          keyword: event.keyword,
          total: newUsers['total_count'],
          isLoading: false,
          typePaging: event.mode));
    });

    on<LoadIssues>((event, emit) async {
      Map<String, dynamic> newissues = await Service().getIssues(event);
      List<Issues> listIssues = newissues['items'].map<Issues>((item) {
        return Issues(
            title: item['title'],
            states: item['state'],
            updateAt: item['updated_at'],
            photo: item['user']['avatar_url']);
      }).toList();

      if (state.typePaging == 'lazyload') {
        if (state is IssuesStateLoaded) {
          IssuesStateLoaded currentState = state as IssuesStateLoaded;
          listIssues = currentState.issues + listIssues;
        }
      }

      emit(IssuesStateLoaded(
          issues: listIssues,
          page: event.page,
          keyword: event.keyword,
          total: newissues['total_count'],
          isLoading: false,
          typePaging: event.mode));
    });

    on<LoadRepo>((event, emit) async {
      Map<String, dynamic> newRepo = await Service().getRepo(event);
      List<Repo> listRepo = newRepo['items'].map<Repo>((item) {
        return Repo(
            createdAt: item['created_at'],
            forksCount: item['forks_count'],
            stargazersCount: item['stargazers_count'],
            title: item['name'],
            watchersCount: item['watchers_count'],
            photo: item['owner']['avatar_url']);
      }).toList();

      if (state.typePaging == 'lazyload') {
        if (state is RepoStateLoaded) {
          RepoStateLoaded currentState = state as RepoStateLoaded;
          listRepo = currentState.repo + listRepo;
        }
      }

      emit(RepoStateLoaded(
          repo: listRepo,
          page: event.page,
          keyword: event.keyword,
          total: newRepo['total_count'],
          isLoading: false,
          typePaging: event.mode));
    });

    on<ChangePaging>((event, emit) async {
      if (state is UserStateLoaded) {
        UserStateLoaded currentState = state as UserStateLoaded;
        Map<String, dynamic> newUsers = await Service().getUser(
            LoadUser(page: currentState.page, keyword: currentState.keyword));
        List<User> listUser = newUsers['items'].map<User>((item) {
          return User(name: item['login'], photo: item['avatar_url']);
        }).toList();

        if (event.mode == 'lazyload') {
          listUser = currentState.user + listUser;
        }

        emit(UserStateLoaded(
            user: listUser,
            page: currentState.page,
            keyword: currentState.keyword,
            total: newUsers['total_count'],
            isLoading: false,
            typePaging: event.mode));
      } else if (state is IssuesStateLoaded) {
        IssuesStateLoaded currentState = state as IssuesStateLoaded;
        Map<String, dynamic> newIssues = await Service().getIssues(
            LoadIssues(page: currentState.page, keyword: currentState.keyword));
        List<Issues> listIssues = newIssues['items'].map<Issues>((item) {
          return Issues(
              title: item['title'],
              states: item['state'],
              updateAt: item['updated_at'],
              photo: item['user']['avatar_url']);
        }).toList();

        if (event.mode == 'lazyload') {
          listIssues = currentState.issues + listIssues;
        }

        emit(IssuesStateLoaded(
            issues: listIssues,
            page: currentState.page,
            keyword: currentState.keyword,
            total: newIssues['total_count'],
            isLoading: false,
            typePaging: event.mode));
      } else if (state is RepoStateLoaded) {
        RepoStateLoaded currentState = state as RepoStateLoaded;
        Map<String, dynamic> newRepo = await Service().getRepo(
            LoadRepo(page: currentState.page, keyword: currentState.keyword));
        List<Repo> listRepo = newRepo['items'].map<Repo>((item) {
          return Repo(
              createdAt: item['created_at'],
              forksCount: item['forks_count'],
              stargazersCount: item['stargazers_count'],
              title: item['name'],
              watchersCount: item['watchers_count'],
              photo: item['owner']['avatar_url']);
        }).toList();

        if (event.mode == 'lazyload') {
          listRepo = currentState.repo + listRepo;
        }

        emit(RepoStateLoaded(
            repo: listRepo,
            page: currentState.page,
            keyword: currentState.keyword,
            total: newRepo['total_count'],
            isLoading: false,
            typePaging: event.mode));
      }
    });

    on<ChangePage>((event, emit) async {
      if (state is UserStateLoaded) {
        UserStateLoaded currentState = state as UserStateLoaded;
        emit(UserStateLoaded(
            user: currentState.user,
            page: event.page,
            keyword: currentState.keyword,
            total: currentState.total,
            isLoading: true,
            typePaging: currentState.typePaging));

        Map<String, dynamic> newUsers = await Service()
            .getUser(LoadUser(page: event.page, keyword: currentState.keyword));
        List<User> listUser = newUsers['items'].map<User>((item) {
          return User(name: item['login'], photo: item['avatar_url']);
        }).toList();

        emit(UserStateLoaded(
            user: listUser,
            page: event.page,
            keyword: currentState.keyword,
            total: newUsers['total_count'],
            isLoading: false,
            typePaging: currentState.typePaging));
      } else if (state is IssuesStateLoaded) {
        IssuesStateLoaded currentState = state as IssuesStateLoaded;
        emit(IssuesStateLoaded(
            issues: currentState.issues,
            page: event.page,
            keyword: currentState.keyword,
            total: currentState.total,
            isLoading: true,
            typePaging: currentState.typePaging));

        Map<String, dynamic> newIssues = await Service().getIssues(
            LoadIssues(page: event.page, keyword: currentState.keyword));
        List<Issues> listIssues = newIssues['items'].map<Issues>((item) {
          return Issues(
              title: item['title'],
              states: item['state'],
              updateAt: item['updated_at'],
              photo: item['user']['avatar_url']);
        }).toList();

        emit(IssuesStateLoaded(
            issues: listIssues,
            page: event.page,
            keyword: currentState.keyword,
            total: newIssues['total_count'],
            isLoading: false,
            typePaging: currentState.typePaging));
      } else if (state is RepoStateLoaded) {
        RepoStateLoaded currentState = state as RepoStateLoaded;
        emit(RepoStateLoaded(
            repo: currentState.repo,
            page: event.page,
            keyword: currentState.keyword,
            total: currentState.total,
            isLoading: true,
            typePaging: currentState.typePaging));

        Map<String, dynamic> newIssues = await Service().getIssues(
            LoadIssues(page: event.page, keyword: currentState.keyword));
        List<Issues> listIssues = newIssues['items'].map<Issues>((item) {
          return Issues(
              title: item['title'],
              states: item['state'],
              updateAt: item['updated_at'],
              photo: item['user']['avatar_url']);
        }).toList();

        emit(IssuesStateLoaded(
            issues: listIssues,
            page: event.page,
            keyword: currentState.keyword,
            total: newIssues['total_count'],
            isLoading: false,
            typePaging: currentState.typePaging));
      }
    });
  }
}
