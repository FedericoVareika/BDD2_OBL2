SET DEFINE OFF;


-- 1. Insert Usuarios (uno por INSERT)
INSERT INTO Usuario(correo, nombre, contrasena, fechaRegistro, pais, continente)
  VALUES('juan@gmail.com','Juan','Contra123!',TO_DATE('2025-05-21','YYYY-MM-DD'),'España','Europa');


INSERT INTO Usuario(correo, nombre, contrasena, fechaRegistro, pais, continente)
  VALUES('pedro@gmail.com','Pedro','Contra123!',TO_DATE('2025-05-21','YYYY-MM-DD'),'Brasil','America');


INSERT INTO Usuario(correo, nombre, contrasena, fechaRegistro, pais, continente)
  VALUES('carla@gmail.com','Carla','Contra123!',TO_DATE('2025-05-21','YYYY-MM-DD'),'China','Asia');


INSERT INTO Usuario(correo, nombre, contrasena, fechaRegistro, pais, continente)
  VALUES('daniel@gmail.com','Daniel','Contra123!',TO_DATE('2025-05-21','YYYY-MM-DD'),'Sudáfrica','Africa');


INSERT INTO Usuario(correo, nombre, contrasena, fechaRegistro, pais, continente)
  VALUES('federica@gmail.com','Federica','Contra123!',TO_DATE('2025-05-21','YYYY-MM-DD'),'Australia','Oceania');


-- 2. Insert Personajes (uno por INSERT)
INSERT INTO Personaje(idUsuario, especie, fuerza, agilidad, inteligencia, vitalidad, resistencia, nivel, experiencia, cantHoras, monedas)
  VALUES((SELECT id FROM Usuario WHERE nombre='Juan'),'Bestia',50,40,30,60,20,10,1500,5,100);


INSERT INTO Personaje(idUsuario, especie, fuerza, agilidad, inteligencia, vitalidad, resistencia, nivel, experiencia, cantHoras, monedas)
  VALUES((SELECT id FROM Usuario WHERE nombre='Pedro'),'Humano',60,30,50,40,70,20,2500,10,200);


INSERT INTO Personaje(idUsuario, especie, fuerza, agilidad, inteligencia, vitalidad, resistencia, nivel, experiencia, cantHoras, monedas)
  VALUES((SELECT id FROM Usuario WHERE nombre='Carla'),'Espíritu',30,60,70,50,40,15,2000,8,150);


INSERT INTO Personaje(idUsuario, especie, fuerza, agilidad, inteligencia, vitalidad, resistencia, nivel, experiencia, cantHoras, monedas)
  VALUES((SELECT id FROM Usuario WHERE nombre='Daniel'),'Demonio',70,50,40,30,60,25,3000,12,250);


INSERT INTO Personaje(idUsuario, especie, fuerza, agilidad, inteligencia, vitalidad, resistencia, nivel, experiencia, cantHoras, monedas)
  VALUES((SELECT id FROM Usuario WHERE nombre='Federica'),'Demonio',70,50,40,30,60,50,3000,12,250);


-- 3. Insert Habilidades
INSERT INTO Habilidad(funcion, nombre, nivelMinimo, tipoEnergia)
  VALUES('ataque','GolpeFeroz',5,'Física');


INSERT INTO Habilidad(funcion, nombre, nivelMinimo, tipoEnergia)
  VALUES('defensa','EscudoMágico',10,'Mística');


INSERT INTO Habilidad(funcion, nombre, nivelMinimo, tipoEnergia)
  VALUES('magia','BolaDeFuego',15,'Mágica');


-- 4. Insert Misiones
INSERT INTO Mision(codigo, nombre, descripcion, nivelMinimo, experiencia, monedas)
  VALUES('M001','Misión 1','Misión super loca mega wow',5,500,50);


INSERT INTO Mision(codigo, nombre, descripcion, nivelMinimo, experiencia, monedas)
  VALUES('M002','Misión 2','Misión wow pero no tanto como la anterior',10,1000,100);


INSERT INTO Mision(codigo, nombre, descripcion, nivelMinimo, experiencia, monedas)
  VALUES('M003','Misión 3','Jefe final chavales',25,300,30);


-- 5. Insert Zonas
INSERT INTO Zona(nombre, descripcion, terreno, ubicacion, nivelMinimo)
  VALUES('Bosque Sombrío','Bosque oscuro y peligroso','Bosque','Norte',8);


INSERT INTO Zona(nombre, descripcion, terreno, ubicacion, nivelMinimo)
  VALUES('Caverna de Hielo','Cavernas heladas internas','Cueva','Sur',12);


-- 6. Insert Botines
INSERT INTO Botin(monedas) VALUES(200);


INSERT INTO Botin(monedas) VALUES(500);


-- 7. Insert Enemigos
INSERT INTO Enemigo(nombre, nivel, ubicacion, tipo)
  VALUES('Lobo Salvaje',5,'Bosque Sombrío','normal');


INSERT INTO Enemigo(nombre, nivel, ubicacion, tipo)
  VALUES('Perry en ornitorrinco',5,'Nickelodeon','elite');


INSERT INTO Enemigo(nombre, nivel, ubicacion, tipo)
  VALUES('Ogro de Fuego',15,'Caverna de Hielo','jefe');


-- 8. Insert Jefe
INSERT INTO Jefe(id, idMision)
  VALUES(
    (SELECT id FROM Enemigo WHERE nombre='Ogro de Fuego'),
    (SELECT id FROM Mision  WHERE codigo='M002')
  );


-- 9. Insert Inventarios
INSERT INTO Inventario(idPersonaje)
  VALUES((SELECT id FROM Personaje WHERE idUsuario=(SELECT id FROM Usuario WHERE nombre='Pedro')));


INSERT INTO Inventario(idPersonaje)
  VALUES((SELECT id FROM Personaje WHERE idUsuario=(SELECT id FROM Usuario WHERE nombre='Juan')));

INSERT INTO Inventario(idPersonaje)
  VALUES((SELECT id FROM Personaje WHERE idUsuario=(SELECT id FROM Usuario WHERE nombre='Federica')));

-- 10. Insert Items
INSERT INTO ItemTable(categoria,nombre,rareza,nivelMinimo,caracteristicasQueAfecta,intercambiable)
  VALUES('armas','EspadaCorta','común',1,'fuerza',1);


INSERT INTO ItemTable(categoria,nombre,rareza,nivelMinimo,caracteristicasQueAfecta,intercambiable)
  VALUES('armaduras','ArmaduraPlateada','rara',10,'resistencia',1);


INSERT INTO ItemTable(categoria,nombre,rareza,nivelMinimo,caracteristicasQueAfecta,intercambiable)
  VALUES('consumibles','PocionVida','epica',20,'vitalidad',1);


INSERT INTO ItemTable(categoria,nombre,rareza,nivelMinimo,caracteristicasQueAfecta,intercambiable)
  VALUES('materiales','Piedra Luna','legendaria',30,'inteligencia',0);


INSERT INTO ItemTable(categoria,nombre,rareza,nivelMinimo,caracteristicasQueAfecta,intercambiable)
  VALUES('reliquias','AmuletoSol','legendaria',50,'inteligencia',0);
  
INSERT INTO ItemTable(categoria,nombre,rareza,nivelMinimo,caracteristicasQueAfecta,intercambiable)
  VALUES('reliquias','AmuletoLuna','legendaria',50,'inteligencia',0);


-- 11. Relaciones simples
INSERT INTO Personaje_Tiene_Habilidad(idPersonaje,idHabilidad)
  VALUES(
    (SELECT id FROM Personaje WHERE idUsuario=(SELECT id FROM Usuario WHERE nombre='Federica')),
    (SELECT id FROM Habilidad WHERE nombre='GolpeFeroz')
  );


INSERT INTO Mision_Desbloquea_Habilidad(idHabilidad,idMision)
  VALUES(
    (SELECT id FROM Habilidad WHERE nombre='BolaDeFuego'),
    (SELECT id FROM Mision    WHERE codigo='M003')
  );


INSERT INTO Mision_Desbloquea_Zona(idMision,idZona)
  VALUES(
    (SELECT id FROM Mision WHERE codigo='M001'),
    (SELECT id FROM Zona    WHERE nombre='Bosque Sombrío')
  );


INSERT INTO Zona_Tiene_Enemigo(idZona,idEnemigo)
  VALUES(
    (SELECT id FROM Zona    WHERE nombre='Caverna de Hielo'),
    (SELECT id FROM Enemigo WHERE nombre='Lobo Salvaje')
  );


INSERT INTO Inventario_Tiene_Item(idInventario,idItem,cantidad,equipado)
  VALUES(
    (SELECT id FROM Inventario WHERE idPersonaje=(SELECT id FROM Personaje WHERE idUsuario=(SELECT id FROM Usuario WHERE nombre='Juan'))),
    (SELECT id FROM ItemTable WHERE nombre='EspadaCorta'),1,'Y'
  );


INSERT INTO Mision_Otorga_Item(idMision,idItem,cantidad)
  VALUES(
    (SELECT id FROM Mision     WHERE codigo='M003'),
    (SELECT id FROM ItemTable WHERE nombre='PocionVida'),3
  );


INSERT INTO Enemigo_Suelta_Botin(idEnemigo,idBotin)
  VALUES(
    (SELECT id FROM Enemigo WHERE nombre='Lobo Salvaje'),
    (SELECT id FROM Botin   WHERE monedas=200)
  );


INSERT INTO Botin_Otorga_Item(idBotin,idItem,cantidad)
  VALUES(
    (SELECT id FROM Botin     WHERE monedas=200),
    (SELECT id FROM ItemTable WHERE nombre='EspadaCorta'),1
  );


INSERT INTO Jefe_Condicionado_Por_Zona(idZona,idJefe)
  VALUES(
    (SELECT id FROM Zona   WHERE nombre='Caverna de Hielo'),
    (SELECT id FROM Jefe   WHERE id=(SELECT id FROM Enemigo WHERE nombre='Ogro de Fuego'))
  );


INSERT INTO Jefe_Condicionado_Por_Mision(idMision,idJefe)
  VALUES(
    (SELECT id FROM Mision WHERE codigo='M002'),
    (SELECT id FROM Jefe   WHERE id=(SELECT id FROM Enemigo WHERE nombre='Ogro de Fuego'))
  );


INSERT INTO Jefe_Tiene_Habilidad(idJefe,idHabilidad)
  VALUES(
    (SELECT id FROM Jefe WHERE id=(SELECT id FROM Enemigo WHERE nombre='Ogro de Fuego')),
    (SELECT id FROM Habilidad WHERE nombre='BolaDeFuego')
  );


-- 12. Usuario progresa misiones
INSERT INTO Usuario_Progresa_Mision(idPersonaje,idMision,estado)
  VALUES(
    (SELECT id FROM Personaje WHERE idUsuario=(SELECT id FROM Usuario WHERE nombre='Juan')), 
    (SELECT id FROM Mision    WHERE codigo='M001'),
    'No iniciada'
  );


INSERT INTO Usuario_Progresa_Mision(idPersonaje,idMision,estado)
  VALUES(
    (SELECT id FROM Personaje WHERE idUsuario=(SELECT id FROM Usuario WHERE nombre='Carla')), 
    (SELECT id FROM Mision    WHERE codigo='M002'),
    'En progreso'
  );


INSERT INTO Usuario_Progresa_Mision(idPersonaje,idMision,estado)
  VALUES(
    (SELECT id FROM Personaje WHERE idUsuario=(SELECT id FROM Usuario WHERE nombre='Daniel')), 
    (SELECT id FROM Mision    WHERE codigo='M003'),
    'Completada'
  );

-- Guardar cambios
COMMIT;
