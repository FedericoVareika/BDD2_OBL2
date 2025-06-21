db.Logros.insertMany([
  {
    _id: ObjectId("650000000000000000000001"),
    nombre:       "Explorador Novato",
    descripcion:  "Visita tu primera ubicación oculta",
    recompensaXP: 200,
    tipo:         "exploración"
  },
  {
    _id: ObjectId("650000000000000000000002"),
    nombre:       "Conquistador de Mazmorras",
    descripcion:  "Completa tu primera mazmorra",
    recompensaXP: 500,
    tipo:         "combate"
  },
  {
    _id: ObjectId("650000000000000000000003"),
    nombre:       "Viajero del Oeste",
    descripcion:  "Explora la región Oeste completamente",
    recompensaXP: 300,
    tipo:         "exploración"
  },
  {
    _id: ObjectId("650000000000000000000004"),
    nombre:       "Maestro Mago",
    descripcion:  "Aprende 10 hechizos diferentes",
    recompensaXP: 800,
    tipo:         "magia"
  },
  {
    _id: ObjectId("650000000000000000000005"),
    nombre:       "Campeón Defensor",
    descripcion:  "Bloquea 100 ataques enemigos",
    recompensaXP: 700,
    tipo:         "defensa"
  }
]);


// la de usuario no anda
db.Usuario.insertMany([
  {
    _id: ObjectId("660000000000000000000011"),
    correo:        "ana@ejemplo.com",
    nombre:        "Ana",
    contrasena:    "Secreto01",
    fechaRegistro: ISODate("2025-06-01T08:00:00Z"),
    pais:          "Uruguay",
    continente:    "América",
    estadisticas: {
      totalLogros:              NumberInt(3),
      totalEnemigosDerrotados:  NumberInt(150),
      totalMisionesCompletadas: NumberInt(5),
      totalHorasJugadas:        12.5,
      progresoGeneral:          Double(50.0)
    },
    logros: [
      { idLogro: ObjectId("650000000000000000000001"), fechaObtenido: ISODate("2025-06-01T10:00:00Z") },
      { idLogro: ObjectId("650000000000000000000003"), fechaObtenido: ISODate("2025-06-01T15:00:00Z") },
      { idLogro: ObjectId("650000000000000000000002"), fechaObtenido: ISODate("2025-06-02T12:00:00Z") }
    ]
  },
  {
    _id: ObjectId("660000000000000000000012"),
    correo:        "bruno@ejemplo.com",
    nombre:        "Bruno",
    contrasena:    "BrunoPass9",
    fechaRegistro: ISODate("2025-06-10T09:00:00Z"),
    pais:          "Chile",
    continente:    "América",
    estadisticas: {
      totalLogros:              NumberInt(2),
      totalEnemigosDerrotados:  NumberInt(80),
      totalMisionesCompletadas: NumberInt(3),
      totalHorasJugadas:        Double(8.0),
      progresoGeneral:          Double(60.0)
    },
    logros: [
      { idLogro: ObjectId("650000000000000000000001"), fechaObtenido: ISODate("2025-06-10T13:00:00Z") },
      { idLogro: ObjectId("650000000000000000000004"), fechaObtenido: ISODate("2025-06-10T18:00:00Z") }
    ]
  },
  {
    _id: ObjectId("660000000000000000000013"),
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
      totalHorasJugadas:        9.5,
      progresoGeneral:          Double(55.0)
    },
    logros: [
      { idLogro: ObjectId("650000000000000000000001"), fechaObtenido: ISODate("2025-06-05T08:00:00Z") },
      { idLogro: ObjectId("650000000000000000000003"), fechaObtenido: ISODate("2025-06-05T10:00:00Z") },
      { idLogro: ObjectId("650000000000000000000005"), fechaObtenido: ISODate("2025-06-05T11:00:00Z") }
    ]
  },
  {
    _id: ObjectId("660000000000000000000014"),
    correo:        "diego@ejemplo.com",
    nombre:        "Diego",
    contrasena:    "DiegoPass2",
    fechaRegistro: ISODate("2025-06-12T14:00:00Z"),
    pais:          "Mexico",
    continente:    "América",
    estadisticas: {
      totalLogros:              NumberInt(1),
      totalEnemigosDerrotados:  NumberInt(50),
      totalMisionesCompletadas: NumberInt(2),
      totalHorasJugadas:        Double(3.0),
      progresoGeneral:          Double(30.0)
    },
    logros: [
      { idLogro: ObjectId("650000000000000000000003"), fechaObtenido: ISODate("2025-06-12T15:00:00Z") }
    ]
  },
  {
    _id: ObjectId("660000000000000000000015"),
    correo:        "elena@ejemplo.com",
    nombre:        "Elena",
    contrasena:    "ElenaPass3",
    fechaRegistro: ISODate("2025-06-08T10:00:00Z"),
    pais:          "Peru",
    continente:    "América",
    estadisticas: {
      totalLogros:              NumberInt(2),
      totalEnemigosDerrotados:  NumberInt(65),
      totalMisionesCompletadas: NumberInt(4),
      totalHorasJugadas:        Double(10.0),
      progresoGeneral:          Double(60.0)
    },
    logros: [
      { idLogro: ObjectId("650000000000000000000002"), fechaObtenido: ISODate("2025-06-08T12:00:00Z") },
      { idLogro: ObjectId("650000000000000000000003"), fechaObtenido: ISODate("2025-06-08T19:00:00Z") }
    ]
  }
]);
