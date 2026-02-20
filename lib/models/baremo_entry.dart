class BaremoThreshold {
  final num min; // min reps for flexiones/abdominales, or max seconds for cardio
  final double nota;
  final String nivel;

  BaremoThreshold({
    required this.min,
    required this.nota,
    required this.nivel,
  });

  factory BaremoThreshold.fromJson(Map<String, dynamic> j) => BaremoThreshold(
        min: j['min'] as num? ?? 0,
        nota: (j['nota'] as num?)?.toDouble() ?? 0,
        nivel: j['nivel'] as String? ?? '',
      );
}

class CardioBaremo {
  final List<BaremoThreshold> trote2400m;
  final List<BaremoThreshold> natacion450m;
  final List<BaremoThreshold> bicicleta12min;
  final List<BaremoThreshold> remo2000m;

  CardioBaremo({
    this.trote2400m = const [],
    this.natacion450m = const [],
    this.bicicleta12min = const [],
    this.remo2000m = const [],
  });

  factory CardioBaremo.fromJson(Map<String, dynamic> j) {
    List<BaremoThreshold> parseList(dynamic list) {
      if (list == null) return [];
      return (list as List).map((e) => BaremoThreshold.fromJson(e)).toList();
    }

    return CardioBaremo(
      trote2400m: parseList(j['trote_2400m']),
      natacion450m: parseList(j['natacion_450m']),
      bicicleta12min: parseList(j['bicicleta_12min']),
      remo2000m: parseList(j['remo_2000m']),
    );
  }

  List<BaremoThreshold> forType(String tipoCardio) {
    switch (tipoCardio) {
      case 'Trote 2.4km':
        return trote2400m;
      case 'Natación 450m':
        return natacion450m;
      case 'Bicicleta 12min':
        return bicicleta12min;
      case 'Remo 2000m':
        return remo2000m;
      default:
        return trote2400m;
    }
  }
}

class BaremoEntry {
  final String grupoEdad;
  final String genero;
  final List<BaremoThreshold> flexiones;
  final List<BaremoThreshold> abdominales;
  final CardioBaremo cardio;

  BaremoEntry({
    required this.grupoEdad,
    required this.genero,
    this.flexiones = const [],
    this.abdominales = const [],
    CardioBaremo? cardio,
  }) : cardio = cardio ?? CardioBaremo();

  factory BaremoEntry.fromJson(Map<String, dynamic> j) {
    List<BaremoThreshold> parseList(dynamic list) {
      if (list == null) return [];
      return (list as List).map((e) => BaremoThreshold.fromJson(e)).toList();
    }

    return BaremoEntry(
      grupoEdad: j['grupoEdad'] as String? ?? j['edad'] as String? ?? '',
      genero: j['genero'] as String? ?? '',
      flexiones: parseList(j['flexiones']),
      abdominales: parseList(j['abdominales']),
      cardio: j['cardio'] != null
          ? CardioBaremo.fromJson(j['cardio'])
          : CardioBaremo(),
    );
  }
}
