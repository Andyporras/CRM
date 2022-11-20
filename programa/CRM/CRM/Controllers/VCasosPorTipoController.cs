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
    public class VCasosPorTipoController : Controller
    {
        private readonly CRMContext _context;

        public VCasosPorTipoController(CRMContext context)
        {
            _context = context;
        }

        // GET: VCasosPorTipo
        public async Task<IActionResult> Index()
        {
              return View(await _context.VCasosPorTipos.ToListAsync());
        }

        // GET: VCasosPorTipo/Details/5
        public async Task<IActionResult> Details(string id)
        {
            if (id == null || _context.VCasosPorTipos == null)
            {
                return NotFound();
            }

            var vCasosPorTipo = await _context.VCasosPorTipos
                .FirstOrDefaultAsync(m => m.Tipo == id);
            if (vCasosPorTipo == null)
            {
                return NotFound();
            }

            return View(vCasosPorTipo);
        }
    }
}
