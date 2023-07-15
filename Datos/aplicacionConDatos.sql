-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 14-06-2023 a las 20:12:24
-- Versión del servidor: 10.4.27-MariaDB
-- Versión de PHP: 8.2.0

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `aplicacion`
--

DELIMITER $$
--
-- Funciones
--
CREATE DEFINER=`root`@`localhost` FUNCTION `buscarEquiposCercanos` (`origen` VARCHAR(500), `radio_en_km` FLOAT) RETURNS VARCHAR(500) CHARSET utf8mb4 COLLATE utf8mb4_general_ci  BEGIN
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
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `buscarLigasCercanos` (`origen` VARCHAR(500), `radio_en_km` FLOAT) RETURNS VARCHAR(500) CHARSET utf8mb4 COLLATE utf8mb4_general_ci  BEGIN
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
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `buscarPartidosCercanos` (`origen` VARCHAR(500), `radio_en_km` FLOAT) RETURNS VARCHAR(500) CHARSET utf8mb4 COLLATE utf8mb4_general_ci  BEGIN
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
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `buscarTorneosCercanos` (`origen` VARCHAR(500), `radio_en_km` FLOAT) RETURNS VARCHAR(500) CHARSET utf8mb4 COLLATE utf8mb4_general_ci  BEGIN
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
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `componenteequipo`
--

CREATE TABLE `componenteequipo` (
  `equipo` int(11) NOT NULL,
  `usuario` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `componenteequipo`
--

INSERT INTO `componenteequipo` (`equipo`, `usuario`) VALUES
(1, 4),
(1, 6),
(2, 4),
(2, 6),
(3, 7),
(3, 8),
(4, 8),
(5, 9),
(5, 10),
(6, 11),
(6, 12),
(7, 13),
(7, 14),
(8, 15),
(8, 16),
(9, 17),
(9, 18),
(10, 19),
(10, 20),
(11, 21),
(11, 22),
(12, 23),
(12, 24);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `deporte`
--

CREATE TABLE `deporte` (
  `id` int(11) NOT NULL,
  `nombreDto` varchar(50) DEFAULT NULL,
  `ctdadJugadores` int(11) DEFAULT NULL,
  `ctdadXequipo` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `deporte`
--

INSERT INTO `deporte` (`id`, `nombreDto`, `ctdadJugadores`, `ctdadXequipo`) VALUES
(1, 'Futbol 11', 22, 11),
(2, 'Futbol 7', 14, 7),
(4, 'Voleibol', 12, 6),
(5, 'Voleibol Playa', 4, 2);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `equipo`
--

CREATE TABLE `equipo` (
  `id` int(11) NOT NULL,
  `nombre` varchar(50) DEFAULT NULL,
  `deporte` int(11) NOT NULL,
  `lider` int(11) DEFAULT NULL,
  `ubicacion` varchar(500) DEFAULT NULL,
  `privacidad` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `equipo`
--

INSERT INTO `equipo` (`id`, `nombre`, `deporte`, `lider`, `ubicacion`, `privacidad`) VALUES
(1, 'E1', 5, 4, '36.5005872,-6.2722443', 1),
(2, 'E2', 5, 4, '36.503959343072616,-6.272575110197067', 3),
(3, 'E3', 5, 7, '36.73170975943478,-6.365294717252254', 1),
(4, 'E4', 1, 8, '36.34960213564575,-6.140236593782902', 1),
(5, 'E5', 5, 9, '36.631942752295764,-6.380501836538314', 1),
(6, 'E7', 5, 11, '36.23504032339073,-6.069413535296917', 1),
(7, 'E8', 5, 13, '37.1918,-3.6095', 1),
(8, 'E9', 5, 15, '36.631942752295764,-6.380501836538314', 1),
(9, 'E10', 5, 17, '36.631942752295764,-6.380501836538314', 1),
(10, 'E11', 5, 19, '36.631942752295764,-6.380501836538314', 1),
(11, 'E12', 5, 21, '36.631942752295764,-6.380501836538314', 1),
(12, 'E13', 5, 23, '36.631942752295764,-6.380501836538314', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `estado`
--

CREATE TABLE `estado` (
  `id` int(11) NOT NULL,
  `nombre` varchar(25) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `estado`
--

INSERT INTO `estado` (`id`, `nombre`) VALUES
(1, 'Jugandose'),
(2, 'Esperando Jugadores'),
(3, 'Cancelado'),
(4, 'Finalizado'),
(5, 'Esperando Respuesta'),
(6, 'Aceptada'),
(7, 'Rechazada');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `inscrippcionliga`
--

CREATE TABLE `inscrippcionliga` (
  `liga` int(11) NOT NULL,
  `equipo` int(11) NOT NULL,
  `pago` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `inscrippcionliga`
--

INSERT INTO `inscrippcionliga` (`liga`, `equipo`, `pago`) VALUES
(1, 1, NULL),
(1, 2, NULL),
(1, 3, NULL),
(1, 5, NULL),
(1, 6, NULL),
(1, 7, NULL),
(1, 8, NULL),
(1, 9, NULL),
(1, 10, NULL),
(1, 11, NULL),
(2, 2, NULL),
(2, 3, NULL),
(2, 5, NULL),
(2, 6, NULL),
(2, 7, NULL),
(2, 8, NULL),
(2, 9, NULL),
(2, 10, NULL),
(4, 1, NULL),
(4, 2, NULL),
(4, 3, NULL),
(4, 5, NULL),
(4, 6, NULL),
(4, 7, NULL),
(4, 8, NULL),
(4, 9, NULL),
(5, 1, NULL),
(5, 2, NULL),
(5, 3, NULL),
(5, 5, NULL),
(5, 6, NULL),
(5, 7, NULL),
(6, 1, NULL),
(6, 2, NULL),
(6, 3, NULL),
(6, 5, NULL),
(7, 1, NULL),
(7, 2, NULL),
(7, 3, NULL),
(8, 1, NULL),
(8, 2, NULL),
(8, 3, NULL),
(8, 5, NULL),
(8, 6, NULL),
(8, 7, NULL),
(8, 8, NULL),
(9, 1, NULL),
(9, 2, NULL),
(9, 3, NULL),
(9, 5, NULL),
(9, 6, NULL),
(10, 1, NULL),
(11, 1, NULL),
(11, 2, NULL),
(11, 3, NULL),
(11, 5, NULL),
(2, 1, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `inscrippciontorneo`
--

CREATE TABLE `inscrippciontorneo` (
  `torneo` int(11) NOT NULL,
  `equipo` int(11) NOT NULL,
  `pago` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `inscrippciontorneo`
--

INSERT INTO `inscrippciontorneo` (`torneo`, `equipo`, `pago`) VALUES
(1, 1, NULL),
(1, 2, NULL),
(1, 3, NULL),
(1, 5, NULL),
(1, 6, NULL),
(1, 7, NULL),
(1, 8, NULL),
(1, 9, NULL),
(2, 2, NULL),
(2, 3, NULL),
(2, 5, NULL),
(2, 6, NULL),
(2, 7, NULL),
(2, 8, NULL),
(3, 2, NULL),
(3, 3, NULL),
(3, 5, NULL),
(4, 1, NULL),
(5, 2, NULL),
(5, 3, NULL),
(5, 5, NULL),
(7, 1, NULL),
(7, 2, NULL),
(7, 3, NULL),
(7, 5, NULL),
(7, 6, NULL),
(7, 7, NULL),
(8, 1, NULL),
(8, 2, NULL),
(8, 3, NULL),
(8, 5, NULL),
(8, 6, NULL),
(9, 1, NULL),
(10, 2, NULL),
(10, 3, NULL),
(10, 5, NULL),
(10, 6, NULL),
(11, 1, NULL),
(11, 2, NULL),
(11, 3, NULL),
(11, 5, NULL),
(12, 1, NULL),
(3, 1, 2),
(6, 1, 3),
(2, 1, 4);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `invitacionequipousuario`
--

CREATE TABLE `invitacionequipousuario` (
  `id` int(11) NOT NULL,
  `equipo` int(11) DEFAULT NULL,
  `usuario` int(11) DEFAULT NULL,
  `estado` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `invitacionequipousuario`
--

INSERT INTO `invitacionequipousuario` (`id`, `equipo`, `usuario`, `estado`) VALUES
(1, 2, 6, 6),
(2, 3, 8, 6),
(3, 5, 10, 6),
(4, 7, 14, 6);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `invitacionusuarioequipo`
--

CREATE TABLE `invitacionusuarioequipo` (
  `id` int(11) NOT NULL,
  `equipo` int(11) DEFAULT NULL,
  `usuario` int(11) DEFAULT NULL,
  `estado` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `liga`
--

CREATE TABLE `liga` (
  `id` int(11) NOT NULL,
  `nombre` varchar(50) DEFAULT NULL,
  `ubicacion` varchar(500) DEFAULT NULL,
  `fInicio` date DEFAULT NULL,
  `hInicio` varchar(5) DEFAULT NULL,
  `fLimite` date DEFAULT NULL,
  `hLimite` varchar(5) DEFAULT NULL,
  `minEquipos` int(11) DEFAULT NULL,
  `maxEquipos` int(11) DEFAULT NULL,
  `coste` double(5,2) DEFAULT NULL,
  `organizador` int(11) DEFAULT NULL,
  `deporte` int(11) DEFAULT NULL,
  `frecuenciaJornada` int(11) DEFAULT NULL,
  `duracionPartido` int(11) DEFAULT NULL,
  `horaInicioPartidos` varchar(5) DEFAULT NULL,
  `horaFinPartidos` varchar(5) DEFAULT NULL,
  `enfrentamientosGenerados` tinyint(1) DEFAULT NULL,
  `estado` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `liga`
--

INSERT INTO `liga` (`id`, `nombre`, `ubicacion`, `fInicio`, `hInicio`, `fLimite`, `hLimite`, `minEquipos`, `maxEquipos`, `coste`, `organizador`, `deporte`, `frecuenciaJornada`, `duracionPartido`, `horaInicioPartidos`, `horaFinPartidos`, `enfrentamientosGenerados`, `estado`) VALUES
(1, 'Liga10', '36.5007925,-6.2724958', '2023-06-15', '20:00', '2023-06-14', '21:00', 4, 10, 0.00, 2, 5, 4, 50, '15:00', '17:00', 0, 2),
(2, 'Liga9', '36.6850064,-6.126074399999999', '2023-06-17', '00:00', '2023-06-14', '20:00', 7, 9, 25.00, 2, 5, 5, 100, '12:00', '19:00', 1, 1),
(3, 'Liga8', '36.6237968,-6.3597236', '2023-06-15', '09:00', '2023-06-14', '22:00', 2, 4, 0.00, 2, 5, 7, 30, '16:00', '20:00', 0, 3),
(4, 'Liga8', '36.6237968,-6.3597236', '2023-06-15', '09:00', '2023-06-14', '20:00', 3, 8, 0.00, 2, 5, 5, 30, '12:00', '18:00', 1, 1),
(5, 'Liga6', '36.6203006,-6.3608235', '2023-06-21', '07:00', '2023-06-17', '15:00', 4, 6, 0.00, 2, 5, 7, 30, '12:00', '21:00', 0, 2),
(6, 'Liga4', '36.6919485,-6.407030199999999', '2023-06-15', '10:00', '2023-06-14', '20:00', 2, 4, 0.00, 2, 5, 7, 15, '05:00', '09:00', 1, 1),
(7, 'Liga7a', '37.3890924,-5.9844589', '2023-06-16', '18:55', '2023-06-14', '20:00', 3, 7, 0.00, 2, 5, 5, 10, '09:00', '12:00', 1, 1),
(8, 'Liga7', '36.75800419999999,-5.5061788', '2023-06-15', '09:00', '2023-06-14', '20:00', 3, 7, 0.00, 3, 5, 6, 30, '10:00', '20:00', 1, 1),
(9, 'Liga5', '36.6236874,-6.3601441', '2023-06-15', '13:00', '2023-06-14', '20:00', 2, 5, 0.00, 3, 5, 4, 30, '18:00', '23:00', 1, 1),
(10, 'Liga4a', '36.2780988,-6.086207099999999', '2023-06-18', '00:00', '2023-06-17', '00:00', 2, 4, 0.00, 3, 5, 7, 10, '03:00', '11:00', 0, 2),
(11, 'Liga6a', '36.4165052,-6.1461102', '2023-06-15', '09:00', '2023-06-14', '20:00', 4, 6, 0.00, 3, 5, 7, 30, '09:00', '16:00', 1, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `pago`
--

CREATE TABLE `pago` (
  `id` int(11) NOT NULL,
  `fecha` date NOT NULL,
  `cantidad` double(5,2) NOT NULL,
  `usuario` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `pago`
--

INSERT INTO `pago` (`id`, `fecha`, `cantidad`, `usuario`) VALUES
(1, '2023-06-14', 25.00, 4),
(2, '2023-06-14', 4.00, 4),
(3, '2023-06-14', 12.00, 4),
(4, '2023-06-14', 4.00, 4);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `participar`
--

CREATE TABLE `participar` (
  `partido` int(11) NOT NULL,
  `usuario` int(11) NOT NULL,
  `pago` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `partido`
--

CREATE TABLE `partido` (
  `id` int(11) NOT NULL,
  `ubicacion` varchar(500) DEFAULT NULL,
  `fInicio` date DEFAULT NULL,
  `hInicio` varchar(5) DEFAULT NULL,
  `fLimite` date DEFAULT NULL,
  `hLimite` varchar(5) DEFAULT NULL,
  `coste` double(5,2) DEFAULT NULL,
  `creador` int(11) DEFAULT NULL,
  `deporte` int(11) DEFAULT NULL,
  `estado` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `peticion`
--

CREATE TABLE `peticion` (
  `id` int(11) NOT NULL,
  `nombreDto` varchar(50) DEFAULT NULL,
  `ctdadJugadores` int(11) DEFAULT NULL,
  `ctdadEquipos` int(11) DEFAULT NULL,
  `informacionExtra` varchar(500) DEFAULT NULL,
  `usuario` int(11) DEFAULT NULL,
  `estado` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `privacidad`
--

CREATE TABLE `privacidad` (
  `id` int(11) NOT NULL,
  `nombre` varchar(25) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `privacidad`
--

INSERT INTO `privacidad` (`id`, `nombre`) VALUES
(1, 'Publico'),
(2, 'Con Invitacion'),
(3, 'Privado');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `resultadosliga`
--

CREATE TABLE `resultadosliga` (
  `id` int(11) NOT NULL,
  `liga` int(11) DEFAULT NULL,
  `fJugada` date DEFAULT NULL,
  `hJugada` varchar(5) DEFAULT NULL,
  `ronda` int(11) DEFAULT NULL,
  `equipoLocal` int(11) DEFAULT NULL,
  `ptosLocal` int(11) DEFAULT NULL,
  `equipoVisitante` int(11) DEFAULT NULL,
  `ptosVisitante` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `resultadosliga`
--

INSERT INTO `resultadosliga` (`id`, `liga`, `fJugada`, `hJugada`, `ronda`, `equipoLocal`, `ptosLocal`, `equipoVisitante`, `ptosVisitante`) VALUES
(1, 9, '2023-06-15', '18:00', 1, 6, 1, 1, 2),
(2, 9, '2023-06-15', '18:30', 1, 5, 2, 2, 1),
(3, 9, '2023-06-19', '18:00', 2, 5, 2, 1, 1),
(4, 9, '2023-06-19', '18:30', 2, 3, 1, 6, 2),
(5, 9, '2023-06-23', '18:00', 3, 3, 2, 1, 1),
(6, 9, '2023-06-23', '18:30', 3, 2, 1, 5, 2),
(7, 9, '2023-06-27', '18:00', 4, 2, 3, 1, 1),
(8, 9, '2023-06-27', '18:30', 4, 6, 5, 3, 2),
(9, 9, '2023-07-01', '18:00', 5, 6, 5, 1, 2),
(10, 9, '2023-07-01', '18:30', 5, 5, 1, 2, 5),
(11, 9, '2023-07-05', '18:00', 6, 5, 4, 1, 2),
(12, 9, '2023-07-05', '18:30', 6, 3, 1, 6, 3),
(13, 9, '2023-07-09', '18:00', 7, 3, 5, 1, 3),
(14, 9, '2023-07-09', '18:30', 7, 2, 2, 5, 5),
(15, 9, '2023-07-13', '18:00', 8, 2, 6, 1, 2),
(16, 9, '2023-07-13', '18:30', 8, 6, 5, 3, 3),
(17, 11, '2023-06-15', '09:00', 1, 5, NULL, 1, NULL),
(18, 11, '2023-06-15', '09:30', 1, 3, NULL, 2, NULL),
(19, 11, '2023-06-22', '09:00', 2, 3, NULL, 1, NULL),
(20, 11, '2023-06-22', '09:30', 2, 2, NULL, 5, NULL),
(21, 11, '2023-06-29', '09:00', 3, 2, NULL, 1, NULL),
(22, 11, '2023-06-29', '09:30', 3, 5, NULL, 3, NULL),
(23, 11, '2023-07-06', '09:00', 4, 5, NULL, 1, NULL),
(24, 11, '2023-07-06', '09:30', 4, 3, NULL, 2, NULL),
(25, 11, '2023-07-13', '09:00', 5, 3, NULL, 1, NULL),
(26, 11, '2023-07-13', '09:30', 5, 2, NULL, 5, NULL),
(27, 11, '2023-07-20', '09:00', 6, 2, NULL, 1, NULL),
(28, 11, '2023-07-20', '09:30', 6, 5, NULL, 3, NULL),
(29, 7, '2023-06-16', '09:00', 1, 3, NULL, 1, NULL),
(30, 7, '2023-06-21', '09:00', 2, 2, NULL, 1, NULL),
(31, 7, '2023-06-26', '09:00', 3, 3, NULL, 1, NULL),
(32, 7, '2023-07-01', '09:00', 4, 2, NULL, 1, NULL),
(33, 8, '2023-06-15', '10:00', 1, 8, NULL, 1, NULL),
(34, 8, '2023-06-15', '10:30', 1, 7, NULL, 2, NULL),
(35, 8, '2023-06-15', '11:00', 1, 6, NULL, 3, NULL),
(36, 8, '2023-06-21', '10:00', 2, 7, NULL, 1, NULL),
(37, 8, '2023-06-21', '10:30', 2, 6, NULL, 8, NULL),
(38, 8, '2023-06-21', '11:00', 2, 5, NULL, 2, NULL),
(39, 8, '2023-06-27', '10:00', 3, 6, NULL, 1, NULL),
(40, 8, '2023-06-27', '10:30', 3, 5, NULL, 7, NULL),
(41, 8, '2023-06-27', '11:00', 3, 3, NULL, 8, NULL),
(42, 8, '2023-07-03', '10:00', 4, 5, NULL, 1, NULL),
(43, 8, '2023-07-03', '10:30', 4, 3, NULL, 6, NULL),
(44, 8, '2023-07-03', '11:00', 4, 2, NULL, 7, NULL),
(45, 8, '2023-07-09', '10:00', 5, 3, NULL, 1, NULL),
(46, 8, '2023-07-09', '10:30', 5, 2, NULL, 5, NULL),
(47, 8, '2023-07-09', '11:00', 5, 8, NULL, 6, NULL),
(48, 8, '2023-07-15', '10:00', 6, 2, NULL, 1, NULL),
(49, 8, '2023-07-15', '10:30', 6, 8, NULL, 3, NULL),
(50, 8, '2023-07-15', '11:00', 6, 7, NULL, 5, NULL),
(51, 8, '2023-07-21', '10:00', 7, 8, NULL, 1, NULL),
(52, 8, '2023-07-21', '10:30', 7, 7, NULL, 2, NULL),
(53, 8, '2023-07-21', '11:00', 7, 6, NULL, 3, NULL),
(54, 8, '2023-07-27', '10:00', 8, 7, NULL, 1, NULL),
(55, 8, '2023-07-27', '10:30', 8, 6, NULL, 8, NULL),
(56, 8, '2023-07-27', '11:00', 8, 5, NULL, 2, NULL),
(57, 8, '2023-08-02', '10:00', 9, 6, NULL, 1, NULL),
(58, 8, '2023-08-02', '10:30', 9, 5, NULL, 7, NULL),
(59, 8, '2023-08-02', '11:00', 9, 3, NULL, 8, NULL),
(60, 8, '2023-08-08', '10:00', 10, 5, NULL, 1, NULL),
(61, 8, '2023-08-08', '10:30', 10, 3, NULL, 6, NULL),
(62, 8, '2023-08-08', '11:00', 10, 2, NULL, 7, NULL),
(63, 8, '2023-08-14', '10:00', 11, 3, NULL, 1, NULL),
(64, 8, '2023-08-14', '10:30', 11, 2, NULL, 5, NULL),
(65, 8, '2023-08-14', '11:00', 11, 8, NULL, 6, NULL),
(66, 8, '2023-08-20', '10:00', 12, 2, NULL, 1, NULL),
(67, 8, '2023-08-20', '10:30', 12, 8, NULL, 3, NULL),
(68, 8, '2023-08-20', '11:00', 12, 7, NULL, 5, NULL),
(69, 4, '2023-06-15', '12:00', 1, 9, NULL, 1, NULL),
(70, 4, '2023-06-15', '12:30', 1, 8, NULL, 2, NULL),
(71, 4, '2023-06-15', '13:00', 1, 7, NULL, 3, NULL),
(72, 4, '2023-06-15', '13:30', 1, 6, NULL, 5, NULL),
(73, 4, '2023-06-20', '12:00', 2, 8, NULL, 1, NULL),
(74, 4, '2023-06-20', '12:30', 2, 7, NULL, 9, NULL),
(75, 4, '2023-06-20', '13:00', 2, 6, NULL, 2, NULL),
(76, 4, '2023-06-20', '13:30', 2, 5, NULL, 3, NULL),
(77, 4, '2023-06-25', '12:00', 3, 7, NULL, 1, NULL),
(78, 4, '2023-06-25', '12:30', 3, 6, NULL, 8, NULL),
(79, 4, '2023-06-25', '13:00', 3, 5, NULL, 9, NULL),
(80, 4, '2023-06-25', '13:30', 3, 3, NULL, 2, NULL),
(81, 4, '2023-06-30', '12:00', 4, 6, NULL, 1, NULL),
(82, 4, '2023-06-30', '12:30', 4, 5, NULL, 7, NULL),
(83, 4, '2023-06-30', '13:00', 4, 3, NULL, 8, NULL),
(84, 4, '2023-06-30', '13:30', 4, 2, NULL, 9, NULL),
(85, 4, '2023-07-05', '12:00', 5, 5, NULL, 1, NULL),
(86, 4, '2023-07-05', '12:30', 5, 3, NULL, 6, NULL),
(87, 4, '2023-07-05', '13:00', 5, 2, NULL, 7, NULL),
(88, 4, '2023-07-05', '13:30', 5, 9, NULL, 8, NULL),
(89, 4, '2023-07-10', '12:00', 6, 3, NULL, 1, NULL),
(90, 4, '2023-07-10', '12:30', 6, 2, NULL, 5, NULL),
(91, 4, '2023-07-10', '13:00', 6, 9, NULL, 6, NULL),
(92, 4, '2023-07-10', '13:30', 6, 8, NULL, 7, NULL),
(93, 4, '2023-07-15', '12:00', 7, 2, NULL, 1, NULL),
(94, 4, '2023-07-15', '12:30', 7, 9, NULL, 3, NULL),
(95, 4, '2023-07-15', '13:00', 7, 8, NULL, 5, NULL),
(96, 4, '2023-07-15', '13:30', 7, 7, NULL, 6, NULL),
(97, 4, '2023-07-20', '12:00', 8, 9, NULL, 1, NULL),
(98, 4, '2023-07-20', '12:30', 8, 8, NULL, 2, NULL),
(99, 4, '2023-07-20', '13:00', 8, 7, NULL, 3, NULL),
(100, 4, '2023-07-20', '13:30', 8, 6, NULL, 5, NULL),
(101, 4, '2023-07-25', '12:00', 9, 8, NULL, 1, NULL),
(102, 4, '2023-07-25', '12:30', 9, 7, NULL, 9, NULL),
(103, 4, '2023-07-25', '13:00', 9, 6, NULL, 2, NULL),
(104, 4, '2023-07-25', '13:30', 9, 5, NULL, 3, NULL),
(105, 4, '2023-07-30', '12:00', 10, 7, NULL, 1, NULL),
(106, 4, '2023-07-30', '12:30', 10, 6, NULL, 8, NULL),
(107, 4, '2023-07-30', '13:00', 10, 5, NULL, 9, NULL),
(108, 4, '2023-07-30', '13:30', 10, 3, NULL, 2, NULL),
(109, 4, '2023-08-04', '12:00', 11, 6, NULL, 1, NULL),
(110, 4, '2023-08-04', '12:30', 11, 5, NULL, 7, NULL),
(111, 4, '2023-08-04', '13:00', 11, 3, NULL, 8, NULL),
(112, 4, '2023-08-04', '13:30', 11, 2, NULL, 9, NULL),
(113, 4, '2023-08-09', '12:00', 12, 5, NULL, 1, NULL),
(114, 4, '2023-08-09', '12:30', 12, 3, NULL, 6, NULL),
(115, 4, '2023-08-09', '13:00', 12, 2, NULL, 7, NULL),
(116, 4, '2023-08-09', '13:30', 12, 9, NULL, 8, NULL),
(117, 4, '2023-08-14', '12:00', 13, 3, NULL, 1, NULL),
(118, 4, '2023-08-14', '12:30', 13, 2, NULL, 5, NULL),
(119, 4, '2023-08-14', '13:00', 13, 9, NULL, 6, NULL),
(120, 4, '2023-08-14', '13:30', 13, 8, NULL, 7, NULL),
(121, 4, '2023-08-19', '12:00', 14, 2, NULL, 1, NULL),
(122, 4, '2023-08-19', '12:30', 14, 9, NULL, 3, NULL),
(123, 4, '2023-08-19', '13:00', 14, 8, NULL, 5, NULL),
(124, 4, '2023-08-19', '13:30', 14, 7, NULL, 6, NULL),
(125, 2, '2023-06-17', '12:00', 1, 10, NULL, 1, NULL),
(126, 2, '2023-06-17', '13:40', 1, 9, NULL, 2, NULL),
(127, 2, '2023-06-17', '15:20', 1, 8, NULL, 3, NULL),
(128, 2, '2023-06-17', '17:00', 1, 7, NULL, 5, NULL),
(129, 2, '2023-06-22', '12:00', 2, 9, NULL, 1, NULL),
(130, 2, '2023-06-22', '13:40', 2, 8, NULL, 10, NULL),
(131, 2, '2023-06-22', '15:20', 2, 7, NULL, 2, NULL),
(132, 2, '2023-06-22', '17:00', 2, 6, NULL, 3, NULL),
(133, 2, '2023-06-27', '12:00', 3, 8, NULL, 1, NULL),
(134, 2, '2023-06-27', '13:40', 3, 7, NULL, 9, NULL),
(135, 2, '2023-06-27', '15:20', 3, 6, NULL, 10, NULL),
(136, 2, '2023-06-27', '17:00', 3, 5, NULL, 2, NULL),
(137, 2, '2023-07-02', '12:00', 4, 7, NULL, 1, NULL),
(138, 2, '2023-07-02', '13:40', 4, 6, NULL, 8, NULL),
(139, 2, '2023-07-02', '15:20', 4, 5, NULL, 9, NULL),
(140, 2, '2023-07-02', '17:00', 4, 3, NULL, 10, NULL),
(141, 2, '2023-07-07', '12:00', 5, 6, NULL, 1, NULL),
(142, 2, '2023-07-07', '13:40', 5, 5, NULL, 7, NULL),
(143, 2, '2023-07-07', '15:20', 5, 3, NULL, 8, NULL),
(144, 2, '2023-07-07', '17:00', 5, 2, NULL, 9, NULL),
(145, 2, '2023-07-12', '12:00', 6, 5, NULL, 1, NULL),
(146, 2, '2023-07-12', '13:40', 6, 3, NULL, 6, NULL),
(147, 2, '2023-07-12', '15:20', 6, 2, NULL, 7, NULL),
(148, 2, '2023-07-12', '17:00', 6, 10, NULL, 8, NULL),
(149, 2, '2023-07-17', '12:00', 7, 3, NULL, 1, NULL),
(150, 2, '2023-07-17', '13:40', 7, 2, NULL, 5, NULL),
(151, 2, '2023-07-17', '15:20', 7, 10, NULL, 6, NULL),
(152, 2, '2023-07-17', '17:00', 7, 9, NULL, 7, NULL),
(153, 2, '2023-07-22', '12:00', 8, 2, NULL, 1, NULL),
(154, 2, '2023-07-22', '13:40', 8, 10, NULL, 3, NULL),
(155, 2, '2023-07-22', '15:20', 8, 9, NULL, 5, NULL),
(156, 2, '2023-07-22', '17:00', 8, 8, NULL, 6, NULL),
(157, 2, '2023-07-27', '12:00', 9, 10, NULL, 1, NULL),
(158, 2, '2023-07-27', '13:40', 9, 9, NULL, 2, NULL),
(159, 2, '2023-07-27', '15:20', 9, 8, NULL, 3, NULL),
(160, 2, '2023-07-27', '17:00', 9, 7, NULL, 5, NULL),
(161, 2, '2023-08-01', '12:00', 10, 9, NULL, 1, NULL),
(162, 2, '2023-08-01', '13:40', 10, 8, NULL, 10, NULL),
(163, 2, '2023-08-01', '15:20', 10, 7, NULL, 2, NULL),
(164, 2, '2023-08-01', '17:00', 10, 6, NULL, 3, NULL),
(165, 2, '2023-08-06', '12:00', 11, 8, NULL, 1, NULL),
(166, 2, '2023-08-06', '13:40', 11, 7, NULL, 9, NULL),
(167, 2, '2023-08-06', '15:20', 11, 6, NULL, 10, NULL),
(168, 2, '2023-08-06', '17:00', 11, 5, NULL, 2, NULL),
(169, 2, '2023-08-11', '12:00', 12, 7, NULL, 1, NULL),
(170, 2, '2023-08-11', '13:40', 12, 6, NULL, 8, NULL),
(171, 2, '2023-08-11', '15:20', 12, 5, NULL, 9, NULL),
(172, 2, '2023-08-11', '17:00', 12, 3, NULL, 10, NULL),
(173, 2, '2023-08-16', '12:00', 13, 6, NULL, 1, NULL),
(174, 2, '2023-08-16', '13:40', 13, 5, NULL, 7, NULL),
(175, 2, '2023-08-16', '15:20', 13, 3, NULL, 8, NULL),
(176, 2, '2023-08-16', '17:00', 13, 2, NULL, 9, NULL),
(177, 2, '2023-08-21', '12:00', 14, 5, NULL, 1, NULL),
(178, 2, '2023-08-21', '13:40', 14, 3, NULL, 6, NULL),
(179, 2, '2023-08-21', '15:20', 14, 2, NULL, 7, NULL),
(180, 2, '2023-08-21', '17:00', 14, 10, NULL, 8, NULL),
(181, 2, '2023-08-26', '12:00', 15, 3, NULL, 1, NULL),
(182, 2, '2023-08-26', '13:40', 15, 2, NULL, 5, NULL),
(183, 2, '2023-08-26', '15:20', 15, 10, NULL, 6, NULL),
(184, 2, '2023-08-26', '17:00', 15, 9, NULL, 7, NULL),
(185, 2, '2023-08-31', '12:00', 16, 2, NULL, 1, NULL),
(186, 2, '2023-08-31', '13:40', 16, 10, NULL, 3, NULL),
(187, 2, '2023-08-31', '15:20', 16, 9, NULL, 5, NULL),
(188, 2, '2023-08-31', '17:00', 16, 8, NULL, 6, NULL),
(189, 6, '2023-06-15', '05:00', 1, 5, NULL, 1, NULL),
(190, 6, '2023-06-15', '05:15', 1, 3, NULL, 2, NULL),
(191, 6, '2023-06-22', '05:00', 2, 3, NULL, 1, NULL),
(192, 6, '2023-06-22', '05:15', 2, 2, NULL, 5, NULL),
(193, 6, '2023-06-29', '05:00', 3, 2, NULL, 1, NULL),
(194, 6, '2023-06-29', '05:15', 3, 5, NULL, 3, NULL),
(195, 6, '2023-07-06', '05:00', 4, 5, NULL, 1, NULL),
(196, 6, '2023-07-06', '05:15', 4, 3, NULL, 2, NULL),
(197, 6, '2023-07-13', '05:00', 5, 3, NULL, 1, NULL),
(198, 6, '2023-07-13', '05:15', 5, 2, NULL, 5, NULL),
(199, 6, '2023-07-20', '05:00', 6, 2, NULL, 1, NULL),
(200, 6, '2023-07-20', '05:15', 6, 5, NULL, 3, NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `resultadostorneo`
--

CREATE TABLE `resultadostorneo` (
  `id` int(11) NOT NULL,
  `torneo` int(11) DEFAULT NULL,
  `fJugada` date DEFAULT NULL,
  `hJugada` varchar(5) DEFAULT NULL,
  `ronda` int(11) DEFAULT NULL,
  `equipoLocal` int(11) DEFAULT NULL,
  `ptosLocal` int(11) DEFAULT NULL,
  `equipoVisitante` int(11) DEFAULT NULL,
  `ptosVisitante` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `resultadostorneo`
--

INSERT INTO `resultadostorneo` (`id`, `torneo`, `fJugada`, `hJugada`, `ronda`, `equipoLocal`, `ptosLocal`, `equipoVisitante`, `ptosVisitante`) VALUES
(1, 8, NULL, NULL, 1, 6, NULL, 5, NULL),
(2, 8, NULL, NULL, 1, 3, NULL, 2, NULL),
(3, 8, NULL, NULL, 1, 1, NULL, NULL, NULL),
(4, 8, NULL, NULL, 1, NULL, NULL, NULL, NULL),
(5, 8, NULL, NULL, 2, NULL, NULL, NULL, NULL),
(6, 8, NULL, NULL, 2, NULL, NULL, NULL, NULL),
(7, 8, NULL, NULL, 3, NULL, NULL, NULL, NULL),
(8, 1, NULL, NULL, 1, 9, NULL, 8, NULL),
(9, 1, NULL, NULL, 1, 7, NULL, 6, NULL),
(10, 1, NULL, NULL, 1, 5, NULL, 3, NULL),
(11, 1, NULL, NULL, 1, 2, NULL, 1, NULL),
(12, 1, NULL, NULL, 2, NULL, NULL, NULL, NULL),
(13, 1, NULL, NULL, 2, NULL, NULL, NULL, NULL),
(14, 1, NULL, NULL, 3, NULL, NULL, NULL, NULL),
(15, 2, NULL, NULL, 1, 8, NULL, 7, NULL),
(16, 2, NULL, NULL, 1, 6, NULL, 5, NULL),
(17, 2, NULL, NULL, 1, 3, NULL, 2, NULL),
(18, 2, NULL, NULL, 1, 1, NULL, NULL, NULL),
(19, 2, NULL, NULL, 2, NULL, NULL, NULL, NULL),
(20, 2, NULL, NULL, 2, NULL, NULL, NULL, NULL),
(21, 2, NULL, NULL, 3, NULL, NULL, NULL, NULL),
(22, 7, NULL, NULL, 1, 7, NULL, 6, NULL),
(23, 7, NULL, NULL, 1, 5, NULL, 3, NULL),
(24, 7, NULL, NULL, 1, 2, NULL, 1, NULL),
(25, 7, NULL, NULL, 1, NULL, NULL, NULL, NULL),
(26, 7, NULL, NULL, 2, NULL, NULL, NULL, NULL),
(27, 7, NULL, NULL, 2, NULL, NULL, NULL, NULL),
(28, 7, NULL, NULL, 3, NULL, NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `rol`
--

CREATE TABLE `rol` (
  `id` int(11) NOT NULL,
  `nombre` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `rol`
--

INSERT INTO `rol` (`id`, `nombre`) VALUES
(1, 'Administrador'),
(2, 'Organizador'),
(3, 'Usuario');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `rolasociado`
--

CREATE TABLE `rolasociado` (
  `rol` int(11) NOT NULL,
  `usuario` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `rolasociado`
--

INSERT INTO `rolasociado` (`rol`, `usuario`) VALUES
(1, 1),
(2, 1),
(2, 2),
(2, 3),
(3, 4),
(3, 6),
(3, 7),
(3, 8),
(3, 9),
(3, 10),
(3, 11),
(3, 12),
(3, 13),
(3, 14),
(3, 15),
(3, 16),
(3, 17),
(3, 18),
(3, 19),
(3, 20),
(3, 21),
(3, 22),
(3, 23),
(3, 24);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `torneo`
--

CREATE TABLE `torneo` (
  `id` int(11) NOT NULL,
  `nombre` varchar(50) DEFAULT NULL,
  `ubicacion` varchar(500) DEFAULT NULL,
  `fInicio` date DEFAULT NULL,
  `hInicio` varchar(5) DEFAULT NULL,
  `fLimite` date DEFAULT NULL,
  `hLimite` varchar(5) DEFAULT NULL,
  `minEquipos` int(11) DEFAULT NULL,
  `maxEquipos` int(11) DEFAULT NULL,
  `coste` double(5,2) DEFAULT NULL,
  `organizador` int(11) DEFAULT NULL,
  `deporte` int(11) DEFAULT NULL,
  `enfrentamientosGenerados` tinyint(1) DEFAULT NULL,
  `estado` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `torneo`
--

INSERT INTO `torneo` (`id`, `nombre`, `ubicacion`, `fInicio`, `hInicio`, `fLimite`, `hLimite`, `minEquipos`, `maxEquipos`, `coste`, `organizador`, `deporte`, `enfrentamientosGenerados`, `estado`) VALUES
(1, 'Torneo8', '36.6236874,-6.3601441', '2023-06-17', '12:00', '2023-06-14', '00:00', 5, 8, 0.00, 2, 5, 1, 1),
(2, 'Torneo7', '36.620664,-6.366986', '2023-06-17', '00:00', '2023-06-14', '00:00', 6, 8, 4.00, 2, 5, 1, 1),
(3, 'Torneo4', '36.6254949,-6.3362333', '2023-06-20', '18:00', '2023-06-17', '15:00', 3, 4, 4.00, 2, 5, 0, 2),
(4, 'Torneo3', '36.6291427,-6.3691728', '2023-06-16', '12:30', '2023-06-14', '20:00', 3, 4, 0.00, 2, 5, 0, 3),
(5, 'Torneo5a', '36.7348614,-6.431699000000001', '2023-06-16', '14:30', '2023-06-14', '20:00', 5, 8, 9.00, 2, 5, 0, 3),
(6, 'Torneo7a', '36.6268821,-6.3522599', '2023-06-19', '15:00', '2023-06-16', '19:00', 7, 8, 12.00, 2, 5, 0, 2),
(7, 'Torneo6', '36.502601,-6.2729285', '2023-06-16', '17:00', '2023-06-14', '17:00', 6, 8, 0.00, 3, 5, 1, 1),
(8, 'Torneo5', '36.6236874,-6.3601441', '2023-06-16', '17:00', '2023-06-14', '20:00', 5, 8, 0.00, 3, 5, 1, 1),
(9, 'Torneo3a', '36.526602,-6.2878078', '2023-06-15', '17:00', '2023-06-14', '20:00', 3, 4, 0.00, 3, 5, 0, 3),
(10, 'Torneo7a', '36.8394942,-5.3919919', '2023-06-16', '21:00', '2023-06-14', '20:00', 7, 8, 0.00, 3, 1, 0, 3),
(11, 'Torneo8a', '36.1407591,-5.456233', '2023-06-17', '13:00', '2023-06-16', '20:00', 7, 8, 0.00, 3, 5, 0, 2),
(12, 'Torneo7a', '36.8394942,-5.3919919', '2023-06-16', '20:00', '2023-06-14', '20:00', 7, 8, 0.00, 3, 5, 0, 3),
(13, 'TorneoPaBorrar', '40.4167754,-3.7037902', '2023-06-30', '00:00', '2023-06-16', '00:00', 3, 4, 0.00, 3, 1, 0, 2),
(14, 'Cancelarce', '36.6236874,-6.3601441', '2023-06-16', '00:00', '2023-06-14', '19:50', 3, 4, 0.00, 2, 1, 0, 3);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuario`
--

CREATE TABLE `usuario` (
  `id` int(11) NOT NULL,
  `nombre` varchar(50) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `passwd` varchar(200) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `usuario`
--

INSERT INTO `usuario` (`id`, `nombre`, `email`, `passwd`) VALUES
(1, 'admin', 'admin@admin.com', 'c7ad44cbad762a5da0a452f9e854fdc1e0e7a52a38015f23f3eab1d80b931dd472634dfac71cd34ebc35d16ab7fb8a90c81f975113d6c7538dc69dd8de9077ec'),
(2, 'Cliente1', 'cliente1@gmail.es', '3c9909afec25354d551dae21590bb26e38d53f2173b8d3dc3eee4c047e7ab1c1eb8b85103e3be7ba613b31bb5c9c36214dc9f14a42fd7a2fdb84856bca5c44c2'),
(3, 'Cliente2', 'Cliente2@gmail.com', '3c9909afec25354d551dae21590bb26e38d53f2173b8d3dc3eee4c047e7ab1c1eb8b85103e3be7ba613b31bb5c9c36214dc9f14a42fd7a2fdb84856bca5c44c2'),
(4, 'movil1', 'movil1@gmail.com', '3c9909afec25354d551dae21590bb26e38d53f2173b8d3dc3eee4c047e7ab1c1eb8b85103e3be7ba613b31bb5c9c36214dc9f14a42fd7a2fdb84856bca5c44c2'),
(6, 'movil2', 'movil2@gmail.com', '3c9909afec25354d551dae21590bb26e38d53f2173b8d3dc3eee4c047e7ab1c1eb8b85103e3be7ba613b31bb5c9c36214dc9f14a42fd7a2fdb84856bca5c44c2'),
(7, 'movil3', 'movil3@gmail.com', '3c9909afec25354d551dae21590bb26e38d53f2173b8d3dc3eee4c047e7ab1c1eb8b85103e3be7ba613b31bb5c9c36214dc9f14a42fd7a2fdb84856bca5c44c2'),
(8, 'movil4', 'movil4@gmail.com', '3c9909afec25354d551dae21590bb26e38d53f2173b8d3dc3eee4c047e7ab1c1eb8b85103e3be7ba613b31bb5c9c36214dc9f14a42fd7a2fdb84856bca5c44c2'),
(9, 'movil5', 'movil5@gmail.com', '3c9909afec25354d551dae21590bb26e38d53f2173b8d3dc3eee4c047e7ab1c1eb8b85103e3be7ba613b31bb5c9c36214dc9f14a42fd7a2fdb84856bca5c44c2'),
(10, 'movil6', 'movil6@gmail.com', '3c9909afec25354d551dae21590bb26e38d53f2173b8d3dc3eee4c047e7ab1c1eb8b85103e3be7ba613b31bb5c9c36214dc9f14a42fd7a2fdb84856bca5c44c2'),
(11, 'movil7', 'movil7@gmail.com', '3c9909afec25354d551dae21590bb26e38d53f2173b8d3dc3eee4c047e7ab1c1eb8b85103e3be7ba613b31bb5c9c36214dc9f14a42fd7a2fdb84856bca5c44c2'),
(12, 'movil8', 'movil8@gmail.com', '3c9909afec25354d551dae21590bb26e38d53f2173b8d3dc3eee4c047e7ab1c1eb8b85103e3be7ba613b31bb5c9c36214dc9f14a42fd7a2fdb84856bca5c44c2'),
(13, 'movil9', 'movil9@gmail.com', '3c9909afec25354d551dae21590bb26e38d53f2173b8d3dc3eee4c047e7ab1c1eb8b85103e3be7ba613b31bb5c9c36214dc9f14a42fd7a2fdb84856bca5c44c2'),
(14, 'movil10', 'movil10@gmail.com', '3c9909afec25354d551dae21590bb26e38d53f2173b8d3dc3eee4c047e7ab1c1eb8b85103e3be7ba613b31bb5c9c36214dc9f14a42fd7a2fdb84856bca5c44c2'),
(15, 'movil11', 'movil11@gmail.com', '3c9909afec25354d551dae21590bb26e38d53f2173b8d3dc3eee4c047e7ab1c1eb8b85103e3be7ba613b31bb5c9c36214dc9f14a42fd7a2fdb84856bca5c44c2'),
(16, 'movil12', 'movil12@gmail.com', '3c9909afec25354d551dae21590bb26e38d53f2173b8d3dc3eee4c047e7ab1c1eb8b85103e3be7ba613b31bb5c9c36214dc9f14a42fd7a2fdb84856bca5c44c2'),
(17, 'movil13', 'movil13@gmail.com', '3c9909afec25354d551dae21590bb26e38d53f2173b8d3dc3eee4c047e7ab1c1eb8b85103e3be7ba613b31bb5c9c36214dc9f14a42fd7a2fdb84856bca5c44c2'),
(18, 'movil14', 'movil14@gmail.com', '3c9909afec25354d551dae21590bb26e38d53f2173b8d3dc3eee4c047e7ab1c1eb8b85103e3be7ba613b31bb5c9c36214dc9f14a42fd7a2fdb84856bca5c44c2'),
(19, 'movil15', 'movil15@gmail.com', '3c9909afec25354d551dae21590bb26e38d53f2173b8d3dc3eee4c047e7ab1c1eb8b85103e3be7ba613b31bb5c9c36214dc9f14a42fd7a2fdb84856bca5c44c2'),
(20, 'movil16', 'movil16@gmail.com', '3c9909afec25354d551dae21590bb26e38d53f2173b8d3dc3eee4c047e7ab1c1eb8b85103e3be7ba613b31bb5c9c36214dc9f14a42fd7a2fdb84856bca5c44c2'),
(21, 'movil17', 'movil17@gmail.com', '3c9909afec25354d551dae21590bb26e38d53f2173b8d3dc3eee4c047e7ab1c1eb8b85103e3be7ba613b31bb5c9c36214dc9f14a42fd7a2fdb84856bca5c44c2'),
(22, 'movil18', 'movil18@gmail.com', '3c9909afec25354d551dae21590bb26e38d53f2173b8d3dc3eee4c047e7ab1c1eb8b85103e3be7ba613b31bb5c9c36214dc9f14a42fd7a2fdb84856bca5c44c2'),
(23, 'movil19', 'movil19@gmail.com', '3c9909afec25354d551dae21590bb26e38d53f2173b8d3dc3eee4c047e7ab1c1eb8b85103e3be7ba613b31bb5c9c36214dc9f14a42fd7a2fdb84856bca5c44c2'),
(24, 'movil20', 'movil20@gmail.com', '3c9909afec25354d551dae21590bb26e38d53f2173b8d3dc3eee4c047e7ab1c1eb8b85103e3be7ba613b31bb5c9c36214dc9f14a42fd7a2fdb84856bca5c44c2');

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `componenteequipo`
--
ALTER TABLE `componenteequipo`
  ADD PRIMARY KEY (`equipo`,`usuario`),
  ADD KEY `pcompo_usua_FK` (`usuario`);

--
-- Indices de la tabla `deporte`
--
ALTER TABLE `deporte`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `equipo`
--
ALTER TABLE `equipo`
  ADD PRIMARY KEY (`id`),
  ADD KEY `equip_lid_FK` (`lider`),
  ADD KEY `equip_dep_FK` (`deporte`),
  ADD KEY `equip_priv_FK` (`privacidad`);

--
-- Indices de la tabla `estado`
--
ALTER TABLE `estado`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `inscrippcionliga`
--
ALTER TABLE `inscrippcionliga`
  ADD PRIMARY KEY (`liga`,`equipo`),
  ADD KEY `insLig_equip_FK` (`equipo`),
  ADD KEY `insLig_pag_FK` (`pago`);

--
-- Indices de la tabla `inscrippciontorneo`
--
ALTER TABLE `inscrippciontorneo`
  ADD PRIMARY KEY (`torneo`,`equipo`),
  ADD KEY `insTor_equip_FK` (`equipo`),
  ADD KEY `insTor_pag_FK` (`pago`);

--
-- Indices de la tabla `invitacionequipousuario`
--
ALTER TABLE `invitacionequipousuario`
  ADD PRIMARY KEY (`id`),
  ADD KEY `invEquUsu_equip_FK` (`equipo`),
  ADD KEY `invEquUsu_usua_FK` (`usuario`),
  ADD KEY `invEquUsu_est_FK` (`estado`);

--
-- Indices de la tabla `invitacionusuarioequipo`
--
ALTER TABLE `invitacionusuarioequipo`
  ADD PRIMARY KEY (`id`),
  ADD KEY `invUsuEqu_equip_FK` (`equipo`),
  ADD KEY `invUsuEqu_usua_FK` (`usuario`),
  ADD KEY `invUsuEqu_est_FK` (`estado`);

--
-- Indices de la tabla `liga`
--
ALTER TABLE `liga`
  ADD PRIMARY KEY (`id`),
  ADD KEY `lig_usua_FK` (`organizador`),
  ADD KEY `lig_dept_FK` (`deporte`),
  ADD KEY `lig_est_FK` (`estado`);

--
-- Indices de la tabla `pago`
--
ALTER TABLE `pago`
  ADD PRIMARY KEY (`id`),
  ADD KEY `pag_usua_FK` (`usuario`);

--
-- Indices de la tabla `participar`
--
ALTER TABLE `participar`
  ADD PRIMARY KEY (`partido`,`usuario`),
  ADD KEY `partic_usua_FK` (`usuario`),
  ADD KEY `partic_pag_FK` (`pago`);

--
-- Indices de la tabla `partido`
--
ALTER TABLE `partido`
  ADD PRIMARY KEY (`id`),
  ADD KEY `par_usua_FK` (`creador`),
  ADD KEY `par_dept_FK` (`deporte`),
  ADD KEY `part_est_FK` (`estado`);

--
-- Indices de la tabla `peticion`
--
ALTER TABLE `peticion`
  ADD PRIMARY KEY (`id`),
  ADD KEY `pet_usua_FK` (`usuario`),
  ADD KEY `pet_est_FK` (`estado`);

--
-- Indices de la tabla `privacidad`
--
ALTER TABLE `privacidad`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `resultadosliga`
--
ALTER TABLE `resultadosliga`
  ADD PRIMARY KEY (`id`),
  ADD KEY `resLig_liga_FK` (`liga`),
  ADD KEY `resLig_loc_FK` (`equipoLocal`),
  ADD KEY `resLig_vis_FK` (`equipoVisitante`);

--
-- Indices de la tabla `resultadostorneo`
--
ALTER TABLE `resultadostorneo`
  ADD PRIMARY KEY (`id`),
  ADD KEY `resTor_torn_FK` (`torneo`),
  ADD KEY `resTor_loc_FK` (`equipoLocal`),
  ADD KEY `resTor_vis_FK` (`equipoVisitante`);

--
-- Indices de la tabla `rol`
--
ALTER TABLE `rol`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `rolasociado`
--
ALTER TABLE `rolasociado`
  ADD PRIMARY KEY (`rol`,`usuario`),
  ADD KEY `rolAso_usua_FK` (`usuario`);

--
-- Indices de la tabla `torneo`
--
ALTER TABLE `torneo`
  ADD PRIMARY KEY (`id`),
  ADD KEY `tor_usua_FK` (`organizador`),
  ADD KEY `tor_dept_FK` (`deporte`),
  ADD KEY `tor_est_FK` (`estado`);

--
-- Indices de la tabla `usuario`
--
ALTER TABLE `usuario`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `nombre` (`nombre`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `deporte`
--
ALTER TABLE `deporte`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `equipo`
--
ALTER TABLE `equipo`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT de la tabla `invitacionequipousuario`
--
ALTER TABLE `invitacionequipousuario`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `invitacionusuarioequipo`
--
ALTER TABLE `invitacionusuarioequipo`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `liga`
--
ALTER TABLE `liga`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT de la tabla `pago`
--
ALTER TABLE `pago`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `partido`
--
ALTER TABLE `partido`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `peticion`
--
ALTER TABLE `peticion`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `privacidad`
--
ALTER TABLE `privacidad`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `resultadosliga`
--
ALTER TABLE `resultadosliga`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=201;

--
-- AUTO_INCREMENT de la tabla `resultadostorneo`
--
ALTER TABLE `resultadostorneo`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=29;

--
-- AUTO_INCREMENT de la tabla `torneo`
--
ALTER TABLE `torneo`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT de la tabla `usuario`
--
ALTER TABLE `usuario`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `componenteequipo`
--
ALTER TABLE `componenteequipo`
  ADD CONSTRAINT `compo_equip_FK` FOREIGN KEY (`equipo`) REFERENCES `equipo` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `pcompo_usua_FK` FOREIGN KEY (`usuario`) REFERENCES `usuario` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `equipo`
--
ALTER TABLE `equipo`
  ADD CONSTRAINT `equip_dep_FK` FOREIGN KEY (`deporte`) REFERENCES `deporte` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `equip_lid_FK` FOREIGN KEY (`lider`) REFERENCES `usuario` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `equip_priv_FK` FOREIGN KEY (`privacidad`) REFERENCES `privacidad` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `inscrippcionliga`
--
ALTER TABLE `inscrippcionliga`
  ADD CONSTRAINT `insLig_equip_FK` FOREIGN KEY (`equipo`) REFERENCES `equipo` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `insLig_lig_FK` FOREIGN KEY (`liga`) REFERENCES `liga` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `insLig_pag_FK` FOREIGN KEY (`pago`) REFERENCES `pago` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `inscrippciontorneo`
--
ALTER TABLE `inscrippciontorneo`
  ADD CONSTRAINT `insTor_equip_FK` FOREIGN KEY (`equipo`) REFERENCES `equipo` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `insTor_pag_FK` FOREIGN KEY (`pago`) REFERENCES `pago` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `insTor_torn_FK` FOREIGN KEY (`torneo`) REFERENCES `torneo` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `invitacionequipousuario`
--
ALTER TABLE `invitacionequipousuario`
  ADD CONSTRAINT `invEquUsu_equip_FK` FOREIGN KEY (`equipo`) REFERENCES `equipo` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `invEquUsu_est_FK` FOREIGN KEY (`estado`) REFERENCES `estado` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `invEquUsu_usua_FK` FOREIGN KEY (`usuario`) REFERENCES `usuario` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `invitacionusuarioequipo`
--
ALTER TABLE `invitacionusuarioequipo`
  ADD CONSTRAINT `invUsuEqu_equip_FK` FOREIGN KEY (`equipo`) REFERENCES `equipo` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `invUsuEqu_est_FK` FOREIGN KEY (`estado`) REFERENCES `estado` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `invUsuEqu_usua_FK` FOREIGN KEY (`usuario`) REFERENCES `usuario` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `liga`
--
ALTER TABLE `liga`
  ADD CONSTRAINT `lig_dept_FK` FOREIGN KEY (`deporte`) REFERENCES `deporte` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `lig_est_FK` FOREIGN KEY (`estado`) REFERENCES `estado` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `lig_usua_FK` FOREIGN KEY (`organizador`) REFERENCES `usuario` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `pago`
--
ALTER TABLE `pago`
  ADD CONSTRAINT `pag_usua_FK` FOREIGN KEY (`usuario`) REFERENCES `usuario` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `participar`
--
ALTER TABLE `participar`
  ADD CONSTRAINT `partic_pag_FK` FOREIGN KEY (`pago`) REFERENCES `pago` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `partic_part_FK` FOREIGN KEY (`partido`) REFERENCES `partido` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `partic_usua_FK` FOREIGN KEY (`usuario`) REFERENCES `usuario` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `partido`
--
ALTER TABLE `partido`
  ADD CONSTRAINT `par_dept_FK` FOREIGN KEY (`deporte`) REFERENCES `deporte` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `par_usua_FK` FOREIGN KEY (`creador`) REFERENCES `usuario` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `part_est_FK` FOREIGN KEY (`estado`) REFERENCES `estado` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `peticion`
--
ALTER TABLE `peticion`
  ADD CONSTRAINT `pet_est_FK` FOREIGN KEY (`estado`) REFERENCES `estado` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `pet_usua_FK` FOREIGN KEY (`usuario`) REFERENCES `usuario` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `resultadosliga`
--
ALTER TABLE `resultadosliga`
  ADD CONSTRAINT `resLig_liga_FK` FOREIGN KEY (`liga`) REFERENCES `liga` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `resLig_loc_FK` FOREIGN KEY (`equipoLocal`) REFERENCES `equipo` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `resLig_vis_FK` FOREIGN KEY (`equipoVisitante`) REFERENCES `equipo` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `resultadostorneo`
--
ALTER TABLE `resultadostorneo`
  ADD CONSTRAINT `resTor_loc_FK` FOREIGN KEY (`equipoLocal`) REFERENCES `equipo` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `resTor_torn_FK` FOREIGN KEY (`torneo`) REFERENCES `torneo` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `resTor_vis_FK` FOREIGN KEY (`equipoVisitante`) REFERENCES `equipo` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `rolasociado`
--
ALTER TABLE `rolasociado`
  ADD CONSTRAINT `rolAso_rol_FK` FOREIGN KEY (`rol`) REFERENCES `rol` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `rolAso_usua_FK` FOREIGN KEY (`usuario`) REFERENCES `usuario` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `torneo`
--
ALTER TABLE `torneo`
  ADD CONSTRAINT `tor_dept_FK` FOREIGN KEY (`deporte`) REFERENCES `deporte` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `tor_est_FK` FOREIGN KEY (`estado`) REFERENCES `estado` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `tor_usua_FK` FOREIGN KEY (`organizador`) REFERENCES `usuario` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
