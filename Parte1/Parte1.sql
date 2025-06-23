ALTER SESSION SET "_ORACLE_SCRIPT"=true;
SET serveroutput ON; 

--------------------------------------------------------------
-- Jefe.Tipo de un enemigo en la tabla Jefe debe ser “jefe” --

CREATE OR REPLACE TRIGGER JEFE_TIPO_ES_JEFE 
BEFORE INSERT OR UPDATE
  ON Jefe 
FOR EACH ROW
DECLARE 
  vlTipoJefe Enemigo.tipo%TYPE;
BEGIN 
  SELECT e.tipo INTO vlTipoJefe
  FROM Enemigo e 
  WHERE e.id = :NEW.id;

  IF vlTipoJefe != 'jefe' THEN
    RAISE_APPLICATION_ERROR(
      -20001,
      'Jefe invalido: Tipo del enemigo referenciado por jefe debe ser "jefe"');
  END IF; 

END;
/

----------------------------------------------------------------------------
-- Un personaje no puede equipar dos ítems de la misma categoría a la vez -- 

CREATE OR REPLACE TRIGGER PERSONAJE_EQUIPA_ITEMS_DE_CATEGORIA_UNICA
FOR INSERT OR UPDATE ON Inventario_Tiene_Item
COMPOUND TRIGGER

  TYPE t_equipa IS RECORD (
    inv_id    Inventario_Tiene_Item.idInventario%TYPE,
    categoria ItemTable.categoria%TYPE
  );
  TYPE t_equipa_tab IS TABLE OF t_equipa INDEX BY PLS_INTEGER;
  equipa t_equipa_tab;

BEFORE EACH ROW IS
  v_categoria ItemTable.categoria%TYPE;
BEGIN
  IF :NEW.equipado = 'Y' THEN
    SELECT categoria INTO v_categoria FROM ItemTable WHERE id = :NEW.idItem;
    equipa(equipa.COUNT + 1) := t_equipa(:NEW.idInventario, v_categoria);
  END IF;
END BEFORE EACH ROW;

AFTER STATEMENT IS
  v_count NUMBER;
BEGIN
  IF equipa.COUNT > 0 THEN
    FOR idx IN equipa.COUNT LOOP
      SELECT COUNT(*) INTO v_count
      FROM Inventario_Tiene_Item iti
      JOIN ItemTable it ON iti.idItem = it.id
      WHERE iti.idInventario = equipa(idx).inv_id
        AND it.categoria = equipa(idx).categoria
        AND iti.equipado = 'Y';

      IF v_count > 1 THEN
        RAISE_APPLICATION_ERROR(
          -20002,
          'Solo se permite un item equipado por categoría en inventario '
          || equipa(idx).inv_id || ', categoría '
          || equipa(idx).categoria
        );
      END IF;
    END LOOP;
  END IF;
END AFTER STATEMENT;

END;
/

----------------------------------------------------------------------------------------
-- Un personaje no puede equipar un ítem cuyo nivelMinimo sea mayor a su nivel actual --

CREATE OR REPLACE TRIGGER PERSONAJE_EQUIPA_ITEMS_CON_NIVEL_ADECUADO 
BEFORE INSERT OR UPDATE
  ON Inventario_Tiene_Item 
FOR EACH ROW
DECLARE 
  vlNivelPersonaje Personaje.nivel%TYPE;
  vlNivelMinimoItem ItemTable.nivelMinimo%TYPE;
BEGIN 
  IF :NEW.equipado = 'Y' THEN
    SELECT p.nivel INTO vlNivelPersonaje
    FROM Inventario i 
    LEFT JOIN Personaje p 
      ON p.id = i.idPersonaje
    WHERE i.Id = :NEW.idInventario;

    SELECT i.nivelMinimo INTO vlNivelMinimoItem 
    FROM ItemTable i 
    WHERE i.id = :NEW.idItem;

    IF vlNivelMinimoItem > vlNivelPersonaje THEN
      RAISE_APPLICATION_ERROR(
        -20003,
        'Equipamiento invalido: No se puede equipar un item de nivel minimo ('
        ||  vlNivelMinimoItem
        || ') mayor al del personaje ('
        ||  vlNivelPersonaje
        || ')'
      );
    END IF; 
  END IF; 
END;
/

-----------------------------------------------------------------------------------------
-- Un usuario no puede progresar una misión cuyo nivelMinimo sea mayor al del usuario. --

CREATE OR REPLACE TRIGGER PERSONAJE_PROGRESA_MISION_CON_NIVEL_ADECUADO
BEFORE INSERT OR UPDATE
  ON Usuario_Progresa_Mision 
FOR EACH ROW
DECLARE 
  vlNivelPersonaje Personaje.nivel%TYPE;
  vlNivelMinimoMision Mision.nivelMinimo%TYPE;
BEGIN 
  IF :NEW.estado != 'No iniciada' THEN
    SELECT p.nivel INTO vlNivelPersonaje
    FROM Personaje p 
    WHERE p.Id = :NEW.idPersonaje;

    SELECT m.nivelMinimo INTO vlNivelMinimoMision
    FROM Mision m 
    WHERE m.Id = :NEW.idMision;

    IF vlNivelMinimoMision > vlNivelPersonaje THEN
      RAISE_APPLICATION_ERROR(
        -20004,
        'Estado de mision invalida: No se puede progresar una mision de nivel minimo ('
        ||  vlNivelMinimoMision
        || ') mayor al del personaje ('
        ||  vlNivelPersonaje
        || ')'
      );
    END IF; 
  END IF; 
END;
/

---------------------------------------------------------------------
-- La cantidad de un item equipado en un inventario no puede ser 0 --

CREATE OR REPLACE TRIGGER PERSONAJE_EQUIPA_UNA_CANTIDAD_POSITIVA_DE_ITEMS 
BEFORE INSERT OR UPDATE
  ON Inventario_Tiene_Item 
FOR EACH ROW
BEGIN 
  IF :NEW.equipado = 'Y' and :NEW.cantidad < 1 THEN
    RAISE_APPLICATION_ERROR(
      -20005,
      'Equipamiento invalido: No se pueden equipar 0 items'
    );
  END IF; 
END;
/

------------------------------------------------
-- Una misión no puede ser previa de si misma --

CREATE OR REPLACE TRIGGER MISION_NO_ES_PREVIA_DE_SI_MISMA 
BEFORE INSERT OR UPDATE
  ON Mision_Previa 
FOR EACH ROW
BEGIN 
  IF :NEW.idPrevia = :NEW.idMision THEN
    RAISE_APPLICATION_ERROR(
      -20006,
      'Previa invalida: Una mision no puede ser previa de si misma'
    );
  END IF;
END;
/

--------------------------------------------
-- Un usuario debe tener un correo válido --

CREATE OR REPLACE TRIGGER CORREO_DE_USUARIO_VALIDO 
BEFORE INSERT OR UPDATE
  ON Usuario 
FOR EACH ROW
BEGIN 
  IF NOT REGEXP_LIKE(
    :NEW.correo,
    '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$')
  THEN
    RAISE_APPLICATION_ERROR(
      -20007,
      'Usuario invalido: correo invalido.'
    );
  END IF;
END;
/

-------------------------------------------------------------------------------------------
-- La fechaCompletada de Usuario Progresa Mision es nula si la mision no esta completada --

CREATE OR REPLACE TRIGGER PERSONAJE_PROGRESA_MISION_CON_NIVEL_ADECUADO
BEFORE INSERT OR UPDATE
  ON Usuario_Progresa_Mision 
FOR EACH ROW
BEGIN 
  IF :NEW.estado != 'Completada' AND :NEW.fechaCompletada IS NOT NULL THEN
    RAISE_APPLICATION_ERROR(
      -20008,
      'Una mision no completada no puede tener fechaCompletada no nula.'
    );
  END IF; 
END;
/
