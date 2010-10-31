USE [GD2C2010]
GO

CREATE TABLE [gd_esquema].[bancos](
[BANC_ID] [int] IDENTITY(1,1) NOT NULL,
[BANC_NOM] [nchar](30) NOT NULL,
[BANC_CUIT] [int] NULL,
Primary Key ([BANC_ID])
)
GO

CREATE TABLE [gd_esquema].[sucursales](
[SUC_ID] [int] IDENTITY(1,1) NOT NULL,
[BANC_ID] [int] NOT NULL, -- BANC_ID
[SUC_DIR] [nchar](50) NOT NULL, -- BANC_DIR
[SUC_DIR_NRO] [int] NOT NULL, -- BANC_DIR_NRO
Primary Key ([SUC_ID]), 
Foreign Key ([BANC_ID]) references [gd_esquema].[bancos]([BANC_ID])
)
GO

CREATE TABLE [gd_esquema].[clientes](
[CLI_COD] [int] IDENTITY(1,1) NOT NULL,
[BANC_ID] [int] NOT NULL,
[CLI_DNI] [int] NOT NULL,
[CLI_NOMB] [nchar](50) NOT NULL,
[CLI_APELLIDO] [nchar](50) NOT NULL,
[CLI_MAIL] [nchar](50) NULL,
Primary Key ([CLI_COD]),
Foreign Key ([BANC_ID]) references [gd_esquema].[bancos]([BANC_ID])
)
GO

CREATE TABLE [gd_esquema].[cuentas](
[CUE_COD] [int] IDENTITY(1,1) NOT NULL,
[CLI_COD] [int] NOT NULL,
[SUC_ID] [int] NOT NULL,
Primary Key ([CUE_COD]),
Foreign Key ([CLI_COD]) references [gd_esquema].[clientes]([CLI_COD]),
Foreign Key ([SUC_ID]) references [gd_esquema].[sucursales]([SUC_ID])
)
GO

CREATE TABLE [gd_esquema].[monedas](
[MON_ID] [int] IDENTITY(1,1) NOT NULL,
[MON_COD] [nvarchar](max) NOT NULL,
[MON_COT] [real] NOT NULL,
Primary Key ([MON_ID])
)
GO

CREATE TABLE [gd_esquema].[plazo_fijos](
[CLI_COD] [int] NOT NULL,
[SUC_ID] [int] NOT NULL,
[PF_COD] [int] IDENTITY(1,1) NOT NULL,
[PF_IMPOR] [real] NULL,
[PF_FCREA] [smalldatetime] NOT NULL,
[PF_FFIN] [smalldatetime] NOT NULL,
[PF_MONEDA] [int] NOT NULL,
[PF_PLAZO] [int] NULL,
[PF_PORC] [real] NOT NULL,
Primary Key ([PF_COD]),
Foreign Key ([CLI_COD]) references [gd_esquema].[clientes]([CLI_COD]),
Foreign Key ([SUC_ID]) references [gd_esquema].[sucursales]([SUC_ID]),
Foreign Key ([PF_MONEDA]) references [gd_esquema].[monedas]([MON_ID])
)
GO

CREATE TABLE [gd_esquema].[deudas](
[DEUDA_ID] [int] IDENTITY (1,1) NOT NULL,
[TAR_DEU_MONTO] [real] NOT NULL,
[TAR_DEU_MONEDA] [int] NOT NULL,
[TAR_DEU_FECHA] [smalldatetime] NOT NULL,
Primary Key ([DEUDA_ID]),
Foreign Key ([TAR_DEU_MONEDA]) references [gd_esquema].[monedas]([MON_ID])
)
GO

CREATE TABLE [gd_esquema].[pagos](
[PAGO_ID] [int] IDENTITY (1,1) NOT NULL,
[TAR_PAG_MONTO] [real] NOT NULL,
[TAR_PAG_MONEDA] [int] NOT NULL,
[TAR_PAG_FECHA] [smalldatetime] NOT NULL,
Primary Key ([PAGO_ID]),
Foreign Key ([TAR_PAG_MONEDA]) references [gd_esquema].[monedas]([MON_ID]),
)
GO

CREATE TABLE [gd_esquema].[tarjetas](
[CLI_COD] [int] NOT NULL,
[TAR_FCREA] [smalldatetime] NOT NULL,
[TAR_NRO] [int] IDENTITY(1,1) NOT NULL,
[TAR_DEU_COD_NEGOCIO] [int] NULL,
[DEUDA_ID] [int] NULL,
[PAGO_ID] [int] NULL,
Primary Key ([TAR_NRO]),
Foreign Key ([CLI_COD]) references [gd_esquema].[clientes]([CLI_COD]),
Foreign Key ([PAGO_ID]) references [gd_esquema].[pagos]([PAGO_ID]),
Foreign Key ([DEUDA_ID]) references [gd_esquema].[deudas]([DEUDA_ID]),
)
GO

CREATE TABLE [gd_esquema].[cheques](
[CHE_CUE_ORIGEN] [int] NOT NULL,
[CHE_CUE_ORIGEN_FCREA] [smalldatetime] NULL,
[CHE_CUE_DESTINO] [int] NOT NULL,
[CHE_CUE_DESTINO_FCREA] [smalldatetime] NULL,
[CHE_NRO] [int] IDENTITY(1,1) NOT NULL,
[CHE_MONTO] [real] NOT NULL,
[CHE_FECHA] [smalldatetime] NOT NULL,
[CHE_MONEDA] [int] NOT NULL,
Primary Key ([CHE_NRO]),
Foreign Key ([CHE_CUE_DESTINO]) references [gd_esquema].[cuentas]([CUE_COD]),
Foreign Key ([CHE_CUE_ORIGEN]) references [gd_esquema].[cuentas]([CUE_COD]),
Foreign Key ([CHE_MONEDA]) references [gd_esquema].[monedas]([MON_ID])
)
GO

CREATE TABLE [gd_esquema].[transferencias](
[TRA_NRO] [int] IDENTITY(1,1) NOT NULL,
[TRA_CUE_ORIGEN] [int] NOT NULL,
[TRA_CUE_ORIGEN_FECRA] [smalldatetime] NULL,
[TRA_CUE_DESTINO] [int] NOT NULL,
[TRA_CUE_DESTINO_FCREA] [smalldatetime] NULL,
[TRA_FECHA] [smalldatetime] NOT NULL,
[TRA_MONTO] [real] NOT NULL,
[TRA_MONEDA] [int] NOT NULL,
Primary Key ([TRA_NRO]),
Foreign Key (TRA_CUE_DESTINO) references [gd_esquema].[cuentas]([CUE_COD]),
Foreign Key ([TRA_CUE_ORIGEN]) references [gd_esquema].[cuentas]([CUE_COD]),
Foreign Key ([TRA_MONEDA]) references [gd_esquema].[monedas]([MON_ID])
)
GO
