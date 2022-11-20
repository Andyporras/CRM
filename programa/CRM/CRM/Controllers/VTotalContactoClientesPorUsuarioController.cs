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
    public class VTotalContactoClientesPorUsuarioController : Controller
    {
        private readonly CRMContext _context;

        public VTotalContactoClientesPorUsuarioController(CRMContext context)
        {
            _context = context;
        }

        // GET: VTotalContactoClientesPorUsuario
        public async Task<IActionResult> Index()
        {
              return View(await _context.VTotalContactoClientesPorUsuarios.ToListAsync());
        }

        // GET: VTotalContactoClientesPorUsuario/Details/5
        public async Task<IActionResult> Details(string id)
        {
            if (id == null || _context.VTotalContactoClientesPorUsuarios == null)
            {
                return NotFound();
            }

            var vTotalContactoClientesPorUsuario = await _context.VTotalContactoClientesPorUsuarios
                .FirstOrDefaultAsync(m => m.Cedula == id);
            if (vTotalContactoClientesPorUsuario == null)
            {
                return NotFound();
            }

            return View(vTotalContactoClientesPorUsuario);
        }
    }
}
