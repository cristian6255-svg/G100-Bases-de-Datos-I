-- =========================================================
-- Tarea 5 - Parte #1 del Proyecto de Aula
-- SCRIPTS DE MODIFICACIÓN DE LA BASE DE DATOS (Versión 2)
-- =========================================================

-- Miembros del grupo:
-- Cristian Camilo Hernandez Lopez
-- Maria Ortiz Oquendo
-- Sebastian Ramirez Ramos
-- Mydshell Stephannia Usuga Arango
-- =========================================================

--
-- INSTRUCCIONES DE MODIFICACIÓN SOLICITADAS
--

-- ============================================
-- 5.1.- Agregar al menos 5 índices diferentes que considere importantes en 5 tablas diferentes. 
-- ============================================
CREATE INDEX idx_paciente_apellido 
    ON paciente(apellido);

CREATE INDEX idx_medico_id_hospital 
    ON medico(id_hospital);

CREATE INDEX idx_cita_fecha 
    ON cita(fecha);

CREATE INDEX idx_diagnostico_id_paciente 
    ON diagnostico(id_paciente);

CREATE INDEX idx_tratamiento_id_diagnostico 
    ON tratamiento(id_diagnostico);



-- ============================================
-- 5.2.- Agregar 5 campos nuevos en 5 tablas diferentes de su preferencia.
-- ============================================
ALTER TABLE paciente
    ADD COLUMN sexo VARCHAR(10);

ALTER TABLE medico
    ADD COLUMN licencia VARCHAR(20);

ALTER TABLE hospital
    ADD COLUMN nivel_planta INTEGER;

ALTER TABLE cita
    ADD COLUMN estado VARCHAR(20);

ALTER TABLE medicamento
    ADD COLUMN unidad VARCHAR(20);



-- ============================================
-- 5.3.- Agregar 5 “CHECK” diferentes en 5 tablas diferentes  de su preferencia. 
-- ============================================
ALTER TABLE paciente
    ADD CONSTRAINT chk_paciente_sexo
        CHECK (sexo IN ('masculino','femenino','otro'));

ALTER TABLE medico
    ADD CONSTRAINT chk_medico_licencia
        CHECK (licencia <> '');

ALTER TABLE hospital
    ADD CONSTRAINT chk_hospital_nivel_planta
        CHECK (nivel_planta > 0);

ALTER TABLE cita
    ADD CONSTRAINT chk_cita_estado
        CHECK (estado IN ('programada','atendida','cancelada'));

ALTER TABLE medicamento
    ADD CONSTRAINT chk_medicamento_unidad
        CHECK (unidad <> '');



-- ============================================
-- 5.4. Modificar los nombres de 5 campos diferentes en 5 tablas diferentes.
-- ============================================
ALTER TABLE paciente
    RENAME COLUMN ciudad_nacimiento TO ciudad_origen;

ALTER TABLE hospital
    RENAME COLUMN nombre TO nombre_hospital;

ALTER TABLE medico
    RENAME COLUMN apellido TO apellido_medico;

ALTER TABLE cita
    RENAME COLUMN fecha TO fecha_programada;

ALTER TABLE tratamiento
    RENAME COLUMN duracion TO dias_duracion;