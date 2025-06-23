db.Personaje.insertMany([
  {
    _id: ObjectId("660000000000000000000021"),
    correo:        "ana@ejemplo.com",
    nombre:        "Ana",
    contrasena:    "Secreto01",
    fechaRegistro: ISODate("2025-06-01T08:00:00Z"),
    pais:          "Uruguay",
    continente:    "America",
    estadisticas: {
      totalLogros:              NumberInt(3),
      totalEnemigosDerrotados:  NumberInt(150),
      totalMisionesCompletadas: NumberInt(5),
      totalHorasJugadas:        Double(12.5),
      progresoGeneral:          Double(50.0)
    },
    logros: [
      {
        nombre:        "Explorador Novato",
        descripcion:   "Visita tu primera ubicacion oculta",
        recompensaXP:  NumberInt(200),
        tipo:          "exploracion",
        fechaObtenido: ISODate("2025-06-01T10:00:00Z"),
        horasJugadas:  Double(2.0)
      },
      {
        nombre:        "Viajero del Oeste",
        descripcion:   "Explora la region Oeste completamente",
        recompensaXP:  NumberInt(300),
        tipo:          "exploracion",
        fechaObtenido: ISODate("2025-06-01T12:00:00Z"),
        horasJugadas:  Double(4.0)
      },
      {
        nombre:        "Conquistador de Mazmorras",
        descripcion:   "Completa tu primera mazmorra",
        recompensaXP:  NumberInt(500),
        tipo:          "combate",
        fechaObtenido: ISODate("2025-06-02T08:00:00Z"),
        horasJugadas:  Double(24.0) 
      },
      {
        nombre:        "Investigador Arcano",
        descripcion:   "Descubre secretos ancestrales",
        recompensaXP:  NumberInt(350),
        tipo:          "magia",
        fechaObtenido: ISODate("2025-06-01T14:00:00Z"),
        horasJugadas:  Double(11.0) 
      }
    ]
  },
  {
    _id: ObjectId("660000000000000000000022"),
    correo:        "bruno@ejemplo.com",
    nombre:        "Bruno",
    contrasena:    "BrunoPass9",
    fechaRegistro: ISODate("2025-06-10T09:00:00Z"),
    pais:          "Chile",
    continente:    "America",
    estadisticas: {
      totalLogros:              NumberInt(2),
      totalEnemigosDerrotados:  NumberInt(80),
      totalMisionesCompletadas: NumberInt(3),
      totalHorasJugadas:        Double(8.0),
      progresoGeneral:          Double(60.0)
    },
    logros: [
      {
        nombre:        "Explorador Novato",
        descripcion:   "Visita tu primera ubicacion oculta",
        recompensaXP:  NumberInt(200),
        tipo:          "exploracion",
        fechaObtenido: ISODate("2025-06-10T11:00:00Z"),
        horasJugadas:  Double(2.0)
      },
      {
        nombre:        "Maestro Mago",
        descripcion:   "Aprende 10 hechizos diferentes",
        recompensaXP:  NumberInt(800),
        tipo:          "magia",
        fechaObtenido: ISODate("2025-06-10T18:00:00Z"),
        horasJugadas:  Double(9.0)
      }
    ]
  },
  {
    _id: ObjectId("660000000000000000000023"),
    correo:        "carla@ejemplo.com",
    nombre:        "Carla",
    contrasena:    "CarlaPass1",
    fechaRegistro: ISODate("2025-06-05T07:00:00Z"),
    pais:          "Espana",
    continente:    "Europa",
    estadisticas: {
      totalLogros:              NumberInt(3),
      totalEnemigosDerrotados:  NumberInt(200),
      totalMisionesCompletadas: NumberInt(7),
      totalHorasJugadas:        Double(9.5),
      progresoGeneral:          Double(55.0)
    },
    logros: [
      {
        nombre:        "Explorador Novato",
        descripcion:   "Visita tu primera ubicacion oculta",
        recompensaXP:  NumberInt(200),
        tipo:          "exploracion",
        fechaObtenido: ISODate("2025-06-05T08:00:00Z"),
        horasJugadas:  Double(1.0)
      },
      {
        nombre:        "Viajero del Oeste",
        descripcion:   "Explora la region Oeste completamente",
        recompensaXP:  NumberInt(300),
        tipo:          "exploracion",
        fechaObtenido: ISODate("2025-06-05T12:00:00Z"),
        horasJugadas:  Double(5.0)
      },
      {
        nombre:        "Campeon Defensor",
        descripcion:   "Bloquea 100 ataques enemigos",
        recompensaXP:  NumberInt(700),
        tipo:          "defensa",
        fechaObtenido: ISODate("2025-06-06T07:00:00Z"),
        horasJugadas:  Double(24.0) 
      }
    ]
  },
  {
    _id: ObjectId("660000000000000000000024"),
    correo:        "diego@ejemplo.com",
    nombre:        "Diego",
    contrasena:    "DiegoPass2",
    fechaRegistro: ISODate("2025-06-12T14:00:00Z"),
    pais:          "Mexico",
    continente:    "America",
    estadisticas: {
      totalLogros:              NumberInt(1),
      totalEnemigosDerrotados:  NumberInt(50),
      totalMisionesCompletadas: NumberInt(2),
      totalHorasJugadas:        Double(3.0),
      progresoGeneral:          Double(30.0)
    },
    logros: [
      {
        nombre:        "Viajero del Oeste",
        descripcion:   "Explora la region Oeste completamente",
        recompensaXP:  NumberInt(300),
        tipo:          "exploracion",
        fechaObtenido: ISODate("2025-06-12T15:00:00Z"),
        horasJugadas:  Double(1.0)
      }
    ]
  },
  {
    _id: ObjectId("660000000000000000000025"),
    correo:        "elena@ejemplo.com",
    nombre:        "Elena",
    contrasena:    "ElenaPass3",
    fechaRegistro: ISODate("2025-06-08T10:00:00Z"),
    pais:          "Peru",
    continente:    "America",
    estadisticas: {
      totalLogros:              NumberInt(2),
      totalEnemigosDerrotados:  NumberInt(65),
      totalMisionesCompletadas: NumberInt(4),
      totalHorasJugadas:        Double(10.0),
      progresoGeneral:          Double(60.0)
    },
    logros: [
      {
        nombre:        "Conquistador de Mazmorras",
        descripcion:   "Completa tu primera mazmorra",
        recompensaXP:  NumberInt(500),
        tipo:          "combate",
        fechaObtenido: ISODate("2025-06-08T12:00:00Z"),
        horasJugadas:  Double(2.0)
      },
      {
        nombre:        "Viajero del Oeste",
        descripcion:   "Explora la region Oeste completamente",
        recompensaXP:  NumberInt(300),
        tipo:          "exploracion",
        fechaObtenido: ISODate("2025-06-09T12:00:00Z"),
        horasJugadas:  Double(26.0) 
      }
    ]
  },
  {
    _id: ObjectId("660000000000000000000026"),
    correo:        "federico@ejemplo.com",
    nombre:        "Federico",
    contrasena:    "FedPass4",
    fechaRegistro: ISODate("2025-06-15T10:00:00Z"),
    pais:          "Argentina",
    continente:    "America",
    estadisticas: {
      totalLogros:              NumberInt(2),
      totalEnemigosDerrotados:  NumberInt(120),
      totalMisionesCompletadas: NumberInt(6),
      totalHorasJugadas:        Double(7.0),
      progresoGeneral:          Double(45.0)
    },
    logros: [
      {
        nombre:        "Maestro Mago",
        descripcion:   "Aprende 10 hechizos diferentes",
        recompensaXP:  NumberInt(800),
        tipo:          "magia",
        fechaObtenido: ISODate("2025-06-15T12:00:00Z"),
        horasJugadas:  Double(2.0)
      },
      {
        nombre:        "Descubridor de Tesoros",
        descripcion:   "Encuentra 50 tesoros ocultos",
        recompensaXP:  NumberInt(600),
        tipo:          "exploracion",
        fechaObtenido: ISODate("2025-06-15T15:00:00Z"),
        horasJugadas:  Double(5.0)
      }
    ]
  },
  {
    _id: ObjectId("660000000000000000000027"),
    correo:        "gustavo@ejemplo.com",
    nombre:        "Gustavo",
    contrasena:    "GusPass5",
    fechaRegistro: ISODate("2025-06-20T10:00:00Z"),
    pais:          "Colombia",
    continente:    "America",
    estadisticas: {
      totalLogros:              NumberInt(2),
      totalEnemigosDerrotados:  NumberInt(30),
      totalMisionesCompletadas: NumberInt(1),
      totalHorasJugadas:        Double(2.0),
      progresoGeneral:          Double(10.0)
    },
    logros: [
      {
        nombre:        "Maestro Mago",
        descripcion:   "Aprende 10 hechizos diferentes",
        recompensaXP:  NumberInt(800),
        tipo:          "magia",
        fechaObtenido: ISODate("2025-06-20T11:00:00Z"),
        horasJugadas:  Double(1.0)
      },
      {
        nombre:        "Campeon Defensor",
        descripcion:   "Bloquea 100 ataques enemigos",
        recompensaXP:  NumberInt(700),
        tipo:          "defensa",
        fechaObtenido: ISODate("2025-06-20T12:00:00Z"),
        horasJugadas:  Double(2.0)
      }
    ]
  }
]);
