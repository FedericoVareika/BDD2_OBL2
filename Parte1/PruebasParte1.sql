ALTER SESSION SET "_ORACLE_SCRIPT"=true;
SET serveroutput ON; 

----------------------------------------------------------------
------------------------- IMPORTANTE ---------------------------
----------------------------------------------------------------
------------- CORRER PRUEBAS LUEGO DE TENER LOS ----------------
------------ CASOS DE PRUEBA ORIGINALES INSERTADOS -------------
----------------------------------------------------------------
----------------------------------------------------------------

CREATE OR REPLACE PROCEDURE test_expected_error (
  p_test_name   IN VARCHAR2,
  p_sql         IN VARCHAR2,
  p_expected_code IN NUMBER
) AS
  v_sql_code NUMBER;
BEGIN
  DBMS_OUTPUT.PUT_LINE('Beginning test: ' || p_test_name);
  EXECUTE IMMEDIATE p_sql;
  DBMS_OUTPUT.PUT_LINE('❌ Test failed: No error raised.');
EXCEPTION
  WHEN OTHERS THEN
    v_sql_code := SQLCODE;
    IF v_sql_code = p_expected_code THEN
      DBMS_OUTPUT.PUT_LINE('✅ Correct error raised: ' || v_sql_code);
      NULL;
    ELSE
      DBMS_OUTPUT.PUT_LINE('❌ Unexpected error: ' || v_sql_code || ' - ' || SQLERRM);
      RAISE;
    END IF;
END;
/

SAVEPOINT test_init;

--------------------------------------------------------------
-- Jefe.Tipo de un enemigo en la tabla Jefe debe ser “jefe” --

BEGIN
    INSERT INTO Enemigo(nombre, nivel, ubicacion, tipo)
      VALUES('Enemigo normal', 6, 'Bosque Sombrío', 'normal');

    test_expected_error(
      'Jefe.Tipo de un enemigo en la tabla Jefe debe ser “jefe”',
      q'[
      INSERT INTO Jefe(id, idMision)
      VALUES(
        (SELECT id FROM Enemigo WHERE nombre='Enemigo normal'),
        (SELECT id FROM Mision  WHERE codigo='M002')
      )]', -20001);
END;
/
ROLLBACK TO test_init;

----------------------------------------------------------------------------
-- Un personaje no puede equipar dos ítems de la misma categoría a la vez -- 

BEGIN
    INSERT INTO Inventario_Tiene_Item(idInventario,idItem,cantidad,equipado)
      VALUES(
        (SELECT id FROM Inventario WHERE idPersonaje=(SELECT id FROM Personaje WHERE idUsuario=(SELECT id FROM Usuario WHERE nombre='Federica'))),
        (SELECT id FROM ItemTable WHERE nombre='AmuletoLuna'),1,'Y'
      );

    test_expected_error(
      'Un personaje no puede equipar dos ítems de la misma categoría a la vez',
      q'[
      INSERT INTO Inventario_Tiene_Item(idInventario,idItem,cantidad,equipado)
      VALUES(
        (SELECT id FROM Inventario WHERE idPersonaje=(SELECT id FROM Personaje WHERE idUsuario=(SELECT id FROM Usuario WHERE nombre='Federica'))),
        (SELECT id FROM ItemTable WHERE nombre='AmuletoSol'),1,'Y'
      )]',
    -20002);
END;
/
ROLLBACK TO test_init;

----------------------------------------------------------------------------------------
-- Un personaje no puede equipar un ítem cuyo nivelMinimo sea mayor a su nivel actual --

BEGIN
    test_expected_error(
      'Un personaje no puede equipar un ítem cuyo nivelMinimo sea mayor a su nivel actual',
      q'[
      INSERT INTO Inventario_Tiene_Item(idInventario,idItem,cantidad,equipado)
      VALUES(
        -- Personaje de nivel 10
        (SELECT id FROM Inventario WHERE idPersonaje=(SELECT id FROM Personaje WHERE idUsuario=(SELECT id FROM Usuario WHERE nombre='Juan'))),
        -- Item con nivel minimo 20
        (SELECT id FROM ItemTable WHERE nombre='PocionVida'),1,'Y'
      )]',
      -20003);
END;
/
ROLLBACK TO test_init;

-----------------------------------------------------------------------------------------
-- Un usuario no puede progresar una misión cuyo nivelMinimo sea mayor al del usuario. --

BEGIN
    test_expected_error(
      'Un usuario no puede progresar una misión cuyo nivelMinimo sea mayor al del usuario.',
      q'[
      INSERT INTO Usuario_Progresa_Mision(idPersonaje,idMision,estado)
        VALUES(
          (SELECT id FROM Personaje WHERE idUsuario=(SELECT id FROM Usuario WHERE nombre='Juan')), 
          (SELECT id FROM Mision    WHERE codigo='M003'),
          'En progreso'
        )
      ]',
      -20004);
END;
/
ROLLBACK TO test_init;

---------------------------------------------------------------------
-- La cantidad de un item equipado en un inventario no puede ser 0 --

BEGIN
    test_expected_error(
      'La cantidad de un item equipado en un inventario no puede ser 0',
      q'[
        INSERT INTO Inventario_Tiene_Item(idInventario,idItem,cantidad,equipado)
          VALUES(
            (SELECT id FROM Inventario WHERE idPersonaje=(SELECT id FROM Personaje WHERE idUsuario=(SELECT id FROM Usuario WHERE nombre='Federica'))),
            (SELECT id FROM ItemTable WHERE nombre='AmuletoLuna'),0,'Y'
          )
      ]',
      -20005);
END;
/
ROLLBACK TO test_init;

------------------------------------------------
-- Una misión no puede ser previa de si misma --

BEGIN
    test_expected_error(
      'Una misión no puede ser previa de si misma',
      q'[
        INSERT INTO Mision_Previa(idMision,idPrevia)
          VALUES(
            (SELECT id FROM Mision  WHERE codigo='M001'),
            (SELECT id FROM Mision  WHERE codigo='M001')
          )
      ]',
      -20006);
END;
/
ROLLBACK TO test_init;
