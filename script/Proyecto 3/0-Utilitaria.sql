/*
Este archivo contiene múltiples vistas y funciones que son de utilidad para los reportes.
*/
USE CRM
GO

select *from Usuario

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

-- Vista que retorna todas los atributos de una cotización y el departamento al que pertenece
DROP VIEW IF EXISTS vCotizacionDepartamento
GO
CREATE VIEW vCotizacionDepartamento AS
	SELECT coti.numero_cotizacion, coti.id_etapa, coti.probabilidad, coti.fecha_cotizacion, coti.fecha_cierre, dep.id as idDepartamento, dep.nombre
		FROM Cotizacion coti, Departamento dep	
			INNER JOIN Usuario usu ON dep.id = usu.id_departamento
				WHERE coti.id_asesor = usu.cedula
GO

-- Vista que retorna todas los atributos de una venta y el departamento al que pertenece
DROP VIEW IF EXISTS vVentaDepartamento
GO
CREATE VIEW vVentaDepartamento AS
	SELECT coti.numero_cotizacion, coti.id_etapa, coti.probabilidad, coti.fecha_cotizacion, coti.fecha_cierre, dep.id as idDepartamento, dep.nombre
		FROM Cotizacion coti, Departamento dep	
			INNER JOIN Usuario usu ON dep.id = usu.id_departamento
				WHERE coti.id_asesor = usu.cedula AND (coti.id_etapa = 'Facturada' OR coti.probabilidad = 100)
GO
	
select *from vVentaDepartamento

/*			
GO
DROP VIEW IF EXISTS vCotizacionesPorDepartamento
GO
CREATE VIEW vCotizacionesPorDepartamento AS
	SELECT coti.numero_cotizacion, dep.nombre AS departamento, dep.id AS id_departamento
		FROM Cotizacion coti, Departamento dep	
			INNER JOIN Usuario usu ON dep.id = usu.id_departamento
				WHERE coti.id_asesor = usu.id
GO
*/

-- Vista que retorna las ventas y el departamento encargado
/*
DROP VIEW IF EXISTS vVentasPorDepartamento
GO
CREATE VIEW vVentasPorDepartamento AS
	SELECT coti.numero_cotizacion, dep.nombre AS departamento, dep.id AS id_departamento
		FROM Cotizacion coti, Departamento dep	
			INNER JOIN Usuario usu ON dep.id = usu.id_departamento
				WHERE id_etapa = 'Facturada' OR probabilidad = 100
GO
*/

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


/* Vista que muestra los datos de los cliente como de su cuentaCliente
*/
DROP VIEW IF EXISTS vClienteCuentaCliente
GO
CREATE VIEW vClienteCuentaCliente AS
SELECT c.cedula, c.nombre, c.apellido1,c.apellido2, c.telefono, c.celular,cc.id AS id_cuenta_cliente, cc.cedula_cliente, cc.moneda, cc.id_sector, cc.nombre_cuenta,cc.id_zona
FROM Cliente c
INNER JOIN CuentaCliente cc ON c.cedula = cc.cedula_cliente
GO


GO
-- Funcion que obtiene las cotizaciones con su total de actividades
DROP FUNCTION IF EXISTS fCotizacionesConTotalActividades
GO
CREATE FUNCTION fCotizacionesConTotalActividades(@numero_cotizacion INT)
RETURNS INT
AS
BEGIN
	DECLARE @totalActividades INT
	SELECT @totalActividades = COUNT(id_cotizacion)
		FROM CotizacionActividad
		WHERE id_cotizacion = @numero_cotizacion
	RETURN @totalActividades
END
GO

-- Funcion que obtiene las cotizaciones con su total de tareas
DROP FUNCTION IF EXISTS fCotizacionesConTotalTareas
GO
CREATE FUNCTION fCotizacionesConTotalTareas(@numero_cotizacion INT)
RETURNS INT
AS
BEGIN
	DECLARE @totalTareas INT
	SELECT @totalTareas = COUNT(id_cotizacion)
		FROM CotizacionTarea
		WHERE id_cotizacion = @numero_cotizacion
	RETURN @totalTareas
END
GO
-- Vista que retorna la cantidad de casos por tipo
DROP VIEW IF EXISTS vCantidadCasosPorTipo
GO
CREATE VIEW vCantidadCasosPorTipo AS
	SELECT tc.tipo AS tipo, COUNT(tc.tipo) AS cantidad_casos
	FROM Caso c
		INNER JOIN TipoCaso tc ON c.id_tipo = tc.id
	GROUP BY tc.tipo
GO

/* Vista que muestra los datos de los casos y ejecucion 
*/
DROP VIEW IF EXISTS vCasosEjecucion
GO
CREATE VIEW vCasosEjecucion AS
SELECT c.id,c.asunto, c.id_tipo,c.id_estado,c.nombreCuenta, c.nombreContacto, c.proyectoAsociado, e.id AS id_ejecucion,e.fechaEjecucion, e.fechaCierre
FROM Caso c
INNER JOIN Ejecucion e ON c.nombreCuenta = e.nombreCuenta
GO

/* Vista que muestra los datos de las Tareas y los estadoTarea
*/
DROP VIEW IF EXISTS vTareasEstadoTarea
GO
CREATE VIEW vTareasEstadoTarea AS
SELECT t.id, t.descripcion, t.fecha_creacion, t.fecha_finalizacion,t.estado, et.id AS id_estado_tarea,et.nombre AS nombre_estado_tarea
FROM Tarea t
INNER JOIN EstadoTarea et ON t.estado = et.id
GO
