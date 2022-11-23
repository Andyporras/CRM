USE CRM
GO

-- Milton 👇🏻



-- Funcion que filtre las ejecuciones con cierre por mes
DROP FUNCTION IF EXISTS fTotalEjecucionesConCierrePorMes
GO
CREATE FUNCTION fTotalEjecucionesConCierrePorMes (@mes VARCHAR(20))
RETURNS TABLE
AS
RETURN
(
		SELECT * from vTotalEjecucionesConCierre
		where mes = @mes
)
GO


--funcion que filtra las ejecucione scon cierre por año
DROP FUNCTION IF EXISTS fTotalEjecucionesConCierrePorAnno
GO
CREATE FUNCTION fTotalEjecucionesConCierrePorAnno (@anno INT)
RETURNS TABLE
AS
RETURN
(
		SELECT * from vTotalEjecucionesConCierrePorAnno
		where @anno = anno
)
GO

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
				 (ve.fecha_cierre >= @fechaInicio AND ve.fecha_cierre <= @fechaFin)
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
			SELECT COUNT(*) FROM vVentas)) AS porcentaje_de_ventas
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


-- Funcion que filtre los productos mas vendidos por fecha

DROP FUNCTION IF EXISTS fProductosMasVendidos
GO
CREATE FUNCTION fProductosMasVendidos(@fechaInicio DATETIME, @fechaFin DATETIME)
RETURNS TABLE
AS
RETURN (
	SELECT TOP 10 p.Descripcion, SUM(p.precio_estandar) AS Monto
	FROM ProductoCotizacion pc
	INNER JOIN Producto p ON p.codigo = pc.codigo_producto
	INNER JOIN vVentas v ON v.numero_cotizacion = pc.numero_cotizacion
		WHERE v.fecha_cierre >= @fechaInicio AND v.fecha_cierre <= @fechaFin
	GROUP BY p.Descripcion, p.nombre, p.precio_estandar
	ORDER BY Monto DESC
)
GO

-- Funcion que filtre las ventas por sector por fecha

DROP FUNCTION IF EXISTS fVentasPorSector
GO
CREATE FUNCTION fVentasPorSector(@fechaInicio DATETIME, @fechaFin DATETIME)
RETURNS TABLE
AS
RETURN (
	SELECT p.Descripcion, SUM(p.precio_estandar) AS Monto
	FROM ProductoCotizacion pc
	INNER JOIN Producto p ON p.codigo = pc.codigo_producto
	INNER JOIN vVentas v ON v.numero_cotizacion = pc.numero_cotizacion
	INNER JOIN Sector s ON s.id = V.id_sector
		WHERE v.fecha_cierre >= @fechaInicio AND v.fecha_cierre <= @fechaFin
	GROUP BY p.descripcion
	--ORDER BY Monto DESC
)
GO

/*
Función que filtra por rango de fecha las/el Cotizaciones y Ventas por departamento. Comparativo. Gráfico de barras.
*/
DROP FUNCTION IF EXISTS fCotizacionYVentasDepartamento
GO
CREATE FUNCTION fCotizacionYVentasDepartamento(@fechaInicio DATE, @fechaFin DATE)
RETURNS TABLE
AS
RETURN (
	SELECT d.nombre AS Departamento,
		(SELECT COUNT(*) FROM vCotizacionDepartamento c WHERE c.idDepartamento = d.id AND c.fecha_cotizacion >= @fechaInicio AND c.fecha_cierre <= @fechaFin) AS Cotizaciones,
		(SELECT COUNT(*) FROM vVentaDepartamento v WHERE v.idDepartamento = d.id AND v.fecha_cierre >= @fechaInicio AND v.fecha_cierre <= @fechaFin) AS Ventas
	FROM Departamento d
)
GO

/*
Función que filtra por rango de fecha las/el Ventas y cotizaciones por mes. Gráfico de barras.
Devuelve el Cotizaciones y Ventas por mes. Comparativo. Gráfico de barras.
*/
DROP FUNCTION IF EXISTS fVentasYCotizacionPorMes
GO
CREATE FUNCTION fVentasYCotizacionPorMes(@fechaInicio DATE, @fechaFin DATE)
RETURNS TABLE
AS
RETURN (
	SELECT MONTH(fecha_cierre) AS Mes,
		(SELECT COUNT(*) FROM vCotizacionDepartamento c WHERE MONTH(c.fecha_cotizacion) = MONTH(v.fecha_cierre) AND c.fecha_cotizacion >= @fechaInicio AND c.fecha_cierre <= @fechaFin) AS Cotizaciones,
		(SELECT COUNT(*) FROM vVentaDepartamento v WHERE MONTH(v.fecha_cierre) = MONTH(v.fecha_cierre) AND v.fecha_cierre >= @fechaInicio AND v.fecha_cierre <= @fechaFin) AS Ventas
	FROM vVentaDepartamento v
	WHERE fecha_cierre >= @fechaInicio AND fecha_cierre <= @fechaFin
	GROUP BY MONTH(fecha_cierre)
)
GO

/*
Función que filtra por rango de fecha las/el  Top 10 de clientes con mayores ventas.
*/
DROP FUNCTION IF EXISTS fTop10ClientesMayorVentas
GO
CREATE FUNCTION fTop10ClientesMayorVentas(@fechaInicio DATE, @fechaFin DATE)
RETURNS TABLE
AS
RETURN (
	SELECT TOP 10 cc.nombre nombre, SUM(p.precio_estandar) AS Monto
	FROM ProductoCotizacion pc
	INNER JOIN Producto p ON p.codigo = pc.codigo_producto
	INNER JOIN vVentas v ON v.numero_cotizacion = pc.numero_cotizacion
	INNER JOIN vClienteCuentaCliente cc ON cc.nombre_cuenta = v.nombre_cuenta
		WHERE v.fecha_cierre >= @fechaInicio AND v.fecha_cierre <= @fechaFin
	GROUP BY cc.nombre
	ORDER BY Monto DESC
)
GO

/*
Función que filtra por rango de fecha las/el Top 10 de vendedores con mayores ventas. Nombre y monto
*/
DROP FUNCTION IF EXISTS fTop10VendedoresMayorVentas
GO
CREATE FUNCTION fTop10VendedoresMayorVentas(@fechaInicio DATE, @fechaFin DATE)
RETURNS TABLE
AS
RETURN (
	SELECT TOP 10 u.nombre, SUM(p.precio_estandar) AS Monto
	FROM ProductoCotizacion pc
	INNER JOIN Producto p ON p.codigo = pc.codigo_producto
	INNER JOIN vVentas v ON v.numero_cotizacion = pc.numero_cotizacion
	INNER JOIN Usuario u ON u.cedula = v.id_asesor
		WHERE v.fecha_cierre >= @fechaInicio AND v.fecha_cierre <= @fechaFin
	GROUP BY u.nombre
	ORDER BY Monto DESC
)
GO


/*
Función que filtra por rango de fecha las/el  Casos por estado. Gráfico circular
*/
DROP FUNCTION IF EXISTS fCasosPorEstado
GO
CREATE FUNCTION fCasosPorEstado(@fechaInicio DATE, @fechaFin DATE)
RETURNS TABLE
AS
RETURN (
	SELECT e.nombre as Estado, COUNT(e.nombre) AS cantidad
	FROM vCasosEjecucion CE
		INNER JOIN Estado e ON e.id = CE.id_estado
		WHERE CE.fechaEjecucion >= @fechaInicio AND CE.fechaCierre <= @fechaFin
	GROUP BY e.nombre
)
GO

/*
Función que filtra por rango de fecha las/el Cantidad de clientes por zona y monto ventas por zona. Zona, cantidad y monto.
*/
DROP FUNCTION IF EXISTS fCantidadClientesPorZonaYMonto
GO
CREATE FUNCTION fCantidadClientesPorZonaYMonto(@fechaInicio DATE, @fechaFin DATE)
RETURNS TABLE
AS
RETURN (
	SELECT z.nombre as Zona, COUNT(z.nombre) AS cantidad, SUM(p.precio_estandar) AS Monto
	FROM ProductoCotizacion pc
	INNER JOIN Producto p ON p.codigo = pc.codigo_producto
	INNER JOIN vVentas v ON v.numero_cotizacion = pc.numero_cotizacion
	INNER JOIN vClienteCuentaCliente cc ON cc.nombre_cuenta = v.nombre_cuenta
	INNER JOIN Zona z ON z.id = cc.id_zona
		WHERE v.fecha_cierre >= @fechaInicio AND v.fecha_cierre <= @fechaFin
	GROUP BY z.nombre
)
GO

/*
Función que filtra por rango de fecha las/el Top 10 de cotizaciones con diferencia entre creación y cierre más altos (cotización, cliente y cantidad de días de diferencia).
*/
DROP FUNCTION IF EXISTS fTop10CotizacionDiferenciaMasAlto
GO
CREATE FUNCTION fTop10CotizacionDiferenciaMasAlto(@fechaInicio DATE, @fechaFin DATE)
RETURNS TABLE
AS
RETURN (
	SELECT TOP 10 c.numero_cotizacion, cc.nombre, DATEDIFF(day, c.fecha_cotizacion, c.fecha_cierre) AS diferencia
	FROM cotizacion c
	INNER JOIN vClienteCuentaCliente cc ON cc.nombre_cuenta = c.nombre_cuenta
		WHERE c.fecha_cierre >= @fechaInicio AND c.fecha_cierre <= @fechaFin
	ORDER BY diferencia DESC
)
GO

/*
Función que filtra por rango de fecha las/el Top 15 de tareas sin cerrar más antiguas.
*/
DROP FUNCTION IF EXISTS fTop15TareasSinCerrarMasAntiguias
GO
CREATE FUNCTION fTop15TareasSinCerrarMasAntiguias(@fechaInicio DATE, @fechaFin DATE)
RETURNS TABLE
AS
RETURN (
	SELECT TOP 15 t.id, t.descripcion, t.fecha_creacion AS FechaCreacion, t.nombre_estado_tarea AS NombreEstadoTarea
	FROM vTareasEstadoTarea t
		WHERE t.fecha_finalizacion IS NULL AND t.fecha_creacion >= @fechaInicio AND t.fecha_finalizacion <= @fechaFin
	ORDER BY t.fecha_creacion ASC
)
GO

select *from vCotizacionYVentasDepartamento
SELECT * FROM dbo.fCotizacionYVentasDepartamento ('','')

SELECT * FROM dbo.VVentasYCotizacionPorMes 
SELECT * FROM dbo.fVentasYCotizacionPorMes ('','')

select *from  vTop10ClientesMayorVentas
select *from vCotizacionYVentasDepartamento
select *from vTop15TareasSinCerrarMasAntiguias

SELECT *FROM fCasosPorEstado ('','')
select *from fCantidadClientesPorZonaYmonto ('','')