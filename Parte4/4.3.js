db.Usuario.aggregate([

  // 1) Desenrolla cada logro
  { $unwind: "$logros" },

  // 2) Filtra solo los obtenidos en las primeras 10 horas
  { $match: {
      $expr: {
        $lte: [
          {
            $dateDiff: {
              startDate: "$fechaRegistro",
              endDate:   "$logros.fechaObtenido",
              unit:      "hour"
            }
          },
          10
        ]
      }
    }
  },

  // 3) Cuenta cuántas veces aparece cada logro
  {
    $group: {
      _id:   "$logros.logroId",
      count: { $sum: 1 }
    }
  },

  // 4) Ordena de mayor a menor y limita a 5
  { $sort: { count: -1 } },
  { $limit: 5 },

  // 5) Une con la colección de Logros para obtener el nombre
  {
    $lookup: {
      from:         "Logros",
      localField:   "_id",
      foreignField: "_id",
      as:           "infoLogro"
    }
  },
  { $unwind: "$infoLogro" },

  // 6) Proyecta el resultado final
  {
    $project: {
      _id:           0,
      logroId:       "$_id",
      nombre:        "$infoLogro.nombre",
      vecesObtenido: "$count"
    }
  }

]);
