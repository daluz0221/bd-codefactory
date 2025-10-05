
-- Eliminamos tablas si ya existen (para reiniciar el esquema)
DROP TABLE IF EXISTS TipoAlerta CASCADE;
DROP TABLE IF EXISTS TipoEncargado CASCADE;
DROP TABLE IF EXISTS NivelPrioridad CASCADE;

-- Tabla NivelPrioridad
CREATE TABLE NivelPrioridad (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL
);

-- Tabla TipoEncargado (equivalente al ENUM del modelo)
CREATE TABLE TipoEncargado (
    id SERIAL PRIMARY KEY,
    nombre CHAR(20) NOT NULL UNIQUE
);

-- Tabla TipoAlerta
CREATE TABLE TipoAlerta (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL UNIQUE,
    descripcion VARCHAR(255),
    nivelPrioridad_id INT NOT NULL REFERENCES NivelPrioridad(id) ON DELETE RESTRICT,
    tipoEncargado_id INT NOT NULL REFERENCES TipoEncargado(id) ON DELETE RESTRICT
);



-- INSERCIÓN DE DATOS

-- Insertar valores en NivelPrioridad
INSERT INTO NivelPrioridad (nombre) VALUES
('Bajo'),
('Medio'),
('Alto'),
('Crítico');

-- Insertar valores en TipoEncargado
INSERT INTO TipoEncargado (nombre) VALUES
('MECANICO'),
('CONDUCTOR'),
('SOPORTE_TECNICO'),
('OPERADOR_LOGISTICA'),
('SEGURIDAD');

-- Insertar valores en TipoAlerta
INSERT INTO TipoAlerta (nombre, descripcion, nivelPrioridad_id, tipoEncargado_id) VALUES
('Falla mecánica leve', 'Problemas menores detectados en el sistema.', 1, 1),
('Accidente de tránsito', 'Colisión o incidente vial.', 4, 2),
('Falla en red', 'Problema con la conexión de red interna.', 3, 3),
('Retraso logístico', 'Demora en la entrega de materiales.', 2, 4),
('Alerta de seguridad', 'Incidente en zona restringida.', 4, 5);


-- Consultas realizadas por el backend

-- NivelPriorirda
-- Creación
INSERT INTO NivelPrioridad (nombre)
VALUES ('Nuevo nivel');

-- Obtener todos
SELECT * FROM NivelPrioridad;

-- obtener por id
SELECT * FROM NivelPrioridad
WHERE id = 1;

-- Actualización
UPDATE NivelPrioridad
SET nombre = 'Nivel Actualizado'
WHERE id = 1;

-- Borrado
DELETE FROM NivelPrioridad
WHERE id = 1;

--TipoAlerta
-- Crear
INSERT INTO TipoAlerta (nombre, descripcion, nivelPrioridad_id, tipoEncargado_id)
VALUES ('Nueva alerta', 'Descripción de ejemplo', 2, 3);

-- Obtener todos
SELECT 
    ta.id,
    ta.nombre,
    ta.descripcion,
    np.nombre AS nivel_prioridad,
    te.nombre AS tipo_encargado
FROM TipoAlerta ta
JOIN NivelPrioridad np ON ta.nivelPrioridad_id = np.id
JOIN TipoEncargado te ON ta.tipoEncargado_id = te.id
ORDER BY ta.id;

-- Obtener por Id
SELECT 
    ta.id,
    ta.nombre,
    ta.descripcion,
    np.nombre AS nivel_prioridad,
    te.nombre AS tipo_encargado
FROM TipoAlerta ta
JOIN NivelPrioridad np ON ta.nivelPrioridad_id = np.id
JOIN TipoEncargado te ON ta.tipoEncargado_id = te.id
WHERE ta.id = 1;

-- Actualizar
UPDATE TipoAlerta
SET nombre = 'Alerta Actualizada',
    descripcion = 'Descripción modificada',
    nivelPrioridad_id = 3,
    tipoEncargado_id = 2
WHERE id = 1;
