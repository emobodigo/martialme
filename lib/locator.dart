import 'package:get_it/get_it.dart';
import 'package:martialme/db/db_places.dart';
import 'package:martialme/provider/groupProvider.dart';
import 'package:martialme/provider/placesProvider.dart';

import 'db/db_group.dart';

GetIt locator = GetIt.instance;

void setupLocator(){
  locator.registerLazySingleton(() => DatabasePlaces('places'));
  locator.registerLazySingleton(() => DatabaseGroup('group'));
  locator.registerLazySingleton(() => PlacesProvider());
  locator.registerLazySingleton(() => GroupProvider());
}