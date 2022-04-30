
import 'package:flutter/material.dart';
import 'package:tes_sejutacita/model/issues.dart' as IssuesModel;
class Issues extends StatelessWidget {
  final IssuesModel.Issues issues;
  const Issues({ Key? key, required this.issues }) : super(key: key);

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
              Image.network(this.issues.photo, width: MediaQuery.of(context).size.width * 0.3,
                fit: BoxFit.cover,),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(this.issues.title, style: Theme.of(context).textTheme.headline6,),
                    Text(this.issues.updateAt, style: Theme.of(context).textTheme.bodyText1,)
                  ],
                ),
              ),
              Expanded(child: Text(this.issues.states, style: Theme.of(context).textTheme.bodyText1, )),
            ],
          ),
        ),
      ),
    );
  }
}