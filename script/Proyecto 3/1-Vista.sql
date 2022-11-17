USE CRM
GO

-- Milton 👇🏻
-- Familias de productos vendidos. Familia y monto.
DROP VIEW IF EXISTS vFamiliaProductosVendidos
GO
CREATE VIEW vFamiliaProductosVendidos AS
	SELECT proxcoti.Familia, SUM(proxcoti.precio_estandar) AS Monto FROM vVentas ve
		INNER JOIN vProductosXcotizacion proxcoti ON ve.numero_cotizacion = proxcoti.numero_cotizacion
		INNER JOIN Familia fa ON proxcoti.Familia = fa.nombre
	GROUP BY proxcoti.Familia
GO

/*
Top 10 de productos más cotizados. Descripción y cantidad.
*/
DROP VIEW IF EXISTS vProductosMasCotizados
GO
CREATE VIEW vProductosMasCotizados AS
	SELECT TOP(10) pro.descripcion, COUNT(proxcoti.codigo_producto) AS cantidad_cotizaciones from ProductoCotizacion proxcoti
		INNER JOIN Producto pro ON proxcoti.codigo_producto = pro.codigo
	GROUP BY proxcoti.codigo_producto, pro.descripcion
	ORDER BY cantidad_cotizaciones DESC
GO


/*
Ventas por zona. Descripción y monto. Gráfico circular.
*/
DROP VIEW IF EXISTS vVentasPorZona
GO
CREATE VIEW vVentasPorZona AS
	SELECT ve.descripcion, (SELECT dbo.fMontoCotizacion(ve.numero_cotizacion)) AS monto
	FROM vVentas ve, zona zo
		WHERE ve.id_zona = zo.id
GO


/*
Ventas por departamento. Gráfico circular (porcentual).
*/
DROP VIEW IF EXISTS vPorcentajeVentasPorDepartamento
GO
CREATE VIEW vPorcentajeVentasPorDepartamento AS
	SELECT departamento, (
							(cantidad_ventas * 100) / (
							SELECT COUNT(*) FROM vVentas
							)) AS porcentaje_de_ventas
	FROM vCantidadVentasPorDepartamento
GO

/*
 Ventas y cotizaciones por mes, por año, en valor presente. Gráfico de barras.
*/
-- CotizacIones valor presente por mes
DROP VIEW IF EXISTS vCotizacionesValorPresentePorMes
GO
CREATE VIEW vCotizacionesValorPresentePorMes AS
      SELECT mes.nombre AS Mes,
			 SUM(dbo.fValorPresenteMontoCotizacion(coti.numero_cotizacion)) AS Monto_cotizaciones
	 FROM Cotizacion coti, mes
		WHERE mes.id = MONTH(coti.fecha_cotizacion)
	 GROUP BY mes.nombre
GO

-- Ventas valor presente por mes
DROP VIEW IF EXISTS vVentasValorPresentePorMes
GO
CREATE VIEW vVentasValorPresentePorMes AS
     SELECT mes.nombre AS Mes,
			 SUM(dbo.fValorPresenteMontoCotizacion(ve.numero_cotizacion)) AS Monto_ventas
	 FROM vVentas ve, mes
		WHERE mes.id = MONTH(ve.fecha_cotizacion)
	 GROUP BY mes.nombre
GO

-- Cotizaciones valor presente por año
DROP VIEW IF EXISTS vCotizacionesValorPresentePorAnno
GO
CREATE VIEW vCotizacionesValorPresentePorAnno AS
	SELECT YEAR(coti.fecha_cotizacion) AS Año,
		   SUM(dbo.fValorPresenteMontoCotizacion(coti.numero_cotizacion)) AS Monto_cotizaciones
	FROM Cotizacion coti
	GROUP BY YEAR(coti.fecha_cotizacion)
GO

-- Ventas valor presente por año
DROP VIEW IF EXISTS vVentasValorPresentePorAnno
GO
CREATE VIEW vVentasValorPresentePorAnno AS
	SELECT YEAR(ve.fecha_cotizacion) AS Año,
		   SUM(dbo.fValorPresenteMontoCotizacion(ve.numero_cotizacion)) AS Monto_Ventas
	FROM vVentas ve
	GROUP BY YEAR(ve.fecha_cotizacion)
GO


/*
Cantidad de contactos de cliente por usuario.
*/
DROP VIEW IF EXISTS vTotalContactoClientesPorUsuario
GO
CREATE VIEW vTotalContactoClientesPorUsuario AS
    select us.cedula, us.nombre + ' ' + us.apellido1 + ' ' + us.apellido2 as Usuario, COUNT(con.id) AS contactos_de_cliente
	from Contacto con, Usuario us
	WHERE cedula_usuario = us.cedula
	group by us.cedula, us.nombre + ' ' + us.apellido1 + ' ' + us.apellido2
GO

/*

Cantidad de Ejecuciones con cierre por mes, por año.
*/
DROP VIEW IF EXISTS vTotalEjecucionesConCierre
GO
CREATE VIEW vTotalEjecucionesConCierre AS
     SELECT COUNT(*) as Total FROM Ejecucion
		WHERE fechaCierre < GETDATE()
GO


/*
Top 10 de cotizaciones con más actividades y tareas (sumadas juntas).
*/
DROP VIEW IF EXISTS vCotizacionesConMasActividadesTareas
GO
CREATE VIEW vCotizacionesConMasActividadesTareas AS
     SELECT TOP(10) numero_cotizacion,
				(SELECT (SELECT dbo.fCotizacionesConTotalTareas(numero_cotizacion)) +
						(SELECT dbo.fCotizacionesConTotalActividades(numero_cotizacion))
				) AS total_tareas_actividades
	 FROM Cotizacion coti
	 ORDER BY total_tareas_actividades DESC
GO


/*
Cantidad de cotizaciones por tipo. Gráfico circular.
*/
DROP VIEW IF EXISTS vCantidadCotizacionesPorTipo
GO
CREATE VIEW vCantidadCotizacionesPorTipo AS
     SELECT tipoCotizacion.nombre, COUNT(numero_cotizacion) cantidad
		FROM Cotizacion, tipoCotizacion
		WHERE Cotizacion.tipo = tipoCotizacion.id
	 GROUP BY tipoCotizacion.nombre
GO


/*
Casos por tipo (porcentual). Gráfico circular
*/
DROP VIEW IF EXISTS vCasosPorTipo
GO
CREATE VIEW vCasosPorTipo AS
     SELECT tipo,
			(
				(cantidad_casos * 100) /
				(SELECT COUNT(*) FROM Caso)
			) AS Porcentaje
	 FROM vCantidadCasosPorTipo
GO



-- Andy 👇🏻



-- Productos vendidos. Descripcion y monto.
DROP VIEW IF EXISTS vProductosMasVendidos
GO
CREATE VIEW vProductosMasVendidos AS
SELECT TOP 10 p.Descripcion, SUM(p.precio_estandar) AS Monto
FROM ProductoCotizacion pc
INNER JOIN Producto p ON p.codigo = pc.codigo_producto
GROUP BY p.Descripcion, p.nombre, p.precio_estandar
GO

--Ventas por sector. Descripcion y monto.
DROP VIEW IF EXISTS vVentasPorSector
GO
CREATE VIEW vVentasPorSector AS
SELECT p.Descripcion, SUM(p.precio_estandar) AS Monto
FROM ProductoCotizacion pc
INNER JOIN Producto p ON p.codigo = pc.codigo_producto
INNER JOIN vVentas v ON v.numero_cotizacion = pc.numero_cotizacion
INNER JOIN Sector s ON s.id = v.id_sector
GROUP BY p.descripcion
--ORDER BY Monto DESC
GO

/*
Cotizaciones y Ventas por departamento. Comparativo. Gráfico de barras. se debe sacar el departamento del usuario
*/
DROP VIEW IF EXISTS vCotizacionYVentasDepartamento
GO
CREATE VIEW CotizacionYVentasDepartamento AS
SELECT d.nombre AS Departamento, COUNT(cd.departamento) AS Cotizaciones, COUNT(VD.departamento) AS Ventas
FROM Departamento d
LEFT JOIN vCantidadCotizacionesPorDepartamento CD ON d.nombre = CD.departamento
LEFT JOIN vCantidadVentasPorDepartamento VD ON d.nombre = VD.departamento
GROUP BY d.nombre
GO

/*
Ventas y cotizaciones por mes. Gráfico de barras.
*/
DROP VIEW IF EXISTS vVentasYCotizavionPorMes
GO
CREATE VIEW vVentasYCotizavionPorMes AS
SELECT MONTH(v.fecha_cotizacion) AS Mes, COUNT(v.fecha_cierre) AS Ventas, COUNT(c.numero_cotizacion) AS Cotizaciones
FROM vVentas v
FULL JOIN Cotizacion c ON v.numero_cotizacion = c.numero_cotizacion
GROUP BY MONTH(v.fecha_cierre)
GO

/*
Ventas y cotizaciones por año. Gráfico de barras.
*/
DROP VIEW IF EXISTS vVentasYCotizavionPorAño
GO
CREATE VIEW vVentasYCotizavionPorAño AS
SELECT YEAR(v.fecha_cierre) AS Año, COUNT(v.fecha_cierre) AS Ventas, COUNT(c.numero_cotizacion) AS Cotizaciones
FROM vVentas v
FULL JOIN Cotizacion c ON v.numero_cotizacion = c.numero_cotizacion
GROUP BY YEAR(v.fecha_cierre)
GO

/*
 Top 10 de clientes con mayores ventas.
*/
DROP VIEW IF EXISTS vTop10ClientesMayorVentas
GO
CREATE VIEW vTop10ClientesMayorVentas AS
SELECT TOP 10 c.nombre as nombre, (SELECT dbo.fMontoCotizacion(v.numero_cotizacion)) AS Monto
FROM vVentas v
INNER JOIN vClienteCuentaCliente c ON c.nombre_cuenta = v.nombre_cuenta
--GROUP BY c.nombre
--ORDER BY Monto DESC
GO

/*
Top 10 de vendedores con mayores ventas. Nombre y monto
*/
DROP VIEW IF EXISTS vTop10VendedoresMayorVentas
GO
CREATE VIEW vTop10VendedoresMayorVentas AS
SELECT TOP 10 u.nombre, SUM(dbo.fMontoCotizacion(v.numero_cotizacion)) AS Monto
FROM vVentas v
INNER JOIN Usuario u ON u.cedula = v.id_asesor
GROUP BY u.nombre
ORDER BY Monto DESC
GO

/*
 Casos por estado. Gráfico circular
*/
DROP VIEW IF EXISTS vCasosPorEstado
GO
CREATE VIEW vCasosPorEstado AS
SELECT e.nombre, COUNT(c.id_estado) AS Cantidad
FROM Estado e
LEFT JOIN Caso c ON e.id = c.id_estado
GROUP BY e.nombre
GO

/*
Cantidad de clientes por zona y monto ventas por zona. Zona, cantidad y monto.
*/
DROP VIEW IF EXISTS vCantidadClientesPorZonaYMonto
GO
CREATE VIEW vCantidadClientesPorZonaYMonto AS
SELECT z.nombre as zona, COUNT(c.nombre_cuenta) AS Cantidad, SUM(dbo.fMontoCotizacion(v.numero_cotizacion)) AS Monto
FROM Zona z
LEFT JOIN vClienteCuentaCliente c ON c.id_zona = z.id
LEFT JOIN vVentas v ON v.nombre_cuenta = c.nombre_cuenta
GROUP BY z.nombre
GO

/*
Top 10 de cotizaciones con diferencia entre creación y cierre más altos (cotización, cliente y cantidad de días de diferencia).
*/
DROP VIEW IF EXISTS vTop10CotizacionDiferenciaMasAlto
GO
CREATE VIEW vTop10CotizacionDiferenciaMasAlto AS
SELECT TOP 10 c.numero_cotizacion,CC.nombre , DATEDIFF(DAY, c.fecha_cotizacion, c.fecha_cierre) AS Diferencia
FROM Cotizacion c
INNER JOIN vClienteCuentaCliente CC ON CC.nombre_cuenta = c.nombre_cuenta
ORDER BY Diferencia DESC
GO

select *from vTop10CotizacionDiferenciaMasAlto