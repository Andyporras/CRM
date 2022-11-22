using System;
using System.Collections.Generic;

namespace CRM.Models
{
    public partial class VCasosEjecucion
    {
        public int Id { get; set; }
        public string Asunto { get; set; } = null!;
        public string IdTipo { get; set; } = null!;
        public string IdEstado { get; set; } = null!;
        public string NombreCuenta { get; set; } = null!;
        public string NombreContacto { get; set; } = null!;
        public int ProyectoAsociado { get; set; }
        public int IdEjecucion { get; set; }
        public DateTime? FechaEjecucion { get; set; }
        public DateTime? FechaCierre { get; set; }
    }
}
