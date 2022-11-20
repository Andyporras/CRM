using System;
using System.Collections.Generic;

namespace CRM.Models
{
    public partial class VClienteCuentaCliente
    {
        public string Cedula { get; set; } = null!;
        public string Nombre { get; set; } = null!;
        public string Apellido1 { get; set; } = null!;
        public string Apellido2 { get; set; } = null!;
        public string Telefono { get; set; } = null!;
        public string Celular { get; set; } = null!;
        public int IdCuentaCliente { get; set; }
        public string CedulaCliente { get; set; } = null!;
        public int Moneda { get; set; }
        public int? IdSector { get; set; }
        public string NombreCuenta { get; set; } = null!;
    }
}
