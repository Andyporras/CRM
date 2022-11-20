using System;
using System.Collections.Generic;

namespace CRM.Models
{
    public partial class VTotalContactoClientesPorUsuario
    {
        public string Cedula { get; set; } = null!;
        public string Usuario { get; set; } = null!;
        public int? ContactosDeCliente { get; set; }
    }
}
