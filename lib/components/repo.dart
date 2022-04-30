import 'package:flutter/material.dart';
import 'package:tes_sejutacita/model/repo.dart' as RepoModel;

class Repo extends StatelessWidget {
  final RepoModel.Repo repo;
  const Repo({Key? key, required this.repo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                this.repo.photo,
                width: MediaQuery.of(context).size.width * 0.3,
                fit: BoxFit.cover,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      this.repo.title,
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    Text(
                      this.repo.createdAt,
                      style: Theme.of(context).textTheme.bodyText1,
                    )
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        "Total Watcher : " + this.repo.watchersCount.toString(),
                        style: Theme.of(context).textTheme.bodyText1),
                    Text(
                        "Total Stars : " + this.repo.stargazersCount.toString(),
                        style: Theme.of(context).textTheme.bodyText1),
                    Text("Total Forks : " + this.repo.forksCount.toString(),
                        style: Theme.of(context).textTheme.bodyText1)
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
