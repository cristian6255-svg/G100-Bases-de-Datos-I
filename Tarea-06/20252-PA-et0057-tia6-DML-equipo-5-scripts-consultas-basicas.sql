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
-- CONSULTAS BÁSICAS
--

-- ============================================================
-- Consulta 1
-- Listar todos los pacientes ordenados alfabéticamente
-- ============================================================
SELECT id_paciente, nombre, apellido, ciudad_origen
FROM paciente
ORDER BY apellido ASC;


-- ============================================================
-- Consulta 2 
-- Mostrar médicos ordenados por nombre
-- ============================================================
SELECT id_medico, nombre, apellido_medico, licencia
FROM medico
ORDER BY nombre ASC;


-- ============================================================
-- Consulta 3 
-- Mostrar todas las especialidades ordenadas por nombre
-- ============================================================
SELECT id_especialidad, nombre, descripcion
FROM especialidad
ORDER BY nombre ASC;


-- ============================================================
-- Consulta 4 
-- Contar cuántos pacientes hay registrados
-- ============================================================
SELECT COUNT(id_paciente) AS total_pacientes
FROM paciente
ORDER BY total_pacientes ASC;


-- ============================================================
-- Consulta 5 
-- Obtener la mayor cantidad de plantas entre los hospitales
-- ============================================================
SELECT MAX(nivel_planta) AS nivel_maximo
FROM hospital
ORDER BY nivel_maximo ASC;


-- ============================================================
-- Consulta 6 
-- Obtener la menor cantidad de plantas entre los hospitales
-- ============================================================
SELECT MIN(nivel_planta) AS nivel_minimo
FROM hospital
ORDER BY nivel_minimo ASC;


-- ============================================================
-- Consulta 7 
-- Promedio del número de cama 
-- ============================================================
SELECT AVG(CAST(RIGHT(id_cama, 3) AS INTEGER)) AS promedio_camas
FROM registro
ORDER BY promedio_camas ASC;


-- ============================================================
-- Consulta 8 
-- Suma total del número de cama 
-- ============================================================
SELECT SUM(CAST(RIGHT(id_cama, 3) AS INTEGER)) AS total_camas_asignadas
FROM registro
ORDER BY total_camas_asignadas ASC;


-- ============================================================
-- Consulta 9 
-- Mostrar todas las enfermeras ordenadas por apellido
-- ============================================================
SELECT id_enfermera, nombre, apellido, sexo
FROM enfermera
ORDER BY apellido ASC;


-- ============================================================
-- Consulta 10 
-- Registros de hospitalización ordenados por fecha de salida
-- ============================================================
SELECT id_registro, id_paciente, id_medico, fecha_ingreso, fecha_salida, tipo
FROM registro
ORDER BY fecha_salida ASC;

-- ============================================================
-- FIN DEL ARCHIVO
-- ============================================================
