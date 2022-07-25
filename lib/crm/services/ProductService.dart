import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gms_erp/crm/models/Product.dart';
import 'package:http/http.dart' as http;

class ProductService {

  static Future<List<Product>> getProducts(String url, BuildContext? context) async {
    List<Product>? list;
    int success=-1;
    String message="";

    url = 'http://144.91.76.98:84/AndroidDB/search.php?barcode=all';
    var res = await http.get(Uri.parse(url));
    var json_data = json.decode(res.body);

    if (res.statusCode == 200) {
      success = json_data["success"];
      message = json_data["message"];
    }
    if(success == 1){
      var data = json_data["data"] as List;
      list = data.map<Product>((json) => Product.fromJson(json)).toList();
    }
    else{
      list = null;
    }

    return list!;
  }

}