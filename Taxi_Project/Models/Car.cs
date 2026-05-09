using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Taxi_Project.Models
{
    public class Car
    {
        public int CarID { get; set; }
        public string PlateNumber { get; set; }
        public string Model { get; set; }
        public bool IsActive { get; set; }
    }
}