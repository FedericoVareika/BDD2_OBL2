ALTER SESSION SET "_ORACLE_SCRIPT"=true;
SET serveroutput ON; 

----------------------------------------------------------------
------------------------- IMPORTANTE ---------------------------
----------------------------------------------------------------
------------- CORRER PRUEBAS LUEGO DE TENER LOS ----------------
------------ CASOS DE PRUEBA ORIGINALES INSERTADOS -------------
----------------------------------------------------------------
----------------------------------------------------------------


--------------------------------------------------------------
-- Jefe.Tipo de un enemigo en la tabla Jefe debe ser “jefe” --

INSERT INTO Enemigo(nombre, nivel, ubicacion, tipo)
  VALUES('Enemigo normal', 6, 'Bosque Sombrío', 'normal');

INSERT INTO Jefe(id, idMision)
  VALUES(
    (SELECT id FROM Enemigo WHERE nombre='Enemigo normal'),
    (SELECT id FROM Mision  WHERE codigo='M002')
  );

----------------------------------------------------------------------------
-- Un personaje no puede equipar dos ítems de la misma categoría a la vez -- 

INSERT INTO Inventario_Tiene_Item(idInventario,idItem,cantidad,equipado)
  VALUES(
    (SELECT id FROM Inventario WHERE idPersonaje=(SELECT id FROM Personaje WHERE idUsuario=(SELECT id FROM Usuario WHERE nombre='Juan'))),
    (SELECT id FROM ItemTable WHERE nombre='AmuletoLuna'),1,'Y'
  );

INSERT INTO Inventario_Tiene_Item(idInventario,idItem,cantidad,equipado)
  VALUES(
    (SELECT id FROM Inventario WHERE idPersonaje=(SELECT id FROM Personaje WHERE idUsuario=(SELECT id FROM Usuario WHERE nombre='Juan'))),
    (SELECT id FROM ItemTable WHERE nombre='AmuletoSol'),1,'Y'
  );
