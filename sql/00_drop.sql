-- =====================================================

-- Orchestra Inventory Database
-- DROP SCRIPT (DESTRUCTIVE - DEV ONLY)

-- =====================================================


\echo 'WARNING: You are about to DESTRUCTIVELY DROP the entire schema?'


-- 1.   Safety confirmation
\prompt 'Type yes to confirm full database drop: ' confirm

\if :confirm != 'yes'
    \echo 'Aborted. Nothing was dropped.'
    \quit
\endif


-- 2.  OVERRIDE DOUBLE CHECK

do $$
begin
    if current_setting('orchestra.allow_drop', true) is distinct from 'true' then
        raise exception
            E'ABORTED: orchestra.allow_drop is not set to true.\n\n'
            E'Run:\n'
            E'SET orchestra.allow_drop = ''true'';\n'
            E'Then execute: \\i 00_drop.sql\n'
            E'If you REALLY want to drop the schema to rebuild';
        end if;
end $$;


\echo 'Dropping Orchestra Inventory Database objects...'


-- 3. DROP VIEWS

\echo 'Dropping views...'

drop view if exists current_loans;
drop view if exists overdue_loans;
drop view if exists inventory_summary;
drop view if exists repair_status_summary;


-- 4. DROP INDEXES

\echo 'Dropping indexes...'

drop index if exists idx_loans_instrument_id;
drop index if exists idx_loans_student_id;
drop index if exists idx_repairs_instrument_id;
drop index if exists idx_inventory_checks_instrument_id;


-- 5. DROP TRIGGERS

\echo 'Dropping triggers...'

drop trigger if exists trg_loans_updated_at on loans;
drop trigger if exists trg_repairs_updated_at on repairs;
drop trigger if exists trg_inventory_checks_updated_at on inventory_checks;
drop trigger if exists trg_repairs_sync_condition on repairs;


-- 6. DROP FUNCTIONS

\echo 'Dropping functions...'

drop function if exists set_updated_at cascade;
drop function if exists sync_instrument_condition cascade;


-- 7. DROP TABLES (CHILD TABLES FIRST)

\echo 'Dropping tables...'

-- dependent / transactional tables first
drop table if exists inventory_checks cascade;
drop table if exists repairs cascade;
drop table if exists loans cascade;

-- core entity tables
drop table if exists instruments cascade;
drop table if exists students cascade;

-- lookup / reference tables last
drop table if exists condition_statuses cascade;

\echo 'DROP COMPLETE: Orchestra Inventory Database has been cleared.'
