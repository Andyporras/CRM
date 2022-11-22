using System;
using System.Collections.Generic;

namespace CRM.Models
{
    public partial class VTareasEstadoTarea
    {
        public int Id { get; set; }
        public string? Descripcion { get; set; }
        public DateTime? FechaCreacion { get; set; }
        public DateTime? FechaFinalizacion { get; set; }
        public int? Estado { get; set; }
        public int IdEstadoTarea { get; set; }
        public string NombreEstadoTarea { get; set; } = null!;
    }
}
