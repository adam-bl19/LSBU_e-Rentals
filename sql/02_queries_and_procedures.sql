USE LSBU_eRentals;
GO
-- TASK 4a
-- Find all e-Cars that have not had a charge in the past 72 hours
SELECT
e.eCarID,
e.Manufacturer,
e.Model,
e.BatteryLevel,
MAX(cs.EndTime) AS LastChargeTime
FROM ECAR e
LEFT JOIN CHARGING_SESSION cs ON e.eCarID = cs.eCarID
GROUP BY e.eCarID, e.Manufacturer, e.Model, e.BatteryLevel
HAVING MAX(cs.EndTime) < DATEADD(HOUR, -72, GETDATE())
OR MAX(cs.EndTime) IS NULL
ORDER BY LastChargeTime ASC;
GO
-- TASK 4b
-- List customers who have made fewer than 3 rentals in the past 3 months
SELECT
m.MemberID,
m.FullName,
m.Address,
m.MembershipStatus,
COUNT(r.RentalAgreementNo) AS RentalCount
FROM MEMBER m
LEFT JOIN RENTAL_AGREEMENT r
ON m.MemberID = r.MemberID
AND r.IssueTime >= DATEADD(MONTH, -3, GETDATE())
GROUP BY m.MemberID, m.FullName, m.Address, m.MembershipStatus
HAVING COUNT(r.RentalAgreementNo) < 3
ORDER BY RentalCount ASC, m.FullName ASC;
GO
-- TASK 4c
-- Weekly charging report showing e-car registration, date, start time, end time, start and end battery charge levels
SELECT
e.eCarID AS Registration,
e.Manufacturer,
e.Model,
CAST(cs.StartTime AS DATE) AS ChargeDate,
CAST(cs.StartTime AS TIME(0)) AS StartTime,
CAST(cs.EndTime AS TIME(0)) AS EndTime,
cs.StartBatteryLevel AS StartCharge,
cs.EndBatteryLevel AS EndCharge,
cs.PowerUsed AS PowerUsedKWh,
cs.StationID
FROM CHARGING_SESSION cs
JOIN ECAR e ON cs.eCarID = e.eCarID
WHERE cs.StartTime >= DATEADD(DAY, -7, GETDATE())
ORDER BY cs.StartTime ASC;
GO
-- TASK 4d
-- Stored procedure: e-Cars that have required repairs, with repair details and total repair cost to date per e-Car
CREATE OR ALTER PROCEDURE sp_RepairReport
AS
BEGIN
SELECT
e.eCarID AS Registration,
e.Manufacturer,
e.Model,
sr.ReportNo,
sr.RentalAgreementNo,
sr.MaintenanceDetails,
sr.DamageFound,
sr.RepairCost,
ra.IssueTime AS RentalDate,
s.FullName AS InspectedBy
FROM SERVICE_REPORT sr
JOIN ECAR e ON sr.eCarID = e.eCarID
JOIN RENTAL_AGREEMENT ra ON sr.RentalAgreementNo = ra.RentalAgreementNo
JOIN STAFF s ON sr.EngineerID = s.StaffID
WHERE sr.DamageFound = 'Yes'
ORDER BY e.eCarID, sr.ReportNo;
-- Total repair cost per e-Car
SELECT
e.eCarID AS Registration,
e.Manufacturer,
e.Model,
COUNT(sr.ReportNo) AS TotalRepairs,
SUM(sr.RepairCost) AS TotalRepairCost
FROM SERVICE_REPORT sr
JOIN ECAR e ON sr.eCarID = e.eCarID
WHERE sr.DamageFound = 'Yes'
GROUP BY e.eCarID, e.Manufacturer, e.Model
ORDER BY TotalRepairCost DESC;
END;
GO
-- Run the procedure
EXEC sp_RepairReport;
GO
-- TASK 4e
-- Stored procedure: monthly itemised rental statement per customer, dynamic parameters for customer and e-car, includes VAT at 20%
CREATE OR ALTER PROCEDURE sp_MonthlyRentalStatement
@MemberID INT,
@Month INT,
@Year INT
AS
BEGIN
-- Customer details
SELECT
m.MemberID,
m.FullName,
m.Address,
m.MembershipStatus
FROM MEMBER m
WHERE m.MemberID = @MemberID;
-- Itemised rentals for the month
SELECT
ra.RentalAgreementNo,
e.eCarID AS Registration,
e.Manufacturer,
e.Model,
ra.IssueTime,
ra.ReturnTime,
ra.Status,
ra.PaymentAmount AS RentalCostExVAT,
ra.PaymentAmount * 0.20 AS VAT,
ra.PaymentAmount * 1.20 AS TotalIncVAT,
p.PaymentType,
p.PaymentDate
FROM RENTAL_AGREEMENT ra
JOIN ECAR e ON ra.eCarID = e.eCarID
JOIN PAYMENT p ON ra.RentalAgreementNo = p.RentalAgreementNo
WHERE ra.MemberID = @MemberID
AND MONTH(ra.IssueTime) = @Month
AND YEAR(ra.IssueTime) = @Year
ORDER BY ra.IssueTime;
-- Monthly totals
SELECT
COUNT(ra.RentalAgreementNo) AS TotalRentals,
SUM(ra.PaymentAmount) AS TotalExVAT,
SUM(ra.PaymentAmount * 0.20) AS TotalVAT,
SUM(ra.PaymentAmount * 1.20) AS TotalIncVAT
FROM RENTAL_AGREEMENT ra
WHERE ra.MemberID = @MemberID
AND MONTH(ra.IssueTime) = @Month
AND YEAR(ra.IssueTime) = @Year;
END;
GO
-- Run the procedure
EXEC sp_MonthlyRentalStatement @MemberID = 1001, @Month = 1, @Year = 2026;
GO
-- Try another member
EXEC sp_MonthlyRentalStatement @MemberID = 1002, @Month = 1, @Year = 2026;
GO
