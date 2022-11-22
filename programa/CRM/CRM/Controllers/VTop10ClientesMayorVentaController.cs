using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.EntityFrameworkCore;
using CRM.Models;
using Microsoft.Data.SqlClient;

namespace CRM.Controllers
{
    public class VTop10ClientesMayorVentaController : Controller
    {
        private readonly CRMContext _context;

        public VTop10ClientesMayorVentaController(CRMContext context)
        {
            _context = context;
        }

        // GET: VTop10ClientesMayorVenta
        public async Task<IActionResult> Index()
        {
              return View(await _context.VTop10ClientesMayorVentas.ToListAsync());
        }

        // GET: VTop10ClientesMayorVenta/filtro/5
        public async Task<IActionResult> Filtrar(DateTime inicio, DateTime fin)
        {
            var pInicio = new SqlParameter
            {
                ParameterName = "fechaInicio",
                Value = inicio,
                SqlDbType = System.Data.SqlDbType.Date
            };
            var pFinal = new SqlParameter
            {
                ParameterName = "fechaFin",
                Value = fin,
                SqlDbType = System.Data.SqlDbType.Date
            };

            //Ejecucion de procedimiento almacenado
            //var sql = "EXECUTE procBuscarCliente @cedula, @ret OUT";
            var ventas = (IEnumerable<VTop10ClientesMayorVenta>)_context
                .VTop10ClientesMayorVentas
                .FromSqlInterpolated($"SELECT * FROM dbo.fTop10ClientesMayorVentas ({pInicio}, {pFinal})")
                .ToList();

            return View("index", ventas);
        }

    }
}
