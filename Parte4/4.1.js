db.Usuario.aggregate([
  { $unwind: "$logros" },
  {
    $lookup: {
      from:         "Logros",
      localField:   "logros.idLogro",
      foreignField: "_id",
      as:           "infoLogro"
    }
  },
  { $unwind: "$infoLogro" },
  { $match: { "infoLogro.tipo": "exploración" } },
  {
    $group: {
      _id: {
        nombre: "$nombre",
        correo: "$correo"
      },
      totalExploracion: { $sum: 1 }
    }
  },
  {
    $project: {
      _id:               0,
      nombre:            "$_id.nombre",
      correo:            "$_id.correo",
      totalExploracion:  1
    }
  }
]);
