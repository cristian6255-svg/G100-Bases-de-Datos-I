-- ============================================================
-- Tarea 6 - Parte #2 del Proyecto de Aula
-- SCRIPTS DE POBLAMIENTO DE LA BASE DE DATOS (INSERTS)
-- ============================================================

-- Miembros del grupo:
-- Cristian Camilo Hernandez Lopez
-- Maria Ortiz Oquendo
-- Sebastian Ramirez Ramos
-- Mydshell Stephannia Usuga Arango

-- ============================================================
-- CORRECCION DE CREACIÓN DE TABLAS 
-- ============================================================

-- ============================================
-- 1. TABLAS INDEPENDIENTES
-- ============================================

-- Tabla EPS
CREATE TABLE eps (
    id_eps VARCHAR(20) PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    CHECK (nombre <> '')
);

-- Tabla Ubicacion
CREATE TABLE ubicacion (
    id_ubicacion VARCHAR(25) PRIMARY KEY,
    ciudad VARCHAR(50) NOT NULL,
    departamento VARCHAR(50) NOT NULL,
    pais VARCHAR(50) NOT NULL
);

-- Tabla Hospital
CREATE TABLE hospital (
    id_hospital VARCHAR(20) PRIMARY KEY,
    nombre_hospital VARCHAR(60) NOT NULL,
    id_ubicacion VARCHAR(25) NOT NULL,
    nivel_planta INT,
    CHECK (nivel_planta IS NULL OR nivel_planta > 0),
    FOREIGN KEY (id_ubicacion) REFERENCES ubicacion(id_ubicacion)
);

-- Tabla Planta
CREATE TABLE planta (
    id_planta VARCHAR(20) PRIMARY KEY,
    numero INT NOT NULL CHECK(numero > 0),
    nombre VARCHAR(30),
    id_hospital VARCHAR(20) NOT NULL,
    FOREIGN KEY (id_hospital) REFERENCES hospital(id_hospital)
);

-- Tabla Habitacion
CREATE TABLE habitacion (
    id_habitacion VARCHAR(20) PRIMARY KEY,
    numero INT NOT NULL CHECK(numero > 0),
    id_planta VARCHAR(20) NOT NULL,
    FOREIGN KEY (id_planta) REFERENCES planta(id_planta)
);

-- Tabla Cama
CREATE TABLE cama (
    id_cama VARCHAR(20) PRIMARY KEY,
    numero INT NOT NULL CHECK(numero > 0),
    id_habitacion VARCHAR(20) NOT NULL,
    FOREIGN KEY (id_habitacion) REFERENCES habitacion(id_habitacion)
);

-- Tabla Paciente
CREATE TABLE paciente (
    id_paciente VARCHAR(20) PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    fecha_nacimiento DATE NOT NULL CHECK(fecha_nacimiento <= CURRENT_DATE),
    ciudad_origen VARCHAR(50),
    pais_nacimiento VARCHAR(50),
    id_eps VARCHAR(20) NOT NULL,
    sexo VARCHAR(10),
    CHECK (sexo IN ('masculino','femenino','otro')),
    FOREIGN KEY (id_eps) REFERENCES eps(id_eps)
);

-- Tabla Familiar
CREATE TABLE familiar (
    id_familiar VARCHAR(20) PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    parentesco VARCHAR(20),
    id_paciente VARCHAR(20),
    FOREIGN KEY (id_paciente) REFERENCES paciente(id_paciente)
);

-- Tabla Especialidad
CREATE TABLE especialidad (
    id_especialidad VARCHAR(10) PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    descripcion TEXT
);

-- Tabla Médico
CREATE TABLE medico (
    id_medico VARCHAR(20) PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    apellido_medico VARCHAR(50) NOT NULL,
    id_hospital VARCHAR(20) NOT NULL,
    id_especialidad VARCHAR(10) NOT NULL,
    licencia VARCHAR(20),
    CHECK (licencia IS NULL OR licencia <> ''),
    FOREIGN KEY (id_hospital) REFERENCES hospital(id_hospital),
    FOREIGN KEY (id_especialidad) REFERENCES especialidad(id_especialidad)
);

-- Tabla Medicamento
CREATE TABLE medicamento (
    id_medicamento VARCHAR(20) PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    dosis DECIMAL CHECK(dosis IS NULL OR dosis > 0),
    unidad VARCHAR(20),
    CHECK (unidad IS NULL OR unidad <> '')
);

-- Tabla Enfermera
CREATE TABLE enfermera (
    id_enfermera VARCHAR(20) PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    id_hospital VARCHAR(20) NOT NULL,
    sexo VARCHAR(10) CHECK(sexo IN ('masculino','femenino','otro')),
    FOREIGN KEY (id_hospital) REFERENCES hospital(id_hospital)
);

-- Tabla Tarjeta
CREATE TABLE tarjeta (
    id_tarjeta VARCHAR(25) PRIMARY KEY,
    estado VARCHAR(15) CHECK(estado IN ('activa','inactiva')),
    fecha DATE CHECK(fecha <= CURRENT_DATE),
    id_paciente VARCHAR(20) NOT NULL,
    FOREIGN KEY (id_paciente) REFERENCES paciente(id_paciente)
);

-- ============================================
-- 2. TABLA REGISTRO ( HOSPITALIZACIÓN)
-- ============================================

CREATE TABLE registro (
    id_registro VARCHAR(25) PRIMARY KEY,
    tipo VARCHAR(20) CHECK(tipo IN ('entrada','salida','control','procedimiento')),
    fecha DATE CHECK (fecha <= CURRENT_DATE),
    id_paciente VARCHAR(20) NOT NULL,
    FOREIGN KEY (id_paciente) REFERENCES paciente(id_paciente)
);

-- Agregar columnas de hospitalización
ALTER TABLE registro
ADD COLUMN id_medico VARCHAR(20),
ADD COLUMN id_cama VARCHAR(20),
ADD COLUMN fecha_ingreso DATE CHECK (fecha_ingreso <= CURRENT_DATE),
ADD COLUMN fecha_salida DATE CHECK (fecha_salida IS NULL OR fecha_salida >= fecha_ingreso),
ADD COLUMN motivo VARCHAR(150),

ADD CONSTRAINT fk_registro_medico FOREIGN KEY(id_medico) REFERENCES medico(id_medico),
ADD CONSTRAINT fk_registro_cama FOREIGN KEY(id_cama) REFERENCES cama(id_cama);



-- ============================================
-- 3. TABLAS DEPENDIENTES
-- ============================================

CREATE TABLE diagnostico (
    id_diagnostico VARCHAR(25) PRIMARY KEY,
    fecha DATE CHECK (fecha <= CURRENT_DATE),
    descripcion TEXT NOT NULL,
    id_paciente VARCHAR(20) NOT NULL,
    id_medico VARCHAR(20) NOT NULL,
    FOREIGN KEY (id_paciente) REFERENCES paciente(id_paciente),
    FOREIGN KEY (id_medico) REFERENCES medico(id_medico)
);

CREATE TABLE tratamiento (
    id_tratamiento VARCHAR(20) PRIMARY KEY,
    dias_duracion INT CHECK(dias_duracion > 0),
    id_diagnostico VARCHAR(25) NOT NULL,
    FOREIGN KEY (id_diagnostico) REFERENCES diagnostico(id_diagnostico)
);

CREATE TABLE autorizacion (
    id_autorizacion VARCHAR(25) PRIMARY KEY,
    tipo VARCHAR(20) CHECK(tipo IN ('visita','procedimiento')),
    fecha DATE CHECK(fecha <= CURRENT_DATE),
    id_paciente VARCHAR(20),
    id_familiar VARCHAR(20),
    FOREIGN KEY (id_paciente) REFERENCES paciente(id_paciente),
    FOREIGN KEY (id_familiar) REFERENCES familiar(id_familiar)
);

CREATE TABLE entrada (
    id_entrada VARCHAR(20) PRIMARY KEY,
    fecha DATE CHECK(fecha <= CURRENT_DATE),
    id_registro VARCHAR(25) NOT NULL,
    id_autorizacion VARCHAR(25) NOT NULL,
    FOREIGN KEY (id_registro) REFERENCES registro(id_registro),
    FOREIGN KEY (id_autorizacion) REFERENCES autorizacion(id_autorizacion)
);

CREATE TABLE alta (
    id_alta VARCHAR(20) PRIMARY KEY,
    fecha DATE CHECK(fecha <= CURRENT_DATE),
    hora TIME,
    id_registro VARCHAR(25) NOT NULL,
    FOREIGN KEY (id_registro) REFERENCES registro(id_registro)
);

CREATE TABLE cita (
    id_cita VARCHAR(25) PRIMARY KEY,
    fecha_programada DATE CHECK (fecha_programada > CURRENT_DATE),
    estado VARCHAR(20) CHECK (estado IN ('programada','atendida','cancelada')),
    id_paciente VARCHAR(20) NOT NULL,
    id_medico VARCHAR(20) NOT NULL,
    id_diagnostico VARCHAR(25) NOT NULL,
    FOREIGN KEY (id_paciente) REFERENCES paciente(id_paciente),
    FOREIGN KEY (id_medico) REFERENCES medico(id_medico),
    FOREIGN KEY (id_diagnostico) REFERENCES diagnostico(id_diagnostico)
);

CREATE TABLE visita (
    id_visita VARCHAR(20) PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    fecha DATE CHECK(fecha <= CURRENT_DATE),
    id_autorizacion VARCHAR(25) NOT NULL,
    id_tarjeta VARCHAR(25) NOT NULL,
    FOREIGN KEY (id_autorizacion) REFERENCES autorizacion(id_autorizacion),
    FOREIGN KEY (id_tarjeta) REFERENCES tarjeta(id_tarjeta)
);

CREATE TABLE telefono (
    id_telefono VARCHAR(20) PRIMARY KEY,
    numero VARCHAR(20) NOT NULL,
    tipo VARCHAR(20) CHECK(tipo IN ('movil','fijo')),
    id_paciente VARCHAR(20),
    id_medico VARCHAR(20),
    id_familiar VARCHAR(20),
    FOREIGN KEY (id_paciente) REFERENCES paciente(id_paciente),
    FOREIGN KEY (id_medico) REFERENCES medico(id_medico),
    FOREIGN KEY (id_familiar) REFERENCES familiar(id_familiar)
);

CREATE TABLE consulta (
    id_consulta VARCHAR(20) PRIMARY KEY,
    fecha DATE CHECK(fecha <= CURRENT_DATE),
    id_paciente VARCHAR(20) NOT NULL,
    id_medico VARCHAR(20) NOT NULL,
    id_tratamiento VARCHAR(20) NOT NULL,
    FOREIGN KEY (id_paciente) REFERENCES paciente(id_paciente),
    FOREIGN KEY (id_medico) REFERENCES medico(id_medico),
    FOREIGN KEY (id_tratamiento) REFERENCES tratamiento(id_tratamiento)
);

CREATE TABLE prescripcion (
    id_prescripcion VARCHAR(20) PRIMARY KEY,
    fecha DATE CHECK(fecha <= CURRENT_DATE),
    id_tratamiento VARCHAR(20) NOT NULL,
    id_medicamento VARCHAR(20) NOT NULL,
    id_paciente VARCHAR(20) NOT NULL,
    FOREIGN KEY (id_tratamiento) REFERENCES tratamiento(id_tratamiento),
    FOREIGN KEY (id_medicamento) REFERENCES medicamento(id_medicamento),
    FOREIGN KEY (id_paciente) REFERENCES paciente(id_paciente)
);

--
-- eps
--
INSERT INTO eps VALUES
('EPS01','SURA'),
('EPS02','Sanitas'),
('EPS03','Coomeva'),
('EPS04','Medimás'),
('EPS05','Nueva EPS'),
('EPS06','Compensar'),
('EPS07','Salud Total'),
('EPS08','Famisanar'),
('EPS09','Cafesalud'),
('EPS10','Colsubsidio');

-- Prompt utilizado:
-- "Genera 10 EPS de Colombia en formato INSERT INTO eps (…) VALUES (...)
-- sin repetir nombres y asegurando que cada registro sea único."

--
-- ubicacion
--
INSERT INTO ubicacion VALUES
('U001','Medellín','Antioquia','Colombia'),
('U002','Bello','Antioquia','Colombia'),
('U003','Envigado','Antioquia','Colombia'),
('U004','Itagüí','Antioquia','Colombia'),
('U005','Sabaneta','Antioquia','Colombia'),
('U006','Rionegro','Antioquia','Colombia'),
('U007','La Ceja','Antioquia','Colombia'),
('U008','Caldas','Antioquia','Colombia'),
('U009','Marinilla','Antioquia','Colombia'),
('U010','Copacabana','Antioquia','Colombia');

-- Prompt utilizado:
-- "Genera 10 registros para la tabla ubicacion con ciudades reales
-- de Antioquia y asegúrate de que los nombres no se repitan."

--
-- medicamento
--
INSERT INTO medicamento VALUES
('MED01','Acetaminofén',500,'mg'),
('MED02','Ibuprofeno',400,'mg'),
('MED03','Amoxicilina',500,'mg'),
('MED04','Omeprazol',20,'mg'),
('MED05','Dexametasona',8,'mg'),
('MED06','Loratadina',10,'mg'),
('MED07','Metformina',850,'mg'),
('MED08','Enalapril',10,'mg'),
('MED09','Losartán',50,'mg'),
('MED10','Atorvastatina',20,'mg');

-- 
-- hospital
-- 
INSERT INTO hospital VALUES
('H01','Hospital General de Medellin','U001',5),
('H02','Clinica Las Americas','U001',6),
('H03','Hospital Marco Fidel Suarez','U002',4),
('H04','Clinica del Sur','U004',5),
('H05','Hospital San Vicente Fundacion','U001',7),
('H06','Hospital San Juan de Dios','U006',4),
('H07','Clinica Somer','U006',5),
('H08','Hospital La Ceja','U007',3),
('H09','Hospital de Caldas','U008',3),
('H10','Hospital de Marinilla','U009',4),
('H20','Hospital Temporal Andino','U001',1),
('H21','Centro Salud Pacifico','U002',1),
('H22','Hospital Valle Verde','U003',1),
('H23','Clinica Nuevo Horizonte','U004',1),
('H24','Centro Medico Aurora','U005',1);


-- Prompt utilizado:
-- "Genera 10 hospitales reales ubicados en las ciudades anteriores,
-- respetando llaves foráneas hacia ubicacion."

-- 
-- planta
-- 
INSERT INTO planta VALUES
('PL01',1,'Urgencias','H01'),
('PL02',2,'Hospitalización','H01'),

('PL03',1,'Cirugía','H02'),
('PL04',2,'UCI Adultos','H02'),

('PL05',1,'Urgencias','H03'),
('PL06',2,'Pediatría','H03'),

('PL07',1,'Maternidad','H04'),
('PL08',2,'Trauma','H04'),

('PL09',1,'Hospitalización','H05'),
('PL10',2,'Cuidados Especiales','H05'),

('PL11',1,'Urgencias','H06'),
('PL12',2,'Cirugía','H06'),

('PL13',1,'UCI','H07'),
('PL14',2,'Hospitalización','H07'),

('PL15',1,'Urgencias','H08'),
('PL16',2,'Hospitalización','H08'),

('PL17',1,'Hospitalización','H09'),
('PL18',2,'Cirugía','H09'),

('PL19',1,'Ginecología','H10'),
('PL20',2,'Urgencias','H10');

-- Prompt utilizado:
-- "Crea plantas para cada hospital, mínimo dos por hospital,
-- usando un rango de identificadores consecutivos."

-- 
-- habitacion
-- 
INSERT INTO habitacion VALUES
('HAB01',101,'PL01'),
('HAB02',201,'PL02'),

('HAB03',301,'PL03'),
('HAB04',401,'PL04'),

('HAB05',102,'PL05'),
('HAB06',202,'PL06'),

('HAB07',103,'PL07'),
('HAB08',203,'PL08'),

('HAB09',104,'PL09'),
('HAB10',204,'PL10'),

('HAB11',105,'PL11'),
('HAB12',205,'PL12'),

('HAB13',106,'PL13'),
('HAB14',206,'PL14'),

('HAB15',107,'PL15'),
('HAB16',207,'PL16'),

('HAB17',108,'PL17'),
('HAB18',208,'PL18'),

('HAB19',109,'PL19'),
('HAB20',209,'PL20');

-- 
-- cama
-- 
INSERT INTO cama VALUES
('C001',1,'HAB01'), ('C002',2,'HAB01'),
('C003',1,'HAB02'), ('C004',2,'HAB02'),

('C005',1,'HAB03'), ('C006',2,'HAB03'),
('C007',1,'HAB04'), ('C008',2,'HAB04'),

('C009',1,'HAB05'), ('C010',2,'HAB05'),
('C011',1,'HAB06'), ('C012',2,'HAB06'),

('C013',1,'HAB07'), ('C014',2,'HAB07'),
('C015',1,'HAB08'), ('C016',2,'HAB08'),

('C017',1,'HAB09'), ('C018',2,'HAB09'),
('C019',1,'HAB10'), ('C020',2,'HAB10'),

('C021',1,'HAB11'), ('C022',2,'HAB11'),
('C023',1,'HAB12'), ('C024',2,'HAB12'),

('C025',1,'HAB13'), ('C026',2,'HAB13'),
('C027',1,'HAB14'), ('C028',2,'HAB14'),

('C029',1,'HAB15'), ('C030',2,'HAB15'),
('C031',1,'HAB16'), ('C032',2,'HAB16'),

('C033',1,'HAB17'), ('C034',2,'HAB17'),
('C035',1,'HAB18'), ('C036',2,'HAB18'),

('C037',1,'HAB19'), ('C038',2,'HAB19'),
('C039',1,'HAB20'), ('C040',2,'HAB20');

-- ============================================================
-- paciente 1–10 AÑOS 
-- ============================================================
INSERT INTO paciente VALUES
('P001','Juan','Restrepo','2017-04-12','Medellín','Colombia','EPS01','masculino'),
('P002','Mateo','García','2016-09-30','Bello','Colombia','EPS02','masculino'),
('P003','Samuel','López','2018-03-22','Envigado','Colombia','EPS03','masculino'),
('P004','Daniel','Orozco','2015-07-10','Itagüí','Colombia','EPS04','masculino'),
('P005','Felipe','Montoya','2014-12-01','Rionegro','Colombia','EPS05','masculino'),

('P006','Valentina','Gómez','2016-06-11','Medellín','Colombia','EPS06','femenino'),
('P007','Sara','Zapata','2018-08-09','Sabaneta','Colombia','EPS07','femenino'),
('P008','Lucía','Cano','2017-02-25','Caldas','Colombia','EPS08','femenino'),
('P009','Mariana','Vásquez','2014-10-13','Envigado','Colombia','EPS09','femenino'),
('P010','Isabella','Pérez','2015-03-04','Bello','Colombia','EPS10','femenino');

-- ============================================================
-- paciente 11–20 AÑOS 
-- ============================================================
INSERT INTO paciente VALUES
('P011','Juan Pablo','Ramírez','2009-05-14','Medellín','Colombia','EPS01','masculino'),
('P012','Esteban','Cárdenas','2008-11-03','Envigado','Colombia','EPS02','masculino'),
('P013','Kevin','Usme','2007-09-12','Bello','Colombia','EPS03','masculino'),
('P014','Brayan','Guzmán','2006-04-28','Itagüí','Colombia','EPS04','masculino'),
('P015','Nicolás','Ruiz','2009-08-22','Caldas','Colombia','EPS05','masculino'),
('P016','Simón','Valencia','2007-03-19','Rionegro','Colombia','EPS06','masculino'),
('P017','Cristian','Ocampo','2006-12-30','La Ceja','Colombia','EPS07','masculino'),
('P018','Dilan','Torres','2005-07-07','Medellín','Colombia','EPS08','masculino'),

('P019','Sofía','Martínez','2009-01-23','Bello','Colombia','EPS09','femenino'),
('P020','Camila','Arango','2008-04-05','Sabaneta','Colombia','EPS10','femenino'),
('P021','Juliana','Zapata','2006-11-17','Envigado','Colombia','EPS01','femenino'),
('P022','Laura','Londoño','2005-08-29','Itagüí','Colombia','EPS02','femenino'),
('P023','Valeria','Ramírez','2007-02-16','Caldas','Colombia','EPS03','femenino'),
('P024','Manuela','Vélez','2006-10-09','Rionegro','Colombia','EPS04','femenino'),
('P025','Antonella','Gil','2009-05-19','La Ceja','Colombia','EPS05','femenino');

-- ============================================================
-- paciente 21–40 AÑOS 
-- ============================================================
INSERT INTO paciente VALUES
('P026','Carlos','Jiménez','1987-03-12','Medellín','Colombia','EPS01','masculino'),
('P027','Julián','Atehortúa','1995-05-09','Bello','Colombia','EPS02','masculino'),
('P028','Luis','Rendón','1990-11-29','Envigado','Colombia','EPS03','masculino'),
('P029','Andrés','Vélez','1988-07-01','Itagüí','Colombia','EPS04','masculino'),
('P030','Sebastián','Ortega','1992-04-16','Rionegro','Colombia','EPS05','masculino'),
('P031','Tomás','Gaviria','1996-12-07','Medellín','Colombia','EPS06','masculino'),
('P032','Mario','Torres','1989-09-10','Caldas','Colombia','EPS07','masculino'),
('P033','Ricardo','Salazar','1998-02-11','Envigado','Colombia','EPS08','masculino'),
('P034','Miguel','Hernández','1986-10-23','La Ceja','Colombia','EPS09','masculino'),
('P035','Fernando','Álvarez','1999-08-15','Bello','Colombia','EPS10','masculino'),

('P036','Paula','García','1991-03-02','Medellín','Colombia','EPS01','femenino'),
('P037','Daniela','Zapata','1994-06-25','Envigado','Colombia','EPS02','femenino'),
('P038','María','Sánchez','1988-11-14','Caldas','Colombia','EPS03','femenino'),
('P039','Angélica','Vargas','1997-05-30','Rionegro','Colombia','EPS04','femenino'),
('P040','Juliana','Quiroz','1990-10-08','Medellín','Colombia','EPS05','femenino'),
('P041','Natalia','Betancur','1986-01-21','Itagüí','Colombia','EPS06','femenino'),
('P042','Camila','Bustamante','1998-04-27','La Ceja','Colombia','EPS07','femenino'),
('P043','Luisa','Ospina','1987-12-19','Envigado','Colombia','EPS08','femenino'),
('P044','Melissa','Montoya','1993-07-17','Bello','Colombia','EPS09','femenino'),
('P045','Adriana','Arango','1995-02-06','Sabaneta','Colombia','EPS10','femenino');

-- ============================================================
-- paciente 41–60 AÑOS 
-- ============================================================
INSERT INTO paciente VALUES
('P046','Hernán','González','1980-09-09','Medellín','Colombia','EPS01','masculino'),
('P047','Jorge','Ramírez','1975-12-11','Bello','Colombia','EPS02','masculino'),
('P048','Óscar','Londoño','1970-02-02','Envigado','Colombia','EPS03','masculino'),
('P049','Rogelio','Ríos','1967-08-18','Itagüí','Colombia','EPS04','masculino'),
('P050','Humberto','Quintero','1979-03-14','Rionegro','Colombia','EPS05','masculino'),
('P051','Mauricio','Valencia','1974-04-24','Medellín','Colombia','EPS06','masculino'),
('P052','Alfredo','Jiménez','1972-10-29','Caldas','Colombia','EPS07','masculino'),
('P053','Rubén','Murillo','1981-06-20','Envigado','Colombia','EPS08','masculino'),
('P054','Ramiro','Hoyos','1969-01-19','La Ceja','Colombia','EPS09','masculino'),
('P055','Wilson','Ortiz','1976-05-10','Bello','Colombia','EPS10','masculino'),
('P056','Gustavo','Castaño','1973-07-30','Medellín','Colombia','EPS01','masculino'),
('P057','Jaime','Soto','1965-11-15','Itagüí','Colombia','EPS02','masculino'),
('P058','Carlos','Vivas','1982-03-05','Sabaneta','Colombia','EPS03','masculino'),

('P059','Claudia','Ruiz','1978-09-27','Envigado','Colombia','EPS04','femenino'),
('P060','Sandra','Gómez','1970-04-12','Caldas','Colombia','EPS05','femenino'),
('P061','Marcela','Garzón','1983-10-22','Medellín','Colombia','EPS06','femenino'),
('P062','Liliana','Gallo','1980-03-09','Bello','Colombia','EPS07','femenino'),
('P063','Patricia','Zapata','1976-08-30','La Ceja','Colombia','EPS08','femenino'),
('P064','Gloria','Montes','1974-06-21','Envigado','Colombia','EPS09','femenino'),
('P065','Beatriz','Vélez','1967-12-28','Medellín','Colombia','EPS10','femenino'),
('P066','Viviana','López','1972-02-03','Caldas','Colombia','EPS01','femenino'),
('P067','Monica','Roldán','1981-11-16','Bello','Colombia','EPS02','femenino'),
('P068','Yolanda','Henao','1973-03-11','Envigado','Colombia','EPS03','femenino'),
('P069','Amparo','Sierra','1970-01-14','Itagüí','Colombia','EPS04','femenino'),
('P070','Teresa','Casas','1982-09-07','Rionegro','Colombia','EPS05','femenino');

-- ============================================================
-- paciente 61+ AÑOS 
-- ============================================================
INSERT INTO paciente VALUES
('P071','Humberto','Duque','1950-06-22','Medellín','Colombia','EPS05','masculino'),
('P072','Raúl','Gallo','1955-01-03','Bello','Colombia','EPS06','masculino'),
('P073','Rubén','Gallego','1948-09-11','Envigado','Colombia','EPS07','masculino'),
('P074','Marco','Giraldo','1956-10-29','Itagüí','Colombia','EPS08','masculino'),
('P075','Elkin','Cárdenas','1952-03-17','La Ceja','Colombia','EPS09','masculino'),
('P076','Mario','Uribe','1943-12-01','Caldas','Colombia','EPS10','masculino'),
('P077','Álvaro','Hincapié','1949-05-25','Medellín','Colombia','EPS01','masculino'),
('P078','Luis','Ospina','1958-07-12','Bello','Colombia','EPS02','masculino'),
('P079','Darío','Torres','1947-04-02','Envigado','Colombia','EPS03','masculino'),
('P080','Hernando','Guzmán','1953-11-09','Itagüí','Colombia','EPS04','masculino'),
('P081','Rigoberto','Valencia','1950-08-20','Rionegro','Colombia','EPS05','masculino'),
('P082','Gonzalo','Sierra','1944-07-19','Caldas','Colombia','EPS06','masculino'),
('P083','Aníbal','Giraldo','1957-12-31','Bello','Colombia','EPS07','masculino'),
('P084','Alberto','Restrepo','1946-06-16','Envigado','Colombia','EPS08','masculino'),

('P085','María','Loaiza','1955-02-14','Medellín','Colombia','EPS09','femenino'),
('P086','Elena','Mesa','1949-10-05','La Ceja','Colombia','EPS10','femenino'),
('P087','Julia','Aristizábal','1958-03-09','Itagüí','Colombia','EPS01','femenino'),
('P088','Amalia','Sánchez','1947-11-12','Caldas','Colombia','EPS02','femenino'),
('P089','Olga','Montoya','1941-09-10','Envigado','Colombia','EPS03','femenino'),
('P090','Ruth','Parra','1953-12-04','Bello','Colombia','EPS04','femenino'),
('P091','Eugenia','Quintero','1944-08-23','Sabaneta','Colombia','EPS05','femenino'),
('P092','Alicia','Duque','1942-06-07','Medellín','Colombia','EPS06','femenino'),
('P093','Dolores','García','1956-09-30','Rionegro','Colombia','EPS07','femenino'),
('P094','Teresa','Jiménez','1940-05-18','Caldas','Colombia','EPS08','femenino'),
('P095','Hilda','Salazar','1948-12-22','Sabaneta','Colombia','EPS09','femenino'),
('P096','Elvira','Rodríguez','1946-04-27','Envigado','Colombia','EPS10','femenino'),
('P097','Ana','Herrera','1943-01-11','Itagüí','Colombia','EPS01','femenino'),
('P098','Lucía','Sierra','1957-02-24','Bello','Colombia','EPS02','femenino'),
('P099','Beatriz','Posada','1949-07-29','Medellín','Colombia','EPS03','femenino'),
('P100','Nelly','Patiño','1945-10-17','Caldas','Colombia','EPS04','femenino');


-- Prompt utilizado:
-- "Genera 100 pacientes divididos así:
--  – 1–10 años: 10 registros (5 hombres, 5 mujeres)
--  – 11–20 años: 15 registros
--  – 21–40 años: 20 registros
--  – 41–60 años: 25 registros
--  – 61+ años: 30 registros
-- Asegura cumpleaños válidos por rango y sin repetir datos."

-- 
-- especialidad
-- 
INSERT INTO especialidad VALUES
('ESP01','Pediatría','Atención médica a niños y adolescentes'),
('ESP02','Medicina Interna','Tratamiento de enfermedades en adultos'),
('ESP03','Cardiología','Especialidad del sistema cardiovascular'),
('ESP04','Neurología','Diagnóstico del sistema nervioso'),
('ESP05','Ginecología','Salud reproductiva de la mujer'),
('ESP06','Traumatología','Lesiones del sistema músculo-esquelético'),
('ESP07','Dermatología','Enfermedades de la piel'),
('ESP08','Psiquiatría','Salud mental'),
('ESP09','Oftalmología','Salud visual'),
('ESP10','Oncología','Tratamiento del cáncer'),
('ESP11','Medicina Aeroespacial','Especialidad de soporte clínico en vuelos y gravedad cero'),
('ESP12','Medicina Tropical','Estudio y tratamiento de enfermedades tropicales');
-- 
-- medico
-- 
INSERT INTO medico VALUES
('M01','Juan','Pérez','H01','ESP01','LIC1001'),
('M02','Carlos','García','H02','ESP02','LIC1002'),
('M03','Andrés','López','H03','ESP03','LIC1003'),
('M04','Felipe','Gómez','H04','ESP04','LIC1004'),
('M05','Julián','Cano','H05','ESP05','LIC1005'),
('M06','Hernán','Zapata','H06','ESP06','LIC1006'),
('M07','Jairo','Restrepo','H07','ESP07','LIC1007'),
('M08','Sebastián','Vallejo','H08','ESP08','LIC1008'),
('M09','David','Ospina','H09','ESP09','LIC1009'),
('M10','Esteban','Rendón','H10','ESP10','LIC1010'),

('M11','Óscar','Torres','H01','ESP02','LIC1011'),
('M12','Nicolás','Vargas','H02','ESP04','LIC1012'),
('M13','Mario','Zúñiga','H03','ESP06','LIC1013'),
('M14','Roberto','Gaviria','H04','ESP08','LIC1014'),
('M15','Héctor','Montoya','H05','ESP10','LIC1015'),
('M16','Jorge','Molina','H06','ESP03','LIC1016'),

('M17','Laura','Guzmán','H07','ESP01','LIC2001'),
('M18','Daniela','Soto','H08','ESP02','LIC2002'),
('M19','Ana','Uribe','H09','ESP03','LIC2003'),
('M20','Sara','Jiménez','H10','ESP04','LIC2004'),
('M21','Carolina','Henao','H01','ESP05','LIC2005'),
('M22','Valentina','Patiño','H02','ESP06','LIC2006'),
('M23','Manuela','Gallo','H03','ESP07','LIC2007'),
('M24','Paula','Cárdenas','H04','ESP08','LIC2008'),
('M25','Camila','Bedoya','H05','ESP09','LIC2009'),
('M26','Mariana','Mejía','H06','ESP10','LIC2010'),
('M27','Rosa','Duque','H07','ESP01','LIC2011'),
('M28','Beatriz','Giraldo','H08','ESP02','LIC2012'),
('M29','Lucía','Castaño','H09','ESP03','LIC2013'),
('M30','Elena','Zapata','H10','ESP04','LIC2014');

-- Prompt utilizado:
-- "Genera 30 médicos (16 hombres, 14 mujeres) distribuyendo
-- 10 especialidades entre ellos y relacionándolos con hospitales."

-- 
-- enfermera
-- 
INSERT INTO enfermera VALUES
('E01','María','Gómez','H01','femenino'),
('E02','Laura','Salazar','H02','femenino'),
('E03','Sandra','Vélez','H03','femenino'),
('E04','Paula','Valencia','H04','femenino'),
('E05','Carolina','Ospina','H05','femenino'),
('E06','Juliana','Pérez','H06','femenino'),
('E07','Claudia','Ríos','H07','femenino'),
('E08','Rosa','Cano','H08','femenino'),
('E09','Juan','Hernández','H09','masculino'),
('E10','Carlos','Montoya','H10','masculino');

-- 
-- hospitalizacion (registro) 
-- 
INSERT INTO registro VALUES
('R001','entrada','2024-02-01','P001','M01','C001','2024-02-01','2024-02-05','Fiebre alta'),
('R002','entrada','2024-02-03','P002','M02','C002','2024-02-03','2024-02-06','Gastroenteritis'),
('R003','entrada','2024-01-15','P003','M03','C003','2024-01-15','2024-01-20','Infección respiratoria'),
('R004','entrada','2024-02-10','P004','M04','C004','2024-02-10','2024-02-14','Caída y contusión'),
('R005','entrada','2024-03-01','P005','M05','C005','2024-03-01','2024-03-04','Alergia severa'),

('R006','entrada','2024-01-25','P006','M06','C006','2024-01-25','2024-01-28','Asma'),
('R007','entrada','2024-03-02','P007','M07','C007','2024-03-02','2024-03-07','Fiebre viral'),
('R008','entrada','2024-03-07','P008','M08','C008','2024-03-07','2024-03-10','Fractura menor'),
('R009','entrada','2024-02-18','P009','M09','C009','2024-02-18','2024-02-22','Deshidratación'),
('R010','entrada','2024-01-09','P010','M10','C010','2024-01-09','2024-01-13','Dolor abdominal'),

('R011','entrada','2024-02-02','P011','M11','C011','2024-02-02','2024-02-07','Apendicitis'),
('R012','entrada','2024-03-12','P012','M12','C012','2024-03-12','2024-03-16','Problemas respiratorios'),
('R013','entrada','2024-01-28','P013','M13','C013','2024-01-28','2024-02-01','Dolor torácico'),
('R014','entrada','2024-02-15','P014','M14','C014','2024-02-15','2024-02-19','Infección de oído'),
('R015','entrada','2024-01-20','P015','M15','C015','2024-01-20','2024-01-23','Migraña severa'),

('R016','entrada','2024-02-05','P016','M16','C016','2024-02-05','2024-02-09','Hipertensión'),
('R017','entrada','2024-03-11','P017','M17','C017','2024-03-11','2024-03-15','Accidente menor'),
('R018','entrada','2024-03-03','P018','M18','C018','2024-03-03','2024-03-08','Infección intestinal'),
('R019','entrada','2024-01-14','P019','M19','C019','2024-01-14','2024-01-20','Dolor lumbar'),
('R020','entrada','2024-02-17','P020','M20','C020','2024-02-17','2024-02-21','Faringitis'),

('R021','entrada','2024-01-02','P021','M21','C021','2024-01-02','2024-01-06','Infección urinaria'),
('R022','entrada','2024-02-08','P022','M22','C022','2024-02-08','2024-02-12','Dolor torácico'),
('R023','entrada','2024-03-04','P023','M23','C023','2024-03-04','2024-03-08','Fiebre persistente'),
('R024','entrada','2024-01-27','P024','M24','C024','2024-01-27','2024-02-01','Desmayo'),
('R025','entrada','2024-03-15','P025','M25','C025','2024-03-15','2024-03-19','Crisis asmática'),

('R026','entrada','2024-01-30','P026','M26','C026','2024-01-30','2024-02-03','Dolor de pecho'),
('R027','entrada','2024-02-04','P027','M27','C027','2024-02-04','2024-02-07','Hipotensión'),
('R028','entrada','2024-03-06','P028','M28','C028','2024-03-06','2024-03-10','Gastroenteritis'),
('R029','entrada','2024-02-11','P029','M29','C029','2024-02-11','2024-02-13','Cefalea'),
('R030','entrada','2024-01-18','P030','M30','C030','2024-01-18','2024-01-22','Infección bacteriana'),

('R031','entrada','2024-02-14','P031','M01','C031','2024-02-14','2024-02-17','Hiperglucemia'),
('R032','entrada','2024-03-10','P032','M02','C032','2024-03-10','2024-03-13','Convulsión'),
('R033','entrada','2024-01-19','P033','M03','C033','2024-01-19','2024-01-23','Caída'),
('R034','entrada','2024-03-14','P034','M04','C034','2024-03-14','2024-03-17','Dolor abdominal'),
('R035','entrada','2024-02-06','P035','M05','C035','2024-02-06','2024-02-10','Fiebre'),

('R036','entrada','2024-03-01','P036','M06','C036','2024-03-01','2024-03-05','Intoxicación alimentaria'),
('R037','entrada','2024-02-13','P037','M07','C037','2024-02-13','2024-02-16','Hipotiroidismo'),
('R038','entrada','2024-01-24','P038','M08','C038','2024-01-24','2024-01-28','Faringitis'),
('R039','entrada','2024-03-09','P039','M09','C039','2024-03-09','2024-03-12','Cólico'),
('R040','entrada','2024-03-04','P040','M10','C040','2024-03-04','2024-03-08','Mareos'),

('R041','entrada','2024-02-01','P041','M11','C001','2024-02-01','2024-02-04','Hipertensión'),
('R042','entrada','2024-02-05','P042','M12','C002','2024-02-05','2024-02-08','Caída'),
('R043','entrada','2024-03-02','P043','M13','C003','2024-03-02','2024-03-06','Dolor articular'),
('R044','entrada','2024-01-22','P044','M14','C004','2024-01-22','2024-01-27','Dermatitis'),
('R045','entrada','2024-03-11','P045','M15','C005','2024-03-11','2024-03-14','Alergia'),

('R046','entrada','2024-01-26','P046','M16','C006','2024-01-26','2024-01-31','Infección pulmonar'),
('R047','entrada','2024-02-21','P047','M17','C007','2024-02-21','2024-02-24','Hipertensión'),
('R048','entrada','2024-02-27','P048','M18','C008','2024-02-27','2024-03-02','Desmayo'),
('R049','entrada','2024-03-08','P049','M19','C009','2024-03-08','2024-03-12','Infección renal'),
('R050','entrada','2024-01-30','P050','M20','C010','2024-01-30','2024-02-03','Adenovirus'),

('R051','entrada','2024-03-05','P051','M21','C011','2024-03-05','2024-03-09','Dolor abdominal'),
('R052','entrada','2024-01-14','P052','M22','C012','2024-01-14','2024-01-19','Golpe de calor'),
('R053','entrada','2024-02-09','P053','M23','C013','2024-02-09','2024-02-12','Fiebre'),
('R054','entrada','2024-02-19','P054','M24','C014','2024-02-19','2024-02-23','Herida menor'),
('R055','entrada','2024-03-07','P055','M25','C015','2024-03-07','2024-03-10','Bronquitis'),

('R056','entrada','2024-01-31','P056','M26','C016','2024-01-31','2024-02-04','Diarrea'),
('R057','entrada','2024-03-03','P057','M27','C017','2024-03-03','2024-03-06','Dolor de espalda'),
('R058','entrada','2024-02-02','P058','M28','C018','2024-02-02','2024-02-07','Hiperglucemia'),
('R059','entrada','2024-03-13','P059','M29','C019','2024-03-13','2024-03-16','Alergia'),
('R060','entrada','2024-01-12','P060','M30','C020','2024-01-12','2024-01-17','Infección viral');

-- P075 
INSERT INTO registro VALUES
('R085','entrada','2024-01-08','P075','M06','C021','2024-01-08','2024-01-12','Dolor abdominal'),
('R086','entrada','2024-02-14','P075','M12','C022','2024-02-14','2024-02-17','Infección pulmonar'),
('R087','entrada','2024-03-06','P075','M20','C023','2024-03-06','2024-03-10','Hipertensión');

-- P076
INSERT INTO registro VALUES
('R088','entrada','2024-01-25','P076','M02','C024','2024-01-25','2024-01-29','Alergia'),
('R089','entrada','2024-02-27','P076','M08','C001','2024-02-27','2024-03-02','Fiebre'),
('R090','entrada','2024-03-15','P076','M14','C002','2024-03-15','2024-03-18','Cólico');

-- P077
INSERT INTO registro VALUES
('R091','entrada','2024-01-18','P077','M03','C003','2024-01-18','2024-01-22','Deshidratación'),
('R092','entrada','2024-02-23','P077','M09','C004','2024-02-23','2024-02-27','Migraña'),
('R093','entrada','2024-03-11','P077','M18','C005','2024-03-11','2024-03-14','Infección viral');

-- P078
INSERT INTO registro VALUES
('R094','entrada','2024-02-04','P078','M11','C006','2024-02-04','2024-02-08','Apendicitis'),
('R095','entrada','2024-02-28','P078','M17','C007','2024-02-28','2024-03-03','Fiebre alta'),
('R096','entrada','2024-03-16','P078','M23','C008','2024-03-16','2024-03-19','Dolor óseo');

-- P079
INSERT INTO registro VALUES
('R097','entrada','2024-01-12','P079','M01','C009','2024-01-12','2024-01-17','Vómito'),
('R098','entrada','2024-02-18','P079','M05','C010','2024-02-18','2024-02-22','Accidente menor'),
('R099','entrada','2024-03-12','P079','M13','C011','2024-03-12','2024-03-15','Alergia severa');

-- Prompt utilizado:
-- "Genera hospitalizaciones completas con médico, cama,
-- fecha de ingreso, fecha de salida y motivo.
-- 64 pacientes con 1 hospitalización, 10 con 2, 5 con 3 y 1 con 4."

-- ============================================================
-- Resto de las tablas
-- ============================================================
-- 
-- diagnostico
-- 
INSERT INTO diagnostico VALUES
('D001','2024-02-01','Fiebre aguda','P001','M01'),
('D002','2024-02-03','Gastroenteritis','P002','M02'),
('D003','2024-01-15','Infección respiratoria','P003','M03'),
('D004','2024-02-10','Contusión menor','P004','M04'),
('D005','2024-03-01','Alergia severa','P005','M05'),
('D006','2024-01-25','Asma leve','P006','M06'),
('D007','2024-03-02','Fiebre viral persistente','P007','M07'),
('D008','2024-03-07','Fractura leve','P008','M08'),
('D009','2024-02-18','Deshidratación moderada','P009','M09'),
('D010','2024-01-09','Dolor abdominal agudo','P010','M10'),

('D011','2024-02-02','Apendicitis','P011','M11'),
('D012','2024-03-12','Bronquitis','P012','M12'),
('D013','2024-01-28','Dolor torácico','P013','M13'),
('D014','2024-02-15','Infección de oído','P014','M14'),
('D015','2024-01-20','Migraña severa','P015','M15'),
('D016','2024-02-05','Hipertensión','P016','M16'),
('D017','2024-03-11','Trauma por caída','P017','M17'),
('D018','2024-03-03','Infección intestinal','P018','M18'),
('D019','2024-01-14','Dolor lumbar','P019','M19'),
('D020','2024-02-17','Faringitis','P020','M20'),

('D021','2024-01-02','Infección urinaria','P021','M21'),
('D022','2024-02-08','Dolor torácico','P022','M22'),
('D023','2024-03-04','Fiebre persistente','P023','M23'),
('D024','2024-01-27','Desmayo','P024','M24'),
('D025','2024-03-15','Crisis asmática','P025','M25'),
('D026','2024-01-30','Dolor de pecho','P026','M26'),
('D027','2024-02-04','Hipotensión','P027','M27'),
('D028','2024-03-06','Gastroenteritis','P028','M28'),
('D029','2024-02-11','Cefalea aguda','P029','M29'),
('D030','2024-01-18','Infección bacteriana','P030','M30');

-- 
-- tratamiento
-- 
INSERT INTO tratamiento VALUES
('T001', 5, 'D001'),
('T002', 4, 'D002'),
('T003', 7, 'D003'),
('T004', 3, 'D004'),
('T005', 5, 'D005'),
('T006', 6, 'D006'),
('T007', 4, 'D007'),
('T008', 8, 'D008'),
('T009', 3, 'D009'),
('T010', 5, 'D010'),

('T011', 10, 'D011'),
('T012', 6,  'D012'),
('T013', 4,  'D013'),
('T014', 3,  'D014'),
('T015', 2,  'D015'),
('T016', 7,  'D016'),
('T017', 5,  'D017'),
('T018', 6,  'D018'),
('T019', 4,  'D019'),
('T020', 3,  'D020'),

('T021', 7,  'D021'),
('T022', 5,  'D022'),
('T023', 4,  'D023'),
('T024', 3,  'D024'),
('T025', 6,  'D025'),
('T026', 2,  'D026'),
('T027', 4,  'D027'),
('T028', 5,  'D028'),
('T029', 3,  'D029'),
('T030', 7,  'D030');

-- 
-- consulta
-- 
INSERT INTO consulta VALUES
('CST001','2024-02-01','P001','M01','T001'),
('CST002','2024-02-03','P002','M02','T002'),
('CST003','2024-01-15','P003','M03','T003'),
('CST004','2024-02-10','P004','M04','T004'),
('CST005','2024-03-01','P005','M05','T005'),

('CST006','2024-01-25','P006','M06','T006'),
('CST007','2024-03-02','P007','M07','T007'),
('CST008','2024-03-07','P008','M08','T008'),
('CST009','2024-02-18','P009','M09','T009'),
('CST010','2024-01-09','P010','M10','T010'),

('CST011','2024-02-02','P011','M11','T011'),
('CST012','2024-03-12','P012','M12','T012'),
('CST013','2024-01-28','P013','M13','T013'),
('CST014','2024-02-15','P014','M14','T014'),
('CST015','2024-01-20','P015','M15','T015'),

('CST016','2024-02-05','P016','M16','T016'),
('CST017','2024-03-11','P017','M17','T017'),
('CST018','2024-03-03','P018','M18','T018'),
('CST019','2024-01-14','P019','M19','T019'),
('CST020','2024-02-17','P020','M20','T020'),

('CST021','2024-01-02','P021','M21','T021'),
('CST022','2024-02-08','P022','M22','T022'),
('CST023','2024-03-04','P023','M23','T023'),
('CST024','2024-01-27','P024','M24','T024'),
('CST025','2024-03-15','P025','M25','T025'),

('CST026','2024-01-30','P026','M26','T026'),
('CST027','2024-02-04','P027','M27','T027'),
('CST028','2024-03-06','P028','M28','T028'),
('CST029','2024-02-11','P029','M29','T029'),
('CST030','2024-01-18','P030','M30','T030');

-- Prompt utilizado:
-- "Genera diagnósticos enlazados con los registros anteriores.
-- Cada diagnóstico debe generar un tratamiento y una consulta válida."

-- 
-- autorizacion
-- 
INSERT INTO autorizacion VALUES
('A001','visita','2024-02-02','P001',NULL),
('A002','procedimiento','2024-02-03','P002',NULL),
('A003','visita','2024-01-16','P003',NULL),
('A004','visita','2024-02-11','P004',NULL),
('A005','procedimiento','2024-03-01','P005',NULL),

('A006','visita','2024-01-26','P006',NULL),
('A007','visita','2024-03-03','P007',NULL),
('A008','visita','2024-03-08','P008',NULL),
('A009','procedimiento','2024-02-19','P009',NULL),
('A010','visita','2024-01-10','P010',NULL),

('A011','visita','2024-02-03','P011',NULL),
('A012','procedimiento','2024-03-12','P012',NULL),
('A013','visita','2024-01-29','P013',NULL),
('A014','visita','2024-02-15','P014',NULL),
('A015','visita','2024-01-21','P015',NULL),

('A016','visita','2024-02-06','P016',NULL),
('A017','visita','2024-03-12','P017',NULL),
('A018','visita','2024-03-04','P018',NULL),
('A019','visita','2024-01-15','P019',NULL),
('A020','visita','2024-02-18','P020',NULL);

-- 
-- entrada
-- 
INSERT INTO entrada VALUES
('EN001','2024-02-01','R001','A001'),
('EN002','2024-02-03','R002','A002'),
('EN003','2024-01-15','R003','A003'),
('EN004','2024-02-10','R004','A004'),
('EN005','2024-03-01','R005','A005'),

('EN006','2024-01-25','R006','A006'),
('EN007','2024-03-02','R007','A007'),
('EN008','2024-03-07','R008','A008'),
('EN009','2024-02-18','R009','A009'),
('EN010','2024-01-09','R010','A010'),

('EN011','2024-02-02','R011','A011'),
('EN012','2024-03-12','R012','A012'),
('EN013','2024-01-28','R013','A013'),
('EN014','2024-02-15','R014','A014'),
('EN015','2024-01-20','R015','A015'),

('EN016','2024-02-05','R016','A016'),
('EN017','2024-03-11','R017','A017'),
('EN018','2024-03-03','R018','A018'),
('EN019','2024-01-14','R019','A019'),
('EN020','2024-02-17','R020','A020');

-- 
-- alta
-- 
INSERT INTO alta VALUES
('AL001','2024-02-05','14:30','R001'),
('AL002','2024-02-06','10:00','R002'),
('AL003','2024-01-20','09:15','R003'),
('AL004','2024-02-14','11:45','R004'),
('AL005','2024-03-04','08:20','R005'),

('AL006','2024-01-28','16:10','R006'),
('AL007','2024-03-07','13:25','R007'),
('AL008','2024-03-10','15:40','R008'),
('AL009','2024-02-22','17:00','R009'),
('AL010','2024-01-13','07:45','R010'),

('AL011','2024-02-07','12:55','R011'),
('AL012','2024-03-16','09:35','R012'),
('AL013','2024-02-01','08:00','R013'),
('AL014','2024-02-19','10:50','R014'),
('AL015','2024-01-23','16:20','R015'),

('AL016','2024-02-09','14:15','R016'),
('AL017','2024-03-15','11:05','R017'),
('AL018','2024-03-08','15:55','R018'),
('AL019','2024-01-20','09:45','R019'),
('AL020','2024-02-21','13:30','R020');

-- 
-- telefono
-- 
INSERT INTO telefono VALUES
('T001','3001112233','movil','P001',NULL,NULL),
('T002','3001112234','movil','P002',NULL,NULL),
('T003','3001112235','movil','P003',NULL,NULL),
('T004','3001112236','movil','P004',NULL,NULL),
('T005','3001112237','movil','P005',NULL,NULL),

('T006','3001112238','movil','P006',NULL,NULL),
('T007','3001112239','movil','P007',NULL,NULL),
('T008','3001112240','movil','P008',NULL,NULL),
('T009','3001112241','movil','P009',NULL,NULL),
('T010','3001112242','movil','P010',NULL,NULL);

INSERT INTO telefono VALUES
('T011','3105551111','movil',NULL,'M01',NULL),
('T012','3105551112','movil',NULL,'M02',NULL),
('T013','3105551113','movil',NULL,'M03',NULL),
('T014','3105551114','movil',NULL,'M04',NULL),
('T015','3105551115','movil',NULL,'M05',NULL),

('T016','3105551116','movil',NULL,'M06',NULL),
('T017','3105551117','movil',NULL,'M07',NULL),
('T018','3105551118','movil',NULL,'M08',NULL),
('T019','3105551119','movil',NULL,'M09',NULL),
('T020','3105551120','movil',NULL,'M10',NULL);

INSERT INTO telefono VALUES
('T021','6045557788','fijo','P011',NULL,NULL),
('T022','6045557789','fijo','P012',NULL,NULL),
('T023','6045557790','fijo','P013',NULL,NULL),
('T024','6045557791','fijo','P014',NULL,NULL),
('T025','6045557792','fijo','P015',NULL,NULL),

('T026','6045557793','fijo','P016',NULL,NULL),
('T027','6045557794','fijo','P017',NULL,NULL),
('T028','6045557795','fijo','P018',NULL,NULL),
('T029','6045557796','fijo','P019',NULL,NULL),
('T030','6045557797','fijo','P020',NULL,NULL);

-- 
-- cita
-- 
INSERT INTO cita VALUES
('CIT001', CURRENT_DATE + 1, 'programada','P001','M01','D001'),
('CIT002', CURRENT_DATE + 2, 'atendida','P002','M02','D002'),
('CIT003', CURRENT_DATE + 3, 'programada','P003','M03','D003'),
('CIT004', CURRENT_DATE + 4, 'cancelada','P004','M04','D004'),
('CIT005', CURRENT_DATE + 5, 'programada','P005','M05','D005'),

('CIT006', CURRENT_DATE + 6, 'programada','P006','M06','D006'),
('CIT007', CURRENT_DATE + 7, 'atendida','P007','M07','D007'),
('CIT008', CURRENT_DATE + 8, 'programada','P008','M08','D008'),
('CIT009', CURRENT_DATE + 9, 'programada','P009','M09','D009'),
('CIT010', CURRENT_DATE + 10, 'programada','P010','M10','D010'),

('CIT011', CURRENT_DATE + 11, 'programada','P011','M11','D011'),
('CIT012', CURRENT_DATE + 12, 'programada','P012','M12','D012'),
('CIT013', CURRENT_DATE + 13, 'atendida','P013','M13','D013'),
('CIT014', CURRENT_DATE + 14, 'cancelada','P014','M14','D014'),
('CIT015', CURRENT_DATE + 15, 'programada','P015','M15','D015'),

('CIT016', CURRENT_DATE + 16, 'programada','P016','M16','D016'),
('CIT017', CURRENT_DATE + 17, 'atendida','P017','M17','D017'),
('CIT018', CURRENT_DATE + 18, 'programada','P018','M18','D018'),
('CIT019', CURRENT_DATE + 19, 'programada','P019','M19','D019'),
('CIT020', CURRENT_DATE + 20, 'programada','P020','M20','D020');

-- Prompt utilizado:
-- "Genera 20 citas con fechas posteriores al día actual,
-- respetando el CHECK que exige que la fecha programada
-- sea mayor que la fecha del sistema."

-- 
-- consulta
-- 
INSERT INTO consulta VALUES
('CONS001','2024-02-06','P001','M01','T001'),
('CONS002','2024-02-05','P002','M02','T002'),
('CONS003','2024-01-21','P003','M03','T003'),
('CONS004','2024-02-12','P004','M04','T004'),
('CONS005','2024-03-05','P005','M05','T005'),

('CONS006','2024-01-29','P006','M06','T006'),
('CONS007','2024-03-08','P007','M07','T007'),
('CONS008','2024-03-11','P008','M08','T008'),
('CONS009','2024-02-23','P009','M09','T009'),
('CONS010','2024-01-14','P010','M10','T010'),

('CONS011','2024-02-08','P011','M11','T011'),
('CONS012','2024-03-17','P012','M12','T012'),
('CONS013','2024-01-31','P013','M13','T013'),
('CONS014','2024-02-17','P014','M14','T014'),
('CONS015','2024-01-24','P015','M15','T015'),

('CONS016','2024-02-10','P016','M16','T016'),
('CONS017','2024-03-16','P017','M17','T017'),
('CONS018','2024-03-06','P018','M18','T018'),
('CONS019','2024-01-22','P019','M19','T019'),
('CONS020','2024-02-20','P020','M20','T020');

-- prescripcion
INSERT INTO prescripcion VALUES
('PR001','2024-02-01','T001','MED01','P001'),
('PR002','2024-02-03','T002','MED02','P002'),
('PR003','2024-01-15','T003','MED03','P003'),
('PR004','2024-02-11','T004','MED04','P004'),
('PR005','2024-03-01','T005','MED05','P005'),

('PR006','2024-01-25','T006','MED06','P006'),
('PR007','2024-03-02','T007','MED07','P007'),
('PR008','2024-03-07','T008','MED08','P008'),
('PR009','2024-02-18','T009','MED09','P009'),
('PR010','2024-01-09','T010','MED10','P010'),

('PR011','2024-02-02','T011','MED01','P011'),
('PR012','2024-03-12','T012','MED02','P012'),
('PR013','2024-01-28','T013','MED03','P013'),
('PR014','2024-02-15','T014','MED04','P014'),
('PR015','2024-01-20','T015','MED05','P015'),

('PR016','2024-02-05','T016','MED06','P016'),
('PR017','2024-03-11','T017','MED07','P017'),
('PR018','2024-03-03','T018','MED08','P018'),
('PR019','2024-01-14','T019','MED09','P019'),
('PR020','2024-02-17','T020','MED10','P020');

-- 
-- tarjeta
-- 
INSERT INTO tarjeta VALUES
('TR001','activa','2024-02-01','P001'),
('TR002','activa','2024-02-03','P002'),
('TR003','activa','2024-01-15','P003'),
('TR004','activa','2024-02-10','P004'),
('TR005','activa','2024-03-01','P005'),

('TR006','activa','2024-01-25','P006'),
('TR007','activa','2024-03-02','P007'),
('TR008','activa','2024-03-07','P008'),
('TR009','activa','2024-02-18','P009'),
('TR010','activa','2024-01-09','P010'),

('TR011','activa','2024-02-02','P011'),
('TR012','activa','2024-03-12','P012'),
('TR013','activa','2024-01-28','P013'),
('TR014','activa','2024-02-15','P014'),
('TR015','activa','2024-01-20','P015'),

('TR016','activa','2024-02-05','P016'),
('TR017','activa','2024-03-11','P017'),
('TR018','activa','2024-03-03','P018'),
('TR019','activa','2024-01-14','P019'),
('TR020','activa','2024-02-17','P020');

-- 
-- visita
-- 
INSERT INTO visita VALUES
('V001','Carlos','Gómez','2024-02-01','A001','TR001'),
('V002','María','Salas','2024-02-03','A002','TR002'),
('V003','Ana','Vélez','2024-01-15','A003','TR003'),
('V004','Laura','Jiménez','2024-02-10','A004','TR004'),
('V005','Nicolás','Cano','2024-03-01','A005','TR005'),

('V006','Sofía','Mesa','2024-01-25','A006','TR006'),
('V007','Daniel','Zapata','2024-03-02','A007','TR007'),
('V008','Manuela','Ortiz','2024-03-07','A008','TR008'),
('V009','Fernando','García','2024-02-18','A009','TR009'),
('V010','Paola','Guzmán','2024-01-09','A010','TR010'),

('V011','Esteban','Bedoya','2024-02-02','A011','TR011'),
('V012','Juliana','Soto','2024-03-12','A012','TR012'),
('V013','Clara','Álvarez','2024-01-28','A013','TR013'),
('V014','Hernán','Ríos','2024-02-15','A014','TR014'),
('V015','Daniela','Rúa','2024-01-20','A015','TR015'),

('V016','Jimmy','Quintana','2024-02-05','A016','TR016'),
('V017','Gabriel','Montoya','2024-03-11','A017','TR017'),
('V018','Lorena','Valencia','2024-03-03','A018','TR018'),
('V019','Óscar','Mora','2024-01-14','A019','TR019'),
('V020','Karen','Patiño','2024-02-17','A020','TR020');

-- 
-- familiar
-- 
INSERT INTO familiar VALUES
('FAM001','Carlos','Restrepo','padre','P001'),
('FAM002','María','García','madre','P002'),
('FAM003','Ana','López','madre','P003'),
('FAM004','Jorge','Orozco','padre','P004'),
('FAM005','Luisa','Montoya','madre','P005'),

('FAM006','Fernando','Gómez','padre','P006'),
('FAM007','Claudia','Zapata','madre','P007'),
('FAM008','Patricia','Cano','madre','P008'),
('FAM009','Ricardo','Vásquez','padre','P009'),
('FAM010','Sonia','Pérez','madre','P010'),

('FAM011','Andrea','Ramírez','madre','P011'),
('FAM012','Óscar','Cárdenas','padre','P012'),
('FAM013','Julia','Usme','madre','P013'),
('FAM014','Gabriel','Guzmán','padre','P014'),
('FAM015','Cristina','Ruiz','madre','P015'),

('FAM016','Héctor','Valencia','padre','P016'),
('FAM017','Marta','Ocampo','madre','P017'),
('FAM018','Gloria','Torres','madre','P018'),
('FAM019','Alfredo','Martínez','padre','P019'),
('FAM020','Beatriz','Arango','madre','P020');
-- ============================================================
-- FIN DEL ARCHIVO
-- ============================================================