db.Usuario.aggregate([
  { $unwind: "$logros" },
  { 
    $match: {
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
  {
    $group: {
      _id:           "$logros.idLogro",
      vecesObtenido: { $sum: 1 }
    }
  },
  { $sort: { vecesObtenido: -1 } },
  { $limit: 5 },
  {
    $lookup: {
      from:         "Logros",
      localField:   "_id",
      foreignField: "_id",
      as:           "infoLogro"
    }
  },
  { $unwind: "$infoLogro" },
  {
    $project: {
      _id:           0,
      idLogro:       "$_id",
      nombre:        "$infoLogro.nombre",
      vecesObtenido: 1
    }
  }
]);