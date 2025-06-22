db.Personaje.aggregate([
  { $unwind: "$logros" },
  { $match: { "logros.tipo": "exploracion" } },  
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
      _id:              0,
      nombre:           "$_id.nombre",
      correo:           "$_id.correo",
      totalExploracion: 1
    }
  }
]);