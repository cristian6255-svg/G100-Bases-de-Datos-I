-- ============================================================
-- Tarea 6 - Parte #2 del Proyecto de Aula
-- VALIDACIÓN ACID DE OPERACIONES (INSERT, UPDATE, DELETE)
-- ============================================================

-- Miembros del grupo:
-- Cristian Camilo Hernandez Lopez
-- Maria Ortiz Oquendo
-- Sebastian Ramirez Ramos
-- Mydshell Stephannia Usuga Arango

-- ============================================================
-- ======================= INSERT =============================
-- ============================================================
INSERT INTO eps VALUES ('EPS99','Salud Total Pruebas');
-- A: se inserta un registro completo y consistente
-- C: cumple restricciones de PK y CHECK
-- I: no afecta otras transacciones simultáneas
-- D: si falla, la Base de Datos revierte el cambio

INSERT INTO especialidad VALUES ('ESP99','Medicina del Sueño','Evaluación de trastornos del sueño');
-- ACID: garantiza consistencia y rollback automático si ocurre error

INSERT INTO hospital VALUES ('H99','Hospital de Ensayo','U001',3);
-- ACID: la operación es atómica y durable, o se guarda completa o no se guarda

-- ============================================================
-- ======================= UPDATE =============================
-- ============================================================

UPDATE paciente SET ciudad_origen = 'Envigado' WHERE id_paciente='P010';
-- A: solo cambia un atributo preciso
-- C: respeta reglas de integridad
-- I: no bloquea otras transacciones más allá del registro afectado
-- D: queda registrado permanentemente una vez confirmado

UPDATE medico SET licencia='LIC3000' WHERE id_medico='M02';
-- ACID: se valida que la clave exista y que la operación sea coherente

UPDATE hospital SET nivel_planta=8 WHERE id_hospital='H02';
-- ACID: modificación coherente y recuperable en caso de fallo

-- ============================================================
-- ========================  DELETE ===========================
-- ============================================================
DELETE FROM especialidad WHERE id_especialidad='ESP11';
-- ACID:
-- A: elimina solo ese registro
-- C: solo se permite porque no tiene FK dependientes
-- I: no afecta transacciones externas
-- D: eliminación permanente tras commit

DELETE FROM especialidad WHERE id_especialidad='ESP12';
-- ACID: borrado seguro, reversible si ocurre error

DELETE FROM eps WHERE id_eps='EPS99';
-- ACID: la Base de Datos garantiza consistencia verificando FK antes de permitir borrar

-- ============================================================
-- FIN DEL ARCHIVO
-- ============================================================
