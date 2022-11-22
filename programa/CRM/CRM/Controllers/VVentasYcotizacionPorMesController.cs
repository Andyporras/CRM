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
    public class VVentasYcotizacionPorMesController : Controller
    {
        private readonly CRMContext _context;

        public VVentasYcotizacionPorMesController(CRMContext context)
        {
            _context = context;
        }

        // GET: VVentasYcotizacionPorMes
        public async Task<IActionResult> Index()
        {
              return View(await _context.VVentasYcotizavionPorMes.ToListAsync());
        }

        // GET: VVentasYcotizacionPorMes/Details/5
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
            var ventas = (IEnumerable<VVentasYcotizacionPorMe>)_context
                .VVentasYcotizavionPorMes
                .FromSqlInterpolated($"SELECT * FROM dbo.fVentasYCotizacionPorMes ({pInicio}, {pFinal})")
                .ToList();

            return View("index", ventas);
        }
    }
}
