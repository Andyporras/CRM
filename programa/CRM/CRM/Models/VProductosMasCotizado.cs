using System;
using System.Collections.Generic;

namespace CRM.Models
{
    public partial class VProductosMasCotizado
    {
        public string Descripcion { get; set; } = null!;
        public int? CantidadCotizaciones { get; set; }
    }
}
