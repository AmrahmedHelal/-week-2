using IceTown;
using System.Collections.Generic;
using System.ComponentModel;

Repository.LoadAllData();
var dailyusages = Repository.DailyUsages;
var Owners = Repository.Owners;
var Heaters = Repository.Heaters;
var Houses = Repository.Houses;

Sorting();

double CalculateCostPure(double power, double hours)
{
    return power * hours;
}
void Impurefunc()
{
    foreach (var daily in dailyusages)
    {
        daily.UsageDate = DateTime.Now;
    }
}
void FunctionalprogrammingandcoreofLINQ()
{
    // method sytax
    Console.WriteLine("------------------------------------------------------------");
    Console.WriteLine("Method Sytnax");
    Console.WriteLine("------------------------------------------------------------");
    var Result01 = Repository.Heaters.Where(h => h.PowerValue > 1500);
    foreach (var r in Result01)
        Console.WriteLine($" id :{r.HeaterId} , PowerValue: {r.PowerValue}");

    Console.WriteLine("------------------------------------------------------------");
    Console.WriteLine("Query Sytnax");
    Console.WriteLine("------------------------------------------------------------");
    // query syntax
    var Result02 = from h in Repository.Heaters
                   where h.PowerValue > 1500
                   select h;
    foreach (var r in Result02)
        Console.WriteLine($" id :{r.HeaterId} ,PowerValue: {r.PowerValue}");

}
void Projection()
{
    // Query that returns { HouseId, OwnerName, TotalMonthlyHours } for each house (sum over last 30 days).
    Console.WriteLine("------------------------------------------------------------");
    Console.WriteLine("Query that returns { HouseId, OwnerName, TotalMonthlyHours } for each house (sum over last 30 days).");
    Console.WriteLine("------------------------------------------------------------");
    var result = from h in Houses
                 join o in Owners on h.OwnerId equals o.OwnerId
                 let monthlyUsage = h.DailyUsages.Where(d => d.UsageDate > DateTime.Now.AddDays(-30))
                 select new
                 {
                     HouseId = h.HouseId,
                     OwnerName = o.FullName,
                     TotalMonthlyHours = monthlyUsage.Sum(d => d.HoursWorked)
                 };

    foreach (var r in result)
    {
        Console.WriteLine($"{r.HouseId} | {r.OwnerName} | {r.TotalMonthlyHours}");
    }
    Console.WriteLine("______________________________________________________________________________________________");

    //Use SelectMany to flatten House->Heaters->DailyUsage into a list of usage DTOs that include house address and heater type.
    Console.WriteLine("------------------------------------------------------------");
    Console.WriteLine("Use SelectMany to flatten House->Heaters->DailyUsage into a list of usage DTOs that include house address and heater type.");
    Console.WriteLine("------------------------------------------------------------");
    var usageList = Houses
    .SelectMany(
        house => house.Heaters,
        (house, heater) => new { house, heater }
    )
    .SelectMany(
        hh => hh.house.DailyUsages
            .Where(d => d.HeaterId == hh.heater.HeaterId),
        (hh, usage) => new UsageDTO
        {
            HouseAddress = hh.house.Address,
            HeaterType = hh.heater.HeaterType,
        }
    );

    foreach (var r in usageList)
    {
        Console.WriteLine($"{r.HouseAddress} | {r.HeaterType} ");
    }

}
void Sorting()
{   //Sort houses by TotalMonthlyHours descending.
    Console.WriteLine("------------------------------------------------------------");
    Console.WriteLine("Sort houses by TotalMonthlyHours descending.");
    Console.WriteLine("------------------------------------------------------------");
    var result01 = Houses
        .OrderByDescending(h => h.DailyUsages
        .Where(d => d.UsageDate > DateTime.Now.AddDays(-30))
        .Sum(d => d.HoursWorked)
        );

    foreach (var r in result01)
    {
        Console.WriteLine($" houseid:{r.HouseId} |ownerid:{r.OwnerId} |TotalMonthlyHours:{r.DailyUsages.Where(d => d.UsageDate > DateTime.Now.AddDays(-30))
        .Sum(d => d.HoursWorked)}");
    }

    //Inside each house, sort heaters by PowerValue descending.
    Console.WriteLine("------------------------------------------------------------");
    Console.WriteLine("Inside each house, sort heaters by PowerValue descending.");
    Console.WriteLine("------------------------------------------------------------");
    var Result02 = Houses
     .Select(house =>
     {
         house.Heaters = house.Heaters
        .OrderByDescending(heater => heater.PowerValue).ToList();
         return house;
     })
     .ToList();
    foreach (var r in Result02)
    {
        Console.WriteLine($" houseid:{r.HouseId} |ownerid:{r.OwnerId} |TotalMonthlyHours:{r.DailyUsages.Where(d => d.UsageDate > DateTime.Now.AddDays(-30))
        .Sum(d => d.HoursWorked)}");
    }
}
void Partitioning()
{
    //Show top 5 houses(Take).
    Console.WriteLine("------------------------------------------------------------");
    Console.WriteLine("Show top 5 houses(Take).");
    Console.WriteLine("------------------------------------------------------------");
    var result01 = Houses.Take(5);

    //Skip first 2 houses, show the rest(Skip).
    Console.WriteLine("------------------------------------------------------------");
    Console.WriteLine("Skip first 2 houses, show the rest(Skip).");
    Console.WriteLine("------------------------------------------------------------");
    var result02 = Houses.Skip(2);

    //Use TakeWhile to get days from the start of the month until a running sum of hours exceeds a threshold.
    Console.WriteLine("------------------------------------------------------------");
    Console.WriteLine("Use TakeWhile to get days from the start of the month until a running sum of hours exceeds a threshold.");
    Console.WriteLine("------------------------------------------------------------");
    double runningSum = 0;
    double threshold = 10;

    var result = dailyusages
        .OrderBy(d => d.UsageDate)
        .TakeWhile(d =>
        {
            runningSum += d.HoursWorked;
            return runningSum <= threshold;
        });
}
void Quantifiers()
{
    // Any house with a heater PowerValue > 2000.
    var result01 =Houses.Where(h => h.Heaters.Any(he => he.PowerValue > 2000) );
    //All daily usages for a selected house have HoursWorked <= 24.
    var result02=dailyusages.All(d=>d.HoursWorked <=24);
    //Contains or Any to detect a specific heater power.
    var result03 = Heaters.Any(he => he.PowerValue > 3000);
}
void Grouping()
{
    // Group DailyUsage by HouseId and compute average hours per house.
    var result01 = from d in dailyusages
                 group d by d.HouseId into g
                 select new
                 {
                    HouseId = g.Key,
                     AverageHours = g.Average(x => x.HoursWorked)
                 };
    //Use ToLookup to map HeaterType → heaters of that type.
    var result02 = Heaters.ToLookup(he => he.HeaterType);
}
void JoinANDGroupJoin()
{
    //join houses with owners to print ownername and address.

    //result01 = Houses.Join(Owners,h => h.OwnerId,o => o.OwnerId,(h, o) => new
    //{
    //    o.FullName,
    //    h.Address
    //});

    //    OR 
    var result01 = from h in Houses
                   join o in Owners on h.OwnerId equals o.OwnerId
                   select new
                   {
                       o.FullName,
                       h.Address
                   };

    //groupjoin houses with usages to get total hours per house.
    var result02 = Houses.GroupJoin(dailyusages, h => h.HouseId, d => d.HouseId, (h, usages) => new
    {
        h.HouseId,
        TotalHours = usages.Sum(u => u.HoursWorked)
    });

}
void Generationoperations()
{
    //Use Enumerable.Range(0, 30) to generate the last 30 dates and fill missing DailyUsage entries(if any heater / date missing).
    Console.WriteLine("------------------------------------------------------------");
    Console.WriteLine("Use Enumerable.Range(0, 30) to generate the last 30 dates and fill missing DailyUsage entries(if any heater / date missing).");
    Console.WriteLine("------------------------------------------------------------");
    // here i used gpt to help me :)

    var last30Days = Enumerable.Range(0, 30)
        .Select(i => DateTime.Today.AddDays(-i).Date)
        .ToList();


    foreach (var house in Houses)
    {
        foreach (var heater in house.Heaters)
        {
            foreach (var date in last30Days)
            {
                bool exists = house.DailyUsages.Any(d =>
                    d.HeaterId == heater.HeaterId &&
                    d.UsageDate.Date == date);

                if (!exists)
                {
                    house.DailyUsages.Add(new DailyUsage
                    {
                        DailyUsageId = Guid.NewGuid(),
                        HouseId = house.HouseId,
                        HeaterId = heater.HeaterId,
                        UsageDate = date,
                        HoursWorked = 0,
                        HeaterValue = heater.PowerValue
                    });
                }
            }
        }
    }

 
    foreach (var house in Houses)
    {
        Console.WriteLine($"House: {house.Address}");
        Console.WriteLine("=================================");

        var grouped = house.DailyUsages
            .GroupBy(d => d.HeaterId)
            .Select(g => new
            {
                HeaterId = g.Key,
                Days = g.OrderBy(d => d.UsageDate)
                        .Select((item, index) => new
                        {
                            DayIndex = index + 1,
                            item.UsageDate,
                            item.HoursWorked,
                            item.HeaterValue
                        })
            });

        foreach (var heater in grouped)
        {
            Console.WriteLine($"Heater: {heater.HeaterId}");

            foreach (var day in heater.Days)
            {
                Console.WriteLine(
                    $"  Day {day.DayIndex} | {day.UsageDate:d} | Hours: {day.HoursWorked} | Value: {day.HeaterValue}");
            }

            Console.WriteLine();
        }

        Console.WriteLine();
    }

}

void DeferredVSImmediate()
{

    // Deferred Execution
    var highPowerQuery = Heaters.Where(h => h.PowerValue > 1200);

    Heaters.Add(new Heater { HeaterId = new Guid(), HeaterType = "GAS", PowerValue = 2000, HouseId = Houses[0].HouseId });

    Console.WriteLine("Deferred Execution:");
    foreach (var h in highPowerQuery)
    {
        Console.WriteLine($"{h.HouseId} - {h.PowerValue}");
    }

    // Immediate Execution
    var immediateList = Heaters.Where(h => h.PowerValue > 1200).ToList(); // نفذ فورًا

    // تعديل المصدر مرة أخرى
    Heaters.Add(new Heater { HeaterId = new Guid(), HeaterType = "GAS", PowerValue = 2000, HouseId = Houses[0].HouseId });

    Console.WriteLine("\nImmediate Execution :");
    foreach (var h in immediateList)
    {
        Console.WriteLine($"{h.HouseId} - {h.PowerValue}");
    }
}
class UsageDTO
{
    public object HouseAddress { get; set; }
    public object HeaterType { get; set; }

}

