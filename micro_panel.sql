-- ============================================
-- Creación de tablas base
-- ============================================

CREATE TABLE alerta_tipo (
    id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

CREATE TABLE prioridad (
    id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

-- ============================================
-- Creación de tabla principal: alerta
-- ============================================

CREATE TABLE alerta (
    id INT PRIMARY KEY,
    alert_type INT,
    responsible VARCHAR(100) NOT NULL,
    priority INT,
    driver VARCHAR(100) NOT NULL,
    generating_unit VARCHAR(100) NOT NULL,
    state VARCHAR(50) NOT NULL,
    generation_date DATE NOT NULL,
    created_at DATE NOT NULL,
    CONSTRAINT fk_alert_type FOREIGN KEY (alert_type) REFERENCES alerta_tipo(id),
    CONSTRAINT fk_priority FOREIGN KEY (priority) REFERENCES prioridad(id)
);