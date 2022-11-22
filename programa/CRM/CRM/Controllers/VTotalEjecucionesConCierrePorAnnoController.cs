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
    public class VTotalEjecucionesConCierrePorAnnoController : Controller
    {
        private readonly CRMContext _context;

        public VTotalEjecucionesConCierrePorAnnoController(CRMContext context)
        {
            _context = context;
        }

        // GET: VTotalEjecucionesConCierrePorAnno
        public async Task<IActionResult> Index()
        {
              return View(await _context.VTotalEjecucionesConCierresPorAnno.ToListAsync());
        }

        
        public async Task<IActionResult> Filtrar(int anno)
        {
            var pInicio = new SqlParameter
            {
                ParameterName = "anno",
                Value = anno,
                SqlDbType = System.Data.SqlDbType.Int
            };
            
            var productos = (IEnumerable<VTotalEjecucionesConCierrePorAnno>)_context
                .VTotalEjecucionesConCierresPorAnno
                .FromSqlInterpolated($"SELECT * FROM dbo.fTotalEjecucionesConCierrePorAnno ({anno})")
                .ToList();

            return View("index", productos);
        }
    }
}
