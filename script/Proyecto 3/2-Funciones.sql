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
)
GO


/*
Función que filtra por rango de fecha las/el Top 10 de productos más cotizados. Descripción y cantidad.
*/
DROP FUNCTION IF EXISTS fProductosMasCotizados
GO
CREATE FUNCTION fProductosMasCotizados(@fechaInicio DATE, @fechaFin DATE)
RETURNS TABLE
AS
RETURN (
	SELECT TOP(10) pro.descripcion, COUNT(proxcoti.codigo_producto) AS cantidad_cotizaciones
	FROM Cotizacion coti, ProductoCotizacion proxcoti
		INNER JOIN Producto pro ON proxcoti.codigo_producto = pro.codigo
			WHERE coti.fecha_cotizacion >= @fechaInicio AND coti.fecha_cotizacion <= @fechaFin
	GROUP BY proxcoti.codigo_producto, pro.descripcion
	ORDER BY cantidad_cotizaciones DESC
	)
GO


/*
Función que filtra por rango de fecha las/el Ventas por zona. Descripción y monto. Gráfico circular.
*/
DROP FUNCTION IF EXISTS fVentasPorZona
GO
CREATE FUNCTION fVentasPorZona(@fechaInicio DATE, @fechaFin DATE)
RETURNS TABLE
AS
RETURN (
		SELECT ve.descripcion, (SELECT dbo.fMontoCotizacion(ve.numero_cotizacion)) AS monto
		FROM vVentas ve, zona zo
			WHERE ve.id_zona = zo.id AND
				 (ve.fecha_cierre >= @fechaInicio OR ve.fecha_cierre <= @fechaFin)
		)
GO

/*
Función que filtra por rango de fecha las/el Ventas por departamento. Gráfico circular (porcentual).
*/
DROP FUNCTION IF EXISTS fPorcentajeVentasPorDepartamento
GO
CREATE FUNCTION fPorcentajeVentasPorDepartamento(@fechaInicio DATE, @fechaFin DATE)
RETURNS TABLE
AS
	RETURN (
			SELECT dep.nombre AS departamento, (COUNT(dep.nombre) * 100 / (
			SELECT COUNT(*) FROM vVentas)) AS porcentaje
			FROM vVentas coti
				INNER JOIN Usuario u ON u.cedula = coti.id_asesor
				INNER JOIN Departamento dep ON dep.id = u.id_departamento
				WHERE coti.fecha_cierre >= @fechaInicio AND fecha_cierre <= @fechaFin
			GROUP BY dep.nombre
	)
GO



/*
Función que filtra por rango de fecha las/el  Ventas y cotizaciones por mes, por año, en valor presente. Gráfico de barras.
*/
-- Función que filtra las cotizaciones con valor presente por mes específico
DROP FUNCTION IF EXISTS fCotizacionesValorPresentePorMes
GO
CREATE FUNCTION fCotizacionesValorPresentePorMes(@mes VARCHAR(20))
RETURNS TABLE
AS
RETURN (
	SELECT * FROM vCotizacionesValorPresentePorMes ve
		WHERE ve.Mes = @mes
)
GO

-- Función que filtra las ventas con valor presente por mes específico
DROP FUNCTION IF EXISTS fVentasValorPresentePorMes
GO
CREATE FUNCTION fVentasValorPresentePorMes(@mes VARCHAR(20))
RETURNS TABLE
AS
RETURN (
	SELECT * FROM vVentasValorPresentePorMes ve
		WHERE ve.Mes = @mes
)
GO

-- Función que filtra las cotizaciones con valor presente por año específico
DROP FUNCTION IF EXISTS fCotizacionesValorPresentePorAnno
GO
CREATE FUNCTION fCotizacionesValorPresentePorAnno(@anno VARCHAR(20))
RETURNS TABLE
AS
RETURN (
	SELECT * FROM vCotizacionesValorPresentePorAnno coti
		WHERE coti.Año = @anno
)
GO

-- Función que filtra las ventas con valor presente por mes específico
DROP FUNCTION IF EXISTS fVentasValorPresentePorAnno
GO
CREATE FUNCTION fVentasValorPresentePorAnno(@anno VARCHAR(20))
RETURNS TABLE
AS
RETURN (
	SELECT * FROM vVentasValorPresentePorAnno ve
		WHERE ve.Año = @anno
)
GO


/*
Función que filtra por rango de fecha las/el Cantidad de Ejecuciones con cierre por mes, por año.
*/
DROP FUNCTION IF EXISTS fTotalEjecucionesConCierre
GO
CREATE FUNCTION fTotalEjecucionesConCierre(@fechaInicio DATE, @fechaFin DATE)
RETURNS TABLE
AS
RETURN (
	SELECT COUNT(*) as Total FROM Ejecucion
		WHERE fechaCierre > @fechaInicio AND
			  fechaCierre < @fechaFin
	)
GO


/*
Función que filtra por rango de fecha las/el Top 10 de cotizaciones con más actividades y tareas (sumadas juntas).
*/
DROP FUNCTION IF EXISTS fCotizacionesConMasActividades
GO
CREATE FUNCTION fCotizacionesConMasActividades(@fechaInicio DATE, @fechaFin DATE)
RETURNS TABLE
AS
RETURN (
	SELECT TOP(10) numero_cotizacion,
				(SELECT (SELECT dbo.fCotizacionesConTotalTareas(numero_cotizacion)) +
						(SELECT dbo.fCotizacionesConTotalActividades(numero_cotizacion))
				) AS total_tareas_actividades
	 FROM Cotizacion coti
		WHERE fecha_cotizacion >= @fechaInicio AND
			  fecha_cotizacion <= @fechaFin
	 )
GO


/*
Función que filtra por rango de fecha las/el Cantidad de cotizaciones por tipo. Gráfico circular.
*/
DROP FUNCTION IF EXISTS fCantidadCotizacionesPorTipo
GO
CREATE FUNCTION fCantidadCotizacionesPorTipo(@fechaInicio DATE, @fechaFin DATE)
RETURNS TABLE
AS
RETURN (
		SELECT tipoCotizacion.nombre, COUNT(numero_cotizacion) cantidad
		FROM Cotizacion, tipoCotizacion
			WHERE Cotizacion.tipo = tipoCotizacion.id AND
				  fecha_cotizacion >= @fechaInicio AND
				  fecha_cotizacion <= @fechaFin
		 GROUP BY tipoCotizacion.nombre
		)
GO


/*
Función que filtra por rango de fecha las/el Casos por tipo (porcentual). Gráfico circular
*/
DROP FUNCTION IF EXISTS fCasosPorTipo
GO
CREATE FUNCTION fCasosPorTipo(@fechaInicio DATE, @fechaFin DATE)
RETURNS TABLE
AS
RETURN (
		SELECT tc.tipo AS tipo, (
								(COUNT(tc.tipo) * 100) /
								(SELECT COUNT(*) FROM Caso)
								) AS Porcentaje
		FROM Caso c
			INNER JOIN TipoCaso tc ON c.id_tipo = tc.id
			INNER JOIN Ejecucion ej ON c.proyectoAsociado = ej.id AND
			ej.fechaEjecucion >= @fechaInicio AND ej.fechaEjecucion <= @fechaFin
		GROUP BY tc.tipo
		)
GO



-- Andy 👇🏻
