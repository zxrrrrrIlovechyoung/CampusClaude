USE CampusCloud;
GO

SELECT
    sol.IdSolicitud,
    e.Matricula,
    e.Nombre AS Estudiante,
    s.NombreServicio,
    sol.Estado,
    sol.FechaSolicitud
FROM dbo.Solicitudes sol
JOIN dbo.Estudiantes e ON e.IdEstudiante = sol.IdEstudiante
JOIN dbo.Servicios s ON s.IdServicio = sol.IdServicio
ORDER BY sol.IdSolicitud;
GO

SELECT
    e.Nombre AS Estudiante,
    s.NombreServicio,
    sol.Estado
FROM dbo.Solicitudes sol
JOIN dbo.Estudiantes e ON e.IdEstudiante = sol.IdEstudiante
JOIN dbo.Servicios s ON s.IdServicio = sol.IdServicio
WHERE sol.Estado IN (N'Pendiente', N'En proceso')
ORDER BY sol.Estado, e.Nombre;
GO

SELECT
    s.NombreServicio,
    COUNT(sol.IdSolicitud) AS TotalSolicitudes
FROM dbo.Servicios s
LEFT JOIN dbo.Solicitudes sol ON sol.IdServicio = s.IdServicio
GROUP BY s.NombreServicio
ORDER BY TotalSolicitudes DESC, s.NombreServicio;
GO

SELECT
    e.Matricula,
    e.Nombre,
    COUNT(sol.IdSolicitud) AS TotalSolicitudes
FROM dbo.Estudiantes e
LEFT JOIN dbo.Solicitudes sol ON sol.IdEstudiante = e.IdEstudiante
GROUP BY e.Matricula, e.Nombre
ORDER BY TotalSolicitudes DESC, e.Matricula;
GO

INSERT INTO dbo.Solicitudes (IdEstudiante, IdServicio, Estado, Comentario)
SELECT e.IdEstudiante, s.IdServicio, N'Pendiente', N'Solicitud de prueba CRUD.'
FROM dbo.Estudiantes e
JOIN dbo.Servicios s ON s.NombreServicio = N'Soporte de plataforma'
WHERE e.Matricula = N'CC260010';
GO

UPDATE dbo.Solicitudes
SET Estado = N'En proceso',
    Comentario = N'Solicitud de prueba CRUD actualizada.'
WHERE Comentario = N'Solicitud de prueba CRUD.';
GO

DELETE FROM dbo.Solicitudes
WHERE Comentario = N'Solicitud de prueba CRUD actualizada.';
GO
