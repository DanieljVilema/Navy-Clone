class UserProfile {
  final int? id;
  final String nombre;
  final String genero;
  final String grupoEdad;
  final double? alturaPulg;
  final double? cinturaPulg;
  final double? pesoLb;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserProfile({
    this.id,
    this.nombre = 'Usuario',
    this.genero = 'Masculino',
    this.grupoEdad = '20-24',
    this.alturaPulg,
    this.cinturaPulg,
    this.pesoLb,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  Map<String, dynamic> toMap() => {
        if (id != null) 'id': id,
        'nombre': nombre,
        'genero': genero,
        'grupo_edad': grupoEdad,
        'altura_pulg': alturaPulg,
        'cintura_pulg': cinturaPulg,
        'peso_lb': pesoLb,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
      };

  factory UserProfile.fromMap(Map<String, dynamic> m) => UserProfile(
        id: m['id'] as int?,
        nombre: m['nombre'] as String? ?? 'Usuario',
        genero: m['genero'] as String? ?? 'Masculino',
        grupoEdad: m['grupo_edad'] as String? ?? '20-24',
        alturaPulg: (m['altura_pulg'] as num?)?.toDouble(),
        cinturaPulg: (m['cintura_pulg'] as num?)?.toDouble(),
        pesoLb: (m['peso_lb'] as num?)?.toDouble(),
        createdAt: DateTime.tryParse(m['created_at'] as String? ?? ''),
        updatedAt: DateTime.tryParse(m['updated_at'] as String? ?? ''),
      );

  UserProfile copyWith({
    int? id,
    String? nombre,
    String? genero,
    String? grupoEdad,
    double? alturaPulg,
    double? cinturaPulg,
    double? pesoLb,
  }) =>
      UserProfile(
        id: id ?? this.id,
        nombre: nombre ?? this.nombre,
        genero: genero ?? this.genero,
        grupoEdad: grupoEdad ?? this.grupoEdad,
        alturaPulg: alturaPulg ?? this.alturaPulg,
        cinturaPulg: cinturaPulg ?? this.cinturaPulg,
        pesoLb: pesoLb ?? this.pesoLb,
        createdAt: createdAt,
        updatedAt: DateTime.now(),
      );
}
