CREATE TABLE rol(
    id INTEGER PRIMARY KEY,
    nombre VARCHAR(50)
);

CREATE TABLE usuario(
    id INTEGER PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(50) UNIQUE,
    email VARCHAR(100) UNIQUE,
    passwd VARCHAR(200) 
);

CREATE TABLE RolAsociado(
    rol INTEGER,
    usuario INTEGER,

    CONSTRAINT rolAso_rol_usua_PK PRIMARY KEY(rol,usuario),
    CONSTRAINT rolAso_rol_FK FOREIGN KEY (rol)
	REFERENCES rol(id) ON DELETE cascade ON UPDATE cascade,
    CONSTRAINT rolAso_usua_FK FOREIGN KEY (usuario)
	REFERENCES usuario(id) ON DELETE cascade ON UPDATE cascade

);

CREATE TABLE estado(
    id INTEGER PRIMARY KEY,
    nombre VARCHAR(25)
);

CREATE TABLE peticion(
    id INTEGER PRIMARY KEY AUTO_INCREMENT,
    nombreDto VARCHAR(50),
    ctdadJugadores INTEGER,
    ctdadEquipos INTEGER,
    informacionExtra VARCHAR(500),
    usuario INTEGER,
    estado INTEGER,

    CONSTRAINT pet_usua_FK FOREIGN KEY (usuario)
	REFERENCES usuario(id) ON DELETE cascade ON UPDATE cascade,
    CONSTRAINT pet_est_FK FOREIGN KEY (estado)
	REFERENCES estado(id) ON DELETE cascade ON UPDATE cascade
);

CREATE TABLE deporte(
    id INTEGER PRIMARY KEY AUTO_INCREMENT,
    nombreDto VARCHAR(50),
    ctdadJugadores INTEGER,
    ctdadXequipo INTEGER
);

CREATE TABLE partido(
    id INTEGER PRIMARY KEY AUTO_INCREMENT,
    ubicacion VARCHAR(500),
    fInicio DATE,
    hInicio VARCHAR(5),
    fLimite DATE,
    hLimite VARCHAR(5),
    coste DOUBLE(5,2),
    creador INTEGER,
    deporte INTEGER,
    estado INTEGER,

    CONSTRAINT par_usua_FK FOREIGN KEY (creador)
	REFERENCES usuario(id) ON DELETE cascade ON UPDATE cascade,
    CONSTRAINT par_dept_FK FOREIGN KEY (deporte)
	REFERENCES deporte(id) ON DELETE cascade ON UPDATE cascade,
    CONSTRAINT part_est_FK FOREIGN KEY (estado)
	REFERENCES estado(id) ON DELETE cascade ON UPDATE cascade
);

CREATE TABLE pago(
    id INTEGER PRIMARY KEY AUTO_INCREMENT,
    fecha DATE NOT NULL,
    cantidad DOUBLE(5,2) NOT NULL,
    usuario INTEGER,

    CONSTRAINT pag_usua_FK FOREIGN KEY (usuario)
	REFERENCES usuario(id) ON DELETE cascade ON UPDATE cascade
);

CREATE TABLE participar(
    partido INTEGER,
    usuario INTEGER,
    pago INTEGER,

    CONSTRAINT partic_part_usua_PK PRIMARY KEY(partido,usuario),
    CONSTRAINT partic_part_FK FOREIGN KEY (partido)
	REFERENCES partido(id) ON DELETE cascade ON UPDATE cascade,
    CONSTRAINT partic_usua_FK FOREIGN KEY (usuario)
	REFERENCES usuario(id) ON DELETE cascade ON UPDATE cascade,
    CONSTRAINT partic_pag_FK FOREIGN KEY (pago)
	REFERENCES pago(id) ON DELETE cascade ON UPDATE cascade
);

CREATE TABLE privacidad(
    id INTEGER PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(25)
);

CREATE TABLE equipo(
    id INTEGER PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(50),
    deporte INTEGER NOT NULL,
    lider INTEGER,
    ubicacion VARCHAR(500),
    privacidad INT,

    CONSTRAINT equip_lid_FK FOREIGN KEY (lider)
	REFERENCES usuario(id) ON DELETE cascade ON UPDATE cascade,
    CONSTRAINT equip_dep_FK FOREIGN KEY (deporte)
	REFERENCES deporte(id) ON DELETE cascade ON UPDATE cascade,
    CONSTRAINT equip_priv_FK FOREIGN KEY (privacidad)
	REFERENCES privacidad(id) ON DELETE cascade ON UPDATE cascade
);

CREATE TABLE ComponenteEquipo(
    equipo INTEGER,
    usuario INTEGER,

    CONSTRAINT compo_equip_usua_PK PRIMARY KEY(equipo,usuario),
    CONSTRAINT compo_equip_FK FOREIGN KEY (equipo)
	REFERENCES equipo(id) ON DELETE cascade ON UPDATE cascade,
    CONSTRAINT pcompo_usua_FK FOREIGN KEY (usuario)
	REFERENCES usuario(id) ON DELETE cascade ON UPDATE cascade
);

CREATE TABLE torneo(
    id INTEGER PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(50),
    ubicacion VARCHAR(500),
    fInicio DATE,
    hInicio VARCHAR(5),
    fLimite DATE,
    hLimite VARCHAR(5),
    minEquipos INTEGER,
    maxEquipos INTEGER,
    coste DOUBLE(5,2),
    organizador INTEGER,
    deporte INTEGER,
    enfrentamientosGenerados BOOLEAN,
    estado INTEGER,


    CONSTRAINT tor_usua_FK FOREIGN KEY (organizador)
	REFERENCES usuario(id) ON DELETE cascade ON UPDATE cascade,
    CONSTRAINT tor_dept_FK FOREIGN KEY (deporte)
	REFERENCES deporte(id) ON DELETE cascade ON UPDATE cascade,
    CONSTRAINT tor_est_FK FOREIGN KEY (estado)
	REFERENCES estado(id) ON DELETE cascade ON UPDATE cascade
);

CREATE TABLE InscrippcionTorneo(
    torneo INTEGER,
    equipo INTEGER,
    pago INTEGER,

    CONSTRAINT insTor_torn_equip_PK PRIMARY KEY(torneo,equipo),
    CONSTRAINT insTor_torn_FK FOREIGN KEY (torneo)
	REFERENCES torneo(id) ON DELETE cascade ON UPDATE cascade,
    CONSTRAINT insTor_equip_FK FOREIGN KEY (equipo)
	REFERENCES equipo(id) ON DELETE cascade ON UPDATE cascade,
    CONSTRAINT insTor_pag_FK FOREIGN KEY (pago)
	REFERENCES pago(id) ON DELETE cascade ON UPDATE cascade
);

CREATE TABLE ResultadosTorneo(
    id INTEGER PRIMARY KEY AUTO_INCREMENT,
    torneo INTEGER,
    fJugada DATE,
    hJugada VARCHAR(5),
    ronda INTEGER,
    equipoLocal INTEGER,
    ptosLocal INTEGER,
    equipoVisitante INTEGER,
    ptosVisitante INTEGER,

    CONSTRAINT resTor_torn_FK FOREIGN KEY (torneo)
	REFERENCES torneo(id) ON DELETE cascade ON UPDATE cascade,
    CONSTRAINT resTor_loc_FK FOREIGN KEY (equipoLocal)
	REFERENCES equipo(id) ON DELETE cascade ON UPDATE cascade,
    CONSTRAINT resTor_vis_FK FOREIGN KEY (equipoVisitante)
	REFERENCES equipo(id) ON DELETE cascade ON UPDATE cascade
);


CREATE TABLE liga(
    id INTEGER PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(50),
    ubicacion VARCHAR(500),
    fInicio DATE,
    hInicio VARCHAR(5),
    fLimite DATE,
    hLimite VARCHAR(5),
    minEquipos INTEGER,
    maxEquipos INTEGER,
    coste DOUBLE(5,2),
    organizador INTEGER,
    deporte INTEGER,
    frecuenciaJornada INTEGER,
    duracionPartido INTEGER,
    horaInicioPartidos VARCHAR(5),
    horaFinPartidos VARCHAR(5),
    enfrentamientosGenerados BOOLEAN,
    estado INTEGER,

    CONSTRAINT lig_usua_FK FOREIGN KEY (organizador)
	REFERENCES usuario(id) ON DELETE cascade ON UPDATE cascade,
    CONSTRAINT lig_dept_FK FOREIGN KEY (deporte)
	REFERENCES deporte(id) ON DELETE cascade ON UPDATE cascade,
    CONSTRAINT lig_est_FK FOREIGN KEY (estado)
	REFERENCES estado(id) ON DELETE cascade ON UPDATE cascade
);

CREATE TABLE InscrippcionLiga(
    liga INTEGER,
    equipo INTEGER,
    pago INTEGER,

    CONSTRAINT insLig_liga_equip_PK PRIMARY KEY(liga,equipo),
    CONSTRAINT insLig_lig_FK FOREIGN KEY (liga)
	REFERENCES liga(id) ON DELETE cascade ON UPDATE cascade,
    CONSTRAINT insLig_equip_FK FOREIGN KEY (equipo)
	REFERENCES equipo(id) ON DELETE cascade ON UPDATE cascade,
    CONSTRAINT insLig_pag_FK FOREIGN KEY (pago)
	REFERENCES pago(id) ON DELETE cascade ON UPDATE cascade
);

CREATE TABLE ResultadosLiga(
    id INTEGER PRIMARY KEY AUTO_INCREMENT,
    liga INTEGER,
    fJugada DATE,
    hJugada VARCHAR(5),
    ronda INTEGER,
    equipoLocal INTEGER,
    ptosLocal INTEGER,
    equipoVisitante INTEGER,
    ptosVisitante INTEGER,

    CONSTRAINT resLig_liga_FK FOREIGN KEY (liga)
	REFERENCES liga(id) ON DELETE cascade ON UPDATE cascade,
    CONSTRAINT resLig_loc_FK FOREIGN KEY (equipoLocal)
	REFERENCES equipo(id) ON DELETE cascade ON UPDATE cascade,
    CONSTRAINT resLig_vis_FK FOREIGN KEY (equipoVisitante)
	REFERENCES equipo(id) ON DELETE cascade ON UPDATE cascade
);


CREATE TABLE invitacionEquipoUsuario(
    id INTEGER PRIMARY KEY AUTO_INCREMENT,
    equipo INTEGER,
    usuario INTEGER,
    estado INTEGER,

    CONSTRAINT invEquUsu_equip_FK FOREIGN KEY (equipo)
	REFERENCES equipo(id) ON DELETE cascade ON UPDATE cascade,
    CONSTRAINT invEquUsu_usua_FK FOREIGN KEY (usuario)
	REFERENCES usuario(id) ON DELETE cascade ON UPDATE cascade,
    CONSTRAINT invEquUsu_est_FK FOREIGN KEY (estado)
	REFERENCES estado(id) ON DELETE cascade ON UPDATE cascade
);

CREATE TABLE invitacionUsuarioEquipo(
    id INTEGER PRIMARY KEY AUTO_INCREMENT,
    equipo INTEGER,
    usuario INTEGER,
    estado INTEGER,

    CONSTRAINT invUsuEqu_equip_FK FOREIGN KEY (equipo)
	REFERENCES equipo(id) ON DELETE cascade ON UPDATE cascade,
    CONSTRAINT invUsuEqu_usua_FK FOREIGN KEY (usuario)
	REFERENCES usuario(id) ON DELETE cascade ON UPDATE cascade,
    CONSTRAINT invUsuEqu_est_FK FOREIGN KEY (estado)
	REFERENCES estado(id) ON DELETE cascade ON UPDATE cascade
);


DELIMITER //
CREATE FUNCTION buscarTorneosCercanos(origen VARCHAR(500), radio_en_km FLOAT)
RETURNS VARCHAR(500)
BEGIN
    DECLARE ids_torneos VARCHAR(500);
    DECLARE origen_lat FLOAT;
    DECLARE origen_lng FLOAT;
    
    SET ids_torneos = '';
    SET origen_lat = CAST(SUBSTRING_INDEX(origen, ',', 1) AS DECIMAL(30,25));
    SET origen_lng = CAST(SUBSTRING_INDEX(origen, ',', -1) AS DECIMAL(30,25));

    SELECT GROUP_CONCAT(id) INTO ids_torneos
    FROM (
        SELECT id, ubicacion, 
               6371 * 2 * ASIN(SQRT(POWER(SIN((origen_lat - ABS(CAST(SUBSTRING_INDEX(ubicacion, ',', 1) AS DECIMAL(30,25)))) * PI()/180 / 2), 2) + COS(origen_lat * PI()/180 ) * COS(ABS(CAST(SUBSTRING_INDEX(ubicacion, ',', -1) AS DECIMAL(30,25))) * PI()/180) * POWER(SIN((origen_lng - CAST(SUBSTRING_INDEX(ubicacion, ',', -1) AS DECIMAL(30,25))) * PI()/180 / 2), 2))) as distancia
        FROM torneo
        WHERE 
          ubicacion IS NOT NULL 
          AND estado = 2
        HAVING distancia <= radio_en_km
        ORDER BY distancia ASC
    ) AS torneos_cercanos;

    RETURN ids_torneos;
END//
DELIMITER ;

DELIMITER //
CREATE FUNCTION buscarLigasCercanos(origen VARCHAR(500), radio_en_km FLOAT)
RETURNS VARCHAR(500)
BEGIN
    DECLARE ids_ligas VARCHAR(500);
    DECLARE origen_lat FLOAT;
    DECLARE origen_lng FLOAT;
    
    SET ids_ligas = '';
    SET origen_lat = CAST(SUBSTRING_INDEX(origen, ',', 1) AS DECIMAL(30,25));
    SET origen_lng = CAST(SUBSTRING_INDEX(origen, ',', -1) AS DECIMAL(30,25));

    SELECT GROUP_CONCAT(id) INTO ids_ligas
    FROM (
        SELECT id, ubicacion, 
               6371 * 2 * ASIN(SQRT(POWER(SIN((origen_lat - ABS(CAST(SUBSTRING_INDEX(ubicacion, ',', 1) AS DECIMAL(30,25)))) * PI()/180 / 2), 2) + COS(origen_lat * PI()/180 ) * COS(ABS(CAST(SUBSTRING_INDEX(ubicacion, ',', -1) AS DECIMAL(30,25))) * PI()/180) * POWER(SIN((origen_lng - CAST(SUBSTRING_INDEX(ubicacion, ',', -1) AS DECIMAL(30,25))) * PI()/180 / 2), 2))) as distancia
        FROM liga
        WHERE 
          ubicacion IS NOT NULL 
          AND estado = 2
        HAVING distancia <= radio_en_km
        ORDER BY distancia ASC
    ) AS ligas_cercanos;

    RETURN ids_ligas;
END//
DELIMITER ;

DELIMITER //
CREATE FUNCTION buscarPartidosCercanos(origen VARCHAR(500), radio_en_km FLOAT)
RETURNS VARCHAR(500)
BEGIN
    DECLARE ids_partidos VARCHAR(500);
    DECLARE origen_lat FLOAT;
    DECLARE origen_lng FLOAT;
    
    SET ids_partidos = '';
    SET origen_lat = CAST(SUBSTRING_INDEX(origen, ',', 1) AS DECIMAL(30,25));
    SET origen_lng = CAST(SUBSTRING_INDEX(origen, ',', -1) AS DECIMAL(30,25));

    SELECT GROUP_CONCAT(id) INTO ids_partidos
    FROM (
        SELECT id, ubicacion, 
               6371 * 2 * ASIN(SQRT(POWER(SIN((origen_lat - ABS(CAST(SUBSTRING_INDEX(ubicacion, ',', 1) AS DECIMAL(30,25)))) * PI()/180 / 2), 2) + COS(origen_lat * PI()/180 ) * COS(ABS(CAST(SUBSTRING_INDEX(ubicacion, ',', -1) AS DECIMAL(30,25))) * PI()/180) * POWER(SIN((origen_lng - CAST(SUBSTRING_INDEX(ubicacion, ',', -1) AS DECIMAL(30,25))) * PI()/180 / 2), 2))) as distancia
        FROM partido
        WHERE 
          ubicacion IS NOT NULL 
          AND estado = 2
        HAVING distancia <= radio_en_km
        ORDER BY distancia ASC
    ) AS partidoss_cercanos;

    RETURN ids_partidos;
END//
DELIMITER ;

DELIMITER //
CREATE FUNCTION buscarEquiposCercanos(origen VARCHAR(500), radio_en_km FLOAT)
RETURNS VARCHAR(500)
BEGIN
    DECLARE ids_equipos VARCHAR(500);
    DECLARE origen_lat FLOAT;
    DECLARE origen_lng FLOAT;
    
    SET ids_equipos = '';
    SET origen_lat = CAST(SUBSTRING_INDEX(origen, ',', 1) AS DECIMAL(30,25));
    SET origen_lng = CAST(SUBSTRING_INDEX(origen, ',', -1) AS DECIMAL(30,25));

    SELECT GROUP_CONCAT(id) INTO ids_equipos
    FROM (
        SELECT id, ubicacion, 
               6371 * 2 * ASIN(SQRT(POWER(SIN((origen_lat - ABS(CAST(SUBSTRING_INDEX(ubicacion, ',', 1) AS DECIMAL(30,25)))) * PI()/180 / 2), 2) + COS(origen_lat * PI()/180 ) * COS(ABS(CAST(SUBSTRING_INDEX(ubicacion, ',', -1) AS DECIMAL(30,25))) * PI()/180) * POWER(SIN((origen_lng - CAST(SUBSTRING_INDEX(ubicacion, ',', -1) AS DECIMAL(30,25))) * PI()/180 / 2), 2))) as distancia
        FROM equipo
        WHERE 
          ubicacion IS NOT NULL 
          AND nombre NOT LIKE 'ELIMINADO'
        HAVING distancia <= radio_en_km
        ORDER BY distancia ASC
    ) AS equipos_cercanos;

    RETURN ids_equipos;
END//
DELIMITER ;


INSERT INTO privacidad VALUES (1,"Publico");
INSERT INTO privacidad VALUES (2,"Con Invitacion");
INSERT INTO privacidad VALUES (3,"Privado");

INSERT INTO estado VALUES(1,'Jugandose');
INSERT INTO estado VALUES(2,'Esperando Jugadores');
INSERT INTO estado VALUES(3,'Cancelado');
INSERT INTO estado VALUES(4,'Finalizado');
INSERT INTO estado VALUES(5,'Esperando Respuesta');
INSERT INTO estado VALUES(6,'Aceptada');
INSERT INTO estado VALUES(7,'Rechazada');

INSERT INTO rol VALUES(1,'Administrador');
INSERT INTO rol VALUES(2,'Organizador');
INSERT INTO rol VALUES(3,'Usuario');

INSERT INTO usuario VALUES (1,'admin','admin@admin.com','c7ad44cbad762a5da0a452f9e854fdc1e0e7a52a38015f23f3eab1d80b931dd472634dfac71cd34ebc35d16ab7fb8a90c81f975113d6c7538dc69dd8de9077ec');
INSERT INTO RolAsociado VALUES (1,1);

INSERT INTO deporte VALUES(1,'Futbol 11', 22,11);
INSERT INTO deporte VALUES(2,'Futbol 7', 14,7);
INSERT INTO deporte VALUES(3,'Futbol Sala', 10),5;
INSERT INTO deporte VALUES(4,'Voleibol', 12,6);
INSERT INTO deporte VALUES(5,'Voleibol Playa',4,2)