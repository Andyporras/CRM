using System;
using System.Collections.Generic;

namespace CRM.Models
{
    public partial class VClienteInfoGeneral
    {
        public string Cedula { get; set; } = null!;
        public string Telefono { get; set; } = null!;
        public string Celular { get; set; } = null!;
        public string Nombre { get; set; } = null!;
        public string Apellido1 { get; set; } = null!;
        public string Apellido2 { get; set; } = null!;
        public string Zona { get; internal set; }
        public string SitioWeb { get; internal set; }
        public string CedulaCliente { get; internal set; }
        public string ContactoPrincipal { get; internal set; }
        public string CorreoElectronico { get; internal set; }
        public string Id { get; internal set; }
        public string InformacionAdicional { get; internal set; }
        public string Moneda { get; internal set; }
        public string NombreCuenta { get; internal set; }
        public string Sector { get; internal set; }
    }
}
