db.Usuario.aggregate([

  // 1) Descomponer el array de logros en un documento por cada logro
  { $unwind: "$logros" },

  // 2) Hacer un “join” con la colección Logros para traer el detalle de cada logro
  {
    $lookup: {
      from:         "Logros",                  // colección externa
      localField:   "logros.logroId",          // campo en Usuario
      foreignField: "_id",                     // campo en Logros
      as:           "infoLogro"                // alias para el array resultante
    }
  },

  // 3) Desplegar el array infoLogro para que cada documento tenga el subdocumento directo
  { $unwind: "$infoLogro" },

  // 4) Filtrar solo los logros cuyo tipo sea “exploración”
  { $match: { "infoLogro.tipo": "exploración" } },

  // 5) Agrupar por usuario (ID, nombre y correo) y contar cuántos logros de exploración tiene
  {
    $group: {
      _id: {
        id:     "$_id",
        nombre: "$nombre",
        correo: "$correo"
      },
      totalExploracion: { $sum: 1 }
    }
  },

  // 6) Dar forma al documento de salida
  {
    $project: {
      _id:               0,                   // ocultamos el campo interno _id
      usuarioId:         "$_id.id",           // extraemos el ID
      nombre:            "$_id.nombre",       // nombre del usuario
      correo:            "$_id.correo",       // correo del usuario
      totalExploracion:  1                    // el conteo de logros de exploración
    }
  }

]);
