import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Info {
  static const String app_name = "Martialme";
  static const String app_version = "1.0.0";
  static const int app_version_code = 1;
  static const String app_color = "ffd7167";
  static Color primaryAppColor = Colors.white;
  static Color secondaryAppColor = Colors.black;

  static const String rekomendasi = "Rekomendasi";
  static const String dataLatihan = "Informasi";
  static const String group = "Group";
  static const String welcomeText = "Selamat datang di Martialme";
  static const String headlineText = "Aplikasi ini memberi akses kepada anda untuk mendapatkan informasi tempat latihan beladiri di Kota Malang, selain itu aplikasi ini memberikan rekomendasi tempat latihan sesuai kriteria anda";

  static const String banner_light = 'assets/images/banner_light.png';
  static const String banner_dark = 'assets/images/banner_dark.png';

  static SharedPreferences preferences;
  static const String darkModePref = "darkModePref";
}