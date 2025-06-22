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

CREATE OR REPLACE PROCEDURE items_mas_equipados (
) AS
BEGIN
END;
/
