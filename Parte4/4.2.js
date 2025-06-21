db.Usuario.aggregate([
  // 1) Filtrar usuarios con progreso ≤ 60%
  { 
    $match: { 
      "estadisticas.overallProgress": { $lte: 60 } 
    } 
  },

  // 2) Ordenar de mayor a menor por enemigos derrotados
  { 
    $sort: { 
      "estadisticas.totalEnemiesDefeated": -1 
    } 
  },

  // 3) Limitar a los 5 primeros
  { 
    $limit: 5 
  },

  // 4) Proyectar los campos de salida
  { 
    $project: {
      _id:                0,
      usuarioId:          "$_id",
      nombre:             1,
      correo:             1,
      enemigosDerrotados: "$estadisticas.totalEnemiesDefeated",
      porcentajeProgreso: "$estadisticas.overallProgress"
    }
  }
]);
