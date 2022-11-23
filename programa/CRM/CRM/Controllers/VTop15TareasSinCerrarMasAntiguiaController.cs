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
    public class VTop15TareasSinCerrarMasAntiguiaController : Controller
    {
        private readonly CRMContext _context;

        public VTop15TareasSinCerrarMasAntiguiaController(CRMContext context)
        {
            _context = context;
        }

        // GET: VTop15TareasSinCerrarMasAntiguia
        public async Task<IActionResult> Index()
        {
              return View(await _context.VTop15TareasSinCerrarMasAntiguias.ToListAsync());
        }

        // GET: VTop15TareasSinCerrarMasAntiguia/Filtrar/5
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
            var tareas = (IEnumerable<VTop15TareasSinCerrarMasAntiguia>)_context
                .VTop15TareasSinCerrarMasAntiguias
                .FromSqlInterpolated($"SELECT * FROM dbo.fTop15TareasSinCerrarMasAntiguias ({pInicio}, {pFinal})")
                .ToList();

            return View("index", tareas);
        }
    }
}
