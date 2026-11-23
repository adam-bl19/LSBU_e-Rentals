USE master;
GO
-- Create and use the database
IF EXISTS (SELECT name FROM sys.databases WHERE name = 'LSBU_eRentals')
DROP DATABASE LSBU_eRentals;
GO
CREATE DATABASE LSBU_eRentals;
GO
USE LSBU_eRentals;
GO
-- TABLE CREATION
CREATE TABLE MEMBER (
MemberID INT PRIMARY KEY,
FullName VARCHAR(100) NOT NULL,
Address VARCHAR(200) NOT NULL,
DateOfBirth DATE NOT NULL,
PassportNumber VARCHAR(20) NOT NULL UNIQUE,
MembershipStatus VARCHAR(20) NOT NULL CHECK (MembershipStatus IN ('Active', 'Suspended', 'Refused')),
PaymentCardDetails VARCHAR(50) NOT NULL
);
GO
CREATE TABLE STAFF (
StaffID INT PRIMARY KEY IDENTITY(1,1),
FullName VARCHAR(100) NOT NULL,
Role VARCHAR(30) NOT NULL CHECK (Role IN ('Rental Clerk', 'Engineer', 'Admin Officer'))
);
GO
CREATE TABLE ECAR (
eCarID INT PRIMARY KEY,
Manufacturer VARCHAR(50) NOT NULL,
Model VARCHAR(50) NOT NULL,
CurrentMileage INT NOT NULL DEFAULT 0,
BatteryLevel INT NOT NULL CHECK (BatteryLevel BETWEEN 0 AND 100)
);
GO
CREATE TABLE RENTAL_AGREEMENT (
RentalAgreementNo INT PRIMARY KEY IDENTITY(1001,1),
MemberID INT NOT NULL FOREIGN KEY REFERENCES MEMBER(MemberID),
eCarID INT NOT NULL FOREIGN KEY REFERENCES ECAR(eCarID),
StaffID INT NOT NULL FOREIGN KEY REFERENCES STAFF(StaffID),
IssueTime DATETIME NOT NULL,
ReturnTime DATETIME,
PaymentAmount DECIMAL(8,2) NOT NULL DEFAULT 80.00,
Status VARCHAR(20) NOT NULL CHECK (Status IN ('Active', 'Returned', 'Late', 'Lost'))
);
GO
CREATE TABLE SERVICE_REPORT (
ReportNo INT PRIMARY KEY IDENTITY(2001,1),
eCarID INT NOT NULL FOREIGN KEY REFERENCES ECAR(eCarID),
EngineerID INT NOT NULL FOREIGN KEY REFERENCES STAFF(StaffID),
RentalAgreementNo INT NOT NULL FOREIGN KEY REFERENCES RENTAL_AGREEMENT(RentalAgreementNo),
MaintenanceDetails VARCHAR(500) NOT NULL,
DamageFound VARCHAR(10) NOT NULL CHECK (DamageFound IN ('Yes', 'No')),
RepairCost DECIMAL(8,2) NOT NULL DEFAULT 0.00
);
GO
CREATE TABLE CHARGING_SESSION (
SessionID INT PRIMARY KEY IDENTITY(3001,1),
eCarID INT NOT NULL FOREIGN KEY REFERENCES ECAR(eCarID),
StationID VARCHAR(20) NOT NULL,
StartTime DATETIME NOT NULL,
EndTime DATETIME,
StartBatteryLevel INT NOT NULL CHECK (StartBatteryLevel BETWEEN 0 AND 100),
EndBatteryLevel INT CHECK (EndBatteryLevel BETWEEN 0 AND 100),
PowerUsed DECIMAL(6,2)
);
GO
CREATE TABLE PAYMENT (
PaymentID INT PRIMARY KEY IDENTITY(4001,1),
MemberID INT NOT NULL FOREIGN KEY REFERENCES MEMBER(MemberID),
RentalAgreementNo INT NOT NULL FOREIGN KEY REFERENCES RENTAL_AGREEMENT(RentalAgreementNo),
Amount DECIMAL(8,2) NOT NULL,
PaymentDate DATE NOT NULL,
PaymentType VARCHAR(30) NOT NULL CHECK (PaymentType IN ('Rental', 'Registration', 'Late Fee', 'Repair Cost', 'Card Replacement'))
);
GO
-- INSERT DATA
-- MEMBER (20 records)
INSERT INTO MEMBER VALUES
(1001, 'James Carter', '12 Rye Lane, Peckham, London SE15 4RT', '1990-03-14', 'GB123456A', 'Active', 'VISA **** 4521'),
(1002, 'Aisha Mohammed', '45 Brixton Road, London SW9 8AF', '1988-07-22', 'GB234567B', 'Active', 'MASTERCARD **** 7832'),
(1003, 'Daniel Hughes', '8 Tower Bridge Rd, Bermondsey SE1 4TR', '1995-11-05', 'GB345678C', 'Active', 'VISA **** 1143'),
(1004, 'Priya Sharma', '33 Old Kent Road, London SE1 5AN', '1992-04-18', 'GB456789D', 'Active', 'MASTERCARD **** 9021'),
(1005, 'Marcus Williams', '67 Walworth Road, London SE17 1RW', '1985-09-30', 'GB567890E', 'Active', 'VISA **** 6634'),
(1006, 'Sophie Turner', '21 Camberwell New Rd, London SE5 0TJ', '1998-01-12', 'GB678901F', 'Suspended', 'VISA **** 3317'),
(1007, 'Omar Hassan', '5 Borough High St, London SE1 1JA', '1991-06-25', 'GB789012G', 'Active', 'MASTERCARD **** 8854'),
(1008, 'Lucy Bennett', '89 Elephant Road, London SE17 1LB', '1996-02-09', 'GB890123H', 'Active', 'VISA **** 2290'),
(1009, 'Ryan Patel', '14 Heygate St, Walworth, London SE17 1PS', '1993-08-17', 'GB901234I', 'Active', 'MASTERCARD **** 5567'),
(1010, 'Fatima Al-Zahra', '56 Newington Causeway, London SE1 6BD', '1987-12-03', 'GB012345J', 'Active', 'VISA **** 4403'),
(1011, 'Tom Reynolds', '3 Long Lane, Borough, London SE1 4PG', '1994-05-21', 'GB112233K', 'Active', 'MASTERCARD **** 7711'),
(1012, 'Zara Khan', '77 Bermondsey St, London SE1 3XF', '1999-10-14', 'GB223344L', 'Active', 'VISA **** 8823'),
(1013, 'Ben Okafor', '22 Great Dover St, London SE1 4YB', '1990-07-08', 'GB334455M', 'Active', 'MASTERCARD **** 3390'),
(1014, 'Hannah Scott', '41 Borough Rd, London SE1 1DG', '1997-03-27', 'GB445566N', 'Active', 'VISA **** 6612'),
(1015, 'Carlos Diaz', '18 Southwark Park Rd, London SE16 3RP', '1986-11-19', 'GB556677O', 'Refused', 'VISA **** 9945'),
(1016, 'Mei Lin', '9 Tanner St, London SE1 3LE', '1995-04-02', 'GB667788P', 'Active', 'MASTERCARD **** 1178'),
(1017, 'Jack Murphy', '30 Lant St, Borough, London SE1 1QR', '1992-09-15', 'GB778899Q', 'Active', 'VISA **** 4456'),
(1018, 'Amara Diallo', '64 Kennington Rd, London SE11 4XS', '1989-06-11', 'GB889900R', 'Active', 'MASTERCARD **** 2234'),
(1019, 'Nina Petrov', '7 Webber St, Waterloo, London SE1 8QA', '1996-01-29', 'GB990011S', 'Active', 'VISA **** 7789'),
(1020, 'Eli Goldstein', '52 Blackfriars Rd, London SE1 8NZ', '1991-08-04', 'GB101112T', 'Active', 'MASTERCARD **** 5523');
GO
-- STAFF (10 records)
INSERT INTO STAFF (FullName, Role) VALUES
('Sarah Collins', 'Rental Clerk'),
('David Osei', 'Rental Clerk'),
('Karen Mills', 'Admin Officer'),
('Tony Adeyemi', 'Engineer'),
('Grace Nwosu', 'Engineer'),
('Paul Hennessy', 'Rental Clerk'),
('Irene Stavros', 'Engineer'),
('Liam Brady', 'Rental Clerk'),
('Yemi Adebayo', 'Engineer'),
('Claire Fox', 'Admin Officer');
GO
-- ECAR (20 records)
INSERT INTO ECAR VALUES
(9000085, 'Renault', 'Twizy', 1240, 78),
(9000095, 'Renault', 'Twizy', 3450, 55),
(9000105, 'Renault', 'Twizy', 890, 92),
(9000115, 'Citroen', 'Ami', 2100, 63),
(9000125, 'Citroen', 'Ami', 4780, 41),
(9000135, 'Citroen', 'Ami', 3310, 87),
(9000145, 'Renault', 'Twizy', 5620, 30),
(9000155, 'Microlino', '2.0', 1980, 74),
(9000165, 'Microlino', '2.0', 780, 95),
(9000175, 'Renault', 'Twizy', 6100, 22),
(9000185, 'Citroen', 'Ami', 2890, 68),
(9000195, 'Microlino', '2.0', 4230, 50),
(9000205, 'Renault', 'Twizy', 3670, 83),
(9000215, 'Citroen', 'Ami', 1550, 71),
(9000225, 'Microlino', '2.0', 920, 89),
(9000235, 'Renault', 'Twizy', 7340, 15),
(9000245, 'Citroen', 'Ami', 4010, 60),
(9000255, 'Microlino', '2.0', 2760, 77),
(9000265, 'Renault', 'Twizy', 5490, 44),
(9000275, 'Citroen', 'Ami', 3120, 81);
GO
-- RENTAL_AGREEMENT (20 records)
INSERT INTO RENTAL_AGREEMENT (MemberID, eCarID, StaffID, IssueTime, ReturnTime, PaymentAmount, Status) VALUES
(1001, 9000085, 1, '2026-01-05 09:00', '2026-01-06 09:00', 80.00, 'Returned'),
(1002, 9000095, 2, '2026-01-07 10:30', '2026-01-08 10:30', 80.00, 'Returned'),
(1003, 9000105, 1, '2026-01-10 11:00', '2026-01-11 11:00', 80.00, 'Returned'),
(1004, 9000115, 6, '2026-01-12 14:00', '2026-01-13 14:00', 80.00, 'Returned'),
(1005, 9000125, 2, '2026-01-15 09:30', '2026-01-17 09:30', 80.00, 'Late'),
(1006, 9000135, 8, '2026-01-18 13:00', '2026-01-19 13:00', 80.00, 'Returned'),
(1007, 9000145, 1, '2026-01-20 10:00', '2026-01-21 10:00', 80.00, 'Returned'),
(1008, 9000155, 6, '2026-01-22 15:00', '2026-01-23 15:00', 80.00, 'Returned'),
(1009, 9000165, 2, '2026-01-25 09:00', '2026-01-26 09:00', 80.00, 'Returned'),
(1010, 9000175, 8, '2026-01-28 11:30', NULL, 80.00, 'Active'),
(1011, 9000185, 1, '2026-02-01 10:00', '2026-02-02 10:00', 80.00, 'Returned'),
(1012, 9000195, 6, '2026-02-03 14:30', '2026-02-04 14:30', 80.00, 'Returned'),
(1013, 9000205, 2, '2026-02-05 09:00', '2026-02-06 09:00', 80.00, 'Returned'),
(1014, 9000215, 8, '2026-02-08 12:00', '2026-02-09 12:00', 80.00, 'Returned'),
(1001, 9000225, 1, '2026-02-10 10:00', '2026-02-11 10:00', 80.00, 'Returned'),
(1016, 9000235, 6, '2026-02-12 09:30', NULL, 80.00, 'Lost'),
(1017, 9000245, 2, '2026-02-15 11:00', '2026-02-16 11:00', 80.00, 'Returned'),
(1018, 9000255, 8, '2026-02-18 14:00', '2026-02-19 14:00', 80.00, 'Returned'),
(1019, 9000265, 1, '2026-02-20 09:00', '2026-02-21 09:00', 80.00, 'Returned'),
(1020, 9000275, 6, '2026-02-22 10:30', '2026-02-23 10:30', 80.00, 'Returned');
GO
-- SERVICE_REPORT (20 records)
INSERT INTO SERVICE_REPORT (eCarID, EngineerID, RentalAgreementNo, MaintenanceDetails, DamageFound, RepairCost) VALUES
(9000085, 4, 1001, 'Tyre pressure checked, minor dirt cleaned.', 'No', 0.00),
(9000095, 5, 1002, 'Battery contacts cleaned, charge port inspected.', 'No', 0.00),
(9000105, 7, 1003, 'Small scratch on rear bumper, logged for repair.', 'Yes', 150.00),
(9000115, 9, 1004, 'General visual inspection passed.', 'No', 0.00),
(9000125, 4, 1005, 'Late return — 2 days. Vehicle inspected on return.', 'No', 0.00),
(9000135, 5, 1006, 'Windscreen crack noted, sent for full repair.', 'Yes', 320.00),
(9000145, 7, 1007, 'Battery level low on return, recharged on site.', 'No', 0.00),
(9000155, 9, 1008, 'All checks passed, no issues found.', 'No', 0.00),
(9000165, 4, 1009, 'Mirror housing loose, tightened on site.', 'Yes', 45.00),
(9000185, 5, 1011, 'Routine check passed.', 'No', 0.00),
(9000195, 7, 1012, 'Charging port cover missing, replacement ordered.', 'Yes', 30.00),
(9000205, 9, 1013, 'General inspection, no issues.', 'No', 0.00),
(9000215, 4, 1014, 'Body panel dent on left side, repair required.', 'Yes', 480.00),
(9000225, 5, 1015, 'All checks passed.', 'No', 0.00),
(9000245, 7, 1017, 'Tyre pressure low on front left, inflated.', 'No', 0.00),
(9000255, 9, 1018, 'Seat belt mechanism stiff, lubricated.', 'No', 0.00),
(9000265, 4, 1019, 'Brake fluid level checked and topped up.', 'No', 0.00),
(9000275, 5, 1020, 'General inspection passed, vehicle in good order.', 'No', 0.00),
(9000085, 7, 1001, 'Follow up check after previous scratch repair.', 'No', 0.00),
(9000105, 9, 1003, 'Rear bumper scratch repair completed and verified.', 'No', 0.00);
GO
-- CHARGING_SESSION (20 records)
INSERT INTO CHARGING_SESSION (eCarID, StationID, StartTime, EndTime, StartBatteryLevel, EndBatteryLevel, PowerUsed) VALUES
(9000085, 'STN-SW1-01', '2026-01-06 09:30', '2026-01-06 11:45', 18, 82, 4.20),
(9000095, 'STN-SE1-03', '2026-01-08 11:00', '2026-01-08 13:30', 25, 90, 4.50),
(9000105, 'STN-SW9-02', '2026-01-11 12:00', '2026-01-11 14:00', 30, 88, 3.90),
(9000115, 'STN-SE1-01', '2026-01-13 15:00', '2026-01-13 17:00', 40, 95, 3.70),
(9000125, 'STN-SW1-02', '2026-01-17 10:00', '2026-01-17 12:30', 10, 75, 4.80),
(9000135, 'STN-SE5-01', '2026-01-19 14:00', '2026-01-19 16:00', 35, 91, 3.80),
(9000145, 'STN-SE1-03', '2026-01-21 11:00', '2026-01-21 13:30', 12, 78, 4.70),
(9000155, 'STN-SW9-01', '2026-01-23 16:00', '2026-01-23 18:00', 42, 94, 3.60),
(9000165, 'STN-SE1-02', '2026-01-26 10:00', '2026-01-26 12:00', 20, 85, 4.30),
(9000175, 'STN-SW1-01', '2026-01-29 09:00', '2026-01-29 11:30', 8, 72, 4.90),
(9000085, 'STN-SE1-01', '2026-02-06 10:00', '2026-02-06 12:00', 22, 84, 4.20),
(9000185, 'STN-SE5-02', '2026-02-02 13:00', '2026-02-02 15:00', 38, 93, 3.70),
(9000195, 'STN-SW9-02', '2026-02-04 11:30', '2026-02-04 13:30', 28, 87, 3.90),
(9000205, 'STN-SE1-03', '2026-02-06 14:00', '2026-02-06 16:00', 45, 96, 3.50),
(9000215, 'STN-SW1-02', '2026-02-09 09:30', '2026-02-09 11:30', 32, 89, 3.80),
(9000225, 'STN-SE1-01', '2026-02-11 12:00', '2026-02-11 14:30', 15, 80, 4.50),
(9000245, 'STN-SW9-01', '2026-02-16 10:00', '2026-02-16 12:00', 48, 97, 3.30),
(9000255, 'STN-SE5-01', '2026-02-19 15:00', '2026-02-19 17:00', 36, 92, 3.60),
(9000265, 'STN-SE1-02', '2026-02-21 11:00', '2026-02-21 13:00', 27, 86, 3.90),
(9000275, 'STN-SW1-01', '2026-02-23 14:00', '2026-02-23 16:30', 44, 95, 3.50);
GO
-- PAYMENT (20 records)
INSERT INTO PAYMENT (MemberID, RentalAgreementNo, Amount, PaymentDate, PaymentType) VALUES
(1001, 1001, 80.00, '2026-01-05', 'Rental'),
(1002, 1002, 80.00, '2026-01-07', 'Rental'),
(1003, 1003, 80.00, '2026-01-10', 'Rental'),
(1004, 1004, 80.00, '2026-01-12', 'Rental'),
(1005, 1005, 240.00, '2026-01-17', 'Late Fee'),
(1006, 1006, 80.00, '2026-01-18', 'Rental'),
(1007, 1007, 80.00, '2026-01-20', 'Rental'),
(1008, 1008, 80.00, '2026-01-22', 'Rental'),
(1009, 1009, 80.00, '2026-01-25', 'Rental'),
(1010, 1010, 80.00, '2026-01-28', 'Rental'),
(1011, 1011, 80.00, '2026-02-01', 'Rental'),
(1012, 1012, 80.00, '2026-02-03', 'Rental'),
(1013, 1013, 80.00, '2026-02-05', 'Rental'),
(1014, 1014, 80.00, '2026-02-08', 'Rental'),
(1001, 1015, 80.00, '2026-02-10', 'Rental'),
(1016, 1016, 80.00, '2026-02-12', 'Rental'),
(1017, 1017, 80.00, '2026-02-15', 'Rental'),
(1018, 1018, 80.00, '2026-02-18', 'Rental'),
(1019, 1019, 80.00, '2026-02-20', 'Rental'),
(1020, 1020, 80.00, '2026-02-22', 'Rental');
GO
-- VERIFY DATA
SELECT 'MEMBER' AS TableName, COUNT(*) AS RecordCount FROM MEMBER
UNION ALL
SELECT 'STAFF', COUNT(*) FROM STAFF
UNION ALL
SELECT 'ECAR', COUNT(*) FROM ECAR
UNION ALL
SELECT 'RENTAL_AGREEMENT', COUNT(*) FROM RENTAL_AGREEMENT
UNION ALL
SELECT 'SERVICE_REPORT', COUNT(*) FROM SERVICE_REPORT
UNION ALL
SELECT 'CHARGING_SESSION', COUNT(*) FROM CHARGING_SESSION
UNION ALL
SELECT 'PAYMENT', COUNT(*) FROM PAYMENT;
GO
