USE CRM
GO

-- Milton 👇🏻
DROP VIEW IF EXISTS vVentas
GO
CREATE VIEW vVentas AS
	SELECT * FROM Cotizacion coti
		WHERE id_etapa = 'Facturada' OR probabilidad = 100
GO

-- Familias de productos vendidos. Familia y monto.
DROP VIEW IF EXISTS vFamiliaProductosVendidos
GO
CREATE VIEW vFamiliaProductosVendidos AS
	SELECT proxcoti.Familia, SUM(proxcoti.precio_estandar) AS Monto FROM vVentas ve
		INNER JOIN vProductosXcotizacion proxcoti ON ve.numero_cotizacion = proxcoti.numero_cotizacion
		INNER JOIN Familia fa ON proxcoti.Familia = fa.nombre
	GROUP BY proxcoti.Familia
	ORDER BY Monto DESC
GO

-- Andy 👇🏻




