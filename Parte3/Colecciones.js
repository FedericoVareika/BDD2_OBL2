db.createCollection("Logros", {
  validator: {
    $jsonSchema: {
      bsonType: "object",
      required: ["nombre","descripcion","recompensaXP","tipo"],
      properties: {
        nombre:       { bsonType: "string" },
        descripcion:  { bsonType: "string" },
        recompensaXP: { bsonType: "int",    minimum: 0 },
        tipo:         { bsonType: "string" }
      }
    }
  },
  validationLevel:  "strict",
  validationAction: "error"
});


db.createCollection("Usuario", {
  validator: {
    $jsonSchema: {
      bsonType: "object",
      required: [
        "correo","nombre","contrasena",
        "fechaRegistro","pais","continente",
        "estadisticas","logros"
      ],
      properties: {
        correo:        { bsonType: "string" },
        nombre:        { bsonType: "string" },
        contrasena:    { bsonType: "string", minLength: 6, maxLength: 16 },
        fechaRegistro: { bsonType: "date" },
        pais:          { bsonType: "string" },
        continente:    { enum: ["Africa","America","Asia","Europa","Oceania"] },
        estadisticas: {
          bsonType: "object",
          required: [
            "totalAchievements",
            "totalEnemiesDefeated",
            "totalMissionsCompleted",
            "totalHoursPlayed",
            "overallProgress"
          ],
          properties: {
            totalAchievements:     { bsonType: "int",    minimum: 0 },
            totalEnemiesDefeated:  { bsonType: "int",    minimum: 0 },
            totalMissionsCompleted:{ bsonType: "int",    minimum: 0 },
            totalHoursPlayed:      { bsonType: "double", minimum: 0 },
            overallProgress:       { bsonType: "double", minimum: 0, maximum: 100 }
          }
        },
        logros: {
          bsonType: "array",
          items: {
            bsonType: "object",
            required: ["logroId","fechaObtenido"],
            properties: {
              logroId:      { bsonType: "objectId" },
              fechaObtenido:{ bsonType: "date" }
            }
          }
        }
      }
    }
  },
  validationLevel:  "strict",
  validationAction: "error"
});
