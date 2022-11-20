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
    public class VVentasPorZonasController : Controller
    {
        private readonly CRMContext _context;

        public VVentasPorZonasController(CRMContext context)
        {
            _context = context;
        }

        // GET: VVentasPorZonas
        public async Task<IActionResult> Index()
        {
              return View(await _context.VVentasPorZonas.ToListAsync());
        }

        // GET: VVentasPorZonas/Details/5
        public async Task<IActionResult> Details(string id)
        {
            if (id == null || _context.VVentasPorZonas == null)
            {
                return NotFound();
            }

            var vVentasPorZona = await _context.VVentasPorZonas
                .FirstOrDefaultAsync(m => m.Descripcion == id);
            if (vVentasPorZona == null)
            {
                return NotFound();
            }

            return View(vVentasPorZona);
        }
    }
}
