
-- Orchestra Inventory Database
-- PostgreSQL Schema v1
-- =========================

-- Table: Students

create table students (
    student_id serial primary key,
    first_name varchar(50) not null,
    last_name varchar(100) not null,
    grade_level smallint not null
        check (grade_level between 5 and 12),
    student_email varchar(255) unique,
    graduation_year smallint
);

-- Table: Instruments

create table instruments (
    instrument_id serial primary key,
    serial_number varchar(20) unique not null,
    instrument_size varchar(10) not null,
    instrument_type varchar(50) not null,
    brand varchar(100),
    condition_status varchar(50) default 'good'
        references condition_statuses(status_name),
    condition_notes text
);

-- Table: Instrument Condition Statuses

create table condition_statuses (
    status_name varchar(50) primary key
);

insert into condition_statuses  
    values ('good'), ('fair'), ('poor'), ('needs_repair'), ('decomissioned'); -- creating an expandable list of condition statuses to check against

-- Table: Loans

create table loans (
    loan_id serial primary key,
    instrument_id int not null references instruments(instrument_id),
    student_id int not null references students(student_id),
    checkout_date date not null default current_date,
    return_date date
        check (return_date is null or return_date >= checkout_date)
);

-- Table: Repairs

create table repairs (
    repair_id serial primary key,
    instrument_id int not null references instruments(instrument_id),
    issue_description text,
    repair_date date default current_date,
    cost numeric(10,2)
        check (cost >= 0),
    status varchar(20) default 'pending'
        check (status in ('pending', 'in_progress', ' completed', 'cancelled' ))
);

