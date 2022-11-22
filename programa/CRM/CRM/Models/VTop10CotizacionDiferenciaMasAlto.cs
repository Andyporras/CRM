using System;
using System.Collections.Generic;

namespace CRM.Models
{
    public partial class VTop10CotizacionDiferenciaMasAlto
    {
        public int NumeroCotizacion { get; set; }
        public string Nombre { get; set; } = null!;
        public int? Diferencia { get; set; }
    }
}
