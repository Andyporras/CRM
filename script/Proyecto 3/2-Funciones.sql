USE CRM
GO

-- Milton 👇🏻

-- Funcion que filtre las familias de productos vendidos por fecha
DROP FUNCTION IF EXISTS fFamiliaProductosVendidos
GO
CREATE FUNCTION fFamiliaProductosVendidos (@fechaInicio DATE, @fechaFin DATE)
RETURNS TABLE
AS
RETURN
(
		SELECT proxcoti.Familia, SUM(proxcoti.precio_estandar) AS Monto
		FROM vVentas ve
		INNER JOIN vProductosXcotizacion proxcoti ON ve.numero_cotizacion = proxcoti.numero_cotizacion
		INNER JOIN Familia fa ON proxcoti.Familia = fa.nombre
			WHERE ve.fecha_cierre >= @fechaInicio AND ve.fecha_cierre <= @fechaFin
		GROUP BY proxcoti.Familia
		ORDER BY Monto DESC
)
GO









-- Andy 👇🏻
