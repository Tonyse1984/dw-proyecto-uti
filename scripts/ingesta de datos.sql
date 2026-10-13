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

