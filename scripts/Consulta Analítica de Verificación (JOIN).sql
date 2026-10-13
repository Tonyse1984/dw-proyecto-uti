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
