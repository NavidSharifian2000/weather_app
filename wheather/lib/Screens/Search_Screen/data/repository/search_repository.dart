import 'package:dartz/dartz.dart';
import 'package:wheather/Screens/Main_Screen/data/datasource/favorite_datasource.dart';
import 'package:wheather/Screens/Main_Screen/data/model/faforite_city_model.dart';
import 'package:wheather/Screens/Search_Screen/data/datasource/search_datasource.dart';
import 'package:wheather/Screens/Search_Screen/data/model/faforite_city_model.dart';
import 'package:wheather/di/di.dart';
import 'package:wheather/utils/Api_Exception.dart';

abstract class ICity_Serach_Repository {
  // ignore: non_constant_identifier_names
  Future<Either<String, List<city_name>>> search_city_name_repository(
      String cityname);
  Future<void> insert_city_name_db_repository(String cityname);
}

class City_Search_Repository extends ICity_Serach_Repository {
  ICitySearchDataSource cityInfoDataSource =
      locator.get<ICitySearchDataSource>();

  @override
  Future<Either<String, List<city_name>>> search_city_name_repository(
      String cityname) async {
    try {
      List<city_name> response =
          await cityInfoDataSource.search_city_name_datasource(cityname);
      return right(response);
    } on ApiException catch (e) {
      return left(e.message ?? "محتوای فنی نداری");
    } catch (e) {
      return left("محتوای فنی نداری");
    }
  }

  @override
  Future<void> insert_city_name_db_repository(String cityname) async {
    try {
      await cityInfoDataSource.insert_city_name_db_datasource(cityname);
    } catch (e) {
      print(e.toString());
    }
  }
}
