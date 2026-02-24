create PROCEDURE sp_CalculateDailyHeaterUsageCost
    @HeaterId INT,
    @UsageDate DATE
AS
BEGIN
   
    DECLARE @RatePerKw DECIMAL= 2.5;

    SELECT
        he.heater_id,
        he.ModelName,
        d.UsageDate,
        d.HoursWorked,
        he.PowerKw AS HeaterPower,
       d.HoursWorked* he.PowerKw* @RatePerKw AS DailyCost
    FROM Heater he
    JOIN Houses h 
        ON he.house_id = h.house_id
    JOIN DailyUsages d 
        ON h.house_id = d.house_id
    WHERE he.heater_id = @HeaterId
      AND d.UsageDate = @UsageDate;
END;
