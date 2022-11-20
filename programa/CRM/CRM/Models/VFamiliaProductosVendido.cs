using System;
using System.Collections.Generic;

namespace CRM.Models
{
    public partial class VFamiliaProductosVendido
    {
        public string Familia { get; set; } = null!;
        public double? Monto { get; set; }
    }
}
