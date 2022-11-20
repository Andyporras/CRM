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
    public class VFamiliaProductosVendidosController : Controller
    {
        private readonly CRMContext _context;

        public VFamiliaProductosVendidosController(CRMContext context)
        {
            _context = context;
        }

        // GET: VFamiliaProductosVendidos
        public async Task<IActionResult> Index()
        {
              return View(await _context.VFamiliaProductosVendidos.ToListAsync());
        }

        // GET: VFamiliaProductosVendidos/Details/5
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
            var productos =  (IEnumerable<VFamiliaProductosVendido>) _context
                .VFamiliaProductosVendidos
                .FromSqlInterpolated($"SELECT * FROM dbo.fFamiliaProductosVendidos ({pInicio}, {pFinal})")
                .ToList();
            
            return View("index", productos);
        }
    }
}
