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

-- Función que calcula el valor presente del monto de la cotización
DROP FUNCTION IF EXISTS fValorPresenteMontoCotizacion
GO
CREATE FUNCTION fValorPresenteMontoCotizacion(@numeroCotizacion INT)
RETURNS FLOAT
AS
BEGIN
	DECLARE @total_a_valor_presente VARCHAR(30),
		@annoCotizacion int,
		@porcentaje FLOAT,
		@annoInflacion int 
		SET @total_a_valor_presente = (SELECT dbo.fMontoCotizacion(@numeroCotizacion))
		SET @annoCotizacion = (SELECT YEAR(fecha_cotizacion) FROM Cotizacion
						WHERE @numeroCotizacion = numero_cotizacion)
	DECLARE curInflacionPorAnno CURSOR
		FOR SELECT anno, porcentaje FROM Inflacion ORDER BY anno DESC;
		OPEN curInflacionPorAnno

		FETCH NEXT FROM curInflacionPorAnno INTO @annoInflacion, @porcentaje;

		WHILE (@@FETCH_STATUS = 0)
		BEGIN
			
			if @annoInflacion > @annoCotizacion
			BEGIN
				SET @total_a_valor_presente = @total_a_valor_presente + @total_a_valor_presente * @porcentaje/100;
			END
			/*
				Si el año de la inflación ya no es mayor al año de la cotización, entonces
				significa que ya se sumó todo el porcentaje de inflación aplicable a la cotización👇
			*/
			ELSE
			BEGIN
				BREAK
			END

			FETCH NEXT FROM curInflacionPorAnno INTO @annoInflacion, @porcentaje;
		END

	CLOSE curInflacionPorAnno
	DEALLOCATE curInflacionPorAnno
	RETURN @total_a_valor_presente
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


-- Tabla que tiene el registro de todos los meses del año
DROP table IF EXISTS mes
GO
create table mes (
	id int primary key,
	nombre varchar(10) 
)

INSERT into mes values 
		(1, 'Enero'),
		(2, 'Febrero'),
		(3, 'Marzo'),
		(4, 'Abril'),
		(5, 'Mayo'),
		(6, 'Junio'),
		(7, 'julio'),
		(8, 'Agosto'),
		(9, 'Septiembre'),
		(10, 'Octubre'),
		(11, 'Noviembre'),
		(12, 'Diciembre')