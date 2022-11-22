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
    public class VTop10ClientesMayorVentaController : Controller
    {
        private readonly CRMContext _context;

        public VTop10ClientesMayorVentaController(CRMContext context)
        {
            _context = context;
        }

        // GET: VTop10ClientesMayorVenta
        public async Task<IActionResult> Index()
        {
              return View(await _context.VTop10ClientesMayorVentas.ToListAsync());
        }

        // GET: VTop10ClientesMayorVenta/Details/5
        public async Task<IActionResult> Details(string id)
        {
            if (id == null || _context.VTop10ClientesMayorVentas == null)
            {
                return NotFound();
            }

            var vTop10ClientesMayorVenta = await _context.VTop10ClientesMayorVentas
                .FirstOrDefaultAsync(m => m.Nombre == id);
            if (vTop10ClientesMayorVenta == null)
            {
                return NotFound();
            }

            return View(vTop10ClientesMayorVenta);
        }

        // GET: VTop10ClientesMayorVenta/Create
        public IActionResult Create()
        {
            return View();
        }

        // POST: VTop10ClientesMayorVenta/Create
        // To protect from overposting attacks, enable the specific properties you want to bind to.
        // For more details, see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create([Bind("Nombre,Monto")] VTop10ClientesMayorVenta vTop10ClientesMayorVenta)
        {
            if (ModelState.IsValid)
            {
                _context.Add(vTop10ClientesMayorVenta);
                await _context.SaveChangesAsync();
                return RedirectToAction(nameof(Index));
            }
            return View(vTop10ClientesMayorVenta);
        }

        // GET: VTop10ClientesMayorVenta/Edit/5
        public async Task<IActionResult> Edit(string id)
        {
            if (id == null || _context.VTop10ClientesMayorVentas == null)
            {
                return NotFound();
            }

            var vTop10ClientesMayorVenta = await _context.VTop10ClientesMayorVentas.FindAsync(id);
            if (vTop10ClientesMayorVenta == null)
            {
                return NotFound();
            }
            return View(vTop10ClientesMayorVenta);
        }

        // POST: VTop10ClientesMayorVenta/Edit/5
        // To protect from overposting attacks, enable the specific properties you want to bind to.
        // For more details, see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(string id, [Bind("Nombre,Monto")] VTop10ClientesMayorVenta vTop10ClientesMayorVenta)
        {
            if (id != vTop10ClientesMayorVenta.Nombre)
            {
                return NotFound();
            }

            if (ModelState.IsValid)
            {
                try
                {
                    _context.Update(vTop10ClientesMayorVenta);
                    await _context.SaveChangesAsync();
                }
                catch (DbUpdateConcurrencyException)
                {
                    if (!VTop10ClientesMayorVentaExists(vTop10ClientesMayorVenta.Nombre))
                    {
                        return NotFound();
                    }
                    else
                    {
                        throw;
                    }
                }
                return RedirectToAction(nameof(Index));
            }
            return View(vTop10ClientesMayorVenta);
        }

        // GET: VTop10ClientesMayorVenta/Delete/5
        public async Task<IActionResult> Delete(string id)
        {
            if (id == null || _context.VTop10ClientesMayorVentas == null)
            {
                return NotFound();
            }

            var vTop10ClientesMayorVenta = await _context.VTop10ClientesMayorVentas
                .FirstOrDefaultAsync(m => m.Nombre == id);
            if (vTop10ClientesMayorVenta == null)
            {
                return NotFound();
            }

            return View(vTop10ClientesMayorVenta);
        }

        // POST: VTop10ClientesMayorVenta/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> DeleteConfirmed(string id)
        {
            if (_context.VTop10ClientesMayorVentas == null)
            {
                return Problem("Entity set 'CRMContext.VTop10ClientesMayorVentas'  is null.");
            }
            var vTop10ClientesMayorVenta = await _context.VTop10ClientesMayorVentas.FindAsync(id);
            if (vTop10ClientesMayorVenta != null)
            {
                _context.VTop10ClientesMayorVentas.Remove(vTop10ClientesMayorVenta);
            }
            
            await _context.SaveChangesAsync();
            return RedirectToAction(nameof(Index));
        }

        private bool VTop10ClientesMayorVentaExists(string id)
        {
          return _context.VTop10ClientesMayorVentas.Any(e => e.Nombre == id);
        }
    }
}
