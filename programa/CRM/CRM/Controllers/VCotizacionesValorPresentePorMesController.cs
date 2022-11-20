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
    public class VCotizacionesValorPresentePorMesController : Controller
    {
        private readonly CRMContext _context;

        public VCotizacionesValorPresentePorMesController(CRMContext context)
        {
            _context = context;
        }

        // GET: VCotizacionesValorPresentePorMes
        public async Task<IActionResult> Index()
        {
              return View(await _context.VCotizacionesValorPresentePorMes.ToListAsync());
        }

        // GET: VCotizacionesValorPresentePorMes/Details/5
        public async Task<IActionResult> Details(string id)
        {
            if (id == null || _context.VCotizacionesValorPresentePorMes == null)
            {
                return NotFound();
            }

            var vCotizacionesValorPresentePorMe = await _context.VCotizacionesValorPresentePorMes
                .FirstOrDefaultAsync(m => m.Mes == id);
            if (vCotizacionesValorPresentePorMe == null)
            {
                return NotFound();
            }

            return View(vCotizacionesValorPresentePorMe);
        }
    }
}
