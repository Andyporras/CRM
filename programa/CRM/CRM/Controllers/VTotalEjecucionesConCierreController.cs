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
    public class VTotalEjecucionesConCierreController : Controller
    {
        private readonly CRMContext _context;

        public VTotalEjecucionesConCierreController(CRMContext context)
        {
            _context = context;
        }

        // GET: VTotalEjecucionesConCierre
        public async Task<IActionResult> Index()
        {
              return View(await _context.VTotalEjecucionesConCierres.ToListAsync());
        }

        
        public async Task<IActionResult> Filtrar(string mes)
        {
            var pInicio = new SqlParameter
            {
                ParameterName = "mes",
                Value = mes,
                SqlDbType = System.Data.SqlDbType.VarChar
            };

            var productos = (IEnumerable<VTotalEjecucionesConCierre>)_context
                .VTotalEjecucionesConCierres
                .FromSqlInterpolated($"SELECT * FROM dbo.fTotalEjecucionesConCierrePorMes ({mes})")
                .ToList();

            return View("index", productos);
        }
    }
}
