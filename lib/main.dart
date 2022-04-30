import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tes_sejutacita/bloc/bloc.dart';
import 'package:tes_sejutacita/bloc/event.dart';
import 'package:tes_sejutacita/bloc/state.dart';
import 'package:tes_sejutacita/components/issues.dart';
import 'package:tes_sejutacita/components/repo.dart';
import 'package:tes_sejutacita/components/user.dart';

import 'components/debouncer.dart';
import 'components/pagination_custome.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (BuildContext context) {
          return GitHubBloc(InitialState());
        }),
      ],
      child: MaterialApp(
        theme: ThemeData(
            primarySwatch: Colors.amber,
            textTheme: const TextTheme(
              headline6: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              bodyText1: TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold),
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ))),
            inputDecorationTheme: InputDecorationTheme(
              filled: true,
              fillColor: Colors.grey[200],
              border: InputBorder.none,
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
              ),  
            ),
            cardTheme: CardTheme(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            iconTheme: IconThemeData(color: Colors.amber),
            primaryIconTheme: IconThemeData(color: Colors.amber),
            ),
        home: const MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController searhController = TextEditingController();
  late ScrollController scrollController;
  late GitHubBloc gitHubBloc;
  final _debouncer = Debouncer(milliseconds: 500);

  @override
  void initState() {
    super.initState();
    gitHubBloc = BlocProvider.of<GitHubBloc>(context);
    gitHubBloc.add(
        LoadUser(page: 1, keyword: searhController.text, mode: 'lazyload'));
    scrollController = ScrollController()..addListener(_scrollListener);
  }

  @override
  void dispose() {
    scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  void _scrollListener() {
    if (scrollController.position.extentAfter <= 2) {
      if (gitHubBloc.state is UserStateLoaded) {
        UserStateLoaded currentState = gitHubBloc.state as UserStateLoaded;
        if (currentState.typePaging == 'lazyload') {
          gitHubBloc.add(LoadUser(
              page: currentState.page + 1,
              keyword: searhController.text,
              mode: 'lazyload'));
        }
      } else if (gitHubBloc.state is IssuesStateLoaded) {
        IssuesStateLoaded currentState = gitHubBloc.state as IssuesStateLoaded;
        if (currentState.typePaging == 'lazyload') {
          gitHubBloc.add(LoadIssues(
              page: currentState.page + 1,
              keyword: searhController.text,
              mode: 'lazyload'));
        }
      } else if (gitHubBloc.state is RepoStateLoaded) {
        RepoStateLoaded currentState = gitHubBloc.state as RepoStateLoaded;
        if (currentState.typePaging == 'lazyload') {
          gitHubBloc.add(LoadRepo(
              page: currentState.page + 1,
              keyword: searhController.text,
              mode: 'lazyload'));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(8.0),
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.transparent,
            centerTitle: false,
            title: TextField(
              controller: searhController,
              onChanged: (value) {
                _debouncer.run(() {
                  if (gitHubBloc.state is UserStateLoaded) {
                    gitHubBloc.add(LoadUser(page: 1, keyword: value));
                  } else if (gitHubBloc.state is IssuesStateLoaded) {
                    gitHubBloc.add(LoadIssues(page: 1, keyword: value));
                  } else if (gitHubBloc.state is RepoStateLoaded) {
                    gitHubBloc.add(LoadRepo(page: 1, keyword: value));
                  }
                });
              },
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.search,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ),
          SliverPersistentHeader(
            pinned: true,
            delegate: Delegate(
              child: Column(
                children: [
                  BlocBuilder<GitHubBloc, RootState>(
                    bloc: gitHubBloc,
                    builder: (ctx, state) {
                      int option = 1;
                      if (state is UserStateLoaded) {
                        option = 1;
                      } else if (state is IssuesStateLoaded) {
                        option = 2;
                      } else if (state is RepoStateLoaded) {
                        option = 3;
                      }
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Radio(
                                value: 1,
                                groupValue: option,
                                onChanged: (value) {
                                  gitHubBloc.add(LoadUser(
                                      page: 1, keyword: searhController.text));
                                },
                              ),
                              Text(
                                'User',
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Radio(
                                value: 2,
                                groupValue: option,
                                onChanged: (value) {
                                  gitHubBloc.add(LoadIssues(
                                      page: 1, keyword: searhController.text));
                                },
                              ),
                              Text('Issues',
                                  style: Theme.of(context).textTheme.bodyText1),
                            ],
                          ),
                          Row(
                            children: [
                              Radio(
                                value: 3,
                                groupValue: option,
                                onChanged: (value) {
                                  gitHubBloc.add(LoadRepo(
                                      page: 1, keyword: searhController.text));
                                },
                              ),
                              Text('Repositories',
                                  style: Theme.of(context).textTheme.bodyText1),
                            ],
                          )
                        ],
                      );
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        BlocBuilder<GitHubBloc, RootState>(
                            builder: (context, state) {
                          Color color = Colors.amber[400] as Color;
                          if (state.typePaging == 'lazyload') {
                            color = Colors.amber[800] as Color;
                          }
                          return ElevatedButton(
                            onPressed: () {
                              gitHubBloc.add(ChangePaging(mode: 'lazyload'));
                            },
                            child: Text("Lazy Loading"),
                            style: ElevatedButton.styleFrom(
                              primary: color,
                            ),
                          );
                        }),
                        SizedBox(
                          width: 10,
                        ),
                        BlocBuilder<GitHubBloc, RootState>(
                            builder: (context, state) {
                          Color color = Colors.amber[400] as Color;
                          if (state.typePaging == 'index') {
                            color = Colors.amber[800] as Color;
                          }
                          return ElevatedButton(
                            onPressed: () {
                              gitHubBloc.add(ChangePaging(mode: 'index'));
                            },
                            child: Text("With Index"),
                            style: ElevatedButton.styleFrom(
                              primary: color,
                            ),
                          );
                        })
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverFillRemaining(
            child: MediaQuery.removePadding(
              context: context,
              removeTop: true,
              child: BlocBuilder<GitHubBloc, RootState>(
                bloc: gitHubBloc,
                builder: (ct, state) {
                  if (state is InitialState) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is UserStateLoaded) {
                    if (state.isLoading) {
                      return Column(
                        children: [
                          Expanded(
                            child: ListView.builder(
                              controller: scrollController,
                              shrinkWrap: true,
                              itemBuilder: (ctx, index) {
                                return User(
                                  user: state.user[index],
                                );
                              },
                              itemCount: state.user.length,
                            ),
                          ),
                          Center(
                            child: CircularProgressIndicator(),
                          )
                        ],
                      );
                    }
                    return Column(children: [
                      Expanded(
                        child: ListView.builder(
                          controller: scrollController,
                          shrinkWrap: true,
                          itemBuilder: (ctx, index) {
                            return User(
                              user: state.user[index],
                            );
                          },
                          itemCount: state.user.length,
                        ),
                      ),
                      (state.typePaging != 'lazyload')
                          ? PaginationCustome(
                              page: state.page,
                              totalData: state.total,
                              onPageChanged: (page) {
                                gitHubBloc.add(ChangePage(page: page));
                              },
                            )
                          : Container()
                    ]);
                  } else if (state is IssuesStateLoaded) {
                    if (state.isLoading) {
                      return Column(
                        children: [
                          Expanded(
                            child: ListView.builder(
                              controller: scrollController,
                              shrinkWrap: true,
                              itemBuilder: (ctx, index) {
                                return Issues(
                                  issues: state.issues[index],
                                );
                              },
                              itemCount: state.issues.length,
                            ),
                          ),
                          Center(
                            child: CircularProgressIndicator(),
                          )
                        ],
                      );
                    }
                    return Column(children: [
                      Expanded(
                        child: ListView.builder(
                          controller: scrollController,
                          shrinkWrap: true,
                          itemBuilder: (ctx, index) {
                            return Issues(
                              issues: state.issues[index],
                            );
                          },
                          itemCount: state.issues.length,
                        ),
                      ),
                      (state.typePaging != 'lazyload')
                          ? PaginationCustome(
                              page: state.page,
                              totalData: state.total,
                              onPageChanged: (page) {
                                gitHubBloc.add(ChangePage(page: page));
                              },
                            )
                          : Container()
                    ]);
                  } else if (state is RepoStateLoaded) {
                    if (state.isLoading) {
                      return Column(
                        children: [
                          Expanded(
                            child: ListView.builder(
                              controller: scrollController,
                              shrinkWrap: true,
                              itemBuilder: (ctx, index) {
                                return Repo(
                                  repo: state.repo[index],
                                );
                              },
                              itemCount: state.repo.length,
                            ),
                          ),
                          Center(
                            child: CircularProgressIndicator(),
                          )
                        ],
                      );
                    }
                    return Column(children: [
                      Expanded(
                        child: ListView.builder(
                          controller: scrollController,
                          shrinkWrap: true,
                          itemBuilder: (ctx, index) {
                            return Repo(
                              repo: state.repo[index],
                            );
                          },
                          itemCount: state.repo.length,
                        ),
                      ),
                      (state.typePaging != 'lazyload')
                          ? PaginationCustome(
                              page: state.page,
                              totalData: state.total,
                              onPageChanged: (page) {
                                gitHubBloc.add(ChangePage(page: page));
                              },
                            )
                          : Container()
                    ]);
                  }
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),
          )
        ],
      ),
    ));
  }
}

class Delegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  Delegate({required this.child}) : super();

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(color: Colors.white, child: child);
  }

  @override
  double get maxExtent => 100;

  @override
  double get minExtent => 100;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
