-- ============================================================
-- BASE DE DATOS: db_edusmart_uti
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
