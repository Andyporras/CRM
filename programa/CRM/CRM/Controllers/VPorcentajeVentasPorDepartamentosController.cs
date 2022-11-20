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
    public class VPorcentajeVentasPorDepartamentosController : Controller
    {
        private readonly CRMContext _context;

        public VPorcentajeVentasPorDepartamentosController(CRMContext context)
        {
            _context = context;
        }

        // GET: VPorcentajeVentasPorDepartamentos
        public async Task<IActionResult> Index()
        {
              return View(await _context.VPorcentajeVentasPorDepartamentos.ToListAsync());
        }

        // GET: VPorcentajeVentasPorDepartamentos/Details/5
        public async Task<IActionResult> Details(string id)
        {
            if (id == null || _context.VPorcentajeVentasPorDepartamentos == null)
            {
                return NotFound();
            }

            var vPorcentajeVentasPorDepartamento = await _context.VPorcentajeVentasPorDepartamentos
                .FirstOrDefaultAsync(m => m.Departamento == id);
            if (vPorcentajeVentasPorDepartamento == null)
            {
                return NotFound();
            }

            return View(vPorcentajeVentasPorDepartamento);
        }
    }
}
