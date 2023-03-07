import 'dart:convert';

import 'package:covid19/Services/Utiles/app_url.dart';
import 'package:http/http.dart' as http;

import '../Model/WorldStateModel.dart';

class StatesServices {
  Future<WorldStateModel> fetchWorldStatesRecord()async{
    final response = await http.get(Uri.parse(AppUrl.worldStatesApi));
    if(response.statusCode == 200){
      var data = jsonDecode(response.body);
      return WorldStateModel.fromJson(data);
    }else{
      throw Exception('Error');
    }
  }
}