/*
SELECT gd_esquema.dame_cant_transf_or(5732)
SELECT gd_esquema.dame_cant_transf_de(5732)
SELECT gd_esquema.dame_op_tar_ua(5732)
SELECT gd_esquema.dame_op_tar_h(5732)
SELECT gd_esquema.dame_mon_che(5732)
SELECT gd_esquema.dame_mon_tar(5732)
SELECT gd_esquema.dame_mon_tran(5732)
SELECT gd_esquema.dame_punt_prom_tar(5732)

BEGIN
	DECLARE @proc AS int
	EXEC gd_esquema.calcular_calidad @proc
	SELECT @proc
END

SELECT * FROM gd_esquema.proceso_calidad_clientes

SELECT TOP 10 c.* FROM gd_esquema.deudas AS d
INNER JOIN gd_esquema.tarjetas AS t ON (d.TAR_NRO = t.TAR_NRO)
INNER JOIN gd_esquema.clientes AS c ON (c.CLI_ID = t.CLI_ID)
WHERE DATEDIFF(YEAR,d.TAR_DEU_FECHA,GETDATE()) < 1 -- MENOR A UN AÑO
*/	


DROP FUNCTION gd_esquema.dame_cant_transf_or 
GO
-- RETORNA LA CANTIDAD DE TRANSFERENCIAS COMO ORIGEN DE UN CLIENTE
CREATE FUNCTION gd_esquema.dame_cant_transf_or (@cli_id int) RETURNS [int] 
AS
BEGIN
	DECLARE @cant_cue AS int
	SELECT @cant_cue=COUNT(tra.TRA_NRO) FROM gd_esquema.transferencias AS tra
	INNER JOIN gd_esquema.cuentas AS co ON (tra.TRA_CUE_ORIGEN = co.CUE_ID)
	WHERE co.CLI_ID = @cli_id
	IF @cant_cue IS NULL
		SET @cant_cue = 0 -- SI NO HAY RESULTADOS SETEO EN 0
	RETURN @cant_cue
END
GO

DROP FUNCTION gd_esquema.dame_cant_transf_de 
GO
-- RETORNA LA CANTIDAD DE TRANSFERENCIAS COMO DESTINO DE UN CLIENTE
CREATE FUNCTION gd_esquema.dame_cant_transf_de (@cli_id int) RETURNS [int] 
AS
BEGIN
	DECLARE @cant_cue AS int
	SELECT @cant_cue=COUNT(tra.TRA_NRO) FROM gd_esquema.transferencias AS tra
	INNER JOIN gd_esquema.cuentas AS co ON (tra.TRA_CUE_DESTINO = co.CUE_ID)
	WHERE co.CLI_ID = @cli_id AND DATEDIFF(YEAR,tra.TRA_FECHA,GETDATE()) < 1 -- MENOR A UN AÑO
	IF @cant_cue IS NULL
		SET @cant_cue = 0 -- SI NO HAY RESULTADOS SETEO EN 0
	RETURN @cant_cue
END
GO

DROP FUNCTION gd_esquema.dame_op_tar_ua
GO
-- RETORNA CANTIDAD DE OPERACIONES TOTAL DE LAS COMPRAS CON TARJETA MENORES A 1 AÑO
CREATE FUNCTION gd_esquema.dame_op_tar_ua (@cli_id int) RETURNS [int] 
AS
BEGIN
	DECLARE @cant_cue AS int
	SELECT @cant_cue=COUNT(d.DEUDA_ID) FROM gd_esquema.deudas AS d
	INNER JOIN gd_esquema.tarjetas AS t ON (t.TAR_NRO = d.TAR_NRO)
	INNER JOIN gd_esquema.clientes AS c ON (c.CLI_ID = t.CLI_ID)
	WHERE c.CLI_ID = @cli_id AND DATEDIFF(YEAR,d.TAR_DEU_FECHA,GETDATE()) < 1 -- MENOR A UN AÑO
	IF @cant_cue IS NULL
		SET @cant_cue = 0 -- SI NO HAY RESULTADOS SETEO EN 0
	RETURN @cant_cue
END
GO

DROP FUNCTION gd_esquema.dame_op_tar_h 
GO
-- RETORNA CANTIDAD DE OPERACIONES TOTAL DE LAS COMPRAS CON TARJETA MAYORES A 1 AÑO
CREATE FUNCTION gd_esquema.dame_op_tar_h (@cli_id int) RETURNS [int] 
AS
BEGIN
	DECLARE @cant_cue AS int
	SELECT @cant_cue=COUNT(d.DEUDA_ID) FROM gd_esquema.deudas AS d
	INNER JOIN gd_esquema.tarjetas AS t ON (t.TAR_NRO = d.TAR_NRO)
	INNER JOIN gd_esquema.clientes AS c ON (c.CLI_ID = t.CLI_ID)
	WHERE c.CLI_ID = @cli_id AND DATEDIFF(YEAR,d.TAR_DEU_FECHA,GETDATE()) > 1 -- MAYOR A UN AÑO
	IF @cant_cue IS NULL
		SET @cant_cue = 0 -- SI NO HAY RESULTADOS SETEO EN 0
	RETURN @cant_cue
END
GO

DROP FUNCTION gd_esquema.dame_mon_che
GO
-- RETORNA EL MONTO TOTAL DE LOS CHEQUES EMITIDOS PARA UN CLIENTE
CREATE FUNCTION gd_esquema.dame_mon_che (@cli_id int) RETURNS [int] 
AS
BEGIN
	DECLARE @mon AS int
	DECLARE @cot AS real
	DECLARE @mon_t AS int
	DECLARE @mon_id AS int
	-- SUMO LOS MONTOS
	SELECT @mon=SUM(ch.CHE_MONTO) FROM gd_esquema.cheques AS ch
	INNER JOIN gd_esquema.cuentas AS cu ON (cu.CUE_ID = ch.CHE_CUE_ORIGEN)
	INNER JOIN gd_esquema.clientes AS c ON (c.CLI_ID = cu.CLI_ID)
	WHERE c.CLI_ID = @cli_id
	-- BUSCO LA MONEDA USADA
	SELECT DISTINCT @mon_id = ch.CHE_MONEDA FROM gd_esquema.cheques AS ch
	INNER JOIN gd_esquema.cuentas AS cu ON (cu.CUE_ID = ch.CHE_CUE_ORIGEN)
	INNER JOIN gd_esquema.clientes AS c ON (c.CLI_ID = cu.CLI_ID)
	WHERE c.CLI_ID = @cli_id
	SELECT @cot = o.MON_COT FROM gd_esquema.monedas AS o WHERE o.MON_ID = @mon_id
	IF @mon IS NULL
		SET @mon = 0 -- SI NO HAY RESULTADOS SETEO EN 0
	IF @cot IS NULL
		SET @cot = 0 -- SI NO HAY RESULTADOS SETEO EN 0
	SET @mon_t = @mon * @cot
	RETURN @mon_t
END
GO

DROP FUNCTION gd_esquema.dame_mon_tar
GO
-- RETORNA EL MONTO TOTAL DE LAS COMPRAS CON TARJETA PARA UN CLIENTE PARA LOS ULTIMOS 3 AÑOS
CREATE FUNCTION gd_esquema.dame_mon_tar (@cli_id int) RETURNS [real] 
AS
BEGIN
	DECLARE @mon AS int
	-- SUMO LOS MONTOS
	SELECT @mon=SUM(d.TAR_DEU_MONTO) FROM gd_esquema.deudas AS d
	INNER JOIN gd_esquema.tarjetas AS t ON (t.TAR_NRO = d.TAR_NRO)
	INNER JOIN gd_esquema.clientes AS c ON (c.CLI_ID = t.CLI_ID)
	WHERE c.CLI_ID = @cli_id AND DATEDIFF(YEAR,d.TAR_DEU_FECHA,GETDATE()) <= 3 -- ULTIMOS 3 AÑOS
	IF @mon IS NULL
		SET @mon = 0 -- SI NO HAY RESULTADOS SETEO EN 0
	RETURN @mon
END
GO

DROP FUNCTION gd_esquema.dame_mon_tran
GO
-- RETORNA EL MONTO TOTAL DE TRANSFERENCIAS ORIGEN PARA UN CLIENTE PARA LOS ULTIMOS 3 AÑOS
CREATE FUNCTION gd_esquema.dame_mon_tran (@cli_id int) RETURNS [real] 
AS
BEGIN
	DECLARE @mon AS real
	-- SUMO LOS MONTOS
	SELECT @mon=SUM(tr.TRA_MONTO) FROM gd_esquema.transferencias AS tr
	INNER JOIN gd_esquema.cuentas AS cu ON (tr.TRA_CUE_ORIGEN = cu.CUE_ID)
	INNER JOIN gd_esquema.clientes AS c ON (c.CLI_ID = cu.CLI_ID)
	WHERE c.CLI_ID = @cli_id AND DATEDIFF(YEAR,tr.TRA_FECHA,GETDATE()) <= 3 -- ULTIMOS 3 AÑOS
	IF @mon IS NULL
		SET @mon = 0 -- SI NO HAY RESULTADOS SETEO EN 0
	RETURN @mon
END
GO

DROP FUNCTION gd_esquema.dame_punt_prom_tar
GO
-- RETORNA LOS PUNTOS POR PROMEDIO DE MONTO DE OPERACIONES CON TARJETA
CREATE FUNCTION gd_esquema.dame_punt_prom_tar (@cli_id int) RETURNS [real] 
AS
BEGIN
	DECLARE @mon AS real
	DECLARE @cant AS int
	-- SUMO LOS MONTOS
	SELECT @mon=SUM(d.TAR_DEU_MONTO) FROM gd_esquema.deudas AS d
	INNER JOIN gd_esquema.tarjetas AS t ON (t.TAR_NRO = d.TAR_NRO)
	INNER JOIN gd_esquema.clientes AS c ON (c.CLI_ID = t.CLI_ID)
	WHERE c.CLI_ID = @cli_id AND DATEDIFF(YEAR,d.TAR_DEU_FECHA,GETDATE()) <= 5 -- ULTIMOS 3 AÑOS
	IF @mon IS NULL
		SET @mon = 0 -- SI NO HAY RESULTADOS SETEO EN 0
	SELECT @cant=COUNT(d.TAR_DEU_MONTO) FROM gd_esquema.deudas AS d
	INNER JOIN gd_esquema.tarjetas AS t ON (t.TAR_NRO = d.TAR_NRO)
	INNER JOIN gd_esquema.clientes AS c ON (c.CLI_ID = t.CLI_ID)
	WHERE c.CLI_ID = @cli_id AND DATEDIFF(YEAR,d.TAR_DEU_FECHA,GETDATE()) <= 5 -- ULTIMOS 3 AÑOS
	IF @cant IS NULL
		RETURN 0 -- SI NO HAY RESULTADOS SETEO EN 0
	RETURN @mon/@cant
END
GO

DROP PROCEDURE gd_esquema.calcular_calidad
GO
CREATE PROCEDURE gd_esquema.calcular_calidad (@proc int OUTPUT)
AS
BEGIN
	DECLARE @cli_iden AS int
	DECLARE @ban_iden AS int
	DECLARE @value AS int
	DECLARE cli_cur CURSOR FOR
	(SELECT c.CLI_ID, b.BANC_ID FROM gd_esquema.clientes AS c
	INNER JOIN gd_esquema.sucursales AS s ON(c.SUC_ID = s.SUC_ID)
	INNER JOIN gd_esquema.bancos AS b ON (b.BANC_ID = s.BANC_ID)
	WHERE c.ENABLED = 1) -- CLIENTE ACTIVO 
	-- OBTENGO EL PROC_ID
	SELECT @proc=MAX(PROC_ID) FROM gd_esquema.proceso_calidad_clientes
	IF @proc IS NULL
		SET @proc = 0 
	OPEN cli_cur
	FETCH cli_cur INTO @cli_iden, @ban_iden 
	WHILE @@fetch_status = 0 -- RECORRO CON UN CURSOR TODOS LOS CLIENTES Y OBTENGO SU PUNTAJE 1 A 1
	BEGIN
		SELECT @value = (COUNT(CLI_ID) * 3) FROM gd_esquema.cuentas WHERE CLI_ID = @cli_iden -- PUNTOS POR CUENTA
		SELECT @value = @value + ((gd_esquema.dame_cant_transf_or(@cli_iden)/100) * 4) -- PUNTOS POR CADA 100 TRANSFERENCIAS ORIGEN
		SELECT @value = @value + ((gd_esquema.dame_cant_transf_de(@cli_iden)/30) * 6) -- PUNTOS POR CADA 30 TRANSFERENCIAS DESTINO
		SELECT @value = @value + ((gd_esquema.dame_op_tar_ua(@cli_iden)/100) * 5) -- PUNTOS POR CADA COMPRA CON TARJETA HECHA EN EL ULTIMO AÑO
		SELECT @value = @value + ((gd_esquema.dame_op_tar_h(@cli_iden)/100) * 3) -- PUNTOS POR CADA COMPRA CON TARJETA HECHA HACE MAS DE UN AÑO
		SELECT @value = @value + ((gd_esquema.dame_mon_che(@cli_iden)/2000) * 2) -- PUNTOS POR CADA 2000 PESOS EN CHEQUE EMITIDO
		IF (gd_esquema.dame_mon_tar(@cli_iden) > gd_esquema.dame_mon_tran(@cli_iden))
			SET @value = @value + 9
		IF (gd_esquema.dame_punt_prom_tar(@cli_iden) > 1000)
			SET @value = @value + 4
		IF @value > 100 
			SET @value = 100 -- TRUNCO RESULTADO
		EXEC insertar_calidad @proc, @cli_iden, @ban_iden, @value
		FETCH cli_cur INTO @cli_iden, @ban_iden
	END
	CLOSE cli_cur
	DEALLOCATE cli_cur
END
GO

DROP PROCEDURE insertar_calidad
GO
CREATE PROCEDURE insertar_calidad(@proc int, @cli_iden int, @ban_iden int, @value int) AS
	INSERT INTO gd_esquema.proceso_calidad_clientes (PROC_ID, CLI_ID, BANC_ID, VALOR_CAL)
		VALUES (@proc, @cli_iden, @ban_iden, @value)
GO