# LSBU e-Rentals: Database Design & Implementation

This is coursework for **CSI-5-BDD Big Data & Database Systems** at London South Bank University (2026, Case Study C). It designs and builds a relational database for *LSBU e-Rentals*, a fictional electric-car rental service, from the first ERD through to working T-SQL and a Power BI dashboard.

📄 **Full report:** [`LSBU_e-Rentals_Report.docx`](LSBU_e-Rentals_Report.docx)
🎥 **Video walkthrough:** https://youtu.be/v-PMVt8uz4k

## The problem

A car-rental business runs on a handful of linked events. A member rents a car, a clerk processes the rental, an engineer inspects the car when it comes back, the car gets charged, and the member pays. The database needs to record all of that cleanly, keep it consistent, and answer operational questions quickly.

## Data model

Seven entities, with `RENTAL_AGREEMENT` at the centre:

| Entity | Purpose |
|--------|---------|
| `MEMBER` | Customers and membership status |
| `STAFF` | Clerks and engineers, distinguished by a `Role` attribute |
| `ECAR` | Fleet vehicles with mileage and battery level |
| `RENTAL_AGREEMENT` | Who rented which car, when, processed by whom |
| `SERVICE_REPORT` | Post-return inspections, damage and repair cost |
| `CHARGING_SESSION` | Charging start/end times, battery levels, power used |
| `PAYMENT` | Payments linked to members and rentals |

**Design decisions worth noting:**
- **One `STAFF` table for two roles.** Clerks and engineers share one table and are referenced by two separate foreign keys (`StaffID` on rentals, `EngineerID` on service reports). That avoids duplicating staff data across two near-identical tables.
- **Single-column integer primary keys everywhere.** With no composite keys, partial dependencies can't occur, so 2NF holds automatically.
- **A deliberate denormalisation in `PAYMENT`.** It keeps `MemberID` even though `RentalAgreementNo` already determines it. This is a conscious trade of strict normal form for fewer joins when building member statements, and the report states it openly.

## Normalisation

The report lists the functional dependencies for every table and checks each one against 1NF, 2NF, 3NF and BCNF, with the `PAYMENT` trade-off above called out explicitly.

## Implementation (MS SQL Server / T-SQL)

- Tables are created in dependency order, with `PRIMARY KEY`, `FOREIGN KEY`, `NOT NULL` and `CHECK` constraints. For example, battery level is limited to 0–100, and rental status must be one of `Active`, `Returned`, `Late` or `Lost`.
- The test data is realistic (London postcodes, a consistent Jan–Feb 2026 timeline), and verification queries at the end confirm that every table was populated.

## Queries & stored procedures

| Task | What it answers |
|------|-----------------|
| 4a | Which e-cars haven't been charged in the past 72 hours? |
| 4b | Which customers have rented fewer than 3 times in the past 3 months? |
| 4c | Weekly charging report |
| 4d | Stored procedure: repair report per vehicle |
| 4e | Stored procedure: monthly rental statement per member |

## Run it yourself

The T-SQL is in [`sql/`](sql/):

| File | What it does |
|------|--------------|
| [`01_schema_and_data.sql`](sql/01_schema_and_data.sql) | Drops and recreates `LSBU_eRentals`, builds all 7 tables with constraints, inserts the test data and verifies the row counts |
| [`02_queries_and_procedures.sql`](sql/02_queries_and_procedures.sql) | Tasks 4a–4e: the three queries plus both stored procedures, with example `EXEC` calls |

Run them in order in SSMS or Azure Data Studio against a SQL Server instance. ⚠️ Script 01 **drops** any existing `LSBU_eRentals` database first.

Card details in the sample data are masked (`VISA **** 4521`). In production, payment data would go to a PCI-compliant payment provider instead, and only a token would be stored here.

## BI dashboard

A Power BI dashboard built on the dataset covers fleet, rental and charging activity.

## Tech

Microsoft SQL Server · T-SQL · Power BI

---

*This is academic work published for portfolio purposes. Copying or resubmitting it counts as plagiarism, and university similarity checkers will flag it.*
