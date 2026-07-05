# Orchestra Inventory Database

This project is a relational database system designed to manage and track a school orchestra and music program’s 
physical inventory, including instruments, accessories, repairs, and lending history.

---

## Purpose

The goal of this system is to replace existing interconnected Google-Sheet-style database 
system developed over a decade with a structured relational database that still supports:

- Instrument checkout and return tracking
- Inventory status (available, in repair, missing, decomissioned)
- Location tracking across multiple school buildings
- Quick lookup of instruments by serial number or student name
- Repair history logging
- Historical reporting for program management
- Automatic emailing confirmation of instrument loans and returns (future)

---

## Tech Stack

- PostgreSQL (primary database)
- SQL (schema design and queries)
- Git / GitHub (version control)
- Optional: Python / scripting for future automation

---

## Database Structure (Planned / In Progress)

The system is built around a relational model with the following core tables:

- `instruments` — master inventory of all instruments
- `students` — student information
- `staff` — teachers and program staff
- `loans` — checkout and return tracking
- `repairs` — maintenance and repair history
- `locations` — storage and assignment locations

---

## Simple Schema Overview

The relationships between tables are designed as follows:

- Students can borrow multiple instruments over time (via `loans`)
- Each instrument can have multiple loan and repair records
- Staff oversees inventory, lending, and repairs
- Locations track where instruments are stored or assigned

**High-level relationship model:**

- students → loans → instruments  
- instruments → repairs  
- instruments → locations  
- staff → manages loans and repairs  

---

## Key Features

- Track who has each instrument at any time
- Maintain full repair and maintenance history
- Identify missing or overdue instruments
- Support multi-building inventory management
- Provide reporting for administration and budgeting

---

## How to Use This Database

### 1. Initial Setup of Database
Run the SQL schema files in PostgreSQL in the following order:

1. Create tables (`schema.sql`)
2. Insert initial reference data (instruments, locations)
3. Load student data (if applicable)

---

### 2. Adding an Instrument
Insert a new record into the `instruments` table with:
- instrument type
- serial number (if applicable)
- condition status
- location assignment

---

### 3. Checking Out an Instrument
Create a record in the `loans` table:
- student_id
- instrument_id
- checkout date

---

### 4. Returning an Instrument
Update the corresponding `loans` record:
- set return date
- update instrument status if needed

---

### 5. Logging Repairs
Insert a record into the `repairs` table:
- instrument_id
- issue description
- repair date
- cost (if applicable)
- status (in progress / completed / etc.)

---


## Project Status

This project is actively being developed and refined. Initial database schema and GitHub structure are in progress.

---

## Future Improvements

- Web-based interface for checkout/check-in
- Web-based interface for instrument lookup by serial # or student name - returns full borrower history
- Automated loan/return emails to parents and students
- Automated overdue/missing instrument reports
- Dashboard visualization for inventory status
- Integration with Orchestra scheduling systems and Admin data

---

## Context

Built as part of a real-world effort to modernize inventory and operational tracking for a school 
music program, replacing existing Google Sheet data system with a structured relational database.

---

## Author

Brian Clinton  
Orchestra Director & Music Educator  