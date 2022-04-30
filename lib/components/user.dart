import 'package:flutter/material.dart';
import '../model/user.dart' as UserModel;

class User extends StatelessWidget {
  final UserModel.User user;
  const User({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Image.network(
                this.user.photo,
                width: MediaQuery.of(context).size.width * 0.2,
                fit: BoxFit.cover,
              ),
              SizedBox(
                width: 10,
              ),
              Flexible(
                child: Text(
                  this.user.name,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.headline6,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
