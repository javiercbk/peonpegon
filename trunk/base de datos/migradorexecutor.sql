/*
DELETE FROM gd_esquema.clientes
DELETE FROM gd_esquema.sucursales
DELETE FROM gd_esquema.bancos
GO
exec migrar_bancos
GO
exec migrar_sucursales
GO
exec migrar_clientes
GO
exec migrar_cuentas
GO
*/