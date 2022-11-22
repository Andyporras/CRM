using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.EntityFrameworkCore;
using CRM.Models;
using Microsoft.Data.SqlClient;

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

        //Estado es la clase que no se puede filtrar
    }
}
