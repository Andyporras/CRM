/*
Este archivo contiene múltiples vistas y funciones que son de utilidad para los reportes.
*/
USE CRM
GO


-- Función que obtiene las ventas que han sido realizadas
DROP VIEW IF EXISTS vVentas
GO
CREATE VIEW vVentas AS
	SELECT * FROM Cotizacion coti
		WHERE id_etapa = 'Facturada' OR probabilidad = 100
GO

-- Función que permite obtener el monto de una cotización en específico
DROP FUNCTION IF EXISTS fMontoCotizacion
GO
CREATE FUNCTION fMontoCotizacion(@numeroCotizacion INT)
RETURNS INT
AS
BEGIN
	DECLARE @monto INT
	SELECT @monto = SUM(proxcoti.precio_negociado * proxcoti.cantidad)
					FROM ProductoCotizacion proxcoti
						WHERE numero_cotizacion = @numeroCotizacion
					
	RETURN @monto
END
GO


-- Vista que retorna las cotizaciones y el departamento encargado
DROP VIEW IF EXISTS vCotizacionesPorDepartamento
GO
CREATE VIEW vCotizacionesPorDepartamento AS
	SELECT coti.numero_cotizacion, dep.nombre AS departamento
	FROM Cotizacion coti
		INNER JOIN Usuario u ON u.cedula = coti.id_asesor
		INNER JOIN Departamento dep ON dep.id = u.id_departamento
	GROUP BY coti.numero_cotizacion, dep.nombre
GO

-- Vista que retorna la cantidad de cotizaciones que ha tenido cada departamento
DROP VIEW IF EXISTS vCantidadCotizacionesPorDepartamento
GO
CREATE VIEW vCantidadCotizacionesPorDepartamento AS
	SELECT dep.nombre AS departamento, COUNT(dep.nombre) AS cantidad_cotizaciones
	FROM Cotizacion coti
		INNER JOIN Usuario u ON u.cedula = coti.id_asesor
		INNER JOIN Departamento dep ON dep.id = u.id_departamento
	GROUP BY dep.nombre
GO

-- Vista que retorna la cantidad de ventas que ha tenido cada departamento
DROP VIEW IF EXISTS vCantidadVentasPorDepartamento
GO
CREATE VIEW vCantidadVentasPorDepartamento AS
	SELECT dep.nombre AS departamento, COUNT(dep.nombre) AS cantidad_ventas
	FROM vVentas coti
		INNER JOIN Usuario u ON u.cedula = coti.id_asesor
		INNER JOIN Departamento dep ON dep.id = u.id_departamento
	GROUP BY dep.nombre
GO
