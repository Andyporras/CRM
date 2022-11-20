using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.EntityFrameworkCore;
using CRM.Models;

namespace CRM.Controllers
{
    public class VProductosMasCotizadosController : Controller
    {
        private readonly CRMContext _context;

        public VProductosMasCotizadosController(CRMContext context)
        {
            _context = context;
        }

        // GET: VProductosMasCotizados
        public async Task<IActionResult> Index()
        {
              return View(await _context.VProductosMasCotizados.ToListAsync());
        }

        // GET: VProductosMasCotizados/Details/5
        public async Task<IActionResult> Details(string id)
        {
            if (id == null || _context.VProductosMasCotizados == null)
            {
                return NotFound();
            }

            var vProductosMasCotizado = await _context.VProductosMasCotizados
                .FirstOrDefaultAsync(m => m.Descripcion == id);
            if (vProductosMasCotizado == null)
            {
                return NotFound();
            }

            return View(vProductosMasCotizado);
        }
    }
}
