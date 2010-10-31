-- exec migrar_bancos
DROP PROCEDURE migrar_bancos
GO
CREATE PROCEDURE migrar_bancos AS
	INSERT INTO gd_esquema.bancos (BANC_NOM, BANC_CUIT) (SELECT DISTINCT BANC_NOM, BANC_CUIT FROM gd_esquema.Maestra)
	UPDATE gd_esquema.bancos SET ENABLED = 1
GO

-- exec migrar_sucursales
DROP PROCEDURE migrar_sucursales
GO
CREATE PROCEDURE migrar_sucursales AS
	INSERT INTO gd_esquema.sucursales (BANC_ID, SUC_DIR, SUC_DIR_NRO) (SELECT DISTINCT b.BANC_ID , m.BANC_DIR , m.BANC_DIR_NRO FROM gd_esquema.Maestra AS m INNER JOIN gd_esquema.bancos AS b ON m.BANC_NOM = b.BANC_NOM)
	UPDATE gd_esquema.sucursales SET ENABLED = 1
GO

-- exec migrar_clientes
DROP PROCEDURE migrar_clientes
GO
CREATE PROCEDURE migrar_clientes AS
	INSERT INTO gd_esquema.clientes (SUC_ID, CLI_COD, CLI_DNI, CLI_NOMB, CLI_APELLIDO, CLI_MAIL)
	(SELECT DISTINCT s.SUC_ID, CLI_COD, CLI_DNI, CLI_NOMB, CLI_APELLIDO, CLI_MAIL 
	FROM gd_esquema.Maestra m INNER JOIN gd_esquema.sucursales s 
	ON m.BANC_DIR = s.SUC_DIR AND m.BANC_DIR_NRO = s.SUC_DIR_NRO)
	UPDATE gd_esquema.clientes SET ENABLED = 1
GO

DROP PROCEDURE migrar_cuentas
GO
CREATE PROCEDURE migrar_cuentas AS
	SET IDENTITY_INSERT gd_esquema.cuentas ON
	-- ASUMO que TODOS LOS CLIENTES HACEN UN DEPOSITO EN TODAS SUS CUENTAS
	INSERT INTO gd_esquema.cuentas (CLI_ID, CUE_COD, FEC_CREA, SUC_ID) (
	SELECT DISTINCT c.CLI_ID, m.TRA_CUE_DESTINO, m.TRA_CUE_DESTINO_FCREA, s.SUC_ID
	FROM gd_esquema.Maestra AS m INNER JOIN gd_esquema.clientes AS c ON (c.CLI_COD = m.CLI_COD) -- Mismo Cliente
	INNER JOIN gd_esquema.sucursales AS s ON (c.SUC_ID = s.SUC_ID) -- Cliente en una sucursal
	WHERE s.SUC_DIR = m.BANC_DIR AND s.SUC_DIR_NRO = m.BANC_DIR_NRO --Misma sucursal
	AND TRA_CUE_DESTINO > 0 AND TRA_CUE_ORIGEN = 0
	)
	UPDATE gd_esquema.cuentas SET ENABLED = 1
	SET IDENTITY_INSERT gd_esquema.cuentas OFF
GO