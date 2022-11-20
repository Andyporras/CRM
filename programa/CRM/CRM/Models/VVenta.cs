using System;
using System.Collections.Generic;

namespace CRM.Models
{
    public partial class VVenta
    {
        public int NumeroCotizacion { get; set; }
        public int? IdFactura { get; set; }
        public int? IdContacto { get; set; }
        public string Tipo { get; set; } = null!;
        public string NombreOportunidad { get; set; } = null!;
        public string FechaCotizacion { get; set; } = null!;
        public string NombreCuenta { get; set; } = null!;
        public DateTime FechaProyeccionCierre { get; set; }
        public DateTime FechaCierre { get; set; }
        public string OrdenCompra { get; set; } = null!;
        public string Descripcion { get; set; } = null!;
        public int IdZona { get; set; }
        public int IdSector { get; set; }
        public int IdMoneda { get; set; }
        public string IdEtapa { get; set; } = null!;
        public string IdAsesor { get; set; } = null!;
        public short Probabilidad { get; set; }
        public string MotivoDenegacion { get; set; } = null!;
        public string IdCompetidor { get; set; } = null!;
    }
}
