import 'dart:convert';
import 'package:http/http.dart' as http;
import 'Maziwa.dart';

class Services {
  static const ROOT = 'http://10.0.2.2:8080/api/employees/';
  static const _CREATE_TABLE_ACTION = 'CREATE_TABLE';
  static const _GET_ALL_ACTION = 'GET_ALL';
  static const _ADD_EMP_ACTION = 'ADD_EMP';
  static const _UPDATE_EMP_ACTION = 'UPDATE_EMP';
  static const _DELETE_EMP_ACTION = 'DELETE_EMP';


  static Future<List<Maziwa>> getMaziwa() async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _GET_ALL_ACTION;
      final response = await http.get(Uri.parse(ROOT));
      print('getMaziwa Response: ${response.body}');
      print(response.statusCode);
      print(200 == response.statusCode);
      if (200 == response.statusCode) {
        List<Maziwa> list = parseResponse(response.body);
        print(list.length);
        return list;
      } else {
        return <Maziwa>[];
      }
    } catch (e) {
      return <Maziwa>[];
    }
  }

  static List<Maziwa> parseResponse(String responseBody) {
    final parsed = json.decode(responseBody);
    print(parsed);
    return parsed.map<Maziwa>((json) => Maziwa.fromJson(json)).toList();
  }


  static Future<bool> addMaziwa(String name, String lita) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _ADD_EMP_ACTION;
      map['name'] = name;
      map['lita'] = lita;
      final response = await http.post(Uri.parse(ROOT), body: map);
      print('addMaziwa Response: ${response.body}');
      if (200 == response.statusCode) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }


  static Future<bool> updateMaziwa(String empId, String name,
      String lita) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _UPDATE_EMP_ACTION;
      map['id'] = empId;
      map['name'] = name;
      map['lita'] = lita;
      final response = await http.put(Uri.parse(ROOT) + empId, body: map);
      print('updateMaziwa Response: ${response.body}');
      if (200 == response.statusCode) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }


  static Future<bool> deleteMaziwa(String empId) async {
    try {
      final response = await http.delete(Uri.parse(ROOT) + empId);
      print('deleteMaziwa Response: ${response.body}');
      if (200 == response.statusCode) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}