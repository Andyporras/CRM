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

        // GET: VCotizacionesValorPresentePorAnno/Details/5
        public async Task<IActionResult> Details(double? id)
        {
            if (id == null || _context.VCotizacionesValorPresentePorAnnos == null)
            {
                return NotFound();
            }

            var vCotizacionesValorPresentePorAnno = await _context.VCotizacionesValorPresentePorAnnos
                .FirstOrDefaultAsync(m => m.MontoCotizaciones == id);
            if (vCotizacionesValorPresentePorAnno == null)
            {
                return NotFound();
            }

            return View(vCotizacionesValorPresentePorAnno);
        }
    }
}
