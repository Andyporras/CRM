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
    public class VCotizacionesValorPresentePorAnnoController : Controller
    {
        private readonly CRMContext _context;

        public VCotizacionesValorPresentePorAnnoController(CRMContext context)
        {
            _context = context;
        }

        // GET: VCotizacionesValorPresentePorAnno
        public async Task<IActionResult> Index()
        {
              return View(await _context.VCotizacionesValorPresentePorAnnos.ToListAsync());
        }

        public async Task<IActionResult> Filtrar(int anno)
        {
            var pAnno = new SqlParameter
            {
                ParameterName = "anno",
                Value = anno,
                SqlDbType = System.Data.SqlDbType.Int
            };

            //Ejecucion de procedimiento almacenado
            //var sql = "EXECUTE procBuscarCliente @cedula, @ret OUT";
            var productos = (IEnumerable<VCotizacionesValorPresentePorAnno>)_context
                .VCotizacionesValorPresentePorAnnos
                .FromSqlInterpolated($"SELECT * FROM dbo.fCotizacionesValorPresentePorAnno ({pAnno})")
                .ToList();

            return View("index", productos);
        }
    }
}
