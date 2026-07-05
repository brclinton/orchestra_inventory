
-- Trigger: Loans Updated At  -- trigger to call set_updated_at function to create or update a timestamp on each loan call

create trigger trg_loans_updated_at
    before update on loans
    for each row execute function set_updated_at();  


-- Trigger: Repairs Updated At  -- trigger to call set_updated_at function to create or update a timestamp on each repairs call

create trigger trg_repairs_updated_at
    before update on repairs
    for each row execute function set_updated_at(); 


-- Trigger: Repairs Sync Condition  -- trigger to call sync_instrument_condition function to update each repairs call

create trigger trg_repairs_sync_condition  -- calls sync_instrument_condition function to update instruments.status
    before update on repairs
    for each row
    execute function sync_instrument_condition();


-- Trigger: Inventory Checks Updated At  -- trigger to call set_updated_at function to create or update a timestamp on each inventory call

create trigger trg_inventory_checks_updated_at
before update on inventory_checks
for each row execute function set_updated_at();  -- trigger to call set_updated_at function
