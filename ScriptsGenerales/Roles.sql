ALTER SESSION SET "_ORACLE_SCRIPT"=true;


DROP ROLE RolAdmin;
DROP ROLE RolDiseniador;
DROP ROLE RolJugador;


DROP USER administrador;
DROP USER diseniador;
DROP USER pedro;


CREATE ROLE RolAdmin;
CREATE ROLE RolDiseniador;
CREATE ROLE RolJugador;


GRANT CREATE SESSION TO RolAdmin, RolDiseniador, RolJugador;


CREATE USER administrador IDENTIFIED BY "Contra";
GRANT RolAdmin TO administrador;


CREATE USER diseniador IDENTIFIED BY "Contra";
GRANT RolDiseniador TO diseniador;


CREATE USER pedro IDENTIFIED BY "Contra";
GRANT RolJugador TO pedro;


CREATE OR REPLACE VIEW Vista_Usuario_Admin AS
SELECT id, correo, nombre, fechaRegistro, pais, continente
 FROM Usuario;
GRANT SELECT, UPDATE ON Vista_Usuario_Admin TO RolAdmin;


GRANT SELECT, UPDATE, INSERT, DELETE
 ON Personaje
 TO RolAdmin;


GRANT SELECT, INSERT, UPDATE, DELETE
 ON Enemigo
 TO RolDiseniador;


GRANT SELECT, INSERT, UPDATE, DELETE
 ON Jefe
 TO RolDiseniador;


GRANT SELECT, INSERT, UPDATE, DELETE
 ON ItemTable
 TO RolDiseniador;


GRANT SELECT, INSERT, UPDATE, DELETE
 ON Zona
 TO RolDiseniador;


CREATE OR REPLACE VIEW Vista_MiPersonaje AS
SELECT p.id,
      p.fuerza, p.agilidad, p.inteligencia,
      p.vitalidad, p.resistencia, p.nivel,
      p.experiencia, p.cantHoras, p.monedas
 FROM Personaje p
 JOIN Usuario u ON p.idUsuario = u.id
WHERE u.nombre = USER;


GRANT SELECT,
     UPDATE (fuerza, agilidad, inteligencia,
             vitalidad, resistencia,
             nivel, experiencia, cantHoras, monedas)
 ON Vista_MiPersonaje
 TO Jugador;
