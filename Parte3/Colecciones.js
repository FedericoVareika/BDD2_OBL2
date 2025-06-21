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
        continente:    {
          enum: ["África","América","Asia","Europa","Oceanía"]
        },
        estadisticas: {
          bsonType: "object",
          required: [
            "totalLogros",
            "totalEnemigosDerrotados",
            "totalMisionesCompletadas",
            "totalHorasJugadas",
            "progresoGeneral"
          ],
          properties: {
            totalLogros:              { bsonType: "int",    minimum: 0 },
            totalEnemigosDerrotados:  { bsonType: "int",    minimum: 0 },
            totalMisionesCompletadas: { bsonType: "int",    minimum: 0 },
            totalHorasJugadas:        { bsonType: "double", minimum: 0 },
            progresoGeneral:          { bsonType: "double", minimum: 0, maximum: 100 }
          }
        },
        logros: {
          bsonType: "array",
          items: {
            bsonType: "object",
            required: ["idLogro","fechaObtenido"],
            properties: {
              idLogro:      { bsonType: "objectId" },
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
