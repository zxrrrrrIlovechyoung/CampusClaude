-- 03_datos.sql
-- Datos minimos: 10 estudiantes, 5 servicios y 15 solicitudes.

USE CampusCloud;
GO

INSERT INTO dbo.Estudiantes (Matricula, Nombre, Correo)
SELECT v.Matricula, v.Nombre, v.Correo
FROM (VALUES
    (N'CC260001', N'Ana Martinez Lopez', N'ana.martinez@campuscloud.local'),
    (N'CC260002', N'Bruno Hernandez Soto', N'bruno.hernandez@campuscloud.local'),
    (N'CC260003', N'Carla Ruiz Torres', N'carla.ruiz@campuscloud.local'),
    (N'CC260004', N'Diego Flores Garcia', N'diego.flores@campuscloud.local'),
    (N'CC260005', N'Elena Morales Diaz', N'elena.morales@campuscloud.local'),
    (N'CC260006', N'Fernando Castro Luna', N'fernando.castro@campuscloud.local'),
    (N'CC260007', N'Gabriela Navarro Cruz', N'gabriela.navarro@campuscloud.local'),
    (N'CC260008', N'Hugo Ramirez Vega', N'hugo.ramirez@campuscloud.local'),
    (N'CC260009', N'Iris Sanchez Rojas', N'iris.sanchez@campuscloud.local'),
    (N'CC260010', N'Jorge Mendoza Perez', N'jorge.mendoza@campuscloud.local')
) AS v(Matricula, Nombre, Correo)
WHERE NOT EXISTS (
    SELECT 1 FROM dbo.Estudiantes e WHERE e.Matricula = v.Matricula
);
GO

INSERT INTO dbo.Servicios (NombreServicio, Descripcion, Activo)
SELECT v.NombreServicio, v.Descripcion, v.Activo
FROM (VALUES
    (N'Constancia de estudios', N'Emision de constancia academica para tramites escolares.', 1),
    (N'Beca academica', N'Solicitud y seguimiento de apoyo economico institucional.', 1),
    (N'Soporte de plataforma', N'Atencion a problemas de acceso a servicios digitales.', 1),
    (N'Prestamo bibliotecario', N'Gestion de prestamos y devoluciones de material bibliografico.', 1),
    (N'Credencial universitaria', N'Reposicion o renovacion de credencial de estudiante.', 1)
) AS v(NombreServicio, Descripcion, Activo)
WHERE NOT EXISTS (
    SELECT 1 FROM dbo.Servicios s WHERE s.NombreServicio = v.NombreServicio
);
GO

INSERT INTO dbo.Solicitudes (IdEstudiante, IdServicio, FechaSolicitud, Estado, Comentario)
SELECT e.IdEstudiante, s.IdServicio, v.FechaSolicitud, v.Estado, v.Comentario
FROM (VALUES
    (N'CC260001', N'Constancia de estudios', CAST('2026-10-01T09:00:00' AS DATETIME2(0)), N'Pendiente', N'Constancia para tramite externo.'),
    (N'CC260002', N'Beca academica', CAST('2026-10-01T10:15:00' AS DATETIME2(0)), N'En proceso', N'Revision de promedio.'),
    (N'CC260003', N'Soporte de plataforma', CAST('2026-10-02T08:30:00' AS DATETIME2(0)), N'Aprobada', N'Restablecimiento de acceso.'),
    (N'CC260004', N'Prestamo bibliotecario', CAST('2026-10-02T11:20:00' AS DATETIME2(0)), N'Pendiente', N'Solicitud de libro de bases de datos.'),
    (N'CC260005', N'Credencial universitaria', CAST('2026-10-03T12:00:00' AS DATETIME2(0)), N'Rechazada', N'Fotografia no valida.'),
    (N'CC260006', N'Constancia de estudios', CAST('2026-10-03T13:10:00' AS DATETIME2(0)), N'Aprobada', N'Documento entregado.'),
    (N'CC260007', N'Beca academica', CAST('2026-10-04T09:45:00' AS DATETIME2(0)), N'Pendiente', N'Falta comprobante de ingresos.'),
    (N'CC260008', N'Soporte de plataforma', CAST('2026-10-04T15:30:00' AS DATETIME2(0)), N'En proceso', N'Validando correo institucional.'),
    (N'CC260009', N'Prestamo bibliotecario', CAST('2026-10-05T08:50:00' AS DATETIME2(0)), N'Cancelada', N'Solicitud cancelada por estudiante.'),
    (N'CC260010', N'Credencial universitaria', CAST('2026-10-05T14:40:00' AS DATETIME2(0)), N'Pendiente', N'Reposicion por extravio.'),
    (N'CC260001', N'Beca academica', CAST('2026-10-06T10:00:00' AS DATETIME2(0)), N'En proceso', N'Documentos recibidos.'),
    (N'CC260002', N'Soporte de plataforma', CAST('2026-10-06T10:30:00' AS DATETIME2(0)), N'Aprobada', N'Cuenta desbloqueada.'),
    (N'CC260003', N'Credencial universitaria', CAST('2026-10-07T09:15:00' AS DATETIME2(0)), N'Pendiente', N'Validacion de pago.'),
    (N'CC260004', N'Constancia de estudios', CAST('2026-10-07T12:25:00' AS DATETIME2(0)), N'Aprobada', N'Constancia generada.'),
    (N'CC260005', N'Prestamo bibliotecario', CAST('2026-10-08T08:05:00' AS DATETIME2(0)), N'En proceso', N'Buscando disponibilidad.')
) AS v(Matricula, NombreServicio, FechaSolicitud, Estado, Comentario)
JOIN dbo.Estudiantes e ON e.Matricula = v.Matricula
JOIN dbo.Servicios s ON s.NombreServicio = v.NombreServicio
WHERE NOT EXISTS (
    SELECT 1
    FROM dbo.Solicitudes sol
    WHERE sol.IdEstudiante = e.IdEstudiante
      AND sol.IdServicio = s.IdServicio
      AND sol.FechaSolicitud = v.FechaSolicitud
);
GO
