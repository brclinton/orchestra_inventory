
-- Orchestra Inventory Database
-- PostgreSQL Schema v1
-- =========================


-- Table: Students

create table students (
    student_id int generated always as identity primary key,
    first_name varchar(50) not null,
    last_name varchar(100) not null,
    grade_level smallint not null
        check (grade_level between 5 and 12),
    student_email varchar(255) unique,
    active boolean not null default true,
    graduation_year smallint
);


-- Table: Instrument Condition Statuses

create table condition_statuses (
    status_name varchar(50) primary key
);


-- Table: Instruments

create table instruments (
    instrument_id int generated always as identity primary key,
    serial_number varchar(20) unique not null,
    instrument_size varchar(10) not null
        check (instrument_size in ('4/4', '3/4', '1/2', '12"', '13"', '14"', '15"', '15 1/2"', '16"')),
    instrument_type varchar(50) not null
        check (instrument_type in ('Violin', 'Viola', 'Cello', 'Bass')),
    brand varchar(100),
    condition_status varchar(50) default 'good' not null
        references condition_statuses(status_name) on delete restrict, -- i need to be able to choose common conditions
    condition_notes text -- in the event of anomalous conditions, I need to be able to note this
);


-- Table: Loans

create table loans (
    loan_id int generated always as identity primary key,
    created_at timestamptz not null default now(),  -- logging creation
    updated_at timestamptz not null default now(),  -- logging updates
    instrument_id int not null references instruments(instrument_id) on delete restrict,
    student_id int not null references students(student_id) on delete restrict,
    checkout_date date not null default current_date,
    return_date date
        check (return_date is null or return_date >= checkout_date)
);


-- Table: Repairs

create table repairs (
    repair_id int generated always as identity primary key,
    created_at timestamptz not null default now(),  -- logging creation
    updated_at timestamptz not null default now(),  -- logging updates
    instrument_id int not null references instruments(instrument_id) on delete restrict,
    issue_description text not null,
    repair_date date default current_date,
    cost numeric(10,2)
        check (cost >= 0),
    status varchar(20) default 'pending'
        check (status in ('pending', 'in_progress', 'completed', 'cancelled' ))
);


-- Table: Inventory Logs -- contains dynamic inventory data as logging events are created.

create table inventory_checks (
    inventory_check_id int generated always as identity primary key,
    instrument_id int not null references instruments(instrument_id) on delete restrict,
    created_at timestamptz not null default now(),
    updated_at timestamptz not null default now(),
    check_date date not null default current_date,
    inventory_school varchar(30) not null
        check (inventory_school in ('High School', 'Elementary School', 'Student')),
    inventory_term varchar(10) not null  
        check (inventory_term in ('Fall', 'Spring', 'Summer')),
    inventory_year smallint not null
        check (inventory_year between 2003 and 2100),
    batch_label text generated always as
        (inventory_school || ' ' || inventory_term || ' ' || inventory_year::text) stored,
    location varchar(30) not null
        check (location in ('High School', 'Elementary School', 'On Loan', 'Other')),
    condition_status varchar(50) not null references condition_statuses(status_name) on delete restrict,
    needs_repair boolean not null default false,
    photo_url text,
    decommissioned boolean not null default false,
    decommission_reason text,
    unique (instrument_id, check_date)
);




