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
    public class VPorcentajeVentasPorDepartamentosController : Controller
    {
        private readonly CRMContext _context;

        public VPorcentajeVentasPorDepartamentosController(CRMContext context)
        {
            _context = context;
        }

        // GET: VPorcentajeVentasPorDepartamentos
        public async Task<IActionResult> Index()
        {
              return View(await _context.VPorcentajeVentasPorDepartamentos.ToListAsync());
        }

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
            var productos = (IEnumerable<VPorcentajeVentasPorDepartamento>)_context
                .VPorcentajeVentasPorDepartamentos
                .FromSqlInterpolated($"SELECT * FROM dbo.fPorcentajeVentasPorDepartamento ({pInicio}, {pFinal})")
                .ToList();

            return View("index", productos);
        }
    }
}
