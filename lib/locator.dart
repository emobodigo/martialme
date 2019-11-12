import 'package:get_it/get_it.dart';
import 'package:martialme/db/db_places.dart';
import 'package:martialme/provider/placesProvider.dart';

GetIt locator = GetIt.instance;

void setupLocator(){
  locator.registerLazySingleton(() => DatabasePlaces('places'));
  locator.registerLazySingleton(() => PlacesProvider());
}