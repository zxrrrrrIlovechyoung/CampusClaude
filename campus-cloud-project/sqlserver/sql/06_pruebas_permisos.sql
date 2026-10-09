USE CampusCloud;
GO

SELECT TOP 5
    IdServicio,
    NombreServicio,
    Activo
FROM dbo.Servicios;
GO

SELECT TOP 5
    IdEstudiante,
    Matricula,
    Nombre,
    Correo
FROM dbo.Estudiantes;
GO

INSERT INTO dbo.Servicios (NombreServicio, Descripcion, Activo)
VALUES (N'pfksdop', N'doidsuoi', 1);
GO

--comprobar que el problema es de permisos no de la tabla.
SELECT COUNT(*) AS TotalServicios
FROM dbo.Servicios;
GO