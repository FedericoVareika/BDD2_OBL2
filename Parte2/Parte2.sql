ALTER SESSION SET "_ORACLE_SCRIPT"=true;

/*
2.1: 
Implementar un servicio que permita asignar recompensas de una misión a un
personaje. 
Recordar que pueden incluir puntos de experiencia, ítems especiales y/o monedas.
Se debe verificar que el estado de la misión sea “completada” y que no se
haya asignado ya dicha recompensa.
*/

CREATE OR REPLACE PROCEDURE asignar_recompensa_mision (
    p_id_personaje IN Personaje.id%TYPE, 
    p_id_mision IN Mision.id%TYPE
) AS 
  v_mision_progreso Usuario_Progresa_Mision.estado%TYPE; 
  v_recompensa_asignada Usuario_Progresa_Mision.recompensa_asignada%TYPE; 
  v_xp Mision.experiencia%TYPE;
  v_monedas Mision.monedas%TYPE;
  v_id_inventario Inventario.id%TYPE;
BEGIN 
  SELECT upm.estado, upm.recompensa_asignada 
  INTO v_mision_progreso, v_recompensa_asignada
  FROM Usuario_Progresa_Mision upm  
  WHERE upm.idPersonaje = p_id_personaje 
    AND upm.idMision = p_id_mision;
  
  IF v_mision_progreso != 'Completada' THEN
    RAISE_APPLICATION_ERROR(
      -20001,
      'La misión no está completada');
  ELSIF v_recompensa_asignada = 'Y' THEN 
    RAISE_APPLICATION_ERROR(
      -20001,
      'La recompensa ya esta asignada');
  END IF;

  SELECT m.experiencia, m.monedas
  INTO v_xp, v_monedas
  FROM Mision m 
  WHERE m.id = p_id_mision;

  SELECT i.id INTO v_id_inventario
  FROM Inventario i 
  WHERE i.idPersonaje = p_id_personaje;

  MERGE INTO Inventario_Tiene_Item iti
    USING (SELECT idItem AS id, cantidad FROM Mision_Otorga_Item
      WHERE idMision = p_id_mision) item
    ON (iti.idItem = item.id AND iti.idInventario = v_id_inventario) 
    WHEN MATCHED THEN UPDATE SET iti.cantidad = iti.cantidad + item.cantidad  
    WHEN NOT MATCHED THEN INSERT (iti.idInventario, iti.idItem, iti.cantidad, iti.equipado)
      VALUES (v_id_inventario, item.id, item.cantidad, 'N');

  UPDATE Personaje 
  SET monedas = monedas + v_monedas,
      experiencia = experiencia + v_xp 
  WHERE id = p_id_personaje;

  UPDATE Usuario_Progresa_Mision 
  SET recompensa_asignada = 'Y'
  WHERE idPersonaje = p_id_personaje 
    AND idMision = p_id_mision;
END;
/
    
/*
2.2: 
Implementar un servicio que muestre los 10 ítems más equipados, permitiendo 
un parámetro opcional que filtre por categoría de ítem.
*/

CREATE OR REPLACE PROCEDURE items_mas_equipados (
  p_categoria IN ItemTable.categoria%TYPE DEFAULT NULL
) AS
BEGIN
  IF p_categoria IS NULL THEN
    FOR rec IN (
      SELECT it.id, it.nombre, it.categoria, COUNT(*) AS veces_equipado
      FROM ItemTable it
      JOIN Inventario_Tiene_Item iti ON it.id = iti.idItem
      WHERE iti.equipado = 'Y'
      GROUP BY it.id, it.nombre, it.categoria
      ORDER BY veces_equipado DESC
      FETCH FIRST 10 ROWS ONLY
    ) LOOP
      DBMS_OUTPUT.PUT_LINE('ID: ' || rec.id || ' | Nombre: ' || rec.nombre || ' | Categoria: ' || rec.categoria || ' | Equipado: ' || rec.veces_equipado);
    END LOOP;

  ELSE
    FOR rec IN (
      SELECT it.id, it.nombre, it.categoria, COUNT(*) AS veces_equipado
      FROM ItemTable it
      JOIN Inventario_Tiene_Item iti ON it.id = iti.idItem
      WHERE iti.equipado = 'Y' AND it.categoria = p_categoria
      GROUP BY it.id, it.nombre, it.categoria
      ORDER BY veces_equipado DESC
      FETCH FIRST 10 ROWS ONLY
    ) LOOP
      DBMS_OUTPUT.PUT_LINE('ID: ' || rec.id || ' | Nombre: ' || rec.nombre || ' | Categoria: ' || rec.categoria || ' | Equipado: ' || rec.veces_equipado);
    END LOOP;
  END IF;
END;
/

/*
2.3: 
Implementar un servicio que identifique a los jugadores cuyo personaje haya
aumentado al menos 3 niveles en las últimas 24 horas y que a su vez cumplan
con haber completado al menos una misión de tipo principal en ese mismo período.

A estos personajes se les debe acreditar en su inventario un ítem de rareza
aleatoria.
*/

CREATE OR REPLACE PROCEDURE regalar_items_a_jugadores_activos
AS
  CURSOR c_personajes IS 
    SELECT ppd.idPersonaje as id
    FROM Personaje_Progreso_Diario ppd 
    WHERE ppd.fecha + 1 >= SYSDATE
      AND ppd.regaloAcreditado = 'N'
      AND ppd.nivelesAumentados >= 3 
      AND EXISTS (
        SELECT 1 
        FROM Usuario_Progresa_Mision upm 
        JOIN Mision m 
          ON m.id = upm.idMision
        WHERE upm.idPersonaje = ppd.idPersonaje 
          AND upm.fechaCompletada IS NOT NULL
          AND upm.fechaCompletada + 1 >= SYSDATE
          AND m.tipo = 'Principal' 
          AND upm.estado = 'Completada' -- esto es redundante
      )
    GROUP BY ppd.idPersonaje; -- esto deberia ser redundante
  v_id_item ItemTable.id%TYPE;
  v_id_inventario Inventario.id%TYPE;
BEGIN
  FOR personaje_rec IN c_personajes
  LOOP 
    -- Item aleatorio
    SELECT * INTO v_id_item 
    FROM (
      SELECT it.id FROM ItemTable it 
      ORDER BY dbms_random.value
    )
    WHERE ROWNUM = 1;

    -- Inventario del personaje actual
    SELECT id INTO v_id_inventario 
    FROM Inventario 
    WHERE idPersonaje = personaje_rec.id;

    -- Acreditar el item al personaje
    MERGE INTO Inventario_Tiene_Item iti 
    USING (SELECT 
        v_id_inventario AS idInventario,
        v_id_item AS idItem 
      FROM dual) key_values
    ON (iti.idInventario = key_values.idInventario 
      AND iti.idItem = key_values.idItem)
    WHEN MATCHED THEN 
      UPDATE SET iti.cantidad = iti.cantidad + 1
    WHEN NOT MATCHED THEN 
      INSERT (iti.idInventario, iti.idItem, iti.cantidad, iti.equipado) 
        VALUES (key_values.idInventario, key_values.idItem, 1, 'N');

    -- Marcar que este personaje ya fue acreditado por el dia de hoy 
    UPDATE Personaje_Progreso_Diario ppd 
    SET ppd.regaloAcreditado = 'Y' 
    WHERE ppd.idPersonaje = personaje_rec.id 
      AND ppd.fecha + 1 >= SYSDATE;

  END LOOP;

  COMMIT;

EXCEPTION 
  WHEN NO_DATA_FOUND THEN 
    RAISE_APPLICATION_ERROR(
      -20003,
      'No existen items o los personajes no tienen inventarios adecuados');
  WHEN OTHERS THEN 
    ROLLBACK;
    RAISE_APPLICATION_ERROR(
      -20001,
      'Hubo un error acreditando los regalos diarios.');
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

CREATE OR REPLACE PROCEDURE Intercambiar_Items(
  p_idPersonaje1 IN NUMBER,
  p_idItem1      IN NUMBER,
  p_idPersonaje2 IN NUMBER,
  p_idItem2      IN NUMBER
) AS
  v_intercambiable1 ItemTable.intercambiable%TYPE;
  v_intercambiable2 ItemTable.intercambiable%TYPE;

  v_inventario1 Inventario.id%TYPE;
  v_inventario2 Inventario.id%TYPE;

  v_cantidad_item1 Inventario_Tiene_Item.cantidad%TYPE;
  v_cantidad_item2 Inventario_Tiene_Item.cantidad%TYPE;
BEGIN
  BEGIN 
    SELECT intercambiable INTO v_intercambiable1 FROM ItemTable WHERE id = p_idItem1;
    SELECT intercambiable INTO v_intercambiable2 FROM ItemTable WHERE id = p_idItem2;
  EXCEPTION 
    WHEN NO_DATA_FOUND THEN 
      RAISE_APPLICATION_ERROR(-20003, 'Alguno de los ítems no existe.');
  END;

  IF v_intercambiable1 = 0 OR v_intercambiable2 = 0 THEN
    RAISE_APPLICATION_ERROR(-20003, 'Alguno de los ítems no es intercambiable.');
  END IF;

  BEGIN 
    SELECT i.id INTO v_inventario1 
    FROM Inventario i
    WHERE i.idPersonaje = p_idPersonaje1;

    SELECT i.id INTO v_inventario2 
    FROM Inventario i
    WHERE i.idPersonaje = p_idPersonaje2;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN 
      RAISE_APPLICATION_ERROR(-20003, 'Alguno de los personajes no tiene inventario');
  END;

  BEGIN 
    SELECT iti.cantidad INTO v_cantidad_item1 
    FROM Inventario_Tiene_Item iti   
    WHERE iti.idInventario = v_inventario1
    AND iti.idItem = p_idItem1; 

    SELECT iti.cantidad INTO v_cantidad_item2 
    FROM Inventario_Tiene_Item iti   
    WHERE iti.idInventario = v_inventario2
    AND iti.idItem = p_idItem2; 
  EXCEPTION 
    WHEN NO_DATA_FOUND THEN 
      RAISE_APPLICATION_ERROR(
        -20003,
        'Alguno de los personajes no tiene el item que quiere intercambiar.');
  END;

  DELETE FROM Inventario_Tiene_Item 
  WHERE idInventario = v_inventario1 
    AND idItem = p_idItem1;

  DELETE FROM Inventario_Tiene_Item 
  WHERE idInventario = v_inventario2 
    AND idItem = p_idItem2;

  INSERT INTO Inventario_Tiene_Item (idInventario, idItem, cantidad, equipado)
  VALUES (v_inventario1, p_idItem2, v_cantidad_item2, 'N');

  INSERT INTO Inventario_Tiene_Item (idInventario, idItem, cantidad, equipado)
  VALUES (v_inventario2, p_idItem1, v_cantidad_item1, 'N');

  COMMIT;
EXCEPTION
  WHEN OTHERS THEN
      ROLLBACK;
      RAISE;
END;
/
