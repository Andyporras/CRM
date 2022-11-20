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
    public class VCotizacionesConMasActividadesTareasController : Controller
    {
        private readonly CRMContext _context;

        public VCotizacionesConMasActividadesTareasController(CRMContext context)
        {
            _context = context;
        }

        // GET: VCotizacionesConMasActividadesTareas
        public async Task<IActionResult> Index()
        {
              return View(await _context.VCotizacionesConMasActividadesTareas.ToListAsync());
        }

        // GET: VCotizacionesConMasActividadesTareas/Details/5
        public async Task<IActionResult> Details(int? id)
        {
            if (id == null || _context.VCotizacionesConMasActividadesTareas == null)
            {
                return NotFound();
            }

            var vCotizacionesConMasActividadesTarea = await _context.VCotizacionesConMasActividadesTareas
                .FirstOrDefaultAsync(m => m.NumeroCotizacion == id);
            if (vCotizacionesConMasActividadesTarea == null)
            {
                return NotFound();
            }

            return View(vCotizacionesConMasActividadesTarea);
        }
    }
}
