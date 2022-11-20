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
        public async Task<IActionResult> Details(string id)
        {
            if (id == null || _context.VFamiliaProductosVendidos == null)
            {
                return NotFound();
            }

            var vFamiliaProductosVendido = await _context.VFamiliaProductosVendidos
                .FirstOrDefaultAsync(m => m.Familia == id);
            if (vFamiliaProductosVendido == null)
            {
                return NotFound();
            }

            return View(vFamiliaProductosVendido);
        }
    }
}
