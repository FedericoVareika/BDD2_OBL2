db.Personaje.aggregate([
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
      _id:           "$logros.nombre",
      vecesObtenido: { $sum: 1 }
    }
  },
  { $sort: { vecesObtenido: -1 } },
  { $limit: 5 },
  {
    $project: {
      _id:           0,
      nombre:        "$_id",
      vecesObtenido: 1
    }
  }
]);