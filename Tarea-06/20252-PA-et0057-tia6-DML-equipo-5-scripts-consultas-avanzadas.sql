-- ============================================================
-- Tarea 6 - Parte #2 del Proyecto de Aula
-- SCRIPTS DE CONSULTAS AVANZADAS (SELECT con JOIN)
-- ============================================================

-- Miembros del grupo:
-- Cristian Camilo Hernandez Lopez
-- Maria Ortiz Oquendo
-- Sebastian Ramirez Ramos
-- Mydshell Stephannia Usuga Arango

--
-- CONSULTAS AVANZADAS
--

-- ============================================================
-- Consulta 1 
-- Pacientes con su EPS correspondiente
-- ============================================================
SELECT p.id_paciente, p.nombre, p.apellido, e.nombre AS nombre_eps
FROM paciente p
JOIN eps e ON p.id_eps = e.id_eps
ORDER BY p.apellido ASC;

-- ============================================================
-- Consulta 2 
-- Médicos con el hospital donde trabajan
-- ============================================================
SELECT m.id_medico, m.nombre, m.apellido_medico, h.nombre_hospital
FROM medico m
JOIN hospital h ON m.id_hospital = h.id_hospital
ORDER BY m.nombre ASC;

-- ============================================================
-- Consulta 3 
-- Cantidad de registros por médico
-- ============================================================
SELECT m.id_medico, m.nombre, COUNT(r.id_registro) AS total_registros
FROM medico m
JOIN registro r ON m.id_medico = r.id_medico
GROUP BY m.id_medico, m.nombre
ORDER BY total_registros DESC;

-- ============================================================
-- Consulta 4 
-- Registros con paciente y médico relacionado
-- ============================================================
SELECT r.id_registro, p.nombre AS paciente, m.nombre AS medico, r.tipo
FROM registro r
JOIN paciente p ON r.id_paciente = p.id_paciente
JOIN medico m   ON r.id_medico = m.id_medico
ORDER BY r.id_registro ASC;

-- ============================================================
-- Consulta 5 
-- Mayor número de cama utilizado por hospital
-- ============================================================
SELECT h.id_hospital, h.nombre_hospital,
       MAX(CAST(RIGHT(r.id_cama, 3) AS INTEGER)) AS cama_maxima
FROM hospital h
JOIN medico m   ON h.id_hospital = m.id_hospital
JOIN registro r ON m.id_medico = r.id_medico
GROUP BY h.id_hospital, h.nombre_hospital
ORDER BY cama_maxima DESC;

-- ============================================================
-- Consulta 6 
-- Menor número de cama por médico
-- ============================================================
SELECT m.id_medico, m.nombre,
       MIN(CAST(RIGHT(r.id_cama, 3) AS INTEGER)) AS cama_minima
FROM medico m
JOIN registro r ON m.id_medico = r.id_medico
GROUP BY m.id_medico, m.nombre
ORDER BY cama_minima ASC;

-- ============================================================
-- Consulta 7 
-- Registros con paciente + médico + hospital
-- ============================================================
SELECT r.id_registro, p.nombre AS paciente, m.nombre AS medico, h.nombre_hospital
FROM registro r
JOIN paciente p ON r.id_paciente = p.id_paciente
JOIN medico m   ON r.id_medico = m.id_medico
JOIN hospital h ON m.id_hospital = h.id_hospital
ORDER BY p.nombre ASC;

-- ============================================================
-- Consulta 8 
-- Promedio de número de cama por hospital
-- ============================================================
SELECT h.id_hospital, h.nombre_hospital,
       AVG(CAST(RIGHT(r.id_cama, 3) AS INTEGER)) AS promedio_camas
FROM hospital h
JOIN medico m   ON h.id_hospital = m.id_hospital
JOIN registro r ON m.id_medico = r.id_medico
GROUP BY h.id_hospital, h.nombre_hospital
ORDER BY promedio_camas ASC;

-- ============================================================
-- Consulta 9 
-- Paciente → Registro → Médico → Hospital → Especialidad
-- ============================================================
SELECT p.id_paciente, p.nombre AS paciente,
       r.id_registro, m.nombre AS medico,
       h.nombre_hospital, e.nombre AS especialidad
FROM paciente p
JOIN registro r     ON p.id_paciente = r.id_paciente
JOIN medico m       ON r.id_medico = m.id_medico
JOIN hospital h     ON m.id_hospital = h.id_hospital
JOIN especialidad e ON m.id_especialidad = e.id_especialidad
ORDER BY p.apellido ASC;

-- ============================================================
-- Consulta 10 
-- Sumar camas utilizadas por cada paciente 
-- ============================================================
SELECT p.id_paciente, p.nombre,
       SUM(CAST(RIGHT(r.id_cama, 3) AS INTEGER)) AS suma_camas
FROM paciente p
JOIN registro r        ON p.id_paciente = r.id_paciente
JOIN medico m          ON r.id_medico = m.id_medico
JOIN hospital h        ON m.id_hospital = h.id_hospital
JOIN especialidad e    ON m.id_especialidad = e.id_especialidad
JOIN eps ep            ON p.id_eps = ep.id_eps
GROUP BY p.id_paciente, p.nombre
ORDER BY suma_camas DESC;

-- ============================================================
-- FIN DEL ARCHIVO
-- ============================================================
