-- ============================================================
-- Tarea 6 - Parte #2 del Proyecto de Aula
-- SCRIPTS DE CREACIÓN y CONSULTAS DE UNA VISTA
-- ============================================================

-- Miembros del grupo:
-- Cristian Camilo Hernandez Lopez
-- Maria Ortiz Oquendo
-- Sebastian Ramirez Ramos
-- Mydshell Stephannia Usuga Arango

--
-- SCRIPT CREACIÓN DE LA VISTA
--
CREATE OR REPLACE VIEW vista_hospitalizacion_completa AS
SELECT 
    r.id_registro,
    r.fecha_ingreso,
    r.fecha_salida,
    r.motivo,
    r.tipo,

    p.id_paciente,
    p.nombre AS nombre_paciente,
    p.apellido AS apellido_paciente,
    p.sexo AS sexo_paciente,
    p.id_eps,

    m.id_medico,
    m.nombre AS nombre_medico,
    m.apellido_medico,
    m.id_hospital,

    e.id_especialidad,
    e.nombre AS nombre_especialidad,

    h.nombre_hospital,
    h.id_ubicacion,

    u.ciudad,
    u.departamento,
    u.pais,

    c.id_cama,
    c.id_habitacion
FROM registro r
JOIN paciente p        ON r.id_paciente = p.id_paciente       -- 1
JOIN medico m          ON r.id_medico = m.id_medico           -- 2
JOIN especialidad e    ON m.id_especialidad = e.id_especialidad -- 3
JOIN hospital h        ON m.id_hospital = h.id_hospital       -- 4
JOIN ubicacion u       ON h.id_ubicacion = u.id_ubicacion     -- 5
JOIN cama c            ON r.id_cama = c.id_cama;              -- 6

--
-- SCRIPT DE CONSULTAS UTILIZANDO LA VISTA
--

-- ============================================================
-- Consulta 1 
-- Cantidad de hospitalizaciones por hospital
-- ============================================================
SELECT nombre_hospital, COUNT(id_registro) AS total_hospitalizaciones
FROM vista_hospitalizacion_completa
GROUP BY nombre_hospital
ORDER BY total_hospitalizaciones DESC;

-- ============================================================
-- Consulta 2
-- Número de pacientes atendidos por cada especialidad
-- ============================================================
SELECT nombre_especialidad, COUNT(DISTINCT id_paciente) AS pacientes_atendidos
FROM vista_hospitalizacion_completa
GROUP BY nombre_especialidad
ORDER BY pacientes_atendidos DESC;

-- ============================================================
-- Consulta 3
-- Cama más utilizada
-- ============================================================
SELECT id_cama, COUNT(id_registro) AS veces_usada
FROM vista_hospitalizacion_completa
GROUP BY id_cama
ORDER BY veces_usada DESC
LIMIT 1;

-- ============================================================
-- Consulta 4
-- Hospitalizaciones por departamento
-- ============================================================
SELECT departamento, COUNT(id_registro) AS total_casos
FROM vista_hospitalizacion_completa
GROUP BY departamento
ORDER BY total_casos DESC;

-- ============================================================
-- Consulta 5
-- Duración máxima, mínima y promedio de hospitalización
-- ============================================================
SELECT 
    MAX(fecha_salida - fecha_ingreso) AS max_dias,
    MIN(fecha_salida - fecha_ingreso) AS min_dias,
    AVG(fecha_salida - fecha_ingreso) AS promedio_dias
FROM vista_hospitalizacion_completa;