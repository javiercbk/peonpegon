SET ROWCOUNT 0
GO
/*
EXEC sp_msforeachtable "ALTER TABLE ? NOCHECK CONSTRAINT all"
GO
DELETE FROM gd_esquema.transferencias
DELETE FROM gd_esquema.cheques
DELETE FROM gd_esquema.pagos
DELETE FROM gd_esquema.deudas
DELETE FROM gd_esquema.tarjetas
DELETE FROM gd_esquema.plazo_fijos
DELETE FROM gd_esquema.cuentas
DELETE FROM gd_esquema.monedas
DELETE FROM gd_esquema.clientes
DELETE FROM gd_esquema.sucursales
DELETE FROM gd_esquema.bancos
GO
exec sp_msforeachtable @command1="print '?'", @command2="ALTER TABLE ? WITH CHECK CHECK CONSTRAINT all"
GO
*/
exec migrar_bancos
GO
exec migrar_sucursales
GO
exec migrar_clientes
GO
exec migrar_cuentas
GO
exec migrar_monedas
GO
exec migrar_plazo_fijos
GO
exec migrar_tarjetas
GO
exec migrar_deudas
GO
exec migrar_pagos
GO
exec migrar_cheques
GO
exec migrar_transferencias
GO

/*
SELECT COUNT(TRA_NRO) AS transferencias_totales FROM gd_esquema.transferencias
SELECT COUNT(CHE_ID) AS cheques_totales FROM gd_esquema.cheques
SELECT COUNT(PAGO_ID) AS pagos_totales FROM gd_esquema.pagos
SELECT COUNT(DEUDA_ID) AS deudas_totales FROM gd_esquema.deudas
SELECT COUNT(TAR_NRO) AS tarjetas_totales FROM gd_esquema.tarjetas
SELECT COUNT(PF_COD) AS pf_totales FROM gd_esquema.plazo_fijos
SELECT COUNT(CUE_ID) AS cuentas_totales FROM gd_esquema.cuentas
SELECT COUNT(MON_ID) AS monedas_totales FROM gd_esquema.monedas
SELECT COUNT(CLI_ID) AS clientes_totales FROM gd_esquema.clientes
SELECT COUNT(SUC_ID) AS sucursales_totales FROM gd_esquema.sucursales
SELECT COUNT(BANC_ID) AS bancos_totales FROM gd_esquema.bancos
*/

