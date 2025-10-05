DROP TABLE IF EXISTS role_permission CASCADE;
DROP TABLE IF EXISTS user_role CASCADE;
DROP TABLE IF EXISTS "User" CASCADE;
DROP TABLE IF EXISTS Role CASCADE;
DROP TABLE IF EXISTS Permission CASCADE;
DROP TABLE IF EXISTS UserDocumentType CASCADE;

-- =====================================
--  ENUMERACIONES
-- =====================================

-- Tipos de documento
CREATE TYPE user_document_type_enum AS ENUM (
    'CEDULA_CIUDADANIA',
    'TARJETA_IDENTIDAD',
    'CEDULA_EXTRANJERIA',
    'PASAPORTE',
    'REGISTRO_CIVIL',
    'REGISTRO_ESPECIAL_PERMANENCIA'
);

-- Roles del sistema
CREATE TYPE role_enum AS ENUM (
    'CONDUCTOR',
    'ADMINISTRADOR',
    'OPERADOR'
);

-- Permisos del sistema
CREATE TYPE permission_enum AS ENUM (
    'CREATE',
    'READ',
    'UPDATE',
    'DELETE'
);

-- =====================================
--  TABLAS PRINCIPALES
-- =====================================

-- Tabla UserDocumentType
CREATE TABLE UserDocumentType (
    id SERIAL PRIMARY KEY,
    user_document_type user_document_type_enum NOT NULL UNIQUE
);

-- Tabla Permission
CREATE TABLE Permission (
    id SERIAL PRIMARY KEY,
    nombre permission_enum NOT NULL UNIQUE
);

-- Tabla Role
CREATE TABLE Role (
    id SERIAL PRIMARY KEY,
    name role_enum NOT NULL UNIQUE
);

-- Tabla User
CREATE TABLE "User" (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    lastName VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    document_type_id INT NOT NULL REFERENCES UserDocumentType(id) ON DELETE RESTRICT,
    account_no_expired BOOLEAN DEFAULT TRUE,
    account_no_locked BOOLEAN DEFAULT TRUE,
    credential_no_expired BOOLEAN DEFAULT TRUE,
    is_enable BOOLEAN DEFAULT TRUE
);

-- =====================================
--  TABLAS INTERMEDIAS (N:M)
-- =====================================

-- Relación Role - Permission (N:M)
CREATE TABLE role_permission (
    role_id INT REFERENCES Role(id) ON DELETE CASCADE,
    permission_id INT REFERENCES Permission(id) ON DELETE CASCADE,
    PRIMARY KEY (role_id, permission_id)
);

-- Relación User - Role (N:M)
CREATE TABLE user_role (
    user_id INT REFERENCES "User"(id) ON DELETE CASCADE,
    role_id INT REFERENCES Role(id) ON DELETE CASCADE,
    PRIMARY KEY (user_id, role_id)
);


-- INSERCIÓN DE DATOS DE PRUEBA
-- Tipos de documento
INSERT INTO UserDocumentType (user_document_type) VALUES
('CEDULA_CIUDADANIA'),
('TARJETA_IDENTIDAD'),
('CEDULA_EXTRANJERIA'),
('PASAPORTE'),
('REGISTRO_CIVIL'),
('REGISTRO_ESPECIAL_PERMANENCIA');

-- Roles
INSERT INTO Role (name) VALUES
('ADMINISTRADOR'),
('CONDUCTOR'),
('OPERADOR');

-- Permisos
INSERT INTO Permission (nombre) VALUES
('CREATE'),
('READ'),
('UPDATE'),
('DELETE');

-- Usuarios
INSERT INTO "User" (name, lastName, email, password, document_type_id)
VALUES
('Carlos', 'Gómez', 'carlos@example.com', 'hashedpassword1', 1),
('Ana', 'López', 'ana@example.com', 'hashedpassword2', 2),
('Miguel', 'Pérez', 'miguel@example.com', 'hashedpassword3', 1),
('Laura', 'Rodríguez', 'laura@example.com', 'hashedpassword4', 4);

-- Relación User - Role
INSERT INTO user_role (user_id, role_id) VALUES
(1, 1),  -- Carlos → ADMINISTRADOR
(2, 2),  -- Ana → CONDUCTOR
(3, 3),  -- Miguel → OPERADOR
(4, 2);  -- Laura → CONDUCTOR

-- Relación Role - Permission
INSERT INTO role_permission (role_id, permission_id) VALUES
(1, 1), (1, 2), (1, 3), (1, 4), -- ADMINISTRADOR: todos los permisos
(2, 2),                         -- CONDUCTOR: READ
(3, 2), (3, 3);                 -- OPERADOR: READ, UPDATE


-- Usuario por id con toda su información
SELECT 
    u.id,
    u.name,
    u.lastName,
    u.email,
    ud.user_document_type AS tipo_documento,
    ARRAY_AGG(r.name) AS roles,
    u.account_no_expired,
    u.account_no_locked,
    u.credential_no_expired,
    u.is_enable
FROM "User" u
JOIN UserDocumentType ud ON u.document_type_id = ud.id
LEFT JOIN user_role ur ON u.id = ur.user_id
LEFT JOIN Role r ON ur.role_id = r.id
WHERE u.id = 1 
GROUP BY 
    u.id, 
    u.name, 
    u.lastName, 
    u.email, 
    ud.user_document_type,
    u.account_no_expired,
    u.account_no_locked,
    u.credential_no_expired,
    u.is_enable;

-- Usuario por email con toda su información
SELECT 
    u.id,
    u.name,
    u.lastName,
    u.email,
    ud.user_document_type AS tipo_documento,
    ARRAY_AGG(r.name) AS roles,
    u.account_no_expired,
    u.account_no_locked,
    u.credential_no_expired,
    u.is_enable
FROM "User" u
JOIN UserDocumentType ud ON u.document_type_id = ud.id
LEFT JOIN user_role ur ON u.id = ur.user_id
LEFT JOIN Role r ON ur.role_id = r.id
WHERE LOWER(u.email) = LOWER('ana@example.com')  
GROUP BY 
    u.id, 
    u.name, 
    u.lastName, 
    u.email, 
    ud.user_document_type,
    u.account_no_expired,
    u.account_no_locked,
    u.credential_no_expired,
    u.is_enable;
