using System;
using System.Collections.Generic;

namespace CRM.Models
{
    public partial class VTop15TareasSinCerrarMasAntiguia
    {
        public int Id { get; set; }
        public string? Descripcion { get; set; }
        public DateTime? FechaCreacion { get; set; }
        public string NombreEstadoTarea { get; set; } = null!;
    }
}
