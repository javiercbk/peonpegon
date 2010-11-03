-- SALDO DE LAS CUENTAS

-- TRANSFERENCIAS QUE SE ACREDITAN
SELECT TRA_CUE_DESTINO, SUM(TRA_MONTO)
FROM gd_esquema.transferencias
WHERE TRA_FECHA <= GETDATE() -- ME ASEGURO QUE SE HAYA ACREDITADO
AND TRA_CUE_DESTINO IS NOT NULL AND TRA_CUE_DESTINO > 0
-- AND TRA_CUE_DESTINO = CUE_ID
GROUP BY TRA_CUE_DESTINO
UNION
-- TRANSFERENCIAS QUE SE DEBITAN
SELECT TRA_CUE_ORIGEN, (- SUM(TRA_MONTO))
FROM gd_esquema.transferencias
WHERE TRA_FECHA <= GETDATE() -- ME ASEGURO QUE SE HAYA DEBITADO
AND TRA_CUE_ORIGEN IS NOT NULL AND TRA_CUE_ORIGEN > 0
-- AND TRA_CUE_ORIGEN = CUE_ID
GROUP BY TRA_CUE_ORIGEN
UNION
-- CHEQUES QUE SE ACREDITAN
SELECT CHE_CUE_DESTINO, SUM(CHE_MONTO)
FROM gd_esquema.cheques
WHERE CHE_FECHA <= GETDATE() -- ME ASEGURO QUE SE HAYA ACREDITADO
AND CHE_CUE_DESTINO IS NOT NULL AND CHE_CUE_DESTINO > 0
-- AND TRA_CUE_DESTINO = CUE_ID
GROUP BY CHE_CUE_DESTINO
UNION
-- CHEQUES QUE SE DEBITAN
SELECT CHE_CUE_ORIGEN, (- SUM(CHE_MONTO))
FROM gd_esquema.cheques
WHERE CHE_FECHA <= GETDATE() -- ME ASEGURO QUE SE HAYA ACREDITADO
AND CHE_CUE_ORIGEN IS NOT NULL AND CHE_CUE_ORIGEN > 0
-- AND CHE_CUE_ORIGEN = CUE_ID
GROUP BY CHE_CUE_ORIGEN


-- PLAZOS FIJOS
SELECT c.CLI_ID, c.CLI_NOMB, c.CLI_APELLIDO, c.CLI_DNI, pf.PF_COD, b.BANC_NOM, s.SUC_DIR, s.SUC_DIR_NRO,
pf.PF_IMPOR, pf.PF_FCREA, pf.PF_FFIN, 
CASE WHEN (DATEDIFF(DAY,pf.PF_FFIN,GETDATE())> 0) THEN 'VIGENTE' ELSE 'NO VIGENTE' END AS VIGENCIA, -- VIGENCIA DEL PLAZO FIJO
CASE WHEN (DATEDIFF(MONTH,pf.PF_FCREA,pf.PF_FFIN) > 0 AND DATEDIFF(MONTH,pf.PF_FCREA,pf.PF_FFIN) <= 3 )
THEN 5 -- 5% DE INTERES 
WHEN (DATEDIFF(MONTH,pf.PF_FCREA,pf.PF_FFIN) > 3 AND DATEDIFF(MONTH,pf.PF_FCREA,pf.PF_FFIN) <= 6 )
THEN 12 -- 12% DE INTERES
WHEN (DATEDIFF(MONTH,pf.PF_FCREA,pf.PF_FFIN) > 6 AND DATEDIFF(MONTH,pf.PF_FCREA,pf.PF_FFIN) <= 12)
THEN 17 -- 17% DE INTERES
WHEN (DATEDIFF(MONTH,pf.PF_FCREA,pf.PF_FFIN) > 12)
THEN 23 -- 23% DE INTERES
ELSE 0 END AS INTERES -- NO DEBER�A SUCEDER
FROM gd_esquema.plazo_fijos AS pf
INNER JOIN gd_esquema.clientes AS c ON (c.CLI_ID = PF.CLI_ID)
INNER JOIN gd_esquema.sucursales AS s ON (s.SUC_ID = c.SUC_ID)
INNER JOIN gd_esquema.bancos AS b ON (b.BANC_ID = s.BANC_ID)
WHERE PF_COD != 0 AND PF_COD IS NOT NULL

SELECT DISTINCT *
FROM gd_esquema.Maestra AS m
WHERE m.PF_COD IS NOT NULL AND m.PF_COD != 0