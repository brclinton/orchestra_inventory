

-- Backup created 2026-07-04 20:35:00



-- Orchestra Inventory Database
-- PostgreSQL Schema v1
-- =========================

-- Function Set Updated At -- creates or updates timestamps for logging events

create or replace function set_updated_at()
    returns trigger as $$
    begin
        new.updated_at := now();
        return new;
    end;
$$ language plpgsql;

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

create index idx_students_last_name
    on students(last_name);
create index idx_students_grade_level
    on students(grade_level);


-- Table: Instrument Condition Statuses

create table condition_statuses (
    status_name varchar(50) primary key
);

insert into condition_statuses  
    values ('good'), ('fair'), ('poor'), ('see_notes'), ('needs_repair'), ('decommissioned'); -- creating an expandable list of condition statuses to check against


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

create trigger trg_loans_updated_at
    before update on loans
    for each row execute function set_updated_at();  -- trigger to call set_updated_at function

create index idx_loans_instrument_id on loans (instrument_id);
create index idx_loans_student_id on loans (student_id);
create unique index idx_one_active_loan
    on loans (instrument_id)
    where return_date is null;


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

create trigger trg_repairs_updated_at   -- trigger to call set_updated_at function
    before update on repairs
    for each row execute function set_updated_at(); 
create trigger trg_repairs_sync_condition  -- calls sync_instrument_condition function to update instruments.status
    before update on repairs
    for each row
    execute function sync_instrument_condition();
create or replace function sync_instrument_condition() -- updates instruments.condition_status to 'needs_repair' when entered into repairs table
    returns trigger as $$
    begin
        update instruments
        set condition_status = 'needs _repair'
        where instrument_id = new.instrument_id;
    end if;
    return new;
end;
$$ language plpgsql;

create index idx_repairs_instrument_id on repairs(instrument_id);


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

create index idx_inventory_checks_instrument_id on inventory_checks(instrument_id);

create trigger trg_inventory_checks_updated_at
before update on inventory_checks
for each row execute function set_updated_at();  -- trigger to call set_updated_at function




