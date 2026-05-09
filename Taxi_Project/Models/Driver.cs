using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Taxi_Project.Models
{
    public class Driver
    {
        public int DriverID { get; set; }
        public string FullName { get; set; }
        public string Phone { get; set; }
        public int CarID { get; set; }
        public bool IsAvailable { get; set; }
    }
}