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
	-- BUSCO CUENTAS ORIGEN EN TRANSFERENCIAS Y CHEQUES
	INSERT INTO gd_esquema.cuentas (CLI_ID, CUE_COD, FEC_CREA, SUC_ID) 
	(SELECT DISTINCT c.CLI_ID, m.TRA_CUE_ORIGEN, m.TRA_CUE_ORIGEN_FECRA, s.SUC_ID
	FROM gd_esquema.Maestra AS m INNER JOIN gd_esquema.clientes AS c ON (c.CLI_DNI = m.CLI_DNI) -- Mismo Cliente
	INNER JOIN gd_esquema.sucursales AS s ON (c.SUC_ID = s.SUC_ID) -- Cliente en una sucursal
	WHERE s.SUC_DIR = m.BANC_DIR AND s.SUC_DIR_NRO = m.BANC_DIR_NRO --Misma sucursal
	AND TRA_CUE_ORIGEN > 0 -- TRANSFERENCIAS A DESTINO VALIDAS Y
	AND NOT EXISTS (SELECT c1.CLI_ID, c1.CUE_COD, c1.FEC_CREA, c1.SUC_ID 
					FROM gd_esquema.cuentas AS c1
					WHERE c1.CUE_COD = m.TRA_CUE_ORIGEN AND c.CLI_ID = c1.CLI_ID))
	-- EXTRAIGO CUENTAS ORIGEN DE CHEQUES
	INSERT INTO gd_esquema.cuentas (CLI_ID, CUE_COD, FEC_CREA, SUC_ID) 
	(SELECT DISTINCT c.CLI_ID, m.CHE_CUE_ORIGEN, m.CHE_CUE_ORIGEN_FCREA, s.SUC_ID
	FROM gd_esquema.Maestra AS m INNER JOIN gd_esquema.clientes AS c ON (c.CLI_DNI = m.CLI_DNI) -- Mismo Cliente
	INNER JOIN gd_esquema.sucursales AS s ON (c.SUC_ID = s.SUC_ID) -- Cliente en una sucursal
	WHERE s.SUC_DIR = m.BANC_DIR AND s.SUC_DIR_NRO = m.BANC_DIR_NRO --Misma sucursal
	AND CHE_CUE_ORIGEN > 0  -- TRANSFERENCIAS A ORIGEN VALIDAS
	AND NOT EXISTS (SELECT c1.CLI_ID, c1.CUE_COD, c1.FEC_CREA, c1.SUC_ID 
					FROM gd_esquema.cuentas AS c1
					WHERE c1.CUE_COD = m.CHE_CUE_ORIGEN AND c.CLI_ID = c1.CLI_ID))-- QUE NO ESTEN YA CARGADAS
	UPDATE gd_esquema.cuentas SET ENABLED = 1 -- Habilito todas
GO

DROP PROCEDURE migrar_monedas
GO
CREATE PROCEDURE migrar_monedas AS
	SET IDENTITY_INSERT gd_esquema.monedas ON
	-- INSERTO LAS MONEDAS DE LOS PLAZOS FIJOS
	INSERT INTO gd_esquema.monedas (MON_ID, MON_COD, MON_COT) 
	(SELECT DISTINCT  m.PF_MONEDA_COD, m.PF_MONEDA_DESC, m.PF_MONEDA_COTIZA 
	FROM gd_esquema.Maestra AS m WHERE m.PF_MONEDA_COD != 0)
	
	-- INSERTO LAS MONEDAS DE LAS DEUDAS DE TARJETAS IGNORANDO LAS QUE ESTAN YA CARGADAS
	INSERT INTO gd_esquema.monedas (MON_ID, MON_COD, MON_COT) 
	(SELECT DISTINCT m.TAR_DEU_MONEDA_COD, m.TAR_DEU_MONEDA_DESC, m.TAR_DEU_MONEDA_COTIZA 
	FROM gd_esquema.Maestra AS m, gd_esquema.monedas AS o WHERE m.TAR_DEU_MONEDA_COD != 0 AND m.TAR_DEU_MONEDA_COD != o.MON_ID)

	-- INSERTO LAS MONEDAS DE LOS PAGOS DE TARJETAS IGNORANDO LAS QUE ESTAN YA CARGADAS
	INSERT INTO gd_esquema.monedas (MON_ID, MON_COD, MON_COT)
	(SELECT DISTINCT m.TAR_PAG_MONEDA_COD, m.TAR_PAG_MONEDA_DESC, m.TAR_PAG_MONEDA_COTIZA 
	FROM gd_esquema.Maestra AS m, gd_esquema.monedas AS o WHERE m.TAR_PAG_MONEDA_COD != 0 AND m.TAR_PAG_MONEDA_COD != o.MON_ID)

	-- INSERTO LAS MONEDAS DE LOS CHEQUES IGNORANDO LAS QUE ESTAN YA CARGADAS
	INSERT INTO gd_esquema.monedas (MON_ID, MON_COD, MON_COT)
	(SELECT DISTINCT m.CHE_MONEDA, m.CHE_MONEDA_COD, m.CHE_MONEDA_COTIZA 
	FROM gd_esquema.Maestra AS m, gd_esquema.monedas AS o WHERE m.CHE_MONEDA != 0 AND m.CHE_MONEDA != o.MON_ID)

	-- INSERTO LAS MONEDAS DE LAS TRANSACCIONES IGNORANDO LAS QUE ESTAN YA CARGADAS
	INSERT INTO gd_esquema.monedas (MON_ID, MON_COD, MON_COT)
	(SELECT DISTINCT m.TRA_MONEDA, m.TRA_MONEDA_COD, m.TRA_MONEDA_COTIZA 
	FROM gd_esquema.Maestra AS m, gd_esquema.monedas AS o WHERE m.TRA_MONEDA != 0 AND m.TRA_MONEDA != o.MON_ID)

	SET IDENTITY_INSERT gd_esquema.monedas OFF
GO

DROP PROCEDURE migrar_plazo_fijos
GO
CREATE PROCEDURE migrar_plazo_fijos AS
	INSERT INTO gd_esquema.plazo_fijos (PF_IMPOR, PF_FCREA, PF_FFIN, PF_PORC, PF_MONEDA, CLI_ID, SUC_ID)
	(SELECT DISTINCT m.PF_IMPOR, m.PF_FCREA, m.PF_FFIN, m.PF_PORC, o.MON_ID, c.CLI_ID, s.SUC_ID
		FROM gd_esquema.Maestra AS m
		INNER JOIN gd_esquema.sucursales AS s ON (m.BANC_DIR = s.SUC_DIR AND m.BANC_DIR_NRO = s.SUC_DIR_NRO)
		INNER JOIN gd_esquema.clientes AS c ON 
		(c.CLI_DNI = m.CLI_DNI AND c.SUC_ID = s.SUC_ID)
		INNER JOIN gd_esquema.monedas AS o ON (m.PF_MONEDA_COD = o.MON_ID)
		WHERE m.PF_COD != 0 AND m.PF_COD IS NOT NULL)
GO

DROP PROCEDURE migrar_tarjetas
GO
CREATE PROCEDURE migrar_tarjetas AS
	SET IDENTITY_INSERT gd_esquema.tarjetas ON
	INSERT INTO gd_esquema.tarjetas (TAR_NRO, TAR_FCREA, CLI_ID)
	(SELECT DISTINCT m.TAR_NRO, m.TAR_FCREA, c.CLI_ID
	FROM gd_esquema.Maestra AS m 
	INNER JOIN gd_esquema.clientes AS c ON (c.CLI_DNI = m.CLI_DNI) -- Mismo Cliente
	INNER JOIN gd_esquema.sucursales AS s ON (c.SUC_ID = s.SUC_ID) -- Cliente en una sucursal
	WHERE s.SUC_DIR = m.BANC_DIR AND s.SUC_DIR_NRO = m.BANC_DIR_NRO --Misma sucursal
	AND TAR_NRO > 0 AND TAR_FCREA IS NOT NULL)
	SET IDENTITY_INSERT gd_esquema.tarjetas OFF
GO

DROP PROCEDURE migrar_deudas
GO
-- PENSAR LA POSIBILIDAD DE 2 PAGOS EN LA MISMA FECHA
-- VER SI HAY QUE PONERLE DISTINCT
CREATE PROCEDURE migrar_deudas AS
	INSERT INTO gd_esquema.deudas (TAR_DEU_COD_NEGOCIO, TAR_DEU_MONTO, TAR_DEU_FECHA, TAR_DEU_MONEDA, TAR_NRO)
	SELECT m.TAR_DEU_COD_NEGOCIO, m.TAR_DEU_MONTO, m.TAR_DEU_FECHA, o.MON_ID, t.TAR_NRO
	FROM gd_esquema.Maestra AS m
	INNER JOIN gd_esquema.tarjetas AS t ON (m.TAR_NRO = t.TAR_NRO)
	INNER JOIN gd_esquema.monedas AS o ON (m.TAR_DEU_MONEDA_COD = o.MON_ID)
	WHERE m.TAR_DEU_MONTO > 0 AND m.TAR_DEU_FECHA IS NOT NULL
GO

DROP PROCEDURE migrar_pagos
GO
-- PENSAR LA POSIBILIDAD DE 2 PAGOS EN LA MISMA FECHA
-- VER SI HAY QUE PONERLE DISTINCT
CREATE PROCEDURE migrar_pagos AS
	INSERT INTO gd_esquema.pagos (TAR_PAG_MONTO, TAR_PAG_FECHA, TAR_PAG_MONEDA, TAR_NRO)
	SELECT m.TAR_PAG_MONTO, m.TAR_PAG_FECHA, o.MON_ID, t.TAR_NRO
	FROM gd_esquema.Maestra AS m
	INNER JOIN gd_esquema.tarjetas AS t ON (m.TAR_NRO = t.TAR_NRO)
	INNER JOIN gd_esquema.monedas AS o ON (m.TAR_PAG_MONEDA_COD = o.MON_ID)
	WHERE m.TAR_PAG_MONTO > 0 AND m.TAR_PAG_FECHA IS NOT NULL
GO

DROP PROCEDURE migrar_cheques
GO
CREATE PROCEDURE migrar_cheques AS
	INSERT INTO gd_esquema.cheques (CHE_CUE_ORIGEN, CHE_CUE_DESTINO, CHE_NRO, CHE_MONTO, CHE_FECHA, CHE_MONEDA)
	(SELECT DISTINCT co.CUE_ID, cd.CUE_ID, m.CHE_NRO, m.CHE_MONTO, m.CHE_FECHA, o.MON_ID
	FROM gd_esquema.Maestra AS m
	INNER JOIN gd_esquema.monedas AS o ON (o.MON_ID = m.CHE_MONEDA) -- Moneda
	INNER JOIN gd_esquema.cuentas AS co ON (co.CUE_COD = m.CHE_CUE_ORIGEN) -- ID de la cuenta de origen
	INNER JOIN gd_esquema.cuentas AS cd ON (cd.CUE_COD = m.CHE_CUE_DESTINO) -- ID de la cuenta de destino
	WHERE m.CHE_MONTO > 0)
GO

DROP PROCEDURE migrar_transferencias
GO
CREATE PROCEDURE migrar_transferencias AS
	INSERT INTO gd_esquema.transferencias (TRA_CUE_ORIGEN, TRA_CUE_DESTINO, TRA_FECHA, TRA_MONTO, TRA_MONEDA)
	(SELECT DISTINCT co.CUE_ID, cd.CUE_ID, m.TRA_FECHA, m.TRA_MONTO, o.MON_ID
	FROM gd_esquema.Maestra AS m
	LEFT JOIN gd_esquema.cuentas AS co ON (co.CUE_COD = m.TRA_CUE_ORIGEN) -- ID de la cuenta de origen
	LEFT JOIN gd_esquema.cuentas AS cd ON (cd.CUE_COD = m.TRA_CUE_DESTINO) -- ID de la cuenta de destino
	INNER JOIN gd_esquema.monedas AS o ON(o.MON_ID = m.TRA_MONEDA))
GO