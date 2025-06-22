db.Personaje.aggregate([
  { 
    $match: { 
      "estadisticas.progresoGeneral": { $lte: 60 } 
    } 
  },
  { 
    $sort: { 
      "estadisticas.totalEnemigosDerrotados": -1 
    } 
  },
  { $limit: 5 },
  {
    $project: {
      _id:                0,
      nombre:             1,
      correo:             1,
      enemigosDerrotados: "$estadisticas.totalEnemigosDerrotados",
      porcentajeProgreso: "$estadisticas.progresoGeneral"
    }
  }
]);
