
-- Index:  Students Last Name  -- creates an index of student last names

create index idx_students_last_name
    on students(last_name);


-- Index: Students Grade Level  --  -- creates an index of student grade levels
    
create index idx_students_grade_level
    on students(grade_level);


-- Index:  Loans Instrument ID  -- creates an index for instrument ids on instrument loans

create index idx_loans_instrument_id on loans (instrument_id);


-- Index: Loans Student ID  - creates an index for student ids on instrument loans

create index idx_loans_student_id on loans (student_id);


-- Index: One Active Loan  -- creates an index to ensure each instrument can only be checked out once at a time

create unique index idx_one_active_loan
    on loans (instrument_id)
    where return_date is null;


-- Index:  Repairs Instrument ID  -- creates an index of instruent ids on repairs

create index idx_repairs_instrument_id on repairs(instrument_id);


-- Index: Inventory Checks Instrument ID  -- creates an index of instrument ids for yearly inventory checks

create index idx_inventory_checks_instrument_id on inventory_checks(instrument_id);

