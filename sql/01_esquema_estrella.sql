-- ESQUEMA: DIMENSIONAL (ESTRELLA)
-- ============================================================

-- 1. TABLA DIMENSIÓN ESTUDIANTE
CREATE TABLE Dim_Estudiante (
    SK_Estudiante SERIAL PRIMARY KEY,      -- Surrogate Key (Clave Sustituta)
    ID_Estudiante_NK INT NOT NULL,         -- Natural Key (Clave Operacional OLTP)
    Nombre_Estudiante VARCHAR(100) NOT NULL,
    Provincia_Origen VARCHAR(50) NOT NULL
);

-- 2. TABLA DIMENSIÓN CURSO
CREATE TABLE Dim_Curso (
    SK_Curso SERIAL PRIMARY KEY,
    ID_Curso_NK INT NOT NULL,
    Nombre_Curso VARCHAR(100) NOT NULL,
    Creditos INT NOT NULL
);

-- 3. TABLA DIMENSIÓN FACULTAD
CREATE TABLE Dim_Facultad (
    SK_Facultad SERIAL PRIMARY KEY,
    ID_Facultad_NK INT NOT NULL,
    Nombre_Facultad VARCHAR(100) NOT NULL
);

-- 4. TABLA DIMENSIÓN TIEMPO
CREATE TABLE Dim_Tiempo (
    SK_Tiempo INT PRIMARY KEY,             -- Formato YYYYMMDD (Ej: 20261006)
    Fecha DATE NOT NULL,
    Anio INT NOT NULL,
    Trimestre INT NOT NULL,
    Mes INT NOT NULL,
    Nombre_Mes VARCHAR(20) NOT NULL,
    Dia INT NOT NULL
);

-- 5. TABLA DE HECHOS: FACT_MATRICULA
CREATE TABLE Fact_Matricula (
    -- Claves Foráneas referenciando a Claves Sustitutas
    SK_Estudiante INT NOT NULL,
    SK_Curso INT NOT NULL,
    SK_Facultad INT NOT NULL,
    SK_Tiempo INT NOT NULL,
    
    -- Métricas / Hechos
    Monto_Pagado_USD NUMERIC(10, 2) NOT NULL,
    Porcentaje_Descuento_Beca NUMERIC(5, 2) DEFAULT 0.00,
    Cantidad_Matriculas INT DEFAULT 1,
    
    -- Clave Primaria Compuesta
    CONSTRAINT PK_Fact_Matricula PRIMARY KEY (SK_Estudiante, SK_Curso, SK_Facultad, SK_Tiempo),
    
    -- Integridad Referencial
    CONSTRAINT FK_Fact_Estudiante FOREIGN KEY (SK_Estudiante) REFERENCES Dim_Estudiante(SK_Estudiante),
    CONSTRAINT FK_Fact_Curso FOREIGN KEY (SK_Curso) REFERENCES Dim_Curso(SK_Curso),
    CONSTRAINT FK_Fact_Facultad FOREIGN KEY (SK_Facultad) REFERENCES Dim_Facultad(SK_Facultad),
    CONSTRAINT FK_Fact_Tiempo FOREIGN KEY (SK_Tiempo) REFERENCES Dim_Tiempo(SK_Tiempo)
);

-- 6. ÍNDICES DE OPTIMIZACIÓN ANALÍTICA
CREATE INDEX IX_Fact_Matricula_Tiempo ON Fact_Matricula(SK_Tiempo);
CREATE INDEX IX_Fact_Matricula_Facultad ON Fact_Matricula(SK_Facultad);


-- 1. Insertar registro en Dim_Tiempo
INSERT INTO Dim_Tiempo (SK_Tiempo, Fecha, Anio, Trimestre, Mes, Nombre_Mes, Dia) 
VALUES (20261006, '2026-10-06', 2026, 4, 10, 'Octubre', 6);

-- 2. Insertar registro en Dim_Facultad
INSERT INTO Dim_Facultad (ID_Facultad_NK, Nombre_Facultad) 
VALUES (101, 'Facultad de Ingeniería y Ciencias Aplicadas');

-- 3. Insertar registro en Dim_Estudiante
INSERT INTO Dim_Estudiante (ID_Estudiante_NK, Nombre_Estudiante, Provincia_Origen) 
VALUES (9001, 'Carlos Pérez', 'Pichincha');

-- 4. Insertar registro en Dim_Curso
INSERT INTO Dim_Curso (ID_Curso_NK, Nombre_Curso, Creditos) 
VALUES (505, 'Inteligencia de Negocios', 4);

-- 5. Registrar el Hecho de Matrícula (Utilizando SK = 1 generada por SERIAL)
INSERT INTO Fact_Matricula (SK_Estudiante, SK_Curso, SK_Facultad, SK_Tiempo, Monto_Pagado_USD, Porcentaje_Descuento_Beca, Cantidad_Matriculas) 
VALUES (1, 1, 1, 20261006, 350.00, 10.00, 1);

-- 6. Consulta Analítica de Verificación (JOIN)
SELECT 
    e.Nombre_Estudiante,
    f.Nombre_Facultad,
    c.Nombre_Curso,
    t.Fecha,
    m.Monto_Pagado_USD
FROM Fact_Matricula m
JOIN Dim_Estudiante e ON m.SK_Estudiante = e.SK_Estudiante
JOIN Dim_Facultad f ON m.SK_Facultad = f.SK_Facultad
JOIN Dim_Curso c ON m.SK_Curso = c.SK_Curso
JOIN Dim_Tiempo t ON m.SK_Tiempo = t.SK_Tiempo;
