

CREATE TABLE tipos_documento (
    id BIGSERIAL PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL
);


CREATE TABLE Roles (
    id BIGSERIAL PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL
);

CREATE TABLE Usuarios (
    id BIGSERIAL PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    apellidos VARCHAR(50),
    documento INT NOT NULL UNIQUE,
    id_tipo_documento BIGINT NOT NULL,
    id_rol BIGINT NOT NULL,
    fecha_creacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    activo BOOLEAN DEFAULT TRUE,
    CONSTRAINT fk_tipo_doc FOREIGN KEY (id_tipo_documento) REFERENCES tipos_documento(id),
    CONSTRAINT fk_rol FOREIGN KEY (id_rol) REFERENCES Roles(id)
);


CREATE TABLE tipos_alerta (
    id BIGSERIAL PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL
);


CREATE TABLE niveles_prioridad (
    id BIGSERIAL PRIMARY KEY,
    nombre_nivel VARCHAR(50) NOT NULL,
    cantidad_nivel INT NOT NULL
);


CREATE TABLE Alertas (
    id BIGSERIAL PRIMARY KEY,
    title VARCHAR(50) NOT NULL,
    descripcion VARCHAR(200),
    id_tipo_alerta BIGINT NOT NULL,
    id_nivel_prioridad BIGINT NOT NULL,
    creado_por BIGINT NOT NULL,
    fecha_creacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    activo BOOLEAN DEFAULT TRUE,
    CONSTRAINT fk_tipo_alerta FOREIGN KEY (id_tipo_alerta) REFERENCES tipos_alerta(id),
    CONSTRAINT fk_nivel_prioridad FOREIGN KEY (id_nivel_prioridad) REFERENCES niveles_prioridad(id),
    CONSTRAINT fk_usuario_alerta FOREIGN KEY (creado_por) REFERENCES Usuarios(id)
);


CREATE TABLE ediciones_alerta (
    id BIGSERIAL PRIMARY KEY,
    id_usuario BIGINT NOT NULL,
    id_alerta BIGINT NOT NULL,
    fecha_edicion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    descripcion_cambio VARCHAR(200),
    CONSTRAINT fk_usuario_edicion FOREIGN KEY (id_usuario) REFERENCES Usuarios(id),
    CONSTRAINT fk_alerta_edicion FOREIGN KEY (id_alerta) REFERENCES Alertas(id)
);


-- ===========================
-- DATOS INICIALES
-- ===========================

INSERT INTO tipos_documento (nombre) VALUES ('Cédula de Ciudadanía');
INSERT INTO tipos_documento (nombre) VALUES ('Tarjeta de Identidad');
INSERT INTO tipos_documento (nombre) VALUES ('Pasaporte');


INSERT INTO Roles (nombre) VALUES ('Administrador');
INSERT INTO Roles (nombre) VALUES ('Operador');
INSERT INTO Roles (nombre) VALUES ('Conductor');


INSERT INTO Usuarios (nombre, apellidos, documento, id_tipo_documento, id_rol)
VALUES ('Luis', 'Pérez', 12341313, 1, 1);

INSERT INTO Usuarios (nombre, apellidos, documento, id_tipo_documento, id_rol)
VALUES ('Ana', 'García', 9854412, 3, 2);


INSERT INTO niveles_prioridad (nombre_nivel, cantidad_nivel) VALUES ('Baja', 1);
INSERT INTO niveles_prioridad (nombre_nivel, cantidad_nivel) VALUES ('Media', 2);
INSERT INTO niveles_prioridad (nombre_nivel, cantidad_nivel) VALUES ('Alta', 3);