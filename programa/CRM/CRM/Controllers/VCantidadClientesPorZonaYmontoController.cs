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
    public class VCantidadClientesPorZonaYmontoController : Controller
    {
        private readonly CRMContext _context;

        public VCantidadClientesPorZonaYmontoController(CRMContext context)
        {
            _context = context;
        }

        // GET: VCantidadClientesPorZonaYmonto
        public async Task<IActionResult> Index()
        {
              return View(await _context.VCantidadClientesPorZonaYmontos.ToListAsync());
        }

        // GET: VCantidadClientesPorZonaYmonto/Filtrar/5
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

            //Ejecucion de Funcion
            var ventas = (IEnumerable<VCantidadClientesPorZonaYmonto>)_context
                .VCantidadClientesPorZonaYmontos
                .FromSqlInterpolated($"SELECT * FROM dbo.fCantidadClientesPorZonaYmonto ({pInicio}, {pFinal})")
                .ToList();

            return View("index", ventas);
        }
    }
}
