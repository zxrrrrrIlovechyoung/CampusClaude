-- 06_pruebas_permisos.sql
-- Pruebas directas para demostrar permisos del usuario marianofool.
-- Ejecutar cada bloque por separado para mostrar permitido y denegado.

USE CampusCloud;
GO

-- 1. Permitido: marianofool puede consultar servicios.
EXECUTE AS USER = 'marianofool';
SELECT TOP 5
    IdServicio,
    NombreServicio,
    Activo
FROM dbo.Servicios;
REVERT;
GO

-- 2. Denegado: marianofool no puede consultar estudiantes.
EXECUTE AS USER = 'marianofool';
SELECT TOP 5
    IdEstudiante,
    Matricula,
    Nombre,
    Correo
FROM dbo.Estudiantes;
REVERT;
GO

-- 3. Denegado: marianofool no puede insertar servicios.
EXECUTE AS USER = 'marianofool';
INSERT INTO dbo.Servicios (NombreServicio, Descripcion, Activo)
VALUES (N'Servicio no autorizado', N'Esta insercion debe fallar.', 1);
REVERT;
GO

-- 4. Permitido para administrador: comprobar que el problema es de permisos, no de la tabla.
EXECUTE AS USER = 'cc_admin';
SELECT COUNT(*) AS TotalServicios
FROM dbo.Servicios;
REVERT;
GO
