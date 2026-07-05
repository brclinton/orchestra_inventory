create or replace view inventory_discrepancies as
select
    ic.inventory_check_id,
    ic.instrument_id,
    i.serial_number,
    ic.check_date,
    ic.location as logged_location,
    l.loan_id as open_loan_id,
    l.student_id,
    s.first_name,
    s.last_name,
    s.active as student_active,
    case
        when l.loan_id is not null and s.active = false
            then 'Open loan to inactive/former student'
        when l.loan_id is not null and ic.location <> 'On Loan'
            then 'Logged at ' || ic.location || ' but has an open loan (expected: On Loan)'
        else null
    end as discrepancy_reason
from inventory_checks ic
join instruments i on i.instrument_id = ic.instrument_id
left join loans l on l.instrument_id = ic.instrument_id and l.return_date is null
left join students s on s.student_id = l.student_id
where
    (l.loan_id is not null and s.active = false)
    or (l.loan_id is not null and ic.location <> 'On Loan');