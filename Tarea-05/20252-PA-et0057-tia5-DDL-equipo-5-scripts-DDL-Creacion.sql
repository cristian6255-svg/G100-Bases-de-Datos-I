-- =========================================================
-- Tarea 5 - Parte #1 del Proyecto de Aula
-- SCRIPTS DE CREACIÓN DE LA BASE DE DATOS (Versión 1)
-- =========================================================

-- Miembros del grupo:
-- Cristian Camilo Hernandez Lopez
-- Maria Ortiz Oquendo
-- Sebastian Ramirez Ramos
-- Mydshell Stephannia Usuga Arango

-- =========================================================
-- TABLAS EN ORDEN DE CREACIÓN:
--   1. Tablas Independientes
--   2. Tablas Dependientes
-- =========================================================



-- ============================================
-- 1. TABLAS INDEPENDIENTES
-- ============================================

-- Tabla 1: eps
CREATE TABLE eps (
    id_eps VARCHAR(20) PRIMARY KEY,
    nombre VARCHAR(20),
    CHECK (nombre <> '')
);

-- Tabla 2: ubicacion
CREATE TABLE ubicacion (
    id_ubicacion VARCHAR(25) PRIMARY KEY,
    ciudad VARCHAR(20),
    departamento VARCHAR(20),
    pais VARCHAR(20) NOT NULL,
    CHECK (ciudad <> ''),
    CHECK (departamento <> ''),
    CHECK (pais <> '')
);

-- Tabla 3: hospital
CREATE TABLE hospital (
    id_hospital VARCHAR(20) PRIMARY KEY,
    nombre VARCHAR(40),
    id_ubicacion VARCHAR(30) NOT NULL UNIQUE,
    CHECK (nombre <> ''),
    CONSTRAINT fk_hospital_ubicacion FOREIGN KEY (id_ubicacion) REFERENCES ubicacion(id_ubicacion)
);

-- Tabla 4: planta
CREATE TABLE planta (
    id_planta VARCHAR(15) PRIMARY KEY,
    numero INTEGER,
    nombre VARCHAR(15),
    id_hospital VARCHAR(10) NOT NULL UNIQUE,
    CHECK (numero > 0),
    CONSTRAINT fk_planta_hospital FOREIGN KEY (id_hospital) REFERENCES hospital(id_hospital)
);

-- Tabla 5: habitacion
CREATE TABLE habitacion (
    id_habitacion VARCHAR(10) PRIMARY KEY,
    numero INTEGER,
    id_planta VARCHAR(10) NOT NULL UNIQUE,
    CHECK (numero > 0),
    CONSTRAINT fk_habitacion_planta FOREIGN KEY (id_planta) REFERENCES planta(id_planta)
);

-- Tabla 6: cama
CREATE TABLE cama (
    id_cama VARCHAR(10) PRIMARY KEY,
    numero INTEGER,
    id_habitacion VARCHAR(5) NOT NULL UNIQUE,
    CHECK (numero > 0),
    CONSTRAINT fk_cama_habitacion FOREIGN KEY (id_habitacion) REFERENCES habitacion(id_habitacion)
);

-- Tabla 7: paciente
CREATE TABLE paciente (
    id_paciente VARCHAR(20) PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    fecha_nacimiento DATE NOT NULL,
    ciudad_nacimiento VARCHAR(25),
    pais_nacimiento VARCHAR(25),
    id_eps VARCHAR(25) NOT NULL,
    CHECK (nombre <> ''),
    CHECK (apellido <> ''),
    CHECK (fecha_nacimiento <= CURRENT_DATE),
    CONSTRAINT fk_paciente_eps FOREIGN KEY (id_eps) REFERENCES eps(id_eps)
);

-- Tabla 8: familiar
CREATE TABLE familiar (
    id_familiar VARCHAR(20) PRIMARY KEY,
    nombre VARCHAR(40) NOT NULL,
    apellido VARCHAR(40) NOT NULL,
    parentesco VARCHAR(15),
    id_paciente VARCHAR(20) UNIQUE,
    CHECK (nombre <> ''),
    CHECK (apellido <> ''),
    CHECK (parentesco IN ('madre','padre','hijo','hija')),
    CONSTRAINT fk_familiar_paciente FOREIGN KEY (id_paciente) REFERENCES paciente(id_paciente)
);

-- Tabla 9: especialidad
CREATE TABLE especialidad (
    id_especialidad VARCHAR(10) PRIMARY KEY,
    nombre VARCHAR(20),
    descripcion TEXT,
    CHECK (nombre <> '')
);

-- Tabla 10: medico
CREATE TABLE medico (
    id_medico VARCHAR(20) PRIMARY KEY,
    nombre VARCHAR(40) NOT NULL,
    apellido VARCHAR(40) NOT NULL,
    id_hospital VARCHAR(20) NOT NULL UNIQUE,
    CHECK (nombre <> ''),
    CHECK (apellido <> ''),
    CONSTRAINT fk_medico_hospital FOREIGN KEY (id_hospital) REFERENCES hospital(id_hospital)
);

-- Tabla 11: medicamento
CREATE TABLE medicamento (
    id_medicamento VARCHAR(20) PRIMARY KEY,
    nombre VARCHAR(25) NOT NULL,
    dosis DECIMAL,
    CHECK (nombre <> ''),
    CHECK (dosis IS NULL OR dosis > 0)
);

-- Tabla 12: enfermera
CREATE TABLE enfermera (
    id_enfermera VARCHAR(20) PRIMARY KEY,
    nombre VARCHAR(10) NOT NULL,
    apellido VARCHAR(40) NOT NULL,
    id_hospital VARCHAR(25) NOT NULL UNIQUE,
    CHECK (nombre <> ''),
    CHECK (apellido <> ''),
    CONSTRAINT fk_enfermera_hospital FOREIGN KEY (id_hospital) REFERENCES hospital(id_hospital)
);

-- Tabla 13: tarjeta
CREATE TABLE tarjeta (
    id_tarjeta VARCHAR(25) PRIMARY KEY,
    estado VARCHAR(15),
    fecha DATE,
    id_paciente VARCHAR(20) NOT NULL UNIQUE,
    CHECK (estado IN ('activa','inactiva')),
    CHECK (fecha <= CURRENT_DATE),
    CONSTRAINT fk_tarjeta_paciente FOREIGN KEY (id_paciente) REFERENCES paciente(id_paciente)
);



-- ============================================
-- 2. TABLAS DEPENDIENTES
-- ============================================

-- Tabla 14: registro
CREATE TABLE registro (
    id_registro VARCHAR(25) PRIMARY KEY,
    tipo VARCHAR(10),
    fecha DATE,
    id_paciente VARCHAR(20) NOT NULL UNIQUE,
    CHECK (tipo IN ('entrada','salida','control','procedimiento')),
    CHECK (fecha <= CURRENT_DATE),
    CONSTRAINT fk_registro_paciente FOREIGN KEY (id_paciente) REFERENCES paciente(id_paciente)
);

-- Tabla 15: diagnostico
CREATE TABLE diagnostico (
    id_diagnostico VARCHAR(30) PRIMARY KEY,
    fecha DATE,
    descripcion TEXT NOT NULL,
    id_paciente VARCHAR(20) NOT NULL UNIQUE,
    id_medico VARCHAR(20) NOT NULL UNIQUE,
    CHECK (fecha <= CURRENT_DATE),
    CHECK (descripcion <> ''),
    CONSTRAINT fk_diagnostico_paciente FOREIGN KEY (id_paciente) REFERENCES paciente(id_paciente),
    CONSTRAINT fk_diagnostico_medico FOREIGN KEY (id_medico) REFERENCES medico(id_medico)
);

-- Tabla 16: tratamiento
CREATE TABLE tratamiento (
    id_tratamiento VARCHAR(20) PRIMARY KEY,
    duracion INTEGER,
    id_diagnostico VARCHAR(25) NOT NULL UNIQUE,
    CHECK (duracion > 0),
    CONSTRAINT fk_tratamiento_diagnostico FOREIGN KEY (id_diagnostico) REFERENCES diagnostico(id_diagnostico)
);

-- Tabla 17: asignacion
CREATE TABLE asignacion (
    id_asignacion VARCHAR(15) PRIMARY KEY,
    fecha DATE,
    id_registro VARCHAR(20) NOT NULL UNIQUE,
    id_cama VARCHAR(10) NOT NULL UNIQUE,
    CHECK (fecha <= CURRENT_DATE),
    CONSTRAINT fk_asignacion_registro FOREIGN KEY (id_registro) REFERENCES registro(id_registro),
    CONSTRAINT fk_asignacion_cama FOREIGN KEY (id_cama) REFERENCES cama(id_cama)
);

-- Tabla 18: autorizacion
CREATE TABLE autorizacion (
    id_autorizacion VARCHAR(25) PRIMARY KEY,
    tipo VARCHAR(20),
    fecha DATE,
    id_paciente VARCHAR(20) UNIQUE,
    id_familiar VARCHAR(20) UNIQUE,
    CHECK (tipo IN ('visita','procedimiento')),
    CHECK (fecha <= CURRENT_DATE),
    CONSTRAINT fk_autorizacion_paciente FOREIGN KEY (id_paciente) REFERENCES paciente(id_paciente),
    CONSTRAINT fk_autorizacion_familiar FOREIGN KEY (id_familiar) REFERENCES familiar(id_familiar)
);

-- Tabla 19: entrada
CREATE TABLE entrada (
    id_entrada VARCHAR(10) PRIMARY KEY,
    fecha DATE,
    id_registro VARCHAR(20) NOT NULL UNIQUE,
    id_autorizacion VARCHAR(20) NOT NULL UNIQUE,
    CHECK (fecha <= CURRENT_DATE),
    CONSTRAINT fk_entrada_registro FOREIGN KEY (id_registro) REFERENCES registro(id_registro),
    CONSTRAINT fk_entrada_autorizacion FOREIGN KEY (id_autorizacion) REFERENCES autorizacion(id_autorizacion)
);

-- Tabla 20: alta
CREATE TABLE alta (
    id_alta VARCHAR(10) PRIMARY KEY,
    fecha DATE,
    hora TIME,
    id_registro VARCHAR(25) NOT NULL UNIQUE,
    CHECK (fecha <= CURRENT_DATE),
    CONSTRAINT fk_alta_registro FOREIGN KEY (id_registro) REFERENCES registro(id_registro)
);

-- Tabla 21: cita
CREATE TABLE cita (
    id_cita VARCHAR(25) PRIMARY KEY,
    fecha DATE,
    id_paciente VARCHAR(20) NOT NULL UNIQUE,
    id_medico VARCHAR(20) NOT NULL UNIQUE,
    id_diagnostico VARCHAR(25) NOT NULL UNIQUE,
    CHECK (fecha >= CURRENT_DATE),
    CONSTRAINT fk_cita_paciente FOREIGN KEY (id_paciente) REFERENCES paciente(id_paciente),
    CONSTRAINT fk_cita_medico FOREIGN KEY (id_medico) REFERENCES medico(id_medico),
    CONSTRAINT fk_cita_diagnostico FOREIGN KEY (id_diagnostico) REFERENCES diagnostico(id_diagnostico)
);

-- Tabla 22: visita
CREATE TABLE visita (
    id_visita VARCHAR(20) PRIMARY KEY,
    nombre VARCHAR(40),
    apellido VARCHAR(40),
    fecha DATE,
    id_autorizacion VARCHAR(20) NOT NULL UNIQUE,
    id_tarjeta VARCHAR(25) NOT NULL UNIQUE,
    CHECK (nombre <> ''),
    CHECK (apellido <> ''),
    CHECK (fecha <= CURRENT_DATE),
    CONSTRAINT fk_visita_autorizacion FOREIGN KEY (id_autorizacion) REFERENCES autorizacion(id_autorizacion),
    CONSTRAINT fk_visita_tarjeta FOREIGN KEY (id_tarjeta) REFERENCES tarjeta(id_tarjeta)
);

-- Tabla 23: telefono
CREATE TABLE telefono (
    id_telefono VARCHAR(15) PRIMARY KEY,
    numero VARCHAR(20),
    tipo VARCHAR(20),
    id_paciente VARCHAR(20) UNIQUE,
    id_medico VARCHAR(20) UNIQUE,
    id_familiar VARCHAR(20) UNIQUE,
    CHECK (numero <> ''),
    CHECK (tipo IN ('movil','fijo')),
    CONSTRAINT fk_telefono_paciente FOREIGN KEY (id_paciente) REFERENCES paciente(id_paciente),
    CONSTRAINT fk_telefono_medico FOREIGN KEY (id_medico) REFERENCES medico(id_medico),
    CONSTRAINT fk_telefono_familiar FOREIGN KEY (id_familiar) REFERENCES familiar(id_familiar)
);

-- Tabla 24: consulta
CREATE TABLE consulta (
    id_consulta VARCHAR(20) PRIMARY KEY,
    fecha DATE,
    id_paciente VARCHAR(25) NOT NULL UNIQUE,
    id_medico VARCHAR(25) NOT NULL UNIQUE,
    id_tratamiento VARCHAR(25) NOT NULL UNIQUE,
    CHECK (fecha <= CURRENT_DATE),
    CONSTRAINT fk_consulta_paciente FOREIGN KEY (id_paciente) REFERENCES paciente(id_paciente),
    CONSTRAINT fk_consulta_medico FOREIGN KEY (id_medico) REFERENCES medico(id_medico),
    CONSTRAINT fk_consulta_tratamiento FOREIGN KEY (id_tratamiento) REFERENCES tratamiento(id_tratamiento)
);

-- Tabla 25: prescripcion
CREATE TABLE prescripcion (
    id_prescripcion VARCHAR(20) PRIMARY KEY,
    fecha DATE,
    id_tratamiento VARCHAR(20) NOT NULL UNIQUE,
    id_medicamento VARCHAR(20) NOT NULL UNIQUE,
    id_paciente VARCHAR(20) NOT NULL UNIQUE,
    CHECK (fecha <= CURRENT_DATE),
    CONSTRAINT fk_prescripcion_tratamiento FOREIGN KEY (id_tratamiento) REFERENCES tratamiento(id_tratamiento),
    CONSTRAINT fk_prescripcion_medicamento FOREIGN KEY (id_medicamento) REFERENCES medicamento(id_medicamento),
    CONSTRAINT fk_prescripcion_paciente FOREIGN KEY (id_paciente) REFERENCES paciente(id_paciente)
);