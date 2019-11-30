import 'package:cloud_firestore/cloud_firestore.dart';

class Places {
   final String alamat,
      id,
      deskripsi,
      gambar,
      gambarlogo,
      harga,
      instagram,
      jenisBeladiri,
      jumlahWaktuLatihan,
      latitude,
      longitude,
      namaTempat;
   double normalisasiHarga, normalisasiJarak, normalisasiWaktu;
   double siPlus, siMin;
   double hasilTopsis, jarak, hasilBorda;
  final List<String> jadwal;

  Places(
      {this.alamat,
      this.id,
      this.deskripsi,
      this.gambar,
      this.gambarlogo,
      this.harga,
      this.instagram,
      this.jenisBeladiri,
      this.jumlahWaktuLatihan,
      this.latitude,
      this.longitude,
      this.namaTempat,
      this.jadwal,
      this.normalisasiHarga,
      this.normalisasiJarak,
      this.normalisasiWaktu,
      this.siMin,
      this.siPlus,
      this.hasilTopsis, this.jarak, this.hasilBorda});

  factory Places.fromMap(Map<String, dynamic> data, String id) {
    data = data ?? {};
    var jadwalfromMap = data['jadwal'];
    List<String> jadwalList = jadwalfromMap.cast<String>();
    return Places(
      id: id,
      alamat: data['alamat'],
      deskripsi: data['deskripsi'],
      gambar: data['gambar'],
      gambarlogo: data['gambarlogo'],
      harga: data['harga'],
      instagram: data['instagram'],
      jenisBeladiri: data['jenis_beladiri'],
      jumlahWaktuLatihan: data['jumlah_waktu_latihan'],
      latitude: data['latitude'],
      longitude: data['longitude'],
      namaTempat: data['nama_tempat'],
      hasilBorda: data['borda'],
      jadwal: jadwalList,
    );
   
  }
  factory Places.fromJson(DocumentSnapshot data){
    data = data ?? {};
    var jadwalfromMap = data['jadwal'];
    List<String> jadwalList = jadwalfromMap.cast<String>();
    return Places(
      id: data.documentID,
      alamat: data['alamat'],
      deskripsi: data['deskripsi'],
      gambar: data['gambar'],
      gambarlogo: data['gambarlogo'],
      harga: data['harga'],
      instagram: data['instagram'],
      jenisBeladiri: data['jenis_beladiri'],
      jumlahWaktuLatihan: data['jumlah_waktu_latihan'],
      latitude: data['latitude'],
      longitude: data['longitude'],
      namaTempat: data['nama_tempat'],
      jadwal: jadwalList,
    );
  }
  // Places.fromMap(Map snapshot) :
  //   jadwal = snapshot['jadwal'],
  //   deskripsi = snapshot['deskripsi'],
  //   gambar = snapshot['gambar'],
  //   gambarlogo = snapshot['gambarlogo'],
  //   harga = snapshot['harga'],
  //   instagram = snapshot['instagram'],
  //   jenisBeladiri = snapshot['jenis_beladiri'],
  //   jumlahWaktuLatihan = snapshot['jumlah_waktu_latihan'],
  //   latitude = snapshot['latitude'],
  //   longitude = snapshot['longitude'],
  //   namaTempat = snapshot['nama_tempat'],
  //   jadwal = snapshot=['jadwal'];
}
