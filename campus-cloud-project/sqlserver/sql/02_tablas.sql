-- 02_tablas.sql
-- Modelo relacional de CampusCloud para SQL Server.

USE CampusCloud;
GO

IF OBJECT_ID(N'dbo.Solicitudes', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.Solicitudes (
        IdSolicitud INT IDENTITY(1,1) NOT NULL,
        IdEstudiante INT NOT NULL,
        IdServicio INT NOT NULL,
        FechaSolicitud DATETIME2(0) NOT NULL CONSTRAINT DF_Solicitudes_Fecha DEFAULT SYSDATETIME(),
        Estado NVARCHAR(20) NOT NULL CONSTRAINT DF_Solicitudes_Estado DEFAULT N'Pendiente',
        Comentario NVARCHAR(250) NULL,
        CONSTRAINT PK_Solicitudes PRIMARY KEY (IdSolicitud),
        CONSTRAINT CK_Solicitudes_Estado CHECK (Estado IN (N'Pendiente', N'En proceso', N'Aprobada', N'Rechazada', N'Cancelada'))
    );
END;
GO

IF OBJECT_ID(N'dbo.Estudiantes', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.Estudiantes (
        IdEstudiante INT IDENTITY(1,1) NOT NULL,
        Matricula NVARCHAR(20) NOT NULL,
        Nombre NVARCHAR(100) NOT NULL,
        Correo NVARCHAR(120) NOT NULL,
        CreadoEn DATETIME2(0) NOT NULL CONSTRAINT DF_Estudiantes_CreadoEn DEFAULT SYSDATETIME(),
        CONSTRAINT PK_Estudiantes PRIMARY KEY (IdEstudiante),
        CONSTRAINT UQ_Estudiantes_Matricula UNIQUE (Matricula),
        CONSTRAINT UQ_Estudiantes_Correo UNIQUE (Correo)
    );
END;
GO

IF OBJECT_ID(N'dbo.Servicios', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.Servicios (
        IdServicio INT IDENTITY(1,1) NOT NULL,
        NombreServicio NVARCHAR(100) NOT NULL,
        Descripcion NVARCHAR(300) NOT NULL,
        Activo BIT NOT NULL CONSTRAINT DF_Servicios_Activo DEFAULT 1,
        CreadoEn DATETIME2(0) NOT NULL CONSTRAINT DF_Servicios_CreadoEn DEFAULT SYSDATETIME(),
        CONSTRAINT PK_Servicios PRIMARY KEY (IdServicio),
        CONSTRAINT UQ_Servicios_NombreServicio UNIQUE (NombreServicio)
    );
END;
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'FK_Solicitudes_Estudiantes')
BEGIN
    ALTER TABLE dbo.Solicitudes
    ADD CONSTRAINT FK_Solicitudes_Estudiantes
        FOREIGN KEY (IdEstudiante)
        REFERENCES dbo.Estudiantes (IdEstudiante);
END;
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'FK_Solicitudes_Servicios')
BEGIN
    ALTER TABLE dbo.Solicitudes
    ADD CONSTRAINT FK_Solicitudes_Servicios
        FOREIGN KEY (IdServicio)
        REFERENCES dbo.Servicios (IdServicio);
END;
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_Solicitudes_IdEstudiante')
    CREATE INDEX IX_Solicitudes_IdEstudiante ON dbo.Solicitudes (IdEstudiante);
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_Solicitudes_IdServicio')
    CREATE INDEX IX_Solicitudes_IdServicio ON dbo.Solicitudes (IdServicio);
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_Solicitudes_Estado')
    CREATE INDEX IX_Solicitudes_Estado ON dbo.Solicitudes (Estado);
GO
