DROP TABLE Personaje_Progreso_Diario;
DROP TABLE Usuario_Progresa_Mision;
DROP TABLE Personaje_Tiene_Habilidad;
DROP TABLE Mision_Desbloquea_Habilidad;
DROP TABLE Mision_Desbloquea_Zona;
DROP TABLE Mision_Previa; 
DROP TABLE Zona_Tiene_Enemigo;
DROP TABLE Inventario_Tiene_Item;
DROP TABLE Mision_Otorga_Item;
DROP TABLE Enemigo_Suelta_Botin;
DROP TABLE Botin_Otorga_Item;
DROP TABLE Jefe_Condicionado_Por_Zona;
DROP TABLE Jefe_Condicionado_Por_Mision;
DROP TABLE Jefe_Tiene_Habilidad;


DROP TABLE Habilidad;
DROP TABLE Jefe;
DROP TABLE Mision;
DROP TABLE Inventario;
DROP TABLE ItemTable;
DROP TABLE Zona;
DROP TABLE Botin;
DROP TABLE Enemigo;
DROP TABLE Personaje;
DROP TABLE Usuario;


CREATE TABLE Usuario (
  id            INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  correo        VARCHAR2(255) NOT NULL UNIQUE,
  nombre        VARCHAR2(50)  NOT NULL UNIQUE,
  contrasena    VARCHAR2(16) NOT NULL,
  fechaRegistro DATE NOT NULL,
  pais          VARCHAR2(100) NOT NULL,
  continente    VARCHAR2(20) NOT NULL
			CHECK (continente IN (
                       'Africa',
                       'America',
                       'Asia',
                       'Europa',
                       'Oceania'))
);




CREATE TABLE Personaje (
  id            NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  idUsuario     NUMBER       NOT NULL UNIQUE,
  especie       VARCHAR2(20) NOT NULL
                   CHECK (especie IN ('Bestia','Humano','Espíritu','Demonio')),
  fuerza        NUMBER       NOT NULL CHECK (fuerza      BETWEEN 0 AND 100),
  agilidad      NUMBER       NOT NULL CHECK (agilidad    BETWEEN 0 AND 100),
  inteligencia  NUMBER       NOT NULL CHECK (inteligencia BETWEEN 0 AND 100),
  vitalidad     NUMBER       NOT NULL CHECK (vitalidad   BETWEEN 0 AND 100),
  resistencia   NUMBER       NOT NULL CHECK (resistencia BETWEEN 0 AND 100),
  nivel         NUMBER       NOT NULL CHECK (nivel      BETWEEN 1 AND 342),
  experiencia   NUMBER       NOT NULL CHECK (experiencia >= 0),
  cantHoras     NUMBER       NOT NULL CHECK (cantHoras   >= 0),
  monedas       NUMBER       NOT NULL CHECK (monedas     >= 0),
  CONSTRAINT fk_personaje_usuario
    FOREIGN KEY (idUsuario) REFERENCES Usuario(id)
);








CREATE TABLE Habilidad (
  id            NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  funcion       VARCHAR2(10) NOT NULL
                   CHECK (funcion IN ('ataque', 'defensa', 'magia')),
  nombre        VARCHAR2(50) NOT NULL UNIQUE ,
  nivelMinimo   NUMBER       NOT NULL CHECK (nivelMinimo BETWEEN 1 AND 342),
  tipoEnergia   VARCHAR2(50)
);




CREATE TABLE Mision (
  id          NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  codigo      VARCHAR2(50)   NOT NULL UNIQUE,
  nombre      VARCHAR2(100)  NOT NULL,
  descripcion VARCHAR2(1000),
  tipo        VARCHAR2(10) DEFAULT ('Principal') NOT NULL
                   CHECK (tipo IN ('Principal', 'Secundaria')),
  nivelMinimo NUMBER         NOT NULL CHECK (nivelMinimo BETWEEN 1 AND 342),
  experiencia NUMBER         NOT NULL CHECK (experiencia >= 0),
  monedas     NUMBER         NOT NULL CHECK (monedas >= 0)
);




CREATE TABLE Inventario (
  id            NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  idPersonaje   NUMBER NOT NULL UNIQUE,
  CONSTRAINT fk_inventario_personaje
    FOREIGN KEY (idPersonaje) REFERENCES Personaje(id)
);


CREATE TABLE ItemTable (
  id            NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  categoria     VARCHAR(15) NOT NULL
                    CHECK (categoria IN (
                        'armas',
                        'armaduras',
                        'consumibles',
                        'materiales',
                        'reliquias')),
  nombre         VARCHAR(20) NOT NULL UNIQUE,
  rareza         VARCHAR(10) NOT NULL
                    CHECK (rareza IN (
                        'común',
                        'rara',
                        'epica',
                        'legendaria')),
  nivelMinimo    NUMBER      NOT NULL CHECK (nivelMinimo BETWEEN 1 AND 342),
  caracteristicasQueAfecta  VARCHAR(15) NOT NULL
                                CHECK (caracteristicasQueAfecta IN (
                                    'fuerza',
                                    'agilidad',
                                    'inteligencia',
                                    'vitalidad',
                                    'resistencia')),
  intercambiable NUMBER(1)   NOT NULL CHECK (intercambiable BETWEEN 0 AND 1)
);




CREATE TABLE Zona (
  id          NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  nombre      VARCHAR2(100)  NOT NULL,
  descripcion VARCHAR2(1000),
  terreno     VARCHAR2(50),
  ubicacion   VARCHAR2(100),
  nivelMinimo NUMBER         NOT NULL CHECK (nivelMinimo  BETWEEN 1 AND 342)
);




CREATE TABLE Botin (
  id      NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  monedas NUMBER         NOT NULL CHECK (monedas >= 0)
);




CREATE TABLE Enemigo (
  id        NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  nombre    VARCHAR2(100)  NOT NULL,
  nivel     NUMBER         NOT NULL CHECK (nivel > 0),
  ubicacion VARCHAR2(100),
  tipo      VARCHAR2(20) NOT NULL CHECK (tipo IN (
                                    'normal',
                                    'elite',
                                    'jefe'
                                    ))
);




CREATE TABLE Jefe (
  id NUMBER PRIMARY KEY,
  idMision  NUMBER,
  CONSTRAINT fk_jefe_enemigo
    FOREIGN KEY (id) REFERENCES Enemigo(id),
  CONSTRAINT fk_jefe_mision
    FOREIGN KEY (idMision) REFERENCES Mision(id)
);




CREATE TABLE Usuario_Progresa_Mision (
  idPersonaje         NUMBER       NOT NULL,
  idMision            NUMBER       NOT NULL,
  estado              VARCHAR2(20) NOT NULL
                        CHECK (estado IN ('No iniciada', 'En progreso', 'Completada')),
  recompensa_asignada CHAR(1) DEFAULT ('N') NOT NULL
                        CHECK (recompensa_asignada IN ('Y','N')) ,
  fechaCompletada     DATE,
  PRIMARY KEY (idPersonaje, idMision),
  FOREIGN KEY (idPersonaje) REFERENCES Personaje(id),
  FOREIGN KEY (idMision) REFERENCES Mision(id)
 );








CREATE TABLE Personaje_Tiene_Habilidad (
  idPersonaje    NUMBER NOT NULL,
  idHabilidad    NUMBER NOT NULL,
  PRIMARY KEY (idPersonaje,idHabilidad),
  FOREIGN KEY (idPersonaje) REFERENCES Personaje(id),
  FOREIGN KEY (idHabilidad) REFERENCES Habilidad(id)
);




CREATE TABLE Mision_Desbloquea_Habilidad (
  idHabilidad    NUMBER NOT NULL,
  idMision       NUMBER NOT NULL,
  PRIMARY KEY (idHabilidad,idMision),
  FOREIGN KEY (idHabilidad) REFERENCES Habilidad(id),
  FOREIGN KEY (idMision)    REFERENCES Mision(id)
);




CREATE TABLE Mision_Desbloquea_Zona (
  idMision       NUMBER NOT NULL,
  idZona         NUMBER NOT NULL,
  PRIMARY KEY (idMision,idZona),
  FOREIGN KEY (idMision) REFERENCES Mision(id),
  FOREIGN KEY (idZona)   REFERENCES Zona(id)
);




CREATE TABLE Mision_Previa (
  idMision       NUMBER NOT NULL,
  idPrevia       NUMBER NOT NULL,
  PRIMARY KEY (idMision,idPrevia),
  FOREIGN KEY (idMision) REFERENCES Mision(id),
  FOREIGN KEY (idPrevia) REFERENCES Mision(id)
);




CREATE TABLE Zona_Tiene_Enemigo (
  idZona         NUMBER NOT NULL,
  idEnemigo      NUMBER NOT NULL,
  PRIMARY KEY (idZona,idEnemigo),
  FOREIGN KEY (idZona)    REFERENCES Zona(id),
  FOREIGN KEY (idEnemigo) REFERENCES Enemigo(id)
);




CREATE TABLE Inventario_Tiene_Item (
  idInventario  NUMBER       NOT NULL,
  idItem        NUMBER       NOT NULL,
  cantidad      NUMBER       NOT NULL CHECK (cantidad >= 0),
  equipado      CHAR(1)      NOT NULL
                 CHECK (equipado IN ('Y','N')),
  PRIMARY KEY (idInventario,idItem),
  FOREIGN KEY (idInventario) REFERENCES Inventario(id),
  FOREIGN KEY (idItem)       REFERENCES ItemTable(id)
);




CREATE TABLE Mision_Otorga_Item (
  idMision   NUMBER NOT NULL,
  idItem     NUMBER NOT NULL,
  cantidad   NUMBER NOT NULL
               CHECK (cantidad >= 0),
  CONSTRAINT pk_item_mision PRIMARY KEY (idMision, idItem),
  CONSTRAINT fk_item_mision_mision
    FOREIGN KEY (idMision) REFERENCES Mision(id),
  CONSTRAINT fk_item_mision_item
    FOREIGN KEY (idItem)   REFERENCES ItemTable(id)
);




CREATE TABLE Enemigo_Suelta_Botin (
  idEnemigo NUMBER NOT NULL,
  idBotin   NUMBER NOT NULL,
  
  CONSTRAINT pk_enemigo_botin PRIMARY KEY (idEnemigo),
  CONSTRAINT fk_enbot_enemigo
    FOREIGN KEY (idEnemigo) REFERENCES Enemigo(id),
  CONSTRAINT fk_enbot_botin
    FOREIGN KEY (idBotin)   REFERENCES Botin(id)
);




CREATE TABLE Botin_Otorga_Item (
  idBotin   NUMBER NOT NULL,
  idItem    NUMBER NOT NULL,
  cantidad  NUMBER NOT NULL
              CHECK (cantidad >= 0),
  CONSTRAINT pk_botin_item PRIMARY KEY (idBotin, idItem),
  CONSTRAINT fk_bi_botin FOREIGN KEY (idBotin)
    REFERENCES Botin(id),
  CONSTRAINT fk_bi_item FOREIGN KEY (idItem)
    REFERENCES ItemTable(id)
);




CREATE TABLE Jefe_Condicionado_Por_Zona (
  idZona NUMBER NOT NULL,
  idJefe NUMBER NOT NULL,
  CONSTRAINT pk_zona_desbloquea_jefe
    PRIMARY KEY (idZona, idJefe),
  CONSTRAINT fk_zdj_zona
    FOREIGN KEY (idZona) REFERENCES Zona(id),
  CONSTRAINT fk_zdj_jefe
    FOREIGN KEY (idJefe) REFERENCES Jefe(id)
);




CREATE TABLE Jefe_Condicionado_Por_Mision (
  idMision NUMBER NOT NULL,
  idJefe   NUMBER NOT NULL,
  CONSTRAINT pk_mision_jefe
    PRIMARY KEY (idMision, idJefe),
  CONSTRAINT fk_mj_mision
    FOREIGN KEY (idMision) REFERENCES Mision(id),
  CONSTRAINT fk_mj_jefe
    FOREIGN KEY (idJefe) REFERENCES Jefe(id)
);




CREATE TABLE Jefe_Tiene_Habilidad (
  idJefe       NUMBER NOT NULL,
  idHabilidad  NUMBER NOT NULL,
  CONSTRAINT pk_jefe_habilidad
    PRIMARY KEY (idJefe, idHabilidad),
  CONSTRAINT fk_jh_jefe
    FOREIGN KEY (idJefe) REFERENCES Jefe(id),
  CONSTRAINT fk_jh_habilidad
    FOREIGN KEY (idHabilidad) REFERENCES Habilidad(id)
);

CREATE TABLE Personaje_Progreso_Diario (
  idPersonaje NUMBER NOT NULL, 
  fecha DATE NOT NULL,
  nivelesAumentados NUMBER NOT NULL CHECK (nivelesAumentados BETWEEN 0 AND 342),
  regaloAcreditado CHAR(1) DEFAULT ('N') NOT NULL
                        CHECK (regaloAcreditado IN ('Y','N')),
  CONSTRAINT pk_personaje_fecha
    PRIMARY KEY (idPersonaje, fecha),
  CONSTRAINT fk_ppd_personaje 
    FOREIGN KEY (idPersonaje) REFERENCES Personaje(id)
);
