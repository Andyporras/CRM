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
    public class VTop10CotizacionDiferenciaMasAltoController : Controller
    {
        private readonly CRMContext _context;

        public VTop10CotizacionDiferenciaMasAltoController(CRMContext context)
        {
            _context = context;
        }

        // GET: VTop10CotizacionDiferenciaMasAlto
        public async Task<IActionResult> Index()
        {
              return View(await _context.VTop10CotizacionDiferenciaMasAltos.ToListAsync());
        }

        // GET: VTop10CotizacionDiferenciaMasAlto/Filtrar/5
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
            var ventas = (IEnumerable<VTop10CotizacionDiferenciaMasAlto>)_context
                .VTop10CotizacionDiferenciaMasAltos
                .FromSqlInterpolated($"SELECT * FROM dbo.fTop10CotizacionDiferenciaMasAlto ({pInicio}, {pFinal})")
                .ToList();

            return View("index", ventas);
        }

    }
}
