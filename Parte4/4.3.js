db.Personaje.aggregate([
  { $unwind: "$logros" },
  { $match: { "logros.horasJugadas": { $lte: 10 } } },
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