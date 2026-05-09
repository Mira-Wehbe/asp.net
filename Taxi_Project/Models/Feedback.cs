using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Taxi_Project.Models
{
    public class Feedback
    {
        public int FeedbackID { get; set; }
        public int TripID { get; set; }
        public int ClientID { get; set; }
        public int Rating { get; set; }
        public string Comment { get; set; }
        public DateTime SubmittedAt { get; set; }
    }
}