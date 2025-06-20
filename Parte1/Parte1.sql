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
BEFORE INSERT OR UPDATE
  ON Inventario_Tiene_Item 
FOR EACH ROW
DECLARE 
  vlCategoriaNueva ItemTable.categoria%TYPE;
  vlTipoYaEquipado Inventario_Tiene_Item.equipado%TYPE;
  BEGIN 
    IF :NEW.equipado = 'Y' THEN
      SELECT i.categoria INTO vlCategoriaNueva
      FROM ItemTable i 
      WHERE i.Id = :NEW.idItem;

      SELECT MAX(inv_item.equipado) INTO vlTipoYaEquipado
      FROM Inventario_Tiene_Item inv_item 
      LEFT JOIN ItemTable i 
      ON inv_item.idItem = i.Id 
      WHERE i.categoria = vlCategoriaNueva 
      AND inv_item.idInventario = :NEW.idInventario
      AND inv_item.idItem != :NEW.idItem;

      IF vlTipoYaEquipado = 'Y' THEN
        RAISE_APPLICATION_ERROR(
          -20001,
          'No se puede equipar item de categoria ' 
          || vlCategoriaNueva 
          || ' para este personaje ya que ya hay un item de la misma categoria equipado');
      END IF; 
  END IF;
END;
/
