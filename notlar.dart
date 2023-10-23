class Not {
  int? notID;
  int? kategoriID;
  String? notBaslik;
  String? notIcerik;
  String? notTarih;
  int? notOncelik;

  Not({
    this.notID,
    this.kategoriID,
    this.notBaslik,
    this.notIcerik,
    this.notTarih,
    this.notOncelik,
  });

  Not.withID({
    required this.notID,
    required this.kategoriID,
    required this.notBaslik,
    required this.notIcerik,
    required this.notTarih,
    required this.notOncelik,
  });

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'kategoriID': kategoriID,
      'notBaslik': notBaslik,
      'notIcerik': notIcerik,
      'notOncelik': notOncelik,
    };

    if (notID != null) {
      map['notID'] = notID;
    }

    if (notTarih != null) {
      map['notTarih'] = notTarih;
    }

    return map;
  }

  Not.fromMap(Map<String, dynamic> map) {
    notID = map['notID'];
    kategoriID = map['kategoriID'];
    notBaslik = map['notBaslik'];
    notIcerik = map['notIcerik'];
    notTarih = map['notTarih'];
    notOncelik = map['notOncelik'];
  }
}
