-- ============================================================
-- Tarea 6 - Parte #2 del Proyecto de Aula
-- SCRIPTS DE MODIFICACION DE LA BASE DE DATOS (UPDATE, DELETE)
-- ============================================================

-- Miembros del grupo:
-- Cristian Camilo Hernandez Lopez
-- Maria Ortiz Oquendo
-- Sebastian Ramirez Ramos
-- Mydshell Stephannia Usuga Arango

-- ============================================================
-- ======================   UPDATE   ============================
-- ============================================================

-- =======================
-- PACIENTE
-- =======================
UPDATE paciente SET ciudad_origen = 'La Estrella' WHERE id_paciente = 'P010';
UPDATE paciente SET apellido = 'Valencia'       WHERE id_paciente = 'P024';
UPDATE paciente SET id_eps = 'EPS07'            WHERE id_paciente = 'P056';
UPDATE paciente SET pais_nacimiento = 'Venezuela' WHERE id_paciente = 'P033';
UPDATE paciente SET sexo = 'femenino'           WHERE id_paciente = 'P041';

-- P010 – ciudad_origen: se corrigió la ciudad porque el dato registrado estaba equivocado
-- P024 – apellido: se ajustó por error ortográfico detectado en la verificación de datos
-- P056 – id_eps: el paciente realizó cambio de EPS y se actualizó
-- P033 – país_nacimiento: se corrigió tras validar documentos oficiales
-- P041 – sexo: actualización solicitada por el paciente para reflejar su información correcta

-- =======================
-- MEDICO
-- =======================
UPDATE medico SET id_hospital = 'H03'   WHERE id_medico = 'M01';
UPDATE medico SET licencia = 'LIC1002A' WHERE id_medico = 'M02';
UPDATE medico SET apellido_medico = 'Hernandez' WHERE id_medico = 'M07';
UPDATE medico SET id_hospital = 'H09'   WHERE id_medico = 'M12';
UPDATE medico SET nombre = 'Jairo Andres' WHERE id_medico = 'M15';

-- M01 – id_hospital: reasignación laboral del médico a otro hospital
-- M02 – licencia: renovación de licencia profesional, se actualizó el número vigente
-- M07 – apellido: corrección por inconsistencia en el registro
-- M12 – id_hospital: traslado temporal a otra sede hospitalaria.
-- M15 – nombre: se ajustó para coincidir con su nombre oficial completo

-- =======================
-- ESPECIALIDAD
-- =======================
UPDATE especialidad SET descripcion = 'Atencion integral a menores de edad' WHERE id_especialidad = 'ESP01';
UPDATE especialidad SET nombre = 'Neurocirugia' WHERE id_especialidad = 'ESP04';
UPDATE especialidad SET descripcion = 'Diagnostico y tratamiento de la piel y sus anexos' WHERE id_especialidad = 'ESP07';
UPDATE especialidad SET nombre = 'Oncologia Clinica' WHERE id_especialidad = 'ESP10';
UPDATE especialidad SET nombre = 'Ginecologia y Obstetricia' WHERE id_especialidad = 'ESP05';

-- ESP01 – descripción: se amplió para mayor claridad del servicio
-- ESP04 – nombre: actualización para usar la nomenclatura correcta de “Neurocirugía”
-- ESP07 – descripción: se mejoró la precisión del alcance de la especialidad
-- ESP10 – nombre: cambio para reflejar la denominación correcta para “Oncología Clínica”
-- ESP05 – nombre: ajuste a la forma completa y oficial de “Ginecología y Obstetricia”

-- =======================
-- ENFERMERA
-- =======================
UPDATE enfermera SET id_hospital = 'H07' WHERE id_enfermera = 'E02';
UPDATE enfermera SET nombre = 'Carla'    WHERE id_enfermera = 'E04';
UPDATE enfermera SET apellido = 'Montes' WHERE id_enfermera = 'E06';
UPDATE enfermera SET sexo = 'otro'       WHERE id_enfermera = 'E09';
UPDATE enfermera SET id_hospital = 'H10' WHERE id_enfermera = 'E08';

-- E02 – id_hospital: traslado interno por necesidad de servicio
-- E04 – nombre: corrección de dato incompleto
-- E06 – apellido: ajuste por error en el registro
-- E09 – sexo: actualización por solicitud de la persona
-- E08 – id_hospital: reubicación temporal

-- =======================
-- HOSPITAL
-- =======================
UPDATE hospital SET nombre_hospital = 'Clinica Medellin Norte' WHERE id_hospital = 'H01';
UPDATE hospital SET nivel_planta = 7 WHERE id_hospital = 'H02';
UPDATE hospital SET id_ubicacion = 'U010' WHERE id_hospital = 'H04';
UPDATE hospital SET nombre_hospital = 'Hospital San Jose' WHERE id_hospital = 'H07';
UPDATE hospital SET nivel_planta = 4 WHERE id_hospital = 'H08';

-- H01 – nombre: cambio por actualización institucional
-- H02 – nivel_planta: aumento de niveles por ampliación física
-- H04 – id_ubicacion: reajuste administrativo de ubicación
-- H07 – nombre: cambió debido a rebranding del hospital
-- H08 – nivel_planta: se actualizó por remodelación estructural

-- =======================
-- HOSPITALIZACION
-- =======================
UPDATE registro SET motivo = 'Complicacion respiratoria' WHERE id_registro = 'R001';
UPDATE registro SET id_cama = 'C015'                     WHERE id_registro = 'R010';
UPDATE registro SET fecha_salida = '2024-03-20'          WHERE id_registro = 'R025';
UPDATE registro SET id_medico = 'M20'                    WHERE id_registro = 'R033';
UPDATE registro SET tipo = 'control'                     WHERE id_registro = 'R050';

-- R001 – motivo: se actualizó para reflejar el diagnóstico correcto
-- R010 – id_cama: trasladado a otra cama disponible
-- R025 – fecha_salida: cambio por extensión de la hospitalización
-- R033 – id_medico: reasignación del médico responsable
-- R050 – tipo: ajustado a “control” para reflejar la naturaleza real del registro

-- ============================================================
-- =======================   DELETE   ==========================
-- ============================================================

-- =======================
-- PACIENTE
-- =======================

-- ======================== P095 ==============================
DELETE FROM prescripcion 
WHERE id_tratamiento IN (
    SELECT id_tratamiento FROM tratamiento 
    WHERE id_diagnostico IN (SELECT id_diagnostico FROM diagnostico WHERE id_paciente = 'P095')
);

DELETE FROM consulta 
WHERE id_tratamiento IN (
    SELECT id_tratamiento FROM tratamiento 
    WHERE id_diagnostico IN (SELECT id_diagnostico FROM diagnostico WHERE id_paciente = 'P095')
);

DELETE FROM cita
WHERE id_diagnostico IN (
    SELECT id_diagnostico FROM diagnostico WHERE id_paciente = 'P095'
);

DELETE FROM tratamiento 
WHERE id_diagnostico IN (SELECT id_diagnostico FROM diagnostico WHERE id_paciente = 'P095');

DELETE FROM diagnostico WHERE id_paciente = 'P095';

DELETE FROM entrada  WHERE id_registro IN (SELECT id_registro FROM registro WHERE id_paciente = 'P095');
DELETE FROM alta     WHERE id_registro IN (SELECT id_registro FROM registro WHERE id_paciente = 'P095');
DELETE FROM registro WHERE id_paciente = 'P095';

DELETE FROM visita WHERE id_autorizacion IN (SELECT id_autorizacion FROM autorizacion WHERE id_paciente = 'P095');
DELETE FROM visita WHERE id_tarjeta       IN (SELECT id_tarjeta FROM tarjeta WHERE id_paciente = 'P095');

DELETE FROM autorizacion WHERE id_paciente = 'P095';
DELETE FROM tarjeta      WHERE id_paciente = 'P095';

DELETE FROM familiar WHERE id_paciente = 'P095';
DELETE FROM telefono WHERE id_paciente = 'P095';

DELETE FROM paciente WHERE id_paciente = 'P095';

-- ======================== P083 ==============================
DELETE FROM prescripcion WHERE id_tratamiento IN (
    SELECT id_tratamiento FROM tratamiento WHERE id_diagnostico IN (
        SELECT id_diagnostico FROM diagnostico WHERE id_paciente = 'P083'
    )
);

DELETE FROM consulta WHERE id_tratamiento IN (
    SELECT id_tratamiento FROM tratamiento WHERE id_diagnostico IN (
        SELECT id_diagnostico FROM diagnostico WHERE id_paciente = 'P083'
    )
);

DELETE FROM cita
WHERE id_diagnostico IN (
    SELECT id_diagnostico FROM diagnostico WHERE id_paciente = 'P083'
);

DELETE FROM tratamiento 
WHERE id_diagnostico IN (SELECT id_diagnostico FROM diagnostico WHERE id_paciente = 'P083');

DELETE FROM diagnostico WHERE id_paciente = 'P083';

DELETE FROM entrada  WHERE id_registro IN (SELECT id_registro FROM registro WHERE id_paciente = 'P083');
DELETE FROM alta     WHERE id_registro IN (SELECT id_registro FROM registro WHERE id_paciente = 'P083');
DELETE FROM registro WHERE id_paciente = 'P083';

DELETE FROM visita WHERE id_autorizacion IN (SELECT id_autorizacion FROM autorizacion WHERE id_paciente = 'P083');
DELETE FROM visita WHERE id_tarjeta       IN (SELECT id_tarjeta FROM tarjeta WHERE id_paciente = 'P083');

DELETE FROM autorizacion WHERE id_paciente = 'P083';
DELETE FROM tarjeta      WHERE id_paciente = 'P083';

DELETE FROM familiar WHERE id_paciente = 'P083';
DELETE FROM telefono WHERE id_paciente = 'P083';

DELETE FROM paciente WHERE id_paciente = 'P083';

-- ======================== P044 ==============================
DELETE FROM prescripcion WHERE id_tratamiento IN (
    SELECT id_tratamiento FROM tratamiento WHERE id_diagnostico IN (
        SELECT id_diagnostico FROM diagnostico WHERE id_paciente = 'P044'
    )
);

DELETE FROM consulta WHERE id_tratamiento IN (
    SELECT id_tratamiento FROM tratamiento WHERE id_diagnostico IN (
        SELECT id_diagnostico FROM diagnostico WHERE id_paciente = 'P044'
    )
);

DELETE FROM cita
WHERE id_diagnostico IN (
    SELECT id_diagnostico FROM diagnostico WHERE id_paciente = 'P044'
);

DELETE FROM tratamiento WHERE id_diagnostico IN (
    SELECT id_diagnostico FROM diagnostico WHERE id_paciente = 'P044'
);

DELETE FROM diagnostico WHERE id_paciente = 'P044';

DELETE FROM entrada  WHERE id_registro IN (SELECT id_registro FROM registro WHERE id_paciente = 'P044');
DELETE FROM alta     WHERE id_registro IN (SELECT id_registro FROM registro WHERE id_paciente = 'P044');
DELETE FROM registro WHERE id_paciente = 'P044';

DELETE FROM visita WHERE id_autorizacion IN (SELECT id_autorizacion FROM autorizacion WHERE id_paciente = 'P044');
DELETE FROM visita WHERE id_tarjeta       IN (SELECT id_tarjeta      FROM tarjeta      WHERE id_paciente = 'P044');

DELETE FROM autorizacion WHERE id_paciente = 'P044';
DELETE FROM tarjeta      WHERE id_paciente = 'P044';

DELETE FROM familiar WHERE id_paciente = 'P044';
DELETE FROM telefono WHERE id_paciente = 'P044';

DELETE FROM paciente WHERE id_paciente = 'P044';

-- ======================== P018 ==============================
DELETE FROM prescripcion WHERE id_tratamiento IN (
    SELECT id_tratamiento FROM tratamiento WHERE id_diagnostico IN (
        SELECT id_diagnostico FROM diagnostico WHERE id_paciente = 'P018'
    )
);

DELETE FROM consulta WHERE id_tratamiento IN (
    SELECT id_tratamiento FROM tratamiento WHERE id_diagnostico IN (
        SELECT id_diagnostico FROM diagnostico WHERE id_paciente = 'P018'
    )
);

DELETE FROM cita
WHERE id_diagnostico IN (
    SELECT id_diagnostico FROM diagnostico WHERE id_paciente = 'P018'
);

DELETE FROM tratamiento WHERE id_diagnostico IN (
    SELECT id_diagnostico FROM diagnostico WHERE id_paciente = 'P018'
);

DELETE FROM diagnostico WHERE id_paciente = 'P018';

DELETE FROM entrada  WHERE id_registro IN (SELECT id_registro FROM registro WHERE id_paciente = 'P018');
DELETE FROM alta     WHERE id_registro IN (SELECT id_registro FROM registro WHERE id_paciente = 'P018');
DELETE FROM registro WHERE id_paciente = 'P018';

DELETE FROM visita WHERE id_autorizacion IN (SELECT id_autorizacion FROM autorizacion WHERE id_paciente = 'P018');
DELETE FROM visita WHERE id_tarjeta       IN (SELECT id_tarjeta      FROM tarjeta      WHERE id_paciente = 'P018');

DELETE FROM autorizacion WHERE id_paciente = 'P018';
DELETE FROM tarjeta      WHERE id_paciente = 'P018';

DELETE FROM familiar WHERE id_paciente = 'P018';
DELETE FROM telefono WHERE id_paciente = 'P018';

DELETE FROM paciente WHERE id_paciente = 'P018';

-- ======================== P012 ==============================
DELETE FROM prescripcion WHERE id_tratamiento IN (
    SELECT id_tratamiento FROM tratamiento WHERE id_diagnostico IN (
        SELECT id_diagnostico FROM diagnostico WHERE id_paciente = 'P012'
    )
);

DELETE FROM consulta WHERE id_tratamiento IN (
    SELECT id_tratamiento FROM tratamiento WHERE id_diagnostico IN (
        SELECT id_diagnostico FROM diagnostico WHERE id_paciente = 'P012'
    )
);

DELETE FROM cita
WHERE id_diagnostico IN (
    SELECT id_diagnostico FROM diagnostico WHERE id_paciente = 'P012'
);

DELETE FROM tratamiento WHERE id_diagnostico IN (
    SELECT id_diagnostico FROM diagnostico WHERE id_paciente = 'P012'
);

DELETE FROM diagnostico WHERE id_paciente = 'P012';

DELETE FROM entrada  WHERE id_registro IN (SELECT id_registro FROM registro WHERE id_paciente = 'P012');
DELETE FROM alta     WHERE id_registro IN (SELECT id_registro FROM registro WHERE id_paciente = 'P012');
DELETE FROM registro WHERE id_paciente = 'P012';

DELETE FROM visita WHERE id_autorizacion IN (SELECT id_autorizacion FROM autorizacion WHERE id_paciente = 'P012');
DELETE FROM visita WHERE id_tarjeta       IN (SELECT id_tarjeta      FROM tarjeta      WHERE id_paciente = 'P012');

DELETE FROM autorizacion WHERE id_paciente = 'P012';
DELETE FROM tarjeta      WHERE id_paciente = 'P012';

DELETE FROM familiar WHERE id_paciente = 'P012';
DELETE FROM telefono WHERE id_paciente = 'P012';

DELETE FROM paciente WHERE id_paciente = 'P012';

-- P095: el paciente no tenía continuidad en el sistema y sus registros estaban incompletos; se eliminaron todas las dependencias para evitar inconsistencias
-- P083: eliminado por duplicidad detectada en la identificación del paciente; se removieron registros asociados para mantener integridad
-- P044: eliminado debido a un registro incorrecto creado durante el poblamiento; se retiraron todas las relaciones para mantener coherencia
-- P018: caso clínico cerrado por error de digitación en la creación del paciente; se eliminaron referencias para no afectar consultas futuras
-- P012: eliminado por ser un registro ingresado de manera duplicada; se limpiaron dependencias en diagnóstico, visita, autorizacion y registro

-- =======================
-- MEDICO
-- =======================

-- ======================== M29 ==============================
DELETE FROM prescripcion 
WHERE id_tratamiento IN (
    SELECT id_tratamiento FROM tratamiento 
    WHERE id_diagnostico IN (
        SELECT id_diagnostico FROM diagnostico WHERE id_medico = 'M29'
    )
);

DELETE FROM consulta 
WHERE id_tratamiento IN (
    SELECT id_tratamiento FROM tratamiento 
    WHERE id_diagnostico IN (
        SELECT id_diagnostico FROM diagnostico WHERE id_medico = 'M29'
    )
);

DELETE FROM cita 
WHERE id_diagnostico IN (
    SELECT id_diagnostico FROM diagnostico WHERE id_medico = 'M29'
);

DELETE FROM tratamiento 
WHERE id_diagnostico IN (
    SELECT id_diagnostico FROM diagnostico WHERE id_medico = 'M29'
);

DELETE FROM diagnostico WHERE id_medico = 'M29';

DELETE FROM registro WHERE id_medico = 'M29';
DELETE FROM telefono WHERE id_medico = 'M29';
DELETE FROM medico WHERE id_medico = 'M29';

-- ======================== M27 ==============================
DELETE FROM prescripcion 
WHERE id_tratamiento IN (
    SELECT id_tratamiento FROM tratamiento 
    WHERE id_diagnostico IN (
        SELECT id_diagnostico FROM diagnostico WHERE id_medico = 'M27'
    )
);

DELETE FROM consulta 
WHERE id_tratamiento IN (
    SELECT id_tratamiento FROM tratamiento 
    WHERE id_diagnostico IN (
        SELECT id_diagnostico FROM diagnostico WHERE id_medico = 'M27'
    )
);

DELETE FROM cita 
WHERE id_diagnostico IN (
    SELECT id_diagnostico FROM diagnostico WHERE id_medico = 'M27'
);

DELETE FROM tratamiento 
WHERE id_diagnostico IN (
    SELECT id_diagnostico FROM diagnostico WHERE id_medico = 'M27'
);

DELETE FROM diagnostico WHERE id_medico = 'M27';

DELETE FROM registro WHERE id_medico = 'M27';
DELETE FROM telefono WHERE id_medico = 'M27';
DELETE FROM medico WHERE id_medico = 'M27';

-- ======================== M14 ==============================
DELETE FROM prescripcion
WHERE id_tratamiento IN (
    SELECT id_tratamiento FROM tratamiento
    WHERE id_diagnostico IN (
        SELECT id_diagnostico FROM diagnostico WHERE id_medico = 'M14'
    )
);

DELETE FROM consulta
WHERE id_tratamiento IN (
    SELECT id_tratamiento FROM tratamiento
    WHERE id_diagnostico IN (
        SELECT id_diagnostico FROM diagnostico WHERE id_medico = 'M14'
    )
);

DELETE FROM cita
WHERE id_diagnostico IN (
    SELECT id_diagnostico FROM diagnostico WHERE id_medico = 'M14'
);

DELETE FROM tratamiento
WHERE id_diagnostico IN (
    SELECT id_diagnostico FROM diagnostico WHERE id_medico = 'M14'
);

DELETE FROM entrada
WHERE id_registro IN (
    SELECT id_registro FROM registro WHERE id_medico = 'M14'
);

DELETE FROM alta
WHERE id_registro IN (
    SELECT id_registro FROM registro WHERE id_medico = 'M14'
);

DELETE FROM diagnostico WHERE id_medico = 'M14';
DELETE FROM registro    WHERE id_medico = 'M14';
DELETE FROM telefono    WHERE id_medico = 'M14';
DELETE FROM medico      WHERE id_medico = 'M14';

-- ======================== M09 ==============================
DELETE FROM prescripcion
WHERE id_tratamiento IN (
    SELECT id_tratamiento FROM tratamiento
    WHERE id_diagnostico IN (
        SELECT id_diagnostico FROM diagnostico WHERE id_medico = 'M09'
    )
);

DELETE FROM consulta
WHERE id_tratamiento IN (
    SELECT id_tratamiento FROM tratamiento
    WHERE id_diagnostico IN (
        SELECT id_diagnostico FROM diagnostico WHERE id_medico = 'M09'
    )
);

DELETE FROM cita
WHERE id_diagnostico IN (
    SELECT id_diagnostico FROM diagnostico WHERE id_medico = 'M09'
);

DELETE FROM tratamiento
WHERE id_diagnostico IN (
    SELECT id_diagnostico FROM diagnostico WHERE id_medico = 'M09'
);

DELETE FROM entrada
WHERE id_registro IN (
    SELECT id_registro FROM registro WHERE id_medico = 'M09'
);

DELETE FROM alta
WHERE id_registro IN (
    SELECT id_registro FROM registro WHERE id_medico = 'M09'
);

DELETE FROM diagnostico WHERE id_medico = 'M09';
DELETE FROM registro    WHERE id_medico = 'M09';
DELETE FROM telefono    WHERE id_medico = 'M09';
DELETE FROM medico      WHERE id_medico = 'M09';

-- ======================== M04 ==============================
DELETE FROM prescripcion 
WHERE id_tratamiento IN (
    SELECT id_tratamiento FROM tratamiento 
    WHERE id_diagnostico IN (
        SELECT id_diagnostico FROM diagnostico WHERE id_medico = 'M04'
    )
);

DELETE FROM consulta 
WHERE id_tratamiento IN (
    SELECT id_tratamiento FROM tratamiento 
    WHERE id_diagnostico IN (
        SELECT id_diagnostico FROM diagnostico WHERE id_medico = 'M04'
    )
);

DELETE FROM cita 
WHERE id_diagnostico IN (
    SELECT id_diagnostico FROM diagnostico WHERE id_medico = 'M04'
);

DELETE FROM tratamiento 
WHERE id_diagnostico IN (
    SELECT id_diagnostico FROM diagnostico WHERE id_medico = 'M04'
);

DELETE FROM entrada
WHERE id_registro IN (
    SELECT id_registro FROM registro WHERE id_medico = 'M04'
);

DELETE FROM alta
WHERE id_registro IN (
    SELECT id_registro FROM registro WHERE id_medico = 'M04'
);

DELETE FROM diagnostico WHERE id_medico = 'M04';
DELETE FROM registro    WHERE id_medico = 'M04';
DELETE FROM telefono    WHERE id_medico = 'M04';
DELETE FROM medico      WHERE id_medico = 'M04';

-- M29: se eliminó porque ya no forma parte del sistema hospitalario; se removieron diagnósticos y tratamientos asociados
-- M27: eliminado por duplicidad en la base de datos; se retiraron registros dependientes para conservar la integridad referencial
-- M14: eliminado por error de creación; tenía registros asociados que debían depurarse para evitar conflictos de llaves foráneas
-- M09: eliminado por inconsistencias detectadas en su información profesional; se limpiaron cita, diagnóstico y entrada asociadas
-- M04: registro creado erróneamente durante pruebas de poblamiento; se borraron todas las dependencias para mantener consistencia

-- =======================
-- ESPECIALIDAD
-- =======================

DELETE FROM especialidad WHERE id_especialidad = 'ESP11';
DELETE FROM especialidad WHERE id_especialidad = 'ESP12';

-- ESP11: eliminada por no estar en uso.
-- ESP12: eliminada por no estar en uso.

-- =======================
-- ENFERMERA
-- =======================
DELETE FROM enfermera WHERE id_enfermera = 'E10';
DELETE FROM enfermera WHERE id_enfermera = 'E08';
DELETE FROM enfermera WHERE id_enfermera = 'E06';
DELETE FROM enfermera WHERE id_enfermera = 'E03';
DELETE FROM enfermera WHERE id_enfermera = 'E01';

-- E10: eliminada por ser un registro de prueba que no correspondía a personal real
-- E08: eliminada por reubicación y depuración del personal duplicado
-- E06: eliminada por inconsistencias en datos personales que generaban conflicto
-- E03: eliminada por duplicidad dentro de la tabla
-- E01: eliminada por ser un registro de prueba inicial 

-- =======================
-- HOSPITAL
-- =======================
DELETE FROM hospital
WHERE id_hospital IN ('H20','H21','H22','H23','H24');

-- H20: eliminado por ser una creación auxiliar privada
-- H21:  eliminado por ser una creación auxiliar privada
-- H22: eliminado por ser una creación auxiliar privada
-- H23: eliminado por ser una creación auxiliar privada
-- H24:  eliminado por ser una creación auxiliar privada

-- =======================
-- HOSPITALIZACION
-- =======================
DELETE FROM entrada  WHERE id_registro IN ('R099','R088','R054','R040','R027');
DELETE FROM alta     WHERE id_registro IN ('R099','R088','R054','R040','R027');
DELETE FROM registro WHERE id_registro IN ('R099','R088','R054','R040','R027');

-- R099: registro eliminado por ser de pruebas y no contener datos válidos
-- R088: eliminado para depurar inconsistencias en fechas y campos faltantes
-- R054: eliminado por registro incompleto creado accidentalmente
-- R040: eliminado por datos erróneos en campos clave
-- R027: eliminado por ser duplicado de otro registro clínico existente

-- ============================================================
-- FIN DEL ARCHIVO
-- ============================================================