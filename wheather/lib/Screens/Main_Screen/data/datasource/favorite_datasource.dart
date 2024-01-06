import 'package:dio/dio.dart';
import 'package:sqflite/sqflite.dart';
import 'package:wheather/Screens/Main_Screen/data/model/faforite_city_model.dart';
import 'package:wheather/di/di.dart';
import 'package:wheather/utils/Api_Exception.dart';
import 'package:wheather/utils/dio_config.dart';

abstract class ICityInfoDataSource {
  Future<city_info> fetch_favorite_city_info_datasource(String city_name);
  Future<List<String>> fetch_favorite_cities_db_datasource();
  Future<List<city_info>> fetch_favorite_cities_Info_datasource();
  Future<void> delete_favorite_city_Info_datasource(String city_name);
}

class CityInfoRemoteDataSource extends ICityInfoDataSource {
  final dio_project _wdio = locator.get<dio_project>();

  @override
  Future<city_info> fetch_favorite_city_info_datasource(
      String city_name) async {
    try {
      var response = await _wdio.dio!
          .get(city_name + "&appid=37cc48acaa650e1802b52bf4587fb294");
      city_info cityinfo = city_info.fromjson(response.data);
      print(cityinfo.temp);
      return cityinfo;
    } on DioException catch (e) {
      throw ApiException(e.response?.statusCode, e.response?.data["message"]);
    }
  }

  @override
  Future<List<String>> fetch_favorite_cities_db_datasource() async {
    Database favorite_cities_db = locator.get<Database>();
    List<Map> maplistciteies =
        await favorite_cities_db.rawQuery('SELECT * FROM cities');
    List<String> cities =
        maplistciteies.map((e) => e["Name_city"].toString()).toList();
    return cities;
  }

  @override
  Future<List<city_info>> fetch_favorite_cities_Info_datasource() async {
    List<city_info> cityinfolist = [];

    city_info cityinformation;

    List<String> favorite_cities_list =
        await fetch_favorite_cities_db_datasource();
    await Future.forEach(favorite_cities_list, (element) async {
      cityinformation = await fetch_favorite_city_info_datasource(element);
      cityinfolist.add(cityinformation);
    });
    return (cityinfolist);
  }

  @override
  Future<void> delete_favorite_city_Info_datasource(String citi_name) async {
    Database favorite_cities_db = locator.get<Database>();
    favorite_cities_db.rawQuery(
        "DELETE FROM cities WHERE Name_city =" + "\"" + citi_name + "\"" + ";");
  }
}
