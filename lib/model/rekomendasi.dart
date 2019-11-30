class Rekomendasi{
  final String idPlaces;
  final double hasilBorda;

  Rekomendasi({this.idPlaces, this.hasilBorda});

  factory Rekomendasi.fromMap(Map<String, dynamic> data, String id){
    data = data ?? {};
    return Rekomendasi(
      idPlaces: id,
      hasilBorda: data['borda']
    );
  }
}