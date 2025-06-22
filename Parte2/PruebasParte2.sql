ALTER SESSION SET "_ORACLE_SCRIPT"=true;
SET serveroutput ON; 

----------------------------------------------------------------
------------------------- IMPORTANTE ---------------------------
----------------------------------------------------------------
------------- CORRER PRUEBAS LUEGO DE TENER LOS ----------------
------------ CASOS DE PRUEBA ORIGINALES INSERTADOS -------------
----------------------------------------------------------------
----------------------------------------------------------------

SAVEPOINT test_init;

/*
2.1: 
Implementar un servicio que permita asignar recompensas de una misión a un
personaje. 
Recordar que pueden incluir puntos de experiencia, ítems especiales y/o monedas.
Se debe verificar que el estado de la misión sea “completada” y que no se
haya asignado ya dicha recompensa.
*/

DECLARE 
  v_id_personaje Personaje.id%TYPE;  
  v_id_mision Mision.id%TYPE;  
BEGIN
  INSERT INTO Mision_Otorga_Item(idMision,idItem,cantidad)
    VALUES(
      (SELECT id FROM Mision     WHERE codigo='M003'),
      (SELECT id FROM ItemTable WHERE nombre='EspadaCorta'),1
    );

  INSERT INTO Mision_Otorga_Item(idMision,idItem,cantidad)
    VALUES(
      (SELECT id FROM Mision     WHERE codigo='M003'),
      (SELECT id FROM ItemTable WHERE nombre='Piedra Luna'),4
    );

  INSERT INTO Inventario_Tiene_Item(idInventario,idItem,cantidad,equipado)
    VALUES(
      (SELECT id FROM Inventario WHERE idPersonaje=(SELECT id FROM Personaje WHERE idUsuario=(SELECT id FROM Usuario WHERE nombre='Daniel'))),
      (SELECT id FROM ItemTable WHERE nombre='PocionVida'),2,'Y'
    );

  SELECT id INTO v_id_personaje FROM Personaje WHERE idUsuario=(SELECT id FROM Usuario WHERE nombre='Daniel');
  SELECT id INTO v_id_mision    FROM Mision    WHERE codigo='M003';

  asignar_recompensa_mision(v_id_personaje, v_id_mision);

  FOR my_cursor IN (
    SELECT it.nombre as nombre, iti.cantidad as cantidad
    FROM ItemTable it 
    JOIN Inventario_Tiene_Item iti 
      ON it.id = iti.idItem
    WHERE iti.idInventario = (
      SELECT id 
      FROM Inventario 
      WHERE idPersonaje=(
        SELECT id 
        FROM Personaje 
        WHERE idUsuario=(
          SELECT id 
          FROM Usuario 
          WHERE nombre='Daniel')))
  ) 
  LOOP
    DBMS_OUTPUT.PUT_LINE('item = ' || my_cursor.nombre ||
      ', cantidad = ' || my_cursor.cantidad);
  END LOOP;
END;
/

ROLLBACK TO test_init;

/*
2.2: 
Implementar un servicio que muestre los 10 ítems más equipados, permitiendo 
un parámetro opcional que filtre por categoría de ítem.
*/

DECLARE
  v_id_juan_inv     Inventario.id%TYPE;
  v_id_federica_inv Inventario.id%TYPE;
  v_id_espada       ItemTable.id%TYPE;
  v_id_armadura     ItemTable.id%TYPE;
BEGIN
  -- Get item IDs
  SELECT id INTO v_id_espada FROM ItemTable WHERE nombre = 'EspadaCorta';
  SELECT id INTO v_id_armadura FROM ItemTable WHERE nombre = 'ArmaduraPlateada';

  -- Get inventory IDs
  SELECT id INTO v_id_juan_inv FROM Inventario
  WHERE idPersonaje = (SELECT id FROM Personaje WHERE idUsuario = (SELECT id FROM Usuario WHERE nombre = 'Juan'));

  SELECT id INTO v_id_federica_inv FROM Inventario
  WHERE idPersonaje = (SELECT id FROM Personaje WHERE idUsuario = (SELECT id FROM Usuario WHERE nombre = 'Federica'));

  -- Juan: update cantidad de EspadaCorta a 3
  MERGE INTO Inventario_Tiene_Item iti
  USING DUAL ON (iti.idInventario = v_id_juan_inv AND iti.idItem = v_id_espada)
  WHEN MATCHED THEN
    UPDATE SET cantidad = 3, equipado = 'Y'
  WHEN NOT MATCHED THEN
    INSERT (idInventario, idItem, cantidad, equipado)
    VALUES (v_id_juan_inv, v_id_espada, 3, 'Y');

  -- Federica: 3 ArmaduraPlateada
  MERGE INTO Inventario_Tiene_Item iti
  USING DUAL ON (iti.idInventario = v_id_federica_inv AND iti.idItem = v_id_armadura)
  WHEN MATCHED THEN
    UPDATE SET cantidad = 3, equipado = 'Y'
  WHEN NOT MATCHED THEN
    INSERT (idInventario, idItem, cantidad, equipado)
    VALUES (v_id_federica_inv, v_id_armadura, 3, 'Y');

  -- Run test without filter
  DBMS_OUTPUT.PUT_LINE('--- TOP 10 EQUIPADOS (sin filtro) ---');
  items_mas_equipados;

  -- Run test with filter: 'armas'
  DBMS_OUTPUT.PUT_LINE('--- TOP 10 EQUIPADOS (categoría = ''armas'') ---');
  items_mas_equipados('armas');

  -- Run test with filter: 'armaduras'
  DBMS_OUTPUT.PUT_LINE('--- TOP 10 EQUIPADOS (categoría = ''armaduras'') ---');
  items_mas_equipados('armaduras');

END;
/

ROLLBACK TO test_init;

