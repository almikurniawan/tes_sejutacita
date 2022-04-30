import 'package:tes_sejutacita/bloc/event.dart';
import 'package:tes_sejutacita/model/user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class Service{
  Future<Map<String, dynamic>> getUser(LoadUser event) async{
    Map<String, String> queryString = {
      'page' : event.page.toString()
    };
    Uri urlApi;
    if(event.keyword!=''){
      queryString['q'] = event.keyword;
      urlApi =
        Uri.https("api.github.com", '/search/users', queryString);
    }else{
      queryString['q'] = 'a';
      urlApi =
        Uri.https("api.github.com", '/search/users', queryString);
    }
    var result = await http.get(urlApi);
    
    Map<String, dynamic> jsonObject = jsonDecode(result.body);
    return jsonObject;
  }

  Future<Map<String, dynamic>> getIssues(LoadIssues event) async{
    Map<String, String> queryString = {
      'page' : event.page.toString()
    };
    Uri urlApi;
    if(event.keyword!=''){
      queryString['q'] = event.keyword;
      urlApi =
        Uri.https("api.github.com", '/search/issues', queryString);
    }else{
      queryString['q'] = 'a';
      urlApi =
        Uri.https("api.github.com", '/search/issues', queryString);
    }
    var result = await http.get(urlApi);
    
    Map<String, dynamic> jsonObject = jsonDecode(result.body);
    print(jsonObject);
    return jsonObject;
  }

  Future<Map<String, dynamic>> getRepo(LoadRepo event) async{
    Map<String, String> queryString = {
      'page' : event.page.toString()
    };
    Uri urlApi;
    if(event.keyword!=''){
      queryString['q'] = event.keyword;
      urlApi =
        Uri.https("api.github.com", '/search/repositories', queryString);
    }else{
      queryString['q'] = 'a';
      urlApi =
        Uri.https("api.github.com", '/search/repositories', queryString);
    }
    var result = await http.get(urlApi);
    
    Map<String, dynamic> jsonObject = jsonDecode(result.body);
    return jsonObject;
  }
}