import 'package:flutter/material.dart';

class PaginationCustome extends StatelessWidget {
  final int page;
  final int totalData;
  final void Function(int) onPageChanged;
  const PaginationCustome({ Key? key, required this.page, required this.totalData, required this.onPageChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int totalPage = (totalData / 30).ceil();
    return Container(
      padding: const EdgeInsets.only(top: 10),
      height: 50,
      width: MediaQuery.of(context).size.width * 1,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemBuilder: (cts, index){
          return Padding(
            padding: const EdgeInsets.all(1),
            child: ElevatedButton(
              onPressed: (){
                this.onPageChanged(index+1);
              }, 
              child: Text((index+1).toString()),
              style: ElevatedButton.styleFrom(shape: const CircleBorder(), 
              primary: (index+1 == page) ? Colors.amber[800] : Colors.amber[400]
              ),
            )
          );
      }, itemCount: totalPage,),
    );
  }
}