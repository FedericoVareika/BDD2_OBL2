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
  v_monedas Personaje.monedas%TYPE;
  v_xp Personaje.experiencia%TYPE;
BEGIN
  DBMS_OUTPUT.PUT_LINE(
    '------------------------- Test 2.1 -------------------------' || chr(13) || chr(10) ||
    'La mision M003 otorga 30 monedas, 300 de experiencia, una ' ||  chr(13) || chr(10) ||
    'EspadaCorta y una Piedra Luna. Y Daniel ya tiene completada' ||  chr(13) || chr(10) ||
    'esta mision, entonces al darle su recompensa, estos valores' ||  chr(13) || chr(10) ||
    'deben de cambiar de manera acorde.' ||  chr(13) || chr(10) ||
    '------------------------------------------------------------' || chr(13) || chr(10)
  );

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

  DBMS_OUTPUT.PUT_LINE('--- Antes de asignar recompensa ---');
  SELECT p.monedas, p.experiencia
  INTO v_monedas, v_xp 
  FROM Personaje p 
  WHERE p.id = v_id_personaje;
    
  DBMS_OUTPUT.PUT_LINE('monedas = ' || v_monedas || ', experiencia = ' || v_xp);

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

  asignar_recompensa_mision(v_id_personaje, v_id_mision);

  DBMS_OUTPUT.PUT_LINE('');
  DBMS_OUTPUT.PUT_LINE('--- Despues de asignar recompensa ---');

  SELECT p.monedas, p.experiencia
  INTO v_monedas, v_xp 
  FROM Personaje p 
  WHERE p.id = v_id_personaje;
    
  DBMS_OUTPUT.PUT_LINE('monedas = ' || v_monedas || ', experiencia = ' || v_xp);

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
  DBMS_OUTPUT.PUT_LINE(
    '------------------------ Test 2.2(1) ------------------------' || chr(13) || chr(10) ||
    'Asignar y equipar 2 de los items existentes. Uno a juan y ' ||  chr(13) || chr(10) ||
    'otro a federica. Al ser de distinta categoría los podemos' ||  chr(13) || chr(10) ||
    'filtrar.' ||  chr(13) || chr(10) ||
    '-------------------------------------------------------------' || chr(13) || chr(10)
  );

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

DECLARE
  v_id_juan_inv     Inventario.id%TYPE;
  v_id_federica_inv Inventario.id%TYPE;
  v_items           SYS_REFCURSOR;
  v_nombre          ItemTable.nombre%TYPE;
  v_id_item         ItemTable.id%TYPE;
  v_cantidad        NUMBER := 1;
BEGIN
  DBMS_OUTPUT.PUT_LINE(
    '------------------------ Test 2.2(2) ------------------------' || chr(13) || chr(10) ||
    'Crear 11 items nuevos, asignarle todos a juan, y solo los' ||  chr(13) || chr(10) ||
    'items 5-11 a federica. Tendria que mostrar solo 10 items,' ||  chr(13) || chr(10) ||
    'y los que estan asignados a ambos deberian estar ordenados' ||  chr(13) || chr(10) ||
    'primero' ||  chr(13) || chr(10) ||
    '-------------------------------------------------------------' || chr(13) || chr(10)
  );

  -- Obtener IDs de inventario
  SELECT id INTO v_id_juan_inv FROM Inventario
  WHERE idPersonaje = (SELECT id FROM Personaje WHERE idUsuario = (SELECT id FROM Usuario WHERE nombre = 'Juan'));

  SELECT id INTO v_id_federica_inv FROM Inventario
  WHERE idPersonaje = (SELECT id FROM Personaje WHERE idUsuario = (SELECT id FROM Usuario WHERE nombre = 'Federica'));

  -- Crear 11 ítems nuevos si es necesario
  FOR i IN 1..11 LOOP
    BEGIN
      INSERT INTO ItemTable(nombre, categoria, rareza, nivelMinimo, caracteristicasQueAfecta, intercambiable)
      VALUES ('ItemTest' || i, 'armas', 'rara', 1, 'fuerza', 1);
    EXCEPTION
      WHEN DUP_VAL_ON_INDEX THEN NULL; -- Ya existe
    END;
  END LOOP;

  -- Asignar ítems equipados a Juan (11 ítems con cantidad creciente)
  FOR i IN 1..11 LOOP
    SELECT id INTO v_id_item FROM ItemTable WHERE nombre = 'ItemTest' || i;

    MERGE INTO Inventario_Tiene_Item iti
    USING DUAL ON (iti.idInventario = v_id_juan_inv AND iti.idItem = v_id_item)
    WHEN MATCHED THEN
      UPDATE SET cantidad = i, equipado = 'Y'
    WHEN NOT MATCHED THEN
      INSERT (idInventario, idItem, cantidad, equipado)
      VALUES (v_id_juan_inv, v_id_item, i, 'Y');
  END LOOP;

  -- Asignar ítems equipados a Federica (11 ítems con cantidad creciente)
  FOR i IN 5..11 LOOP
    SELECT id INTO v_id_item FROM ItemTable WHERE nombre = 'ItemTest' || i;

    MERGE INTO Inventario_Tiene_Item iti
    USING DUAL ON (iti.idInventario = v_id_federica_inv AND iti.idItem = v_id_item)
    WHEN MATCHED THEN
      UPDATE SET cantidad = i, equipado = 'Y'
    WHEN NOT MATCHED THEN
      INSERT (idInventario, idItem, cantidad, equipado)
      VALUES (v_id_federica_inv, v_id_item, i, 'Y');
  END LOOP;

  -- Imprimir los 10 ítems más equipados sin filtro
  DBMS_OUTPUT.PUT_LINE('--- TOP 10 EQUIPADOS (sin filtro) ---');
  items_mas_equipados;

END;
/

ROLLBACK TO test_init;

/*
2.3: 
Implementar un servicio que identifique a los jugadores cuyo personaje haya
aumentado al menos 3 niveles en las últimas 24 horas y que a su vez cumplan
con haber completado al menos una misión de tipo principal en ese mismo período.

A estos personajes se les debe acreditar en su inventario un ítem de rareza
aleatoria.
*/

DECLARE
  v_id_usuario Usuario.id%TYPE;
  v_id_personaje Personaje.id%TYPE;
  v_id_mision Mision.id%TYPE;
BEGIN
  DBMS_OUTPUT.PUT_LINE(
    '------------------------- Test 2.3 -------------------------' || chr(13) || chr(10) ||
    'Crear 15 usuarios en total, todos aptos para acreditar' ||  chr(13) || chr(10) ||
    'un regalo diario. Primero ingresar 10 y despues los otros 5' || chr(13) || chr(10) ||
    '------------------------------------------------------------' || chr(13) || chr(10)
  );

  INSERT INTO Mision (codigo, nombre, descripcion, nivelMinimo, experiencia, monedas)
  VALUES ('PRINC01', 'Principal1', 'Test', 1, 100, 10)
  RETURNING id INTO v_id_mision;

  FOR i IN 1..10 LOOP
    INSERT INTO Usuario (correo, nombre, contrasena, fechaRegistro, pais, continente)
    VALUES ('test_user_' || i || '@mail.com', 'Tester_' || i, 'Abc1234!', SYSDATE, 'Uruguay', 'America')
    RETURNING id INTO v_id_usuario;

    INSERT INTO Personaje (idUsuario, especie, fuerza, agilidad, inteligencia, vitalidad,
                           resistencia, nivel, experiencia, cantHoras, monedas)
    VALUES (v_id_usuario, 'Humano', 20, 20, 20, 20, 20, 10, 100, 2, 50)
    RETURNING id INTO v_id_personaje;

    INSERT INTO Inventario (idPersonaje)
    VALUES (v_id_personaje);

    INSERT INTO Personaje_Progreso_Diario (idPersonaje, fecha, nivelesAumentados)
    VALUES (v_id_personaje, SYSDATE - 0.5, 4);

    INSERT INTO Usuario_Progresa_Mision (idPersonaje, idMision, estado, fechaCompletada)
    VALUES (v_id_personaje, v_id_mision, 'Completada', SYSDATE - 0.5);
  END LOOP;

  regalar_items_a_jugadores_activos;

  -- Mostrar inventario resultante
  DBMS_OUTPUT.PUT_LINE('Inventarios despues de agregar 10 personajes aptos para acreditar');
  FOR item_rec IN (
    SELECT p.id AS personaje_id, it.nombre, iti.cantidad
    FROM Inventario i
    JOIN Personaje p ON i.idPersonaje = p.id
    JOIN Inventario_Tiene_Item iti ON iti.idInventario = i.id
    JOIN ItemTable it ON it.id = iti.idItem
    WHERE p.idUsuario IN (
      SELECT id FROM Usuario WHERE correo LIKE 'test_user_%@mail.com'
    )
  ) LOOP
    DBMS_OUTPUT.PUT_LINE('PERSONAJE: ' || item_rec.personaje_id || ' - ITEM: ' || item_rec.nombre || ' - CANTIDAD: ' || item_rec.cantidad);
  END LOOP;
  DBMS_OUTPUT.PUT_LINE('');

  FOR i IN 11..15 LOOP
    INSERT INTO Usuario (correo, nombre, contrasena, fechaRegistro, pais, continente)
    VALUES ('test_user_' || i || '@mail.com', 'Tester_' || i, 'Abc1234!', SYSDATE, 'Uruguay', 'America')
    RETURNING id INTO v_id_usuario;

    INSERT INTO Personaje (idUsuario, especie, fuerza, agilidad, inteligencia, vitalidad,
                           resistencia, nivel, experiencia, cantHoras, monedas)
    VALUES (v_id_usuario, 'Humano', 20, 20, 20, 20, 20, 10, 100, 2, 50)
    RETURNING id INTO v_id_personaje;

    INSERT INTO Inventario (idPersonaje)
    VALUES (v_id_personaje);

    INSERT INTO Personaje_Progreso_Diario (idPersonaje, fecha, nivelesAumentados)
    VALUES (v_id_personaje, SYSDATE - 0.5, 4);

    INSERT INTO Usuario_Progresa_Mision (idPersonaje, idMision, estado, fechaCompletada)
    VALUES (v_id_personaje, v_id_mision, 'Completada', SYSDATE - 0.5);
  END LOOP;

  regalar_items_a_jugadores_activos;

  -- Mostrar inventario resultante
  DBMS_OUTPUT.PUT_LINE('Inventarios despues de agregar los otros 5 personajes aptos para acreditar');
  DBMS_OUTPUT.PUT_LINE('Notar que los inventarios de los personajes previos no cambiaron');
  FOR item_rec IN (
    SELECT p.id AS personaje_id, it.nombre, iti.cantidad
    FROM Inventario i
    JOIN Personaje p ON i.idPersonaje = p.id
    JOIN Inventario_Tiene_Item iti ON iti.idInventario = i.id
    JOIN ItemTable it ON it.id = iti.idItem
    WHERE p.idUsuario IN (
      SELECT id FROM Usuario WHERE correo LIKE 'test_user_%@mail.com'
    )
  ) LOOP
    DBMS_OUTPUT.PUT_LINE('PERSONAJE: ' || item_rec.personaje_id || ' - ITEM: ' || item_rec.nombre || ' - CANTIDAD: ' || item_rec.cantidad);
  END LOOP;

    -- Eliminar datos creados
  DELETE FROM Inventario_Tiene_Item WHERE idInventario IN (
    SELECT i.id FROM Inventario i
    JOIN Personaje p ON i.idPersonaje = p.id
    WHERE p.idUsuario IN (
      SELECT id FROM Usuario WHERE correo LIKE 'test_user_%@mail.com')
  );
  DELETE FROM Usuario_Progresa_Mision WHERE idMision = v_id_mision;
  DELETE FROM Personaje_Progreso_Diario WHERE idPersonaje IN (
    SELECT id FROM Personaje WHERE idUsuario IN (
      SELECT id FROM Usuario WHERE correo LIKE 'test_user_%@mail.com')
  );
  DELETE FROM Inventario WHERE idPersonaje IN (
    SELECT id FROM Personaje WHERE idUsuario IN (
      SELECT id FROM Usuario WHERE correo LIKE 'test_user_%@mail.com')
  );
  DELETE FROM Personaje WHERE idUsuario IN (
    SELECT id FROM Usuario WHERE correo LIKE 'test_user_%@mail.com'
  );
  DELETE FROM Usuario WHERE correo LIKE 'test_user_%@mail.com';
  DELETE FROM Mision WHERE codigo = 'PRINC01';
END;
/


/*
2.4: 
Implementar un servicio que permita el intercambio de ítems entre jugadores,
verificando que el ítem sea intercambiable, que los jugadores y personajes
existan, etc. 
El intercambio debe ser atómico, es decir que debe partir de un estado 
consistente y finalizar en un estado consistente.
*/

DECLARE
  v_id_usuario1 Usuario.id%TYPE;
  v_id_usuario2 Usuario.id%TYPE;
  v_id_personaje1 Personaje.id%TYPE;
  v_id_personaje2 Personaje.id%TYPE;
  v_id_item1 ItemTable.id%TYPE;
  v_id_item2 ItemTable.id%TYPE;
BEGIN
  DBMS_OUTPUT.PUT_LINE(
    '------------------------- Test 2.2(1) -------------------------' || chr(13) || chr(10) ||
    'Crear dos usuarios A y B, hacer que uno tenga la EspadaCorta, ' || chr(13) || chr(10) ||
    'y que el otro tenga la ArmaduraPlateada (ambos intercambiables).' || chr(13) || chr(10) ||
    'Intercambiarlos y comparar sus inventarios.' || chr(13) || chr(10) ||
    '------------------------------------------------------------' || chr(13) || chr(10)
  );

  -- Crear usuarios y personajes
  INSERT INTO Usuario (correo, nombre, contrasena, fechaRegistro, pais, continente)
  VALUES ('userA@mail.com', 'UserA', 'Abc123!', SYSDATE, 'Uruguay', 'America')
  RETURNING id INTO v_id_usuario1;

  INSERT INTO Usuario (correo, nombre, contrasena, fechaRegistro, pais, continente)
  VALUES ('userB@mail.com', 'UserB', 'Abc123!', SYSDATE, 'Uruguay', 'America')
  RETURNING id INTO v_id_usuario2;

  INSERT INTO Personaje (idUsuario, especie, fuerza, agilidad, inteligencia, vitalidad, resistencia, nivel, experiencia, cantHoras, monedas)
  VALUES (v_id_usuario1, 'Humano', 10, 10, 10, 10, 10, 1, 10, 1, 10)
  RETURNING id INTO v_id_personaje1;

  INSERT INTO Personaje (idUsuario, especie, fuerza, agilidad, inteligencia, vitalidad, resistencia, nivel, experiencia, cantHoras, monedas)
  VALUES (v_id_usuario2, 'Humano', 10, 10, 10, 10, 10, 1, 10, 1, 10)
  RETURNING id INTO v_id_personaje2;

  INSERT INTO Inventario (idPersonaje) VALUES (v_id_personaje1);
  INSERT INTO Inventario (idPersonaje) VALUES (v_id_personaje2);

  -- Usar items ya creados
  SELECT id INTO v_id_item1 FROM ItemTable WHERE nombre = 'EspadaCorta';
  SELECT id INTO v_id_item2 FROM ItemTable WHERE nombre = 'ArmaduraPlateada';

  -- Agregar items a cada uno
  INSERT INTO Inventario_Tiene_Item (idInventario, idItem, cantidad, equipado)
  VALUES ((SELECT id FROM Inventario WHERE idPersonaje = v_id_personaje1), v_id_item1, 1, 'N');

  INSERT INTO Inventario_Tiene_Item (idInventario, idItem, cantidad, equipado)
  VALUES ((SELECT id FROM Inventario WHERE idPersonaje = v_id_personaje2), v_id_item2, 1, 'N');

  -- Mostrar datos previos
  DBMS_OUTPUT.PUT_LINE('Antes del intercambio:');
  FOR rec IN (
    SELECT u.nombre AS usuario_nombre, p.id AS personaje_id, it.nombre, iti.cantidad
    FROM Personaje p
    JOIN Usuario u ON u.id = p.idUsuario
    JOIN Inventario i ON i.idPersonaje = p.id
    JOIN Inventario_Tiene_Item iti ON iti.idInventario = i.id
    JOIN ItemTable it ON it.id = iti.idItem
    WHERE p.id IN (v_id_personaje1, v_id_personaje2)
  ) LOOP
    DBMS_OUTPUT.PUT_LINE('PERSONAJE: ' || rec.usuario_nombre || ' - ITEM: ' || rec.nombre || ' - CANTIDAD: ' || rec.cantidad);
  END LOOP;
  DBMS_OUTPUT.PUT_LINE('');

  -- Ejecutar intercambio
  Intercambiar_Items(v_id_personaje1, v_id_item1, v_id_personaje2, v_id_item2);

  -- Mostrar resultado
  DBMS_OUTPUT.PUT_LINE('Despues del intercambio:');
  FOR rec IN (
    SELECT u.nombre AS usuario_nombre, p.id AS personaje_id, it.nombre, iti.cantidad
    FROM Personaje p
    JOIN Usuario u ON u.id = p.idUsuario
    JOIN Inventario i ON i.idPersonaje = p.id
    JOIN Inventario_Tiene_Item iti ON iti.idInventario = i.id
    JOIN ItemTable it ON it.id = iti.idItem
    WHERE p.id IN (v_id_personaje1, v_id_personaje2)
  ) LOOP
    DBMS_OUTPUT.PUT_LINE('PERSONAJE: ' || rec.usuario_nombre || ' - ITEM: ' || rec.nombre || ' - CANTIDAD: ' || rec.cantidad);
  END LOOP;

  -- Eliminar datos creados
  DELETE FROM Inventario_Tiene_Item WHERE idInventario IN (
    SELECT id FROM Inventario WHERE idPersonaje IN (v_id_personaje1, v_id_personaje2));
  DELETE FROM Inventario WHERE idPersonaje IN (v_id_personaje1, v_id_personaje2);
  DELETE FROM Personaje WHERE id IN (v_id_personaje1, v_id_personaje2);
  DELETE FROM Usuario WHERE id IN (v_id_usuario1, v_id_usuario2);
END;
/


