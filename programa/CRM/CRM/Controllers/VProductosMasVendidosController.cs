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
    public class VProductosMasVendidosController : Controller
    {
        private readonly CRMContext _context;

        public VProductosMasVendidosController(CRMContext context)
        {
            _context = context;
        }

        // GET: VProductosMasVendidos
        public async Task<IActionResult> Index()
        {
              return View(await _context.VProductosMasVendidos.ToListAsync());
        }

        // GET: VProductosMasVendidos/Details/5
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

            //Ejecucion de funcion
            var productos = (IEnumerable<VProductosMasVendido>)_context
                .VProductosMasVendidos
                .FromSqlInterpolated($"SELECT * FROM dbo.fProductosMasVendidos ({pInicio}, {pFinal})")
                .ToList();

            return View("index", productos);
        }
    }
}
