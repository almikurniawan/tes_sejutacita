class Repo{
  final String title;
  final String createdAt;
  final int watchersCount;
  final int stargazersCount;
  final int forksCount;
  final String photo;

  Repo({required this.createdAt, required this.forksCount, required this.stargazersCount, required this.title, required this.watchersCount, required this.photo});
}