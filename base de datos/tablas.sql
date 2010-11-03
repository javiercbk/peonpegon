USE [GD2C2010]
GO
-- EXEC sp_msforeachtable "ALTER TABLE ? NOCHECK CONSTRAINT all"
-- GO
-- Veo si las tablas fueron creadas
if object_id('gd_esquema.bancos') is not null
begin
  drop table gd_esquema.bancos
end
CREATE TABLE [gd_esquema].[bancos](
[BANC_ID] [int] IDENTITY(1,1) NOT NULL,
[BANC_NOM] [nchar](30) NOT NULL,
[BANC_CUIT] [int] NULL,
[ENABLED] [bit] NULL,
Primary Key ([BANC_ID])
)
GO
CREATE UNIQUE INDEX cuit_indx ON [gd_esquema].[bancos] (BANC_CUIT)
GO
CREATE INDEX bname_indx ON [gd_esquema].[bancos] (BANC_NOM)
GO

if object_id('gd_esquema.sucursales') is not null
begin
  drop table gd_esquema.sucursales
end
CREATE TABLE [gd_esquema].[sucursales](
[SUC_ID] [int] IDENTITY(1,1) NOT NULL,
[BANC_ID] [int] NOT NULL, -- BANC_ID
[SUC_DIR] [nchar](50) NOT NULL, -- BANC_DIR
[SUC_DIR_NRO] [int] NOT NULL, -- BANC_DIR_NRO
[ENABLED] [bit] NULL,
Primary Key ([SUC_ID]), 
Foreign Key ([BANC_ID]) references [gd_esquema].[bancos]([BANC_ID])
)
GO
CREATE UNIQUE INDEX dir_indx ON [gd_esquema].[sucursales] (SUC_DIR, SUC_DIR_NRO)
GO

if object_id('gd_esquema.clientes') is not null
begin
  drop table gd_esquema.clientes
end
CREATE TABLE [gd_esquema].[clientes](
[CLI_ID] [int] IDENTITY(1,1) NOT NULL,
[CLI_COD] [int] NOT NULL,
[SUC_ID] [int] NOT NULL,
[CLI_DNI] [int] NOT NULL,
[CLI_NOMB] [nchar](50) NOT NULL,
[CLI_APELLIDO] [nchar](50) NOT NULL,
[CLI_MAIL] [nchar](50) NULL,
[ENABLED] [bit] NULL,
Primary Key ([CLI_ID]),
Foreign Key ([SUC_ID]) references [gd_esquema].[sucursales]([SUC_ID])
)
GO

CREATE INDEX dni_indx ON [gd_esquema].[clientes] (CLI_DNI)
GO
CREATE INDEX cname_indx ON [gd_esquema].[clientes] (CLI_NOMB)
GO
CREATE INDEX csur_indx ON [gd_esquema].[clientes] (CLI_APELLIDO)
GO

if object_id('gd_esquema.cuentas') is not null
begin
  drop table gd_esquema.cuentas
end
CREATE TABLE [gd_esquema].[cuentas](
[CUE_ID] [int] IDENTITY(1,1) NOT NULL,
[CUE_COD] [int] NOT NULL,
[CLI_ID] [int] NOT NULL,
[SUC_ID] [int] NOT NULL,
[FEC_CREA][smalldatetime] NOT NULL,
[ENABLED] [bit] NULL,
Primary Key ([CUE_ID]),
Foreign Key ([CLI_ID]) references [gd_esquema].[clientes]([CLI_ID]),
Foreign Key ([SUC_ID]) references [gd_esquema].[sucursales]([SUC_ID])
)
GO

CREATE INDEX ccod_indx ON [gd_esquema].[cuentas] (CUE_COD)
GO
CREATE INDEX cfec_indx ON [gd_esquema].[cuentas] (FEC_CREA)
GO

if object_id('gd_esquema.monedas') is not null
begin
  drop table gd_esquema.monedas
end
CREATE TABLE [gd_esquema].[monedas](
[MON_ID] [int] IDENTITY(1,1) NOT NULL,
[MON_COD] [nvarchar](max) NOT NULL,
[MON_COT] [real] NOT NULL,
Primary Key ([MON_ID]),
CONSTRAINT chk_mon CHECK ([MON_COT]>0)
)
GO

if object_id('gd_esquema.plazos_fijos') is not null
begin
  drop table gd_esquema.plazo_fijos
end
CREATE TABLE [gd_esquema].[plazo_fijos](
[CLI_ID] [int] NOT NULL,
[SUC_ID] [int] NOT NULL,
[PF_COD] [int] IDENTITY(1,1) NOT NULL,
[PF_IMPOR] [real] NULL,
[PF_FCREA] [smalldatetime] NOT NULL,
[PF_FFIN] [smalldatetime] NOT NULL,
[PF_MONEDA] [int] NOT NULL,
[PF_PORC] [real] NOT NULL,
Primary Key ([PF_COD]),
Foreign Key ([CLI_ID]) references [gd_esquema].[clientes]([CLI_ID]),
Foreign Key ([SUC_ID]) references [gd_esquema].[sucursales]([SUC_ID]),
Foreign Key ([PF_MONEDA]) references [gd_esquema].[monedas]([MON_ID])
)
GO

CREATE INDEX pfcrea_indx ON [gd_esquema].[plazo_fijos] (PF_FCREA)
GO
CREATE INDEX pffin_indx ON [gd_esquema].[plazo_fijos] (PF_FFIN)
GO

if object_id('gd_esquema.tarjetas') is not null
begin
  drop table gd_esquema.tarjetas
end
CREATE TABLE [gd_esquema].[tarjetas](
[CLI_ID] [int] NOT NULL,
[TAR_FCREA] [smalldatetime] NOT NULL,
[TAR_NRO] [int] IDENTITY(1,1) NOT NULL,
Primary Key ([TAR_NRO]),
Foreign Key ([CLI_ID]) references [gd_esquema].[clientes]([CLI_ID]),
)
GO

CREATE INDEX tfcrea_indx ON [gd_esquema].[tarjetas] (TAR_FCREA)
GO

if object_id('gd_esquema.deuda') is not null
begin
  drop table gd_esquema.deudas
end
CREATE TABLE [gd_esquema].[deudas](
[DEUDA_ID] [int] IDENTITY (1,1) NOT NULL,
[TAR_NRO] [int] NULL,
[TAR_DEU_MONTO] [real] NOT NULL,
[TAR_DEU_MONEDA] [int] NOT NULL,
[TAR_DEU_FECHA] [smalldatetime] NOT NULL,
[TAR_DEU_COD_NEGOCIO] [int] NULL,
Primary Key ([DEUDA_ID]),
Foreign Key ([TAR_DEU_MONEDA]) references [gd_esquema].[monedas]([MON_ID]),
Foreign Key ([TAR_NRO]) references [gd_esquema].[tarjetas]([TAR_NRO])
)
GO

CREATE INDEX dfecha_indx ON [gd_esquema].[deudas] (TAR_DEU_FECHA)
GO

if object_id('gd_esquema.pagos') is not null
begin
  drop table gd_esquema.pagos
end
CREATE TABLE [gd_esquema].[pagos](
[PAGO_ID] [int] IDENTITY (1,1) NOT NULL,
[TAR_NRO] [int] NOT NULL,
[TAR_PAG_MONTO] [real] NOT NULL,
[TAR_PAG_MONEDA] [int] NOT NULL,
[TAR_PAG_FECHA] [smalldatetime] NOT NULL,
Primary Key ([PAGO_ID]),
Foreign Key ([TAR_PAG_MONEDA]) references [gd_esquema].[monedas]([MON_ID]),
Foreign Key ([TAR_NRO]) references [gd_esquema].[tarjetas]([TAR_NRO])
)
GO

CREATE INDEX pfecha_indx ON [gd_esquema].[pagos] (TAR_PAG_FECHA)
GO

if object_id('gd_esquema.cheques') is not null
begin
  drop table gd_esquema.cheques
end
CREATE TABLE [gd_esquema].[cheques](
[CHE_ID] [int] IDENTITY(1,1) NOT NULL,
[CHE_CUE_ORIGEN] [int] NOT NULL,
[CHE_CUE_DESTINO] [int] NOT NULL,
[CHE_NRO] [int] NOT NULL,
[CHE_MONTO] [real] NOT NULL,
[CHE_FECHA] [smalldatetime] NOT NULL,
[CHE_MONEDA] [int] NOT NULL,
Primary Key ([CHE_ID]),
Foreign Key ([CHE_CUE_DESTINO]) references [gd_esquema].[cuentas]([CUE_ID]),
Foreign Key ([CHE_CUE_ORIGEN]) references [gd_esquema].[cuentas]([CUE_ID]),
Foreign Key ([CHE_MONEDA]) references [gd_esquema].[monedas]([MON_ID])
)
GO

CREATE INDEX chenro_indx ON [gd_esquema].[cheques] (CHE_NRO)
GO
CREATE INDEX chefe_indx ON [gd_esquema].[cheques] (CHE_FECHA)
GO

if object_id('gd_esquema.transferencias') is not null
begin
  drop table gd_esquema.transferencias
end
CREATE TABLE [gd_esquema].[transferencias](
[TRA_NRO] [int] IDENTITY(1,1) NOT NULL,
[TRA_CUE_ORIGEN] [int] NULL,
[TRA_CUE_DESTINO] [int] NULL,
[TRA_FECHA] [smalldatetime] NOT NULL,
[TRA_MONTO] [real] NOT NULL,
[TRA_MONEDA] [int] NOT NULL,
Primary Key ([TRA_NRO]),
Foreign Key (TRA_CUE_DESTINO) references [gd_esquema].[cuentas]([CUE_ID]),
Foreign Key ([TRA_CUE_ORIGEN]) references [gd_esquema].[cuentas]([CUE_ID]),
Foreign Key ([TRA_MONEDA]) references [gd_esquema].[monedas]([MON_ID])
)
GO

CREATE INDEX trafe_indx ON [gd_esquema].[transferencias] (TRA_FECHA)
GO

-- exec sp_msforeachtable @command1="print '?'", @command2="ALTER TABLE ? WITH CHECK CHECK CONSTRAINT all"
-- GO