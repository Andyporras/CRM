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

        // GET: VTotalEjecucionesConCierre/Details/5
        public async Task<IActionResult> Details(int? id)
        {
            if (id == null || _context.VTotalEjecucionesConCierres == null)
            {
                return NotFound();
            }

            var vTotalEjecucionesConCierre = await _context.VTotalEjecucionesConCierres
                .FirstOrDefaultAsync(m => m.Total == id);
            if (vTotalEjecucionesConCierre == null)
            {
                return NotFound();
            }

            return View(vTotalEjecucionesConCierre);
        }
    }
}
