using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Taxi_Project.Models
{
    public class Trip
    {
        public int TripID { get; set; }
        public int ClientID { get; set; }
        public int DriverID { get; set; }
        public int CarID { get; set; }
        public string PickupLocation { get; set; }
        public string DropoffLocation { get; set; }
        public DateTime PickupTime { get; set; }
        public string Status { get; set; }
        public decimal Price { get; set; }
        public DateTime CreatedAt { get; set; }
    }
}