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
    public class VCantidadCotizacionesPorTipoController : Controller
    {
        private readonly CRMContext _context;

        public VCantidadCotizacionesPorTipoController(CRMContext context)
        {
            _context = context;
        }

        // GET: VCantidadCotizacionesPorTipo
        public async Task<IActionResult> Index()
        {
              return View(await _context.VCantidadCotizacionesPorTipos.ToListAsync());
        }

        // GET: VCantidadCotizacionesPorTipo/Details/5
        public async Task<IActionResult> Details(string id)
        {
            if (id == null || _context.VCantidadCotizacionesPorTipos == null)
            {
                return NotFound();
            }

            var vCantidadCotizacionesPorTipo = await _context.VCantidadCotizacionesPorTipos
                .FirstOrDefaultAsync(m => m.Nombre == id);
            if (vCantidadCotizacionesPorTipo == null)
            {
                return NotFound();
            }

            return View(vCantidadCotizacionesPorTipo);
        }
    }
}
